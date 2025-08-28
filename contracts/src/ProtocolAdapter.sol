// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ReentrancyGuardTransient} from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
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
        _verify(transaction);

        bytes32 newRoot = 0;

        uint256 nActions = transaction.actions.length;
        for (uint256 i = 0; i < nActions; ++i) {
            Action calldata action = transaction.actions[i];

            uint256 nResources = action.logicVerifierInputs.length;
            for (uint256 j = 0; j < nResources; ++j) {
                Logic.VerifierInput calldata input = action.logicVerifierInputs[j];

                if (input.appData.externalPayload.length != 0) {
                    ForwarderCalldata memory call =
                        abi.decode(input.appData.externalPayload[0].blob, (ForwarderCalldata));
                    _executeForwarderCall(call);
                }
            }

            uint256 nCUs = action.complianceVerifierInputs.length;
            for (uint256 k = 0; k < nCUs; ++k) {
                Compliance.Instance calldata instance = action.complianceVerifierInputs[k].instance;
                _addNullifier(instance.consumed.nullifier);
                newRoot = _addCommitment(instance.created.commitment);
            }
        }

        if (newRoot != 0) {
            // Store the latest root
            _storeRoot(newRoot);
        }

        // slither-disable-next-line reentrancy-benign
        emit TransactionExecuted({id: _txCount++, transaction: transaction, newRoot: newRoot});
    }
    // slither-disable-end reentrancy-no-eth

    /// @inheritdoc IProtocolAdapter
    function verify(Transaction calldata transaction) external view override {
        _verify(transaction);
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

    /// @notice An internal function to verify a transaction.
    /// @param transaction The transaction to verify.
    function _verify(Transaction calldata transaction) internal view {
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

            // Compute the action tree root
            bytes32 actionTreeRoot;
            {
                bytes32[] memory actionTreeTags = new bytes32[](nResources);

                // Prepare the action tree tags
                for (uint256 j = 0; j < nCUs; ++j) {
                    Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];

                    actionTreeTags[2 * j] = complianceVerifierInput.instance.consumed.nullifier;
                    actionTreeTags[(2 * j) + 1] = complianceVerifierInput.instance.created.commitment;
                }

                actionTreeRoot = actionTreeTags.computeRoot(_ACTION_TAG_TREE_DEPTH);
            }

            for (uint256 j = 0; j < nCUs; ++j) {
                Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];

                bytes32 nf = complianceVerifierInput.instance.consumed.nullifier;
                bytes32 cm = complianceVerifierInput.instance.created.commitment;

                // Check the compliance unit
                {
                    // Check that the root exists.
                    _checkRootPreExistence(complianceVerifierInput.instance.consumed.commitmentTreeRoot);

                    // Check that the nullifier does not already exist in the transaction.
                    tags.checkNullifierNonExistence(nf);

                    // Check that the nullifier does not exists in the nullifier set.
                    _checkNullifierNonExistence(nf);

                    // Verify the compliance proof
                    _verifyComplianceProof(complianceVerifierInput);

                    tags[resCounter++] = nf;
                    tags[resCounter++] = cm;
                }

                // Check consumed resource
                {
                    Logic.VerifierInput calldata consumedInput = action.logicVerifierInputs.lookup(nf);

                    // Check logic ref consistency
                    if (complianceVerifierInput.instance.consumed.logicRef != consumedInput.verifyingKey) {
                        revert LogicRefMismatch({
                            expected: consumedInput.verifyingKey,
                            actual: complianceVerifierInput.instance.consumed.logicRef
                        });
                    }

                    // Check the external call payload if present
                    if (consumedInput.appData.externalPayload.length != 0) {
                        _verifyForwarderCall(consumedInput, true);
                    }

                    // Check the logic proof
                    _verifyLogicProof({input: consumedInput, root: actionTreeRoot, consumed: true});
                }

                // Check created resource
                {
                    Logic.VerifierInput calldata createdInput = action.logicVerifierInputs.lookup(cm);

                    // Check logic ref consistency
                    if (complianceVerifierInput.instance.created.logicRef != createdInput.verifyingKey) {
                        revert LogicRefMismatch({
                            expected: createdInput.verifyingKey,
                            actual: complianceVerifierInput.instance.created.logicRef
                        });
                    }

                    // Check the external call payload if present
                    if (createdInput.appData.externalPayload.length != 0) {
                        _verifyForwarderCall(createdInput, false);
                    }

                    // Check the logic proof
                    _verifyLogicProof({input: createdInput, root: actionTreeRoot, consumed: false});
                }

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

        // Check whether the transaction is empty
        if (nActions != 0) {
            // Check the delta proof

            _verifyDeltaProof({proof: transaction.deltaProof, transactionDelta: transactionDelta, tags: tags});
        }
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

    /// @notice Verifies the forwarder calls of a given action.
    /// @param input The input to verify the forwarder calls for.
    /// @param consumed The bool indicating whether the tag is commitment of nullifier
    function _verifyForwarderCall(Logic.VerifierInput calldata input, bool consumed) internal view {
        // The PA expects the forwarder calldata to be present at the head of the external payload
        ForwarderCalldata memory call = abi.decode(input.appData.externalPayload[0].blob, (ForwarderCalldata));
        // The plaintext should be stored at the head of resource payload and be decodable
        Resource memory resource = abi.decode(input.appData.resourcePayload[0].blob, (Resource));
        // slither-disable-next-line calls-loop
        bytes32 fetchedKind = IForwarder(call.untrustedForwarder).calldataCarrierResourceKind();

        // Check kind correspondence
        if (resource.kind() != fetchedKind) {
            revert CalldataCarrierKindMismatch({expected: fetchedKind, actual: resource.kind()});
        }

        // Check tag correspondence
        if (!consumed) {
            // If created, compute the commitment of a resource and check correspondence to tag
            if (resource.commitment() != input.tag) {
                revert CalldataCarrierCommitmentMismatch({actual: input.tag, expected: resource.commitment()});
            }
        } else if (
            // If consumed, we expect the nullifier key to be present in the resource payload as well
            resource.nullifier(bytes32(input.appData.resourcePayload[1].blob)) != input.tag
        ) {
            revert CalldataCarrierNullifierMismatch({
                actual: input.tag,
                expected: resource.nullifier(bytes32(input.appData.resourcePayload[1].blob))
            });
        }
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
