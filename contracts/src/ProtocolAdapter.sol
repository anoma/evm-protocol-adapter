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
    using TagLookup for bytes32[];
    using ComputableComponents for Resource;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;
    using Logic for Logic.VerifierInput[];
    using Delta for uint256[2];

    RiscZeroVerifierRouter internal immutable _TRUSTED_RISC_ZERO_VERIFIER_ROUTER;
    uint8 internal immutable _ACTION_TAG_TREE_DEPTH;

    uint256 private _txCount;

    error ForwarderCallOutputMismatch(bytes expected, bytes actual);

    error ResourceLifecycleMismatch(bool expected);
    error ResourceCountMismatch(uint256 expected, uint256 actual);
    error RootMismatch(bytes32 expected, bytes32 actual);
    error LogicRefMismatch(bytes32 expected, bytes32 actual);
    error RiscZeroVerifierStopped();

    error CalldataCarrierKindMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierAppDataMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierLabelMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierCommitmentNotFound(bytes32 commitment);

    /// @notice Constructs the protocol adapter contract.
    /// @param riscZeroVerifierRouter The RISC Zero verifier router contract.
    /// @param commitmentTreeDepth The depth of the commitment tree of the commitment accumulator.
    /// @param actionTagTreeDepth The depth of the tag tree of each action.
    constructor(RiscZeroVerifierRouter riscZeroVerifierRouter, uint8 commitmentTreeDepth, uint8 actionTagTreeDepth)
        CommitmentAccumulator(commitmentTreeDepth)
    {
        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER = riscZeroVerifierRouter;
        _ACTION_TAG_TREE_DEPTH = actionTagTreeDepth;

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
                Logic.Instance calldata instance = action.logicVerifierInputs[j].instance;

                if (instance.isConsumed) {
                    _addNullifier(instance.tag);
                } else {
                    newRoot = _addCommitment(instance.tag);
                }
            }

            uint256 nForwarderCalls = action.resourceCalldataPairs.length;
            for (uint256 j = 0; j < nForwarderCalls; ++j) {
                _executeForwarderCall(action.resourceCalldataPairs[j].call);
            }
        }

        if (newRoot != 0) {
            // Store the latest root
            _storeRoot(newRoot);
        }

        // slither-disable-next-line reentrancy-benign
        emit TransactionExecuted({id: ++_txCount, transaction: transaction, newRoot: newRoot});
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
        verifierSelector = 0x9f39696c;
    }

    /// @notice Executes a call to a forwarder contracts.
    /// @param call The calldata to conduct the forwarder call.
    function _executeForwarderCall(ForwarderCalldata calldata call) internal {
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

            bytes32[] memory actionTreeTags = new bytes32[](nResources);

            // Check that the resource counts in the action and compliance units match
            if (nResources != nCUs * 2) {
                revert ResourceCountMismatch({expected: nResources, actual: nCUs});
            }

            _verifyForwarderCalls(action);

            // Compliance Proofs
            {
                for (uint256 j = 0; j < nCUs; ++j) {
                    Compliance.VerifierInput calldata complianceVerifierInput = action.complianceVerifierInputs[j];

                    bytes32 nf = complianceVerifierInput.instance.consumed.nullifier;
                    bytes32 cm = complianceVerifierInput.instance.created.commitment;

                    {
                        // Check that the root exists.
                        _checkRootPreExistence(complianceVerifierInput.instance.consumed.commitmentTreeRoot);

                        // Check that the nullifier does not already exist in the transaction.
                        tags.checkNullifierNonExistence(nf);

                        // Check that the nullifier does not exists in the nullifier set.
                        _checkNullifierNonExistence(nf);

                        // Add the nullifier to the list of tags
                        // solhint-disable-next-line gas-increment-by-one
                        tags[resCounter++] = nf;
                        actionTreeTags[2 * j] = nf;
                    }

                    {
                        // Check that the commitment does not already exist
                        tags.checkCommitmentNonExistence(cm);

                        // Check that the commitment does not exist in the commitment accumulator
                        _checkCommitmentNonExistence(cm);

                        // Add the nullifier to the list of tags
                        // solhint-disable-next-line gas-increment-by-one
                        tags[resCounter++] = cm;
                        actionTreeTags[(2 * j) + 1] = cm;
                    }

                    _verifyComplianceProof(complianceVerifierInput);

                    // Check the logic ref consistency
                    {
                        Logic.VerifierInput calldata logicVerifierInput = action.logicVerifierInputs.lookup(nf);

                        if (!logicVerifierInput.instance.isConsumed) {
                            revert ResourceLifecycleMismatch({expected: true});
                        }

                        if (complianceVerifierInput.instance.consumed.logicRef != logicVerifierInput.verifyingKey) {
                            revert LogicRefMismatch({
                                expected: logicVerifierInput.verifyingKey,
                                actual: complianceVerifierInput.instance.consumed.logicRef
                            });
                        }
                    }
                    {
                        Logic.VerifierInput calldata logicVerifierInput = action.logicVerifierInputs.lookup(cm);

                        if (logicVerifierInput.instance.isConsumed) {
                            revert ResourceLifecycleMismatch({expected: false});
                        }

                        if (complianceVerifierInput.instance.created.logicRef != logicVerifierInput.verifyingKey) {
                            revert LogicRefMismatch({
                                expected: logicVerifierInput.verifyingKey,
                                actual: complianceVerifierInput.instance.created.logicRef
                            });
                        }
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

            // Logic Proofs
            {
                bytes32 computedActionTreeRoot = MerkleTree.computeRoot(actionTreeTags, _ACTION_TAG_TREE_DEPTH);

                for (uint256 j = 0; j < nResources; ++j) {
                    Logic.VerifierInput calldata input = action.logicVerifierInputs[j];

                    // Check root consistency
                    if (input.instance.actionTreeRoot != computedActionTreeRoot) {
                        revert RootMismatch({expected: computedActionTreeRoot, actual: input.instance.actionTreeRoot});
                    }

                    // Check the logic proof
                    _verifyLogicProof(input);
                }
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
    /// @dev This function is virtual to allow for it to be overridden, e.g., to mock proofs with a mock verifier.
    function _verifyLogicProof(Logic.VerifierInput calldata input) internal view virtual {
        // slither-disable-next-line calls-loop
        _TRUSTED_RISC_ZERO_VERIFIER_ROUTER.verify({
            seal: input.proof,
            imageId: input.verifyingKey,
            journalDigest: input.instance.toJournalDigest()
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
    /// @param action The action to verify the forwarder calls for.
    function _verifyForwarderCalls(Action calldata action) internal view {
        uint256 nForwarderCalls = action.resourceCalldataPairs.length;
        for (uint256 i = 0; i < nForwarderCalls; ++i) {
            Resource calldata carrier = action.resourceCalldataPairs[i].carrier;
            ForwarderCalldata calldata call = action.resourceCalldataPairs[i].call;

            // Kind integrity check

            {
                bytes32 passedKind = carrier.kind();

                // slither-disable-next-line calls-loop
                bytes32 fetchedKind = IForwarder(call.untrustedForwarder).calldataCarrierResourceKind();

                if (passedKind != fetchedKind) {
                    revert CalldataCarrierKindMismatch({expected: fetchedKind, actual: passedKind});
                }
            }

            // AppData integrity check
            {
                bytes32 expectedAppDataHash = keccak256(abi.encode(call.untrustedForwarder, call.input, call.output));

                // Lookup the first appData entry.
                bytes32 actualAppDataHash =
                    keccak256(abi.encode(action.logicVerifierInputs.lookup(carrier.commitment()).instance.appData[0]));

                if (actualAppDataHash != expectedAppDataHash) {
                    revert CalldataCarrierAppDataMismatch({actual: actualAppDataHash, expected: expectedAppDataHash});
                }
            }
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
