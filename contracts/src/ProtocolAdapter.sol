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
    using Logic for Logic.VerifierInput;
    using Logic for bytes32[];
    using RiscZeroUtils for Aggregation.Instance;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;
    using RiscZeroUtils for uint32;

    /// @notice A data structure containing internal variables being updated while iterating over the actions and
    ///  compliance units of the transaction to execute.
    /// @param commitmentTreeRoot The commitment tree root for the root update.
    /// @param tags A variable to aggregate tags over the actions.
    /// @param logicRefs A variable to aggregate logic references over the actions.
    /// @param transactionDelta A variable to aggregate the unit deltas over the actions.
    /// @param packedComplianceProofJournals A variable to aggregate RISC Zero compliance proof journals.
    /// @param packedLogicProofJournals A variable to aggregate RISC Zero logic proof journals.
    struct InternalVariables {
        bytes32 commitmentTreeRoot;
        bytes32[] tags;
        bytes32[] logicRefs;
        Delta.CurvePoint transactionDelta;
        Compliance.Instance[] complianceInstances;
        Logic.Instance[] logicInstances;
        uint256 tagCounter;
        bool isProofAggregated;
    }

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
        (uint256 actionCount, uint256 tagCount) = _computeCounts(transaction);

        InternalVariables memory vars =
            _initializeVars({tagCount: tagCount, isProofAggregated: transaction.aggregationProof.length > 0});

        for (uint256 i = 0; i < actionCount; ++i) {
            Action calldata action = transaction.actions[i];

            bytes32 actionTreeRoot = _computeActionTreeRoot(action);

            uint256 complianceUnitCount = action.complianceVerifierInputs.length;
            for (uint256 j = 0; j < complianceUnitCount; ++j) {
                Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];

                // Compliance proof
                vars = _processCompliance({input: complianceVerifierInput, vars: vars});

                // Consumed logic proof
                vars = _processLogic({
                    isConsumed: true,
                    input: action.logicVerifierInputs.lookup(complianceVerifierInput.instance.consumed.nullifier),
                    complianceLogicRef: complianceVerifierInput.instance.consumed.logicRef,
                    actionTreeRoot: actionTreeRoot,
                    vars: vars
                });

                // Created logic proof
                vars = _processLogic({
                    isConsumed: false,
                    input: action.logicVerifierInputs.lookup(complianceVerifierInput.instance.created.commitment),
                    complianceLogicRef: complianceVerifierInput.instance.created.logicRef,
                    actionTreeRoot: actionTreeRoot,
                    vars: vars
                });

                // Add unit delta
                vars.transactionDelta = vars.transactionDelta.add(
                    Delta.CurvePoint({
                        x: uint256(complianceVerifierInput.instance.unitDeltaX),
                        y: uint256(complianceVerifierInput.instance.unitDeltaY)
                    })
                );
            }
            emit ActionExecuted({actionTreeRoot: actionTreeRoot, actionTagCount: action.logicVerifierInputs.length});
        }

        // Check if the transaction induces a state change.
        if (vars.tagCounter > 0) {
            // Verify the delta proof and, optionally, the aggregation proof, if it is present.
            _verifyGlobalProofs({
                deltaProof: transaction.deltaProof,
                aggregationProof: transaction.aggregationProof,
                vars: vars
            });

            // Store the final commitment tree root
            _addCommitmentTreeRoot(vars.commitmentTreeRoot);
        }

        // Emit the event containing the transaction and new root
        emit TransactionExecuted({tags: vars.tags, logicRefs: vars.logicRefs});
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
    function _emitAppDataBlobs(Logic.VerifierInput calldata input) internal {
        Logic.ExpirableBlob[] calldata payload = input.appData.resourcePayload;
        uint256 n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit ResourcePayload({tag: input.tag, index: i, blob: payload[i].blob});
            }
        }

        payload = input.appData.discoveryPayload;
        n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit DiscoveryPayload({tag: input.tag, index: i, blob: payload[i].blob});
            }
        }

        payload = input.appData.externalPayload;
        n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit ExternalPayload({tag: input.tag, index: i, blob: payload[i].blob});
            }
        }

        payload = input.appData.applicationPayload;
        n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit ApplicationPayload({tag: input.tag, index: i, blob: payload[i].blob});
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

    /// @param vars Internal variables to read from.
    function _processLogic(
        bool isConsumed,
        Logic.VerifierInput calldata input,
        bytes32 complianceLogicRef,
        bytes32 actionTreeRoot,
        InternalVariables memory vars
    ) internal returns (InternalVariables memory updatedVars) {
        updatedVars = vars;

        _checkLogicRefConsistency({fromLogicProof: input.verifyingKey, fromComplianceProof: complianceLogicRef});

        _executeForwarderCalls(input);

        {
            // Process logic proof.
            Logic.Instance memory instance = input.toInstance({actionTreeRoot: actionTreeRoot, isConsumed: isConsumed});

            // Aggregate the logic instance.
            if (updatedVars.isProofAggregated) {
                updatedVars.logicInstances[updatedVars.tagCounter] = instance;
            }
            // Verify the logic proof.
            else {
                // slither-disable-next-line calls-loop
                _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
                    seal: input.proof,
                    imageId: input.verifyingKey,
                    journalDigest: sha256(instance.toJournal())
                });
            }
        }

        bytes32 tag = input.tag;
        updatedVars.tags[updatedVars.tagCounter] = tag;
        updatedVars.logicRefs[updatedVars.tagCounter++] = input.verifyingKey;

        // Transition the resource machine state.
        if (isConsumed) {
            _addNullifier(tag);
        } else {
            updatedVars.commitmentTreeRoot = _addCommitment(tag);
        }

        _emitAppDataBlobs(input);
    }

    /// @param vars Internal variables to read from.
    function _processCompliance(Compliance.VerifierInput calldata input, InternalVariables memory vars)
        internal
        view
        returns (InternalVariables memory updatedVars)
    {
        updatedVars = vars;

        bytes32 root = input.instance.consumed.commitmentTreeRoot;
        if (!_isCommitmentTreeRootContained(root)) {
            revert NonExistingRoot(root);
        }

        // Aggregate the compliance instance
        if (updatedVars.isProofAggregated) {
            updatedVars.complianceInstances[vars.tagCounter / 2] = input.instance;
        }
        // Verify the compliance proof.
        else {
            // slither-disable-next-line calls-loop
            _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
                seal: input.proof,
                imageId: Compliance._VERIFYING_KEY,
                journalDigest: sha256(input.instance.toJournal())
            });
        }
    }

    /// @notice Verifies global proofs:
    /// @param deltaProof The delta proof to verify.
    /// @param aggregationProof The aggregation proof to verify if existent.
    /// @param vars Internal variables to read from.
    function _verifyGlobalProofs(
        bytes calldata deltaProof,
        bytes calldata aggregationProof,
        InternalVariables memory vars
    ) internal view {
        // Check the delta proof.
        Delta.verify({
            proof: deltaProof,
            instance: vars.transactionDelta,
            verifyingKey: Delta.computeVerifyingKey(vars.tags)
        });

        // Verify aggregation proof.
        if (vars.isProofAggregated) {
            // slither-disable-next-line calls-loop
            _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
                seal: aggregationProof,
                imageId: Aggregation._VERIFYING_KEY,
                journalDigest: sha256(
                    Aggregation.Instance({
                        logicRefs: vars.logicRefs,
                        complianceInstances: vars.complianceInstances,
                        logicInstances: vars.logicInstances
                    }).toJournal()
                )
            });
        }
    }

    function _initializeVars(uint256 tagCount, bool isProofAggregated)
        internal
        pure
        returns (InternalVariables memory vars)
    {
        vars = InternalVariables({
            // Initialize regular variables.
            commitmentTreeRoot: bytes32(0),
            tags: new bytes32[](tagCount),
            logicRefs: new bytes32[](tagCount),
            transactionDelta: Delta.zero(),
            tagCounter: 0,
            // Initialize proof aggregation-related variables.
            isProofAggregated: isProofAggregated,
            complianceInstances: new Compliance.Instance[](isProofAggregated ? tagCount / 2 : 0),
            logicInstances: new Logic.Instance[](isProofAggregated ? tagCount : 0)
        });
    }

    function _computeCounts(Transaction calldata transaction)
        internal
        pure
        returns (uint256 actionCount, uint256 tagCount)
    {
        actionCount = transaction.actions.length;

        // Count the total number of tags in the transaction.
        for (uint256 i = 0; i < actionCount; ++i) {
            Action calldata action = transaction.actions[i];

            uint256 complianceUnitCount = action.complianceVerifierInputs.length;
            uint256 actionTagCount = action.logicVerifierInputs.length;

            // Check that the tag count in the action and compliance units match.
            if (actionTagCount != complianceUnitCount * 2) {
                revert TagCountMismatch({expected: actionTagCount, actual: complianceUnitCount * 2});
            }

            tagCount += action.logicVerifierInputs.length;
        }
    }

    function _checkLogicRefConsistency(bytes32 fromLogicProof, bytes32 fromComplianceProof) internal pure {
        if (fromLogicProof != fromComplianceProof) {
            revert LogicRefMismatch({expected: fromComplianceProof, actual: fromLogicProof});
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
