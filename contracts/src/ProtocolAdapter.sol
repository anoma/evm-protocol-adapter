// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Ownable} from "@openzeppelin-contracts-5.5.0/access/Ownable.sol";
import {Pausable} from "@openzeppelin-contracts-5.5.0/utils/Pausable.sol";
import {ReentrancyGuardTransient} from "@openzeppelin-contracts-5.5.0/utils/ReentrancyGuardTransient.sol";
import {RiscZeroVerifierRouter} from "risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierRouter.sol";

import {IForwarder} from "./interfaces/IForwarder.sol";
import {IProtocolAdapter} from "./interfaces/IProtocolAdapter.sol";
import {IVersion} from "./interfaces/IVersion.sol";

import {MerkleTree} from "./libs/MerkleTree.sol";
import {Aggregation} from "./libs/proving/Aggregation.sol";
import {Compliance} from "./libs/proving/Compliance.sol";
import {Delta} from "./libs/proving/Delta.sol";
import {Logic} from "./libs/proving/Logic.sol";
import {RiscZeroUtils} from "./libs/RiscZeroUtils.sol";
import {TagUtils} from "./libs/TagUtils.sol";
import {Versioning} from "./libs/Versioning.sol";

import {CommitmentTree} from "./state/CommitmentTree.sol";
import {NullifierSet} from "./state/NullifierSet.sol";
import {Action, Transaction} from "./Types.sol";

