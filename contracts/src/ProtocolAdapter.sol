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

import {Compliance} from "./proving/Compliance.sol";
import {Delta} from "./proving/Delta.sol";
import {Logic} from "./proving/Logic.sol";
import {CommitmentAccumulator} from "./state/CommitmentAccumulator.sol";

import {NullifierSet} from "./state/NullifierSet.sol";

import {Action, Transaction} from "./Types.sol";

// The semantic version number of the Anoma protocol adapter.
string constant PROTOCOL_ADAPTER_VERSION = "1.0.0-beta";

// The RISC Zero verifier selector that the protocol adapter is associated with.
bytes4 constant RISC_ZERO_VERIFIER_SELECTOR = 0x73c457ba;

/// @title ProtocolAdapter
/// @author Anoma Foundation, 2025
/// @notice The protocol adapter contract verifying and executing resource machine transactions.
/// @custom:security-contact security@anoma.foundation
contract ProtocolAdapter is
    IProtocolAdapter,
    ReentrancyGuardTransient,
    Ownable,
    Pausable,
    CommitmentAccumulator,
    NullifierSet
{
    using MerkleTree for bytes32[];
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.VerifierInput;
    using Logic for Logic.VerifierInput[];
    using Delta for uint256[2];

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
    /// @param owner The owner that can stop the protocol adapter in case of a vulnerability.
    constructor(RiscZeroVerifierRouter riscZeroVerifierRouter, bytes4 riscZeroVerifierSelector, address owner)
        Ownable(owner)
    {
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
        uint256 tagCount = 0;

        // Count the total number of tags in the transaction.
        for (uint256 i = 0; i < actionCount; ++i) {
            tagCount += transaction.actions[i].logicVerifierInputs.length;
        }

        // Allocate the tags array containing all commitments and nullifiers.
        bytes32[] memory tags = new bytes32[](tagCount);

        // Allocate the array containing all logic references.
        bytes32[] memory logicRefs = new bytes32[](tagCount);

        // Reset the resource counter.
        tagCount = 0;

        // Allocate variable for the root update.
        bytes32 updatedRoot = 0;

        // Start with the zero point on the curve for delta-computation.
        uint256[2] memory transactionDelta = [uint256(0), uint256(0)];

        for (uint256 i = 0; i < actionCount; ++i) {
            Action calldata action = transaction.actions[i];

            uint256 complianceUnitCount = action.complianceVerifierInputs.length;
            uint256 actionTagCount = action.logicVerifierInputs.length;

            // Check that the tag count in the action and compliance units matches which ensures that if the tags match,
            // the compliance units partition the action.
            if (actionTagCount != complianceUnitCount * 2) {
                revert TagCountMismatch({expected: actionTagCount, actual: complianceUnitCount * 2});
            }

            // Compute the action tree root.
            bytes32 actionTreeRoot = _computeActionTreeRoot(action, complianceUnitCount);

            for (uint256 j = 0; j < complianceUnitCount; ++j) {
                Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];

                bytes32 nf = complianceVerifierInput.instance.consumed.nullifier;
                bytes32 cm = complianceVerifierInput.instance.created.commitment;

                // Process the tags and provided root against global state.
                updatedRoot =
                    _processState({nf: nf, cm: cm, root: complianceVerifierInput.instance.consumed.commitmentTreeRoot});

                // Verify the proof against a hardcoded compliance circuit.
                _verifyComplianceProof(complianceVerifierInput);

                // Check the consumed resource.
                // slither-disable-next-line reentrancy-benign
                _processResourceLogicContext({
                    input: action.logicVerifierInputs.lookup(nf),
                    logicRef: complianceVerifierInput.instance.consumed.logicRef,
                    actionTreeRoot: actionTreeRoot,
                    consumed: true
                });

                // Check the created resource.
                // slither-disable-next-line reentrancy-benign
                _processResourceLogicContext({
                    input: action.logicVerifierInputs.lookup(cm),
                    logicRef: complianceVerifierInput.instance.created.logicRef,
                    actionTreeRoot: actionTreeRoot,
                    consumed: false
                });

                // Populate the tags and logic reference arrays.
                tags[tagCount] = nf;
                logicRefs[tagCount++] = complianceVerifierInput.instance.consumed.logicRef;
                tags[tagCount] = cm;
                logicRefs[tagCount++] = complianceVerifierInput.instance.created.logicRef;

                // Compute transaction delta.
                transactionDelta = transactionDelta.add(
                    [
                        uint256(complianceVerifierInput.instance.unitDeltaX),
                        uint256(complianceVerifierInput.instance.unitDeltaY)
                    ]
                );
            }

            emit ActionExecuted({actionTreeRoot: actionTreeRoot, actionTagCount: actionTagCount});
        }

        // Check if the transaction induces a state change.
        if (tagCount != 0) {
            // Check the delta proof.
            _verifyDeltaProof({proof: transaction.deltaProof, transactionDelta: transactionDelta, tags: tags});

            // Store the final root.
            _storeRoot(updatedRoot);
        }

        emit TransactionExecuted({tags: tags, logicRefs: logicRefs});
    }
    // slither-disable-end reentrancy-no-eth

    /// @inheritdoc IProtocolAdapter
    function estop() external override onlyOwner whenNotPaused {
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
    function getProtocolAdapterVersion() public pure override returns (string memory version) {
        version = PROTOCOL_ADAPTER_VERSION;
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

    /// @notice The function processing the state checks and updates.
    /// @param nf The nullifier of a compliance unit.
    /// @param cm The commitment of a compliance unit.
    /// @param root The current commitment tree root.
    /// @return newRoot The root after potentially adding the commitment in the compliance unit.
    function _processState(bytes32 nf, bytes32 cm, bytes32 root) internal returns (bytes32 newRoot) {
        // Check root in the compliance unit is an actually existing root.
        _checkRootPreExistence(root);

        // Nullifier addition reverts if it was present in the set before.
        _addNullifier(nf);

        // Compute the root after adding the commitment. Note, that the compliance circuit ensures the uniqueness of the
        // commitment given a unique nullifier in the same compliance unit.
        newRoot = _addCommitment(cm);
    }

    /// @notice Processes a resource by
    ///  * checking the verifying key correspondence,
    ///  * checking the resource logic proof, and
    ///  * processing forward calls.
    /// @param input The logic verifier input for processing.
    /// @param logicRef The logic ref approved by compliance proof.
    /// @param actionTreeRoot The root of the tree containing all action tags for the instance.
    /// @param consumed Flag for indicating whether the resource is consumed.
    function _processResourceLogicContext(
        Logic.VerifierInput calldata input,
        bytes32 logicRef,
        bytes32 actionTreeRoot,
        bool consumed
    ) internal {
        // Check verifying key correspondence.
        if (logicRef != input.verifyingKey) {
            revert LogicRefMismatch({expected: input.verifyingKey, actual: logicRef});
        }

        // Check the logic proof.
        _verifyLogicProof({input: input, root: actionTreeRoot, consumed: consumed});

        // Perform external calls.
        _processForwarderCalls(input);

        _emitBlobs(input);
    }

    /// @notice Emits app data blobs based on their deletion criterion.
    /// @param input The logic verifier input containing the app data.
    function _emitBlobs(Logic.VerifierInput calldata input) internal {
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
    function _processForwarderCalls(Logic.VerifierInput calldata verifierInput) internal {
        uint256 nCalls = verifierInput.appData.externalPayload.length;

        for (uint256 i = 0; i < nCalls; ++i) {
            _executeForwarderCall({
                carrierLogicRef: verifierInput.verifyingKey,
                callBlob: verifierInput.appData.externalPayload[i].blob
            });
        }
    }

    /// @notice Verifies a RISC0 compliance proof.
    /// @param input The verifier input of the compliance proof.
    /// @dev This function is virtual to allow for it to be overridden, e.g., to use mock proofs with a mock verifier.
    function _verifyComplianceProof(Compliance.VerifierInput calldata input) internal view virtual {
        // slither-disable-next-line calls-loop
        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
            seal: input.proof,
            imageId: Compliance._VERIFYING_KEY,
            journalDigest: input.instance.toJournalDigest()
        });
    }

    /// @notice Verifies a RISC0 logic proof.
    /// @param input The verifier input of the logic proof.
    /// @param root The root of the action tree containing all tags of an action.
    /// @param consumed Bool indicating whether the tag is a commitment or a nullifier.
    /// @dev This function is virtual to allow for it to be overridden, e.g., to mock proofs with a mock verifier.
    function _verifyLogicProof(Logic.VerifierInput calldata input, bytes32 root, bool consumed) internal view virtual {
        // slither-disable-next-line calls-loop
        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
            seal: input.proof,
            imageId: input.verifyingKey,
            journalDigest: input.toJournalDigest(root, consumed)
        });
    }

    /// @notice Verifies a delta proof.
    /// @param proof The delta proof.
    /// @param transactionDelta The transaction delta.
    /// @param tags The tags being part of the transaction in the order of appearance in the compliance units.
    /// @dev This function is virtual to allow for it to be overridden, e.g., to mock proofs.
    function _verifyDeltaProof(bytes calldata proof, uint256[2] memory transactionDelta, bytes32[] memory tags)
        internal
        view
        virtual
    {
        Delta.verify({proof: proof, instance: transactionDelta, verifyingKey: Delta.computeVerifyingKey(tags)});
    }

    /// @notice Computes the action tree root of an action constituted by all its nullifiers and commitments.
    /// @param action The action whose root we compute.
    /// @param complianceUnitCount The number of compliance units in the action.
    /// @return root The root of the corresponding tree.
    function _computeActionTreeRoot(Action calldata action, uint256 complianceUnitCount)
        internal
        pure
        returns (bytes32 root)
    {
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
