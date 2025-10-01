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
    using MerkleTree for bytes32[];
    using RiscZeroUtils for Aggregation.Instance;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.VerifierInput;
    using RiscZeroUtils for Logic.Instance;
    using RiscZeroUtils for uint32;
    using Logic for Logic.VerifierInput[];
    using Delta for uint256[2];

    struct AggregatedArguments {
        bytes32 commitmentTreeRoot;
        bytes32[] tags;
        bytes32[] logicRefs;
        uint256 tagCounter;
        uint256[2] transactionDelta;
        Compliance.Instance[] complianceInstances;
        Logic.Instance[] logicInstances;
    }

    RiscZeroVerifierRouter internal immutable _TRUSTED_RISC_ZERO_VERIFIER_ROUTER;
    bytes4 internal immutable _RISC_ZERO_VERIFIER_SELECTOR;

    error ZeroNotAllowed();
    error ForwarderCallOutputMismatch(bytes expected, bytes actual);
    error TagCountMismatch(uint256 expected, uint256 actual);
    error LogicRefMismatch(bytes32 expected, bytes32 actual);
    error RiscZeroVerifierStopped();
    error TagNotFound(bytes32 tag);

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
        // Reverts if number of tags in actions and compliance units mismatch.
        tagCounter = _computeTagCount(transaction.actions);

        AggregatedArguments memory args = AggregatedArguments({
            commitmentTreeRoot: bytes32(0),
            tags: new bytes32[](tagCounter),
            logicRefs: new bytes32[](tagCounter),
            tagCounter: 0,
            transactionDelta: [uint256(0), uint256(0)],
            complianceInstances: new Compliance.Instance[](tagCounter / 2),
            logicInstances: new Logic.Instance[](tagCounter)
        });

        // If there is an aggregated proof present, we will skip all individual resource logic and compliance checks.
        bool isProofAggregated = transaction.aggregationProof.length != 0;

        for (uint256 i = 0; i < actionCount; ++i) {
            Action calldata action = transaction.actions[i];
            bytes32[] memory tagList = new bytes32[](action.logicVerifierInputs.length);

            // Make Compliance-level Checks
            // Returns global arguments and the list of all tags in the action ordered by compliance units.
            (args, tagList) = _processComplianceUnits(action.complianceVerifierInputs, args, isProofAggregated);

            bytes32 actionTreeRoot = tagList.computeRoot();

            // Make Action-level Checks
            args = _processLogicInputs(action.logicVerifierInputs, args, isProofAggregated, actionTreeRoot, tagList);

            emit ActionExecuted({actionTreeRoot: actionTreeRoot, actionTagCount: action.logicVerifierInputs.length});
        }

        // Check if the transaction induces a state change.
        if (args.tagCounter != 0) {
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
                            complianceInstances: args.complianceInstances,
                            logicInstances: args.logicInstances,
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

    function _computeTagCount(Action[] calldata actions) internal view returns (uint256 tagCount) {
        uint256 actionCount = actions.length;
        for (uint256 i = 0; i < actionCount; ++i) {
            uint256 complianceUnitCount = actions[i].complianceVerifierInputs.length;
            uint256 actionTagCount = actions[i].logicVerifierInputs.length;

            // Check that the tag count in the action and compliance units match.
            if (actionTagCount != complianceUnitCount * 2) {
                revert TagCountMismatch({expected: actionTagCount, actual: complianceUnitCount * 2});
            }
            tagCount += actions[i].logicVerifierInputs.length;
        }
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
    function _processComplianceProof(Compliance.VerifierInput calldata input, bool isProofAggregated) internal view {
        bytes32 root = input.instance.consumed.commitmentTreeRoot;
        if (!_isCommitmentTreeRootContained(root)) {
            revert NonExistingRoot(root);
        }

        // Process compliance proof.
        {
            // Aggregate the compliance instance
            if (!isProofAggregated) {
                bytes memory journal = input.instance.toJournal();

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
    function _processLogicProof(
        Logic.VerifierInput calldata input,
        bytes32 actionTreeRoot,
        bytes32 logicRef,
        bool isConsumed,
        bool isProofAggregated
    ) internal view {
        // Check verifying key correspondence.
        if (logicRef != input.verifyingKey) {
            revert LogicRefMismatch({expected: input.verifyingKey, actual: logicRef});
        }

        // Process logic proof.

        if (!isProofAggregated) {
            // slither-disable-next-line calls-loop
            _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
                seal: input.proof,
                imageId: input.verifyingKey,
                journalDigest: sha256(
                    Logic.Instance({
                        tag: input.tag,
                        isConsumed: isConsumed,
                        actionTreeRoot: actionTreeRoot,
                        appData: input.appData
                    }).toJournal()
                )
            });
        }
    }

    function _processComplianceUnits(
        Compliance.VerifierInput[] calldata units,
        AggregatedArguments memory args,
        bool isProofAggregated
    ) internal view returns (AggregatedArguments memory newArgs, bytes32[] memory tagList) {
        uint256 complianceUnitCount = units.length;
        tagList = new bytes32[](complianceUnitCount * 2);
        for (uint256 j = 0; j < complianceUnitCount; ++j) {
            // Compliance Proof
            Compliance.VerifierInput calldata complianceVerifierInput = units[j];

            _processComplianceProof(complianceVerifierInput, isProofAggregated);

            if (isProofAggregated) {
                args.complianceInstances[args.tagCounter / 2] = complianceVerifierInput.instance;
            }

            // Consumed resource logic proof.
            bytes32 nf = complianceVerifierInput.instance.consumed.nullifier;
            bytes32 cm = complianceVerifierInput.instance.created.commitment;

            args.tags[args.tagCounter] = nf;
            args.logicRefs[args.tagCounter++] = complianceVerifierInput.instance.consumed.logicRef;
            tagList[2 * j] = nf;

            args.tags[args.tagCounter] = cm;
            args.logicRefs[args.tagCounter++] = complianceVerifierInput.instance.created.logicRef;
            tagList[(2 * j) + 1] = cm;

            // Compute transaction delta.
            args.transactionDelta = args.transactionDelta.add(
                [
                    uint256(complianceVerifierInput.instance.unitDeltaX),
                    uint256(complianceVerifierInput.instance.unitDeltaY)
                ]
            );
        }
        newArgs = args;
    }

    function _processLogicInputs(
        Logic.VerifierInput[] calldata inputs,
        AggregatedArguments memory args,
        bool isProofAggregated,
        bytes32 actionTreeRoot,
        bytes32[] memory tagList
    ) internal returns (AggregatedArguments memory newArgs) {
        for (uint256 k = 0; k < inputs.length; ++k) {
            Logic.VerifierInput calldata logicInput = inputs[k];
            uint256 position = _lookup(tagList, logicInput.tag);
            bool isConsumed = (position % 2 == 0);
            uint256 globalPosition = args.tagCounter + position - tagList.length;

            _processLogicProof({
                input: logicInput,
                actionTreeRoot: actionTreeRoot,
                logicRef: args.logicRefs[globalPosition],
                isConsumed: isConsumed,
                isProofAggregated: isProofAggregated
            });

            if (isProofAggregated) {
                args.logicInstances[globalPosition] =
                    Logic.Instance(logicInput.tag, isConsumed, actionTreeRoot, logicInput.appData);
            }

            // Execute external calls.
            _executeForwarderCalls(logicInput);

            if (isConsumed) {
                _addNullifier(logicInput.tag);
            } else {
                args.commitmentTreeRoot = _addCommitment(logicInput.tag);
            }

            // Emit app-data blobs.
            _emitAppDataBlobs(logicInput.appData, logicInput.tag);
        }
        newArgs = args;
    }

    function _lookup(bytes32[] memory list, bytes32 tag) internal pure returns (uint256 position) {
        uint256 len = list.length;
        for (uint256 i = 0; i < len; ++i) {
            if (list[i] == tag) {
                return position = i;
            }
        }
        revert TagNotFound(tag);
    }
}
