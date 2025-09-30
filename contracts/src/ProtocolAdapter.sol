// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Ownable} from "@openzeppelin-contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";
import {ReentrancyGuardTransient} from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {IForwarder} from "./interfaces/IForwarder.sol";
import {IProtocolAdapter} from "./interfaces/IProtocolAdapter.sol";

import {MerkleTree} from "./libs/MerkleTree.sol";
import {RiscZeroUtils} from "./libs/RiscZeroUtils.sol";
import {Versioning} from "./libs/Versioning.sol";

import {Aggregation} from "./proving/Aggregation.sol";
import {Compliance} from "./proving/Compliance.sol";
import {Delta} from "./proving/Delta.sol";
import {Logic} from "./proving/Logic.sol";
import {CommitmentTree} from "./state/CommitmentTree.sol";
import {NullifierSet} from "./state/NullifierSet.sol";
import {Action, Transaction} from "./Types.sol";

/// @title ProtocolAdapter
/// @author Anoma Foundation, 2025
/// @notice The protocol adapter contract verifying and executing resource machine transactions.
/// @custom:security-contact security@anoma.foundation
contract ProtocolAdapter is
    IProtocolAdapter,
    ReentrancyGuardTransient,
    Ownable,
    Pausable,
    CommitmentTree,
    NullifierSet
{
    using Delta for Delta.CurvePoint;
    using MerkleTree for bytes32[];
    using Logic for Logic.VerifierInput[];
    using RiscZeroUtils for Aggregation.Instance;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.VerifierInput;
    using RiscZeroUtils for uint32;

    /// @notice A data structure containing variables being updated while iterating over the actions and compliance
    /// units within a transaction.
    /// @param commitmentTreeRoot The commitment tree root for the root update.
    /// @param tags A variable to aggregate tags over the actions.
    /// @param logicRefs A variable to aggregate logic references over the actions.
    /// @param transactionDelta A variable to aggregate the unit deltas over the actions.
    /// @param packedComplianceProofJournals A variable to aggregate RISC Zero compliance proof journals.
    /// @param packedLogicProofJournals A variable to aggregate RISC Zero logic proof journals.
    struct AggregatedArguments {
        bytes32 commitmentTreeRoot;
        bytes32[] tags;
        bytes32[] logicRefs;
        Delta.CurvePoint transactionDelta;
        bytes packedComplianceProofJournals;
        bytes packedLogicProofJournals;
    }

    uint256 internal constant _MAX_ARRAY_LENGTH = type(uint32).max;

    RiscZeroVerifierRouter internal immutable _TRUSTED_RISC_ZERO_VERIFIER_ROUTER;
    bytes4 internal immutable _RISC_ZERO_VERIFIER_SELECTOR;

    error ZeroNotAllowed();
    error ForwarderCallOutputMismatch(bytes expected, bytes actual);
    error TagCountMismatch(uint256 expected, uint256 actual);
    error LogicRefMismatch(bytes32 expected, bytes32 actual);
    error RiscZeroVerifierStopped();

    /// @notice Constructs the protocol adapter contract.
    /// @param riscZeroVerifierRouter The RISC Zero verifier router contract.
    /// @param riscZeroVerifierSelector The RISC Zero verifier selector this protocol adapter is associated with.
    /// @param emergencyStopCaller The account that can stop the protocol adapter in case of a vulnerability.
    constructor(
        RiscZeroVerifierRouter riscZeroVerifierRouter,
        bytes4 riscZeroVerifierSelector,
        address emergencyStopCaller
    ) Ownable(emergencyStopCaller) {
        if (address(riscZeroVerifierRouter) == address(0)) {
            revert ZeroNotAllowed();
        }

        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER = riscZeroVerifierRouter;
        _RISC_ZERO_VERIFIER_SELECTOR = riscZeroVerifierSelector;

        // Sanity check that the verifier has not been stopped already.
        if (isEmergencyStopped()) {
            revert RiscZeroVerifierStopped();
        }
    }

    // slither-disable-start reentrancy-no-eth
    /// @inheritdoc IProtocolAdapter
    function execute(Transaction calldata transaction) external override nonReentrant whenNotPaused {
        uint256 actionCount = transaction.actions.length;

        uint256 tagCounter = 0;

        // Count the total number of tags in the transaction.
        for (uint256 i = 0; i < actionCount; ++i) {
            tagCounter += transaction.actions[i].logicVerifierInputs.length;
        }

        AggregatedArguments memory args = AggregatedArguments({
            commitmentTreeRoot: bytes32(0),
            tags: new bytes32[](tagCounter),
            logicRefs: new bytes32[](tagCounter),
            transactionDelta: Delta.zero(),
            packedComplianceProofJournals: "",
            packedLogicProofJournals: ""
        });

        bool isProofAggregated = transaction.aggregationProof.length != 0;

        tagCounter = 0;
        for (uint256 i = 0; i < actionCount; ++i) {
            Action calldata action = transaction.actions[i];

            _checkActionPartitioning(action);

            bytes32 actionTreeRoot = _computeActionTreeRoot(action);

            uint256 complianceUnitCount = action.complianceVerifierInputs.length;

            for (uint256 j = 0; j < complianceUnitCount; ++j) {
                // Compliance Proof
                Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];
                {
                    // slither-disable-next-line encode-packed-collision
                    args.packedComplianceProofJournals = abi.encodePacked(
                        args.packedComplianceProofJournals,
                        _processComplianceProof(complianceVerifierInput, isProofAggregated)
                    );
                }

                // Consumed resource logic proof.
                bytes32 nf = complianceVerifierInput.instance.consumed.nullifier;
                Logic.VerifierInput calldata consumedInput = action.logicVerifierInputs.lookup(nf);
                bytes32 cm = complianceVerifierInput.instance.created.commitment;
                Logic.VerifierInput calldata createdInput = action.logicVerifierInputs.lookup(cm);
                {
                    bytes memory nfLogicProofJournal = _processLogicProof({
                        input: consumedInput,
                        actionTreeRoot: actionTreeRoot,
                        logicRef: complianceVerifierInput.instance.consumed.logicRef,
                        isConsumed: true,
                        isProofAggregated: isProofAggregated
                    });
                    bytes memory cmLogicProofJournal = _processLogicProof({
                        input: createdInput,
                        actionTreeRoot: actionTreeRoot,
                        logicRef: complianceVerifierInput.instance.created.logicRef,
                        isConsumed: false,
                        isProofAggregated: isProofAggregated
                    });

                    // slither-disable-next-line encode-packed-collision
                    args.packedLogicProofJournals =
                        abi.encodePacked(args.packedLogicProofJournals, nfLogicProofJournal, cmLogicProofJournal);
                }

                // Execute external calls.
                _executeForwarderCalls(consumedInput);
                _executeForwarderCalls(createdInput);

                // Transition the resource machine state.
                _addNullifier(nf);
                args.tags[tagCounter] = nf;
                args.logicRefs[tagCounter++] = complianceVerifierInput.instance.consumed.logicRef;

                args.commitmentTreeRoot = _addCommitment(cm);
                args.tags[tagCounter] = cm;
                args.logicRefs[tagCounter++] = complianceVerifierInput.instance.created.logicRef;

                // Compute transaction delta.
                args.transactionDelta = args.transactionDelta.add(
                    Delta.CurvePoint({
                        x: uint256(complianceVerifierInput.instance.unitDeltaX),
                        y: uint256(complianceVerifierInput.instance.unitDeltaY)
                    })
                );

                // Emit app-data blobs.
                _emitAppDataBlobs(consumedInput.appData, nf);
                _emitAppDataBlobs(createdInput.appData, cm);
            }

            emit ActionExecuted({actionTreeRoot: actionTreeRoot, actionTagCount: action.logicVerifierInputs.length});
        }

        // Check if the transaction induces a state change.
        if (tagCounter != 0) {
            // Check the delta proof.
            Delta.verify({
                proof: transaction.deltaProof,
                instance: args.transactionDelta,
                verifyingKey: Delta.computeVerifyingKey(args.tags)
            });

            // Verify aggregation proof.
            if (isProofAggregated) {
                // slither-disable-next-line calls-loop
                _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
                    seal: transaction.aggregationProof,
                    imageId: Aggregation._VERIFYING_KEY,
                    journalDigest: sha256(
                        Aggregation.Instance({
                            packedComplianceProofJournals: args.packedComplianceProofJournals,
                            packedLogicProofJournals: args.packedLogicProofJournals,
                            logicRefs: args.logicRefs
                        }).toJournal()
                    )
                });
            }

            // Store the final commitment tree root
            _addCommitmentTreeRoot(args.commitmentTreeRoot);
        }

        // Emit the event containing the transaction and new root
        emit TransactionExecuted({tags: args.tags, logicRefs: args.logicRefs});
    }
    // slither-disable-end reentrancy-no-eth

    /// @inheritdoc IProtocolAdapter
    function emergencyStop() external override onlyOwner whenNotPaused {
        _pause();
    }

    /// @inheritdoc IProtocolAdapter
    function isEmergencyStopped() public view override returns (bool isStopped) {
        bool risc0Paused = RiscZeroVerifierEmergencyStop(
            address(_TRUSTED_RISC_ZERO_VERIFIER_ROUTER.getVerifier(getRiscZeroVerifierSelector()))
        ).paused();

        isStopped = paused() || risc0Paused;
    }

    /// @inheritdoc IProtocolAdapter
    function getRiscZeroVerifierSelector() public view override returns (bytes4 verifierSelector) {
        verifierSelector = _RISC_ZERO_VERIFIER_SELECTOR;
    }

    /// @inheritdoc IProtocolAdapter
    function getProtocolAdapterVersion() public pure override returns (bytes32 version) {
        version = Versioning._PROTOCOL_ADAPTER_VERSION;
    }

    /// @notice Executes a call to a forwarder contracts.
    /// @param carrierLogicRef The logic reference of the carrier resource.
    /// @param callBlob The blob containing the call instruction.
    function _executeForwarderCall(bytes32 carrierLogicRef, bytes memory callBlob) internal {
        (address untrustedForwarder, bytes memory input, bytes memory expectedOutput) =
            abi.decode(callBlob, (address, bytes, bytes));

        // slither-disable-next-line calls-loop
        bytes memory actualOutput =
            IForwarder(untrustedForwarder).forwardCall({logicRef: carrierLogicRef, input: input});

        if (keccak256(actualOutput) != keccak256(expectedOutput)) {
            revert ForwarderCallOutputMismatch({expected: expectedOutput, actual: actualOutput});
        }

        // solhint-disable-next-line max-line-length
        emit ForwarderCallExecuted({untrustedForwarder: untrustedForwarder, input: input, output: actualOutput});
    }

    /// @notice Emits app data blobs based on their deletion criterion.
    /// @param appData The logic verifier input containing the app data.
    /// @param tag The tag of the associated resource.
    function _emitAppDataBlobs(Logic.AppData calldata appData, bytes32 tag) internal {
        Logic.ExpirableBlob[] calldata payload = appData.resourcePayload;
        uint256 n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit ResourcePayload({tag: tag, index: i, blob: payload[i].blob});
            }
        }

        payload = appData.discoveryPayload;
        n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit DiscoveryPayload({tag: tag, index: i, blob: payload[i].blob});
            }
        }

        payload = appData.externalPayload;
        n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit ExternalPayload({tag: tag, index: i, blob: payload[i].blob});
            }
        }

        payload = appData.applicationPayload;
        n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit ApplicationPayload({tag: tag, index: i, blob: payload[i].blob});
            }
        }
    }

    /// @notice Processes forwarder calls by verifying and executing them.
    /// @param verifierInput The logic verifier input of a resource making the call.
    function _executeForwarderCalls(Logic.VerifierInput calldata verifierInput) internal {
        uint256 nCalls = verifierInput.appData.externalPayload.length;

        for (uint256 i = 0; i < nCalls; ++i) {
            _executeForwarderCall({
                carrierLogicRef: verifierInput.verifyingKey,
                callBlob: verifierInput.appData.externalPayload[i].blob
            });
        }
    }

    /// @notice Processes a resource machine compliance proof by
    /// * checking that the commitment tree root is an historical root, and
    /// * verifying or the compliance proof or computing the compliance proof RISC Zero journal.
    /// @param input The logic verifier input for processing.
    /// @param isProofAggregated Whether the proof is aggregated or not.
    /// @return encodedJournal The encoded RISC Zero journal if the proof is aggregated or the empty array.
    function _processComplianceProof(Compliance.VerifierInput calldata input, bool isProofAggregated)
        internal
        view
        returns (bytes memory encodedJournal)
    {
        bytes32 root = input.instance.consumed.commitmentTreeRoot;
        if (!_isCommitmentTreeRootContained(root)) {
            revert NonExistingRoot(root);
        }

        // Process compliance proof.
        {
            bytes memory journal = input.instance.toJournal();

            // Aggregate the compliance instance
            if (isProofAggregated) {
                encodedJournal = journal;
            }
            // Verify the compliance proof.
            else {
                // slither-disable-next-line calls-loop
                _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
                    seal: input.proof,
                    imageId: Compliance._VERIFYING_KEY,
                    journalDigest: sha256(journal)
                });
            }
        }
    }

    /// @notice Processes a resource logic proof by
    /// * checking the verifying key correspondence,
    /// * checking the resource logic proof, and
    /// * executing external calls.
    /// @param input The logic verifier input for processing.
    /// @param actionTreeRoot The action tree root.
    /// @param logicRef The logic reference that was verified in the compliance proof.
    /// @param isConsumed Whether the proof belongs to a consumed or created resource.
    /// @param isProofAggregated Whether the proof is aggregated or not.
    /// @return encodedJournal The encoded RISC Zero journal if the proof is aggregated or the empty array.
    function _processLogicProof(
        Logic.VerifierInput calldata input,
        bytes32 actionTreeRoot,
        bytes32 logicRef,
        bool isConsumed,
        bool isProofAggregated
    ) internal view returns (bytes memory encodedJournal) {
        // Check verifying key correspondence.
        if (logicRef != input.verifyingKey) {
            revert LogicRefMismatch({expected: input.verifyingKey, actual: logicRef});
        }

        // Process logic proof.
        {
            bytes memory journal = input.toJournal({actionTreeRoot: actionTreeRoot, isConsumed: isConsumed});

            // Aggregate the logic instance.
            if (isProofAggregated) {
                encodedJournal = journal.toJournalWithEncodedLength();
            }
            // Verify the logic proof.
            else {
                // slither-disable-next-line calls-loop
                _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
                    seal: input.proof,
                    imageId: input.verifyingKey,
                    journalDigest: sha256(journal)
                });
            }
        }
    }

    /// @notice Checks the compliance units partition the action.
    /// @param action The action to check.
    function _checkActionPartitioning(Action calldata action) internal pure {
        uint256 complianceUnitCount = action.complianceVerifierInputs.length;
        uint256 actionTagCount = action.logicVerifierInputs.length;

        // Check that the tag count in the action and compliance units match.
        if (actionTagCount != complianceUnitCount * 2) {
            revert TagCountMismatch({expected: actionTagCount, actual: complianceUnitCount * 2});
        }
    }

    /// @notice Computes the action tree root of an action constituted by all its nullifiers and commitments.
    /// @param action The action whose root we compute.
    /// @return root The root of the corresponding tree.
    function _computeActionTreeRoot(Action calldata action) internal pure returns (bytes32 root) {
        uint256 complianceUnitCount = action.complianceVerifierInputs.length;

        bytes32[] memory actionTreeTags = new bytes32[](complianceUnitCount * 2);

        // The order in which the tags are added to the tree is provided by the compliance units.
        for (uint256 j = 0; j < complianceUnitCount; ++j) {
            Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];

            actionTreeTags[2 * j] = complianceVerifierInput.instance.consumed.nullifier;
            actionTreeTags[(2 * j) + 1] = complianceVerifierInput.instance.created.commitment;
        }

        root = actionTreeTags.computeRoot();
    }
}
