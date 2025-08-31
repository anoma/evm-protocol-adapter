// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ReentrancyGuardTransient} from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {IForwarder} from "./interfaces/IForwarder.sol";
import {IProtocolAdapter} from "./interfaces/IProtocolAdapter.sol";

import {ComputableComponents} from "./libs/ComputableComponents.sol";
import {MerkleTree} from "./libs/MerkleTree.sol";
import {RiscZeroUtils} from "./libs/RiscZeroUtils.sol";
import {TagLookup} from "./libs/TagLookup.sol";

import {Compliance} from "./proving/Compliance.sol";
import {Delta} from "./proving/Delta.sol";
import {Logic} from "./proving/Logic.sol";
import {CommitmentAccumulator} from "./state/CommitmentAccumulator.sol";

import {NullifierSet} from "./state/NullifierSet.sol";

import {Action, ForwarderCalldata, Resource, Transaction} from "./Types.sol";

/// @title ProtocolAdapter
/// @author Anoma Foundation, 2025
/// @notice The protocol adapter contract verifying and executing resource machine transactions.
/// @custom:security-contact security@anoma.foundation
contract ProtocolAdapter is IProtocolAdapter, ReentrancyGuardTransient, CommitmentAccumulator, NullifierSet {
    using MerkleTree for bytes32[];
    using TagLookup for bytes32[];
    using ComputableComponents for Resource;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.VerifierInput;
    using Logic for Logic.VerifierInput[];
    using Delta for uint256[2];
    using EnumerableSet for EnumerableSet.Bytes32Set;

    RiscZeroVerifierRouter internal immutable _TRUSTED_RISC_ZERO_VERIFIER_ROUTER;
    uint8 internal immutable _ACTION_TAG_TREE_DEPTH;

    uint256 internal _txCount;

    error ZeroNotAllowed();

    error ForwarderCallOutputMismatch(bytes expected, bytes actual);
    error ResourceCountMismatch(uint256 expected, uint256 actual);
    error RootMismatch(bytes32 expected, bytes32 actual);
    error LogicRefMismatch(bytes32 expected, bytes32 actual);
    error RiscZeroVerifierStopped();

    error CalldataCarrierKindMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierCommitmentMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierNullifierMismatch(bytes32 expected, bytes32 actual);

    /// @notice Constructs the protocol adapter contract.
    /// @param riscZeroVerifierRouter The RISC Zero verifier router contract.
    /// @param commitmentTreeDepth The depth of the commitment tree of the commitment accumulator.
    /// @param actionTagTreeDepth The depth of the tag tree of each action.
    constructor(RiscZeroVerifierRouter riscZeroVerifierRouter, uint8 commitmentTreeDepth, uint8 actionTagTreeDepth)
        CommitmentAccumulator(commitmentTreeDepth)
    {
        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER = riscZeroVerifierRouter;
        _ACTION_TAG_TREE_DEPTH = actionTagTreeDepth;

        if (address(riscZeroVerifierRouter) == address(0)) {
            revert ZeroNotAllowed();
        }

        // Sanity check that the verifier has not been stopped already.
        if (isEmergencyStopped()) {
            revert RiscZeroVerifierStopped();
        }
    }

    // slither-disable-start reentrancy-no-eth
    /// @inheritdoc IProtocolAdapter
    function execute(Transaction calldata transaction) external override nonReentrant {
        {
            bytes32 newRoot = 0;
            uint256[2] memory transactionDelta = [uint256(0), uint256(0)];

            uint256 nActions = transaction.actions.length;

            // Calculate the total number of resources.
            uint256 resCounter = 0;
            for (uint256 i = 0; i < nActions; ++i) {
                resCounter += transaction.actions[i].logicVerifierInputs.length;
            }

            // Allocate the array.
            bytes32[] memory tags = new bytes32[](resCounter);

            // Reset the resource counter.
            resCounter = 0;

            for (uint256 i = 0; i < nActions; ++i) {
                Action calldata action = transaction.actions[i];

                uint256 nCUs = action.complianceVerifierInputs.length;
                uint256 nResources = action.logicVerifierInputs.length;

                // Check that the resource counts in the action and compliance units match
                if (nResources != nCUs * 2) {
                    revert ResourceCountMismatch({expected: nResources, actual: nCUs});
                }

                // Compute the root of the tree containing all tags of the action
                bytes32 actionTreeRoot = _computeActionTreeRoot(action, nCUs);

                for (uint256 j = 0; j < nCUs; ++j) {
                    Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];

                    bytes32 nf = complianceVerifierInput.instance.consumed.nullifier;
                    bytes32 cm = complianceVerifierInput.instance.created.commitment;

                    // Process the tags and provided root against global state
                    newRoot = _processState({
                        nf: nf,
                        cm: cm,
                        root: complianceVerifierInput.instance.consumed.commitmentTreeRoot
                    });

                    // Verify the proof against a hardcoded compliance circuit
                    _verifyComplianceProof(complianceVerifierInput);

                    // Check consumed resource logic, verifier key correspondence,
                    // as well as possible external calls
                    _processResourceLogicContext({
                        input: action.logicVerifierInputs.lookup(nf),
                        logicRef: complianceVerifierInput.instance.consumed.logicRef,
                        actionTreeRoot: actionTreeRoot,
                        consumed: true
                    });

                    // Check the related info for the created resource as well
                    _processResourceLogicContext({
                        input: action.logicVerifierInputs.lookup(cm),
                        logicRef: complianceVerifierInput.instance.created.logicRef,
                        actionTreeRoot: actionTreeRoot,
                        consumed: false
                    });

                    tags[resCounter++] = nf;
                    tags[resCounter++] = cm;

                    // Compute transaction delta
                    transactionDelta = _addUnitDelta({
                        transactionDelta: transactionDelta,
                        unitDelta: [
                            uint256(complianceVerifierInput.instance.unitDeltaX),
                            uint256(complianceVerifierInput.instance.unitDeltaY)
                        ]
                    });
                }
            }

            // Check that the transaction is balanced
            _verifyDeltaProof({proof: transaction.deltaProof, transactionDelta: transactionDelta, tags: tags});

            // Store the final root
            _storeRoot(newRoot);

            // Emit the event containing the transaction and new root
            emit TransactionExecuted({id: _txCount++, transaction: transaction, newRoot: newRoot});
        }
    }

    /// @inheritdoc IProtocolAdapter
    function isEmergencyStopped() public view override returns (bool isStopped) {
        isStopped = RiscZeroVerifierEmergencyStop(
            address(_TRUSTED_RISC_ZERO_VERIFIER_ROUTER.getVerifier(getRiscZeroVerifierSelector()))
        ).paused();
    }

    /// @inheritdoc IProtocolAdapter
    function getRiscZeroVerifierSelector() public pure virtual override returns (bytes4 verifierSelector) {
        verifierSelector = 0xbb001d44;
    }

    /// @notice Executes a call to a forwarder contracts.
    /// @param call The calldata to conduct the forwarder call.
    function _executeForwarderCall(ForwarderCalldata memory call) internal {
        // slither-disable-next-line calls-loop
        bytes memory output = IForwarder(call.untrustedForwarder).forwardCall(call.input);

        if (keccak256(output) != keccak256(call.output)) {
            revert ForwarderCallOutputMismatch({expected: call.output, actual: output});
        }

        // solhint-disable-next-line max-line-length
        emit ForwarderCallExecuted({untrustedForwarder: call.untrustedForwarder, input: call.input, output: call.output});
    }

    /// @notice The function processing the state checks and updates
    /// @param nf The nullifier of a compliance unit
    /// @param cm The commitment of a compliance unit
    /// @param root The current commitment tree root
    /// @return newRoot The root after potentially adding the commitment in the compliance unit
    function _processState(bytes32 nf, bytes32 cm, bytes32 root) internal returns (bytes32 newRoot) {
        // Check root in the compliance unit is an actually existing root
        _checkRootPreExistence(root);
        // Nullifier addition reverts if it was present in the set before
        _addNullifier(nf);
        // Compute the root after adding the commitment
        newRoot = _addCommitment(cm);
    }

    /// @notice Function for processing resource logics and related checks
    /// @param input The logic verifier input for processing
    /// @param logicRef The logic ref approved by compliance proof
    /// @param actionTreeRoot The root of the tree containing all action tags for the instance
    /// @param consumed Flag for indicating whether the resource is consumed
    function _processResourceLogicContext(
        Logic.VerifierInput calldata input,
        bytes32 logicRef,
        bytes32 actionTreeRoot,
        bool consumed
    ) internal {
        // Check verifier key correspondence
        if (logicRef != input.verifyingKey) {
            revert LogicRefMismatch({expected: input.verifyingKey, actual: logicRef});
        }

        // The PA checks whether a call is to be made by looking inside
        // the externalPayload and trying to process the first entry
        if (input.appData.externalPayload.length != 0) {
            _processForwarderCall(input, consumed);
        }

        // Verify the logic proof againts the provided verifying key
        _verifyLogicProof({input: input, root: actionTreeRoot, consumed: consumed});
    }

    /// @notice Function for verifying and executing forwarder calls
    /// @param input The logic verifier input of a resource making the call
    /// @param consumed A flag indicating whether the resource is consumed or not
    function _processForwarderCall(Logic.VerifierInput calldata input, bool consumed) internal {
        // The PA expects the forwarder calldata to be present at the head of the external payload
        ForwarderCalldata memory call = abi.decode(input.appData.externalPayload[0].blob, (ForwarderCalldata));
        // slither-disable-next-line calls-loop
        bytes32 fetchedKind = IForwarder(call.untrustedForwarder).calldataCarrierResourceKind();
        /// Verify whether the resource can make the call
        _verifyForwarderCall(input.appData.resourcePayload, input.tag, fetchedKind, consumed);
        /// Perform the calls
        _executeForwarderCall(call);
    }

    /// @notice Given an action, computes the root of a tree containing all of its tags
    /// @param action The action whose root we compute
    /// @param nCUs The number of compliance units in the action
    /// @return actionTreeRoot The root of the corresponding tree
    function _computeActionTreeRoot(Action calldata action, uint256 nCUs)
        internal
        view
        returns (bytes32 actionTreeRoot)
    {
        bytes32[] memory actionTreeTags = new bytes32[](nCUs * 2);

        // The order in which the tags are added to the tree are provided by the compliance units
        for (uint256 j = 0; j < nCUs; ++j) {
            Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];

            actionTreeTags[2 * j] = complianceVerifierInput.instance.consumed.nullifier;
            actionTreeTags[(2 * j) + 1] = complianceVerifierInput.instance.created.commitment;
        }

        actionTreeRoot = actionTreeTags.computeRoot(_ACTION_TAG_TREE_DEPTH);
    }

    /// @notice An internal function verifying a RISC0 compliance proof.
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

    /// @notice An internal function verifying a RISC0 logic proof.
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

    /// @notice An internal function verifying a delta proof.
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

    /// @notice Verifies the forwarder calls of a given action.
    /// @param payload The payload of the resource making the call.
    /// @param tag The tag of the resource making the call.
    /// @param kind The kind requested by the forwarder contract.
    /// @param consumed The flag indicating whether the resource is created or consumed
    function _verifyForwarderCall(Logic.ExpirableBlob[] calldata payload, bytes32 tag, bytes32 kind, bool consumed)
        internal
        pure
    {
        // The plaintext should be stored at the head of resource payload and be decodable
        Resource memory resource = abi.decode(payload[0].blob, (Resource));

        // Check kind correspondence
        if (resource.kind() != kind) {
            revert CalldataCarrierKindMismatch({expected: kind, actual: resource.kind()});
        }

        // Check tag correspondence
        if (!consumed) {
            // If created, compute the commitment of a resource and check correspondence to tag
            if (resource.commitment() != tag) {
                revert CalldataCarrierCommitmentMismatch({actual: tag, expected: resource.commitment()});
            }
        } else if (
            // If consumed, we expect the nullifier key to be present in the resource payload as well
            resource.nullifier(bytes32(payload[1].blob)) != tag
        ) {
            revert CalldataCarrierNullifierMismatch({
                actual: tag,
                expected: resource.nullifier(bytes32(payload[1].blob))
            });
        }
    }

    /// @notice An internal function adding a unit delta to the transactionDelta.
    /// @param transactionDelta The transaction delta.
    /// @param unitDelta The unit delta to add.
    /// @return sum The sum of the transaction delta and the unit delta.
    /// @dev This function is virtual to allow for it to be overridden, e.g., to mock delta proofs.
    function _addUnitDelta(uint256[2] memory transactionDelta, uint256[2] memory unitDelta)
        internal
        pure
        virtual
        returns (uint256[2] memory sum)
    {
        sum = transactionDelta.add(unitDelta);
    }
}