/// @title ProtocolAdapter
/// @author Anoma Foundation, 2025
/// @notice The protocol adapter contract verifying and executing resource machine transactions.
/// @custom:security-contact security@anoma.foundation
contract ProtocolAdapter is
    IProtocolAdapter,
    IVersion,
    ReentrancyGuardTransient,
    Ownable,
    Pausable,
    CommitmentTree,
    NullifierSet
{
    using Delta for Delta.Point;
    using MerkleTree for bytes32[];
    using Logic for Logic.VerifierInput[];
    using Logic for Logic.VerifierInput;
    using RiscZeroUtils for Aggregation.Instance;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;
    using TagUtils for Action;
    using TagUtils for Transaction;

    /// @notice A data structure containing general and proof aggregation-related internal variables being updated while
    /// iterating over the actions and compliance units during the `execute` function call.
    /// @param tags A variable to aggregate tags over the actions.
    /// @param logicRefs A variable to aggregate logic references over the actions.
    /// @param latestCommitmentTreeRoot The latest commitment tree root to be stored in the set of historical roots at
    /// the end of the `execute` function call.
    /// @param transactionDelta A variable to aggregate the unit deltas over the actions.
    /// @param tagCounter A counter representing the index of the next resource tag to visit.
    /// @param isProofAggregated Whether the transaction to execute contains an aggregated proof or not.
    /// @param complianceInstances A variable to aggregate RISC Zero compliance proof instances.
    /// @param logicInstances A variable to aggregate RISC Zero logic proof instances.
    struct InternalVariables {
        /* General variables */
        bytes32[] tags;
        bytes32[] logicRefs;
        bytes32 latestCommitmentTreeRoot;
        Delta.Point transactionDelta;
        uint256 tagCounter;
        /* Proof aggregation-related variables */
        bool isProofAggregated;
        Compliance.Instance[] complianceInstances;
        Logic.Instance[] logicInstances;
    }

    RiscZeroVerifierRouter internal immutable _TRUSTED_RISC_ZERO_VERIFIER_ROUTER;
    bytes4 internal immutable _RISC_ZERO_VERIFIER_SELECTOR;

    error ZeroNotAllowed();
    error ForwarderCallOutputMismatch(bytes expected, bytes actual);
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
    /// @dev This function cannot be called anymore once `emergencyStop()` has been called.
    function execute(Transaction calldata transaction) external override nonReentrant whenNotPaused {
        InternalVariables memory vars = _initializeVars(transaction);

        uint256 actionCount = transaction.actions.length;
        for (uint256 i = 0; i < actionCount; ++i) {
            Action calldata action = transaction.actions[i];

            // The action tree root is placed in the resource logic instance, informing a resource of all the
            // created and consumed resources in the same action.
            bytes32 actionTreeRoot = action.collectTags().computeRoot();

            uint256 complianceUnitCount = action.complianceVerifierInputs.length;
            for (uint256 j = 0; j < complianceUnitCount; ++j) {
                Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];

                // Process the compliance related checks and proofs.
                vars = _processCompliance({input: complianceVerifierInput, vars: vars});

                // Process the logic proof of the consumed resource.
                vars = _processLogic({
                    isConsumed: true,
                    // The `lookup` function reverts if the nullifier is not part of the logic verifier inputs.
                    input: action.logicVerifierInputs.lookup(complianceVerifierInput.instance.consumed.nullifier),
                    logicRefFromComplianceUnit: complianceVerifierInput.instance.consumed.logicRef,
                    actionTreeRoot: actionTreeRoot,
                    vars: vars
                });

                // Process the logic proof of the created resource.
                vars = _processLogic({
                    isConsumed: false,
                    // The `lookup` function reverts if the commitment is not part of the logic verifier inputs.
                    input: action.logicVerifierInputs.lookup(complianceVerifierInput.instance.created.commitment),
                    logicRefFromComplianceUnit: complianceVerifierInput.instance.created.logicRef,
                    actionTreeRoot: actionTreeRoot,
                    vars: vars
                });

                // After all tags in the action are looked up, we are ensured that the logic verifier input tags are
                // a subset of the tags as presented in the compliance unit.

                // Add the unit delta to the transaction delta.
                vars.transactionDelta = vars.transactionDelta
                    .add(
                        Delta.Point({
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
                deltaProof: transaction.deltaProof, aggregationProof: transaction.aggregationProof, vars: vars
            });

            // Store the final commitment tree root.
            _addCommitmentTreeRoot(vars.latestCommitmentTreeRoot);
        }

        // Emit the event containing the transaction and new root.
        emit TransactionExecuted({tags: vars.tags, logicRefs: vars.logicRefs});
    }

    // slither-disable-end reentrancy-no-eth

    /// @inheritdoc IProtocolAdapter
    function emergencyStop() external override onlyOwner whenNotPaused {
        _pause();
    }

    /// @inheritdoc IVersion
    function getVersion() external pure override returns (bytes32 version) {
        version = Versioning._PROTOCOL_ADAPTER_VERSION;
    }

    /// @inheritdoc IProtocolAdapter
    function isEmergencyStopped() public view override returns (bool isStopped) {
        bool risc0Paused =
            Pausable(address(_TRUSTED_RISC_ZERO_VERIFIER_ROUTER.getVerifier(getRiscZeroVerifierSelector()))).paused();

        isStopped = paused() || risc0Paused;
    }

    /// @inheritdoc IProtocolAdapter
    function getRiscZeroVerifierRouter() public view override returns (address verifierRouter) {
        verifierRouter = address(_TRUSTED_RISC_ZERO_VERIFIER_ROUTER);
    }

    /// @inheritdoc IProtocolAdapter
    function getRiscZeroVerifierSelector() public view override returns (bytes4 verifierSelector) {
        verifierSelector = _RISC_ZERO_VERIFIER_SELECTOR;
    }

    /// @notice Processes a resource logic proof by
    /// * checking that the logic reference matches the one with the corresponding tag in the compliance unit,
    /// * aggregating the logic instance OR verifying the RISC Zero logic proof,
    /// * executing external forwarder calls,
    /// * adding the consumed or created resource tag to the commitment tree or nullifier set,
    /// * emitting the blobs contained in the app data payloads, and
    /// * updating the internal variables
    ///   * adding the tag to the `tags `array
    ///   * adding the logic reference to the `logicRefs` array
    ///   * incrementing the tag counter
    ///   * updating the current commitment tree root
    /// @param isConsumed Whether the logic belongs to a consumed or created resource.
    /// @param input The logic verifier input.
    /// @param logicRefFromComplianceUnit The logic references as found in the corresponding compliance unit.
    /// @param actionTreeRoot The action tree root.
    /// @param vars Internal variables to read from.
    /// @return updatedVars The updated internal variables.
    function _processLogic(
        bool isConsumed,
        Logic.VerifierInput calldata input,
        bytes32 logicRefFromComplianceUnit,
        bytes32 actionTreeRoot,
        InternalVariables memory vars
    ) internal returns (InternalVariables memory updatedVars) {
        updatedVars = vars;

        // In this RM implementation the logicRef is the verifying key.
        bytes32 logicRef = input.verifyingKey;

        // Check that the logic reference from the logic verifier input matches the expected reference from the
        // compliance unit.
        if (logicRef != logicRefFromComplianceUnit) {
            revert LogicRefMismatch({expected: logicRefFromComplianceUnit, actual: logicRef});
        }

        {
            // Obtain the logic instance from the verifier input, action tree root, and consumed flag.
            Logic.Instance memory instance = input.toInstance({actionTreeRoot: actionTreeRoot, isConsumed: isConsumed});

            if (updatedVars.isProofAggregated) {
                // Aggregate the logic instance.
                updatedVars.logicInstances[updatedVars.tagCounter] = instance;
            } else {
                // Verify the logic proof.
                // slither-disable-next-line calls-loop
                _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
                    seal: input.proof, imageId: logicRef, journalDigest: sha256(instance.toJournal())
                });
            }
        }

        _executeForwarderCalls(input);

        bytes32 tag = input.tag;
        // Populate the tags array for use as a verification key for the delta proof.
        // Note that the order of the compliance units dictate the delta verifying key.
        updatedVars.tags[updatedVars.tagCounter] = tag;

        // Populate an array containing all the logic references.
        // This is used both for events and aggregation proofs.
        updatedVars.logicRefs[updatedVars.tagCounter++] = logicRef;

        // Transition the resource machine state.
        if (isConsumed) {
            // The function reverts if a repeating tag is added to the set.
            // If the final nullifier stored in the action gets added to the set successfully,
            // the compliance units partition the action.
            _addNullifier(tag);
        } else {
            // `_addCommitment` does not error if a repeating leaf is added to the tree.
            // Uniqueness of commitments is grated by the compliance circuit, assuming that nullifiers are unique.
            updatedVars.latestCommitmentTreeRoot = _addCommitment(tag);
        }

        _emitAppDataBlobs(input);
    }

    /// @notice Processes forwarder calls by verifying and executing them.
    /// @param verifierInput The logic verifier input of a resource making the call.
    function _executeForwarderCalls(Logic.VerifierInput calldata verifierInput) internal {
        uint256 nCalls = verifierInput.appData.externalPayload.length;

        for (uint256 i = 0; i < nCalls; ++i) {
            _executeForwarderCall({
                carrierLogicRef: verifierInput.verifyingKey, callBlob: verifierInput.appData.externalPayload[i].blob
            });
        }
    }

    /// @notice Executes a call to a an external, untrusted forwarder contract.
    /// @param carrierLogicRef The logic reference of the carrier resource.
    /// @param callBlob The blob containing the external call instruction.
    /// @dev This function allows arbitrary code execution through the protocol adapter but is constrained through
    /// the associated carrier resource logic.
    function _executeForwarderCall(bytes32 carrierLogicRef, bytes calldata callBlob) internal {
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

    /// @notice Emits app data blobs together with the associated resource tag based on their deletion criterion.
    /// @param input The logic verifier input of a resource making the call.
    function _emitAppDataBlobs(Logic.VerifierInput calldata input) internal {
        bytes32 tag = input.tag;

        Logic.ExpirableBlob[] calldata payload = input.appData.resourcePayload;
        uint256 n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit ResourcePayload({tag: tag, index: i, blob: payload[i].blob});
            }
        }

        payload = input.appData.discoveryPayload;
        n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit DiscoveryPayload({tag: tag, index: i, blob: payload[i].blob});
            }
        }

        payload = input.appData.externalPayload;
        n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit ExternalPayload({tag: tag, index: i, blob: payload[i].blob});
            }
        }

        payload = input.appData.applicationPayload;
        n = payload.length;
        for (uint256 i = 0; i < n; ++i) {
            if (payload[i].deletionCriterion == Logic.DeletionCriterion.Never) {
                emit ApplicationPayload({tag: tag, index: i, blob: payload[i].blob});
            }
        }
    }

    /// @notice Processes a resource machine compliance proof by
    /// * checking that the commitment tree root references by the consumed resource is in the set of historical roots,
    /// * aggregating the compliance instance OR verifying the RISC Zero compliance proof
    /// @param input The compliance verifier input.
    /// @param vars Internal variables to read from.
    /// @return updatedVars The updated internal variables.
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

        if (updatedVars.isProofAggregated) {
            // Aggregate the compliance instance
            updatedVars.complianceInstances[vars.tagCounter / Compliance._RESOURCES_PER_COMPLIANCE_UNIT] =
            input.instance;
        } else {
            // Verify the compliance proof.
            // slither-disable-next-line calls-loop
            _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
                seal: input.proof, imageId: Compliance._VERIFYING_KEY, journalDigest: sha256(input.instance.toJournal())
            });
        }
    }

    /// @notice Verifies global proofs:
    /// * the mandatory delta proof ensuring that the transaction is balanced,
    /// * the optional aggregation proof if present.
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
            proof: deltaProof, instance: vars.transactionDelta, verifyingKey: Delta.computeVerifyingKey(vars.tags)
        });

        if (vars.isProofAggregated) {
            // Verify aggregation proof.
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

    /// @notice Initializes internal variables based on the tag count of the transaction and whether it contains an
    /// aggregation proof or not.
    /// @param transaction The transaction object.
    /// @return vars The initialized internal variables.
    function _initializeVars(Transaction calldata transaction) internal pure returns (InternalVariables memory vars) {
        // Compute the tag count.
        //Note that this function ensures that the tag count is a multiple of two.
        uint256 tagCount = transaction.countTags();

        bool isProofAggregated = transaction.aggregationProof.length > 0;

        // Initialize
        vars = InternalVariables({
            /* General variables */
            tags: new bytes32[](tagCount),
            logicRefs: new bytes32[](tagCount),
            latestCommitmentTreeRoot: bytes32(0),
            transactionDelta: Delta.zero(),
            tagCounter: 0,
            /* Proof aggregation-related variables */
            isProofAggregated: isProofAggregated,
            complianceInstances: new Compliance
                .Instance[](isProofAggregated ? tagCount / Compliance._RESOURCES_PER_COMPLIANCE_UNIT : 0),
            logicInstances: new Logic.Instance[](isProofAggregated ? tagCount : 0)
        });
    }
}
