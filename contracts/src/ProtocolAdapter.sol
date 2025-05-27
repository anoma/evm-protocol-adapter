// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ReentrancyGuardTransient} from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
import {IRiscZeroVerifier as TrustedRiscZeroVerifier} from "@risc0-ethereum/IRiscZeroVerifier.sol";

import {IForwarder} from "./interfaces/IForwarder.sol";
import {IProtocolAdapter} from "./interfaces/IProtocolAdapter.sol";

import {ComputableComponents} from "./libs/ComputableComponents.sol";
import {MerkleTree} from "./libs/MerkleTree.sol";
import {RiscZeroUtils} from "./libs/RiscZeroUtils.sol";

import {Compliance} from "./proving/Compliance.sol";
import {Delta} from "./proving/Delta.sol";
import {Logic} from "./proving/Logic.sol";
import {BlobStorage} from "./state/BlobStorage.sol";
import {CommitmentAccumulator} from "./state/CommitmentAccumulator.sol";

import {NullifierSet} from "./state/NullifierSet.sol";

import {Action, ForwarderCalldata, Resource, Transaction} from "./Types.sol";

contract ProtocolAdapter is
    IProtocolAdapter,
    ReentrancyGuardTransient,
    CommitmentAccumulator,
    NullifierSet,
    BlobStorage
{
    using ComputableComponents for Resource;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;
    using Logic for Logic.VerifierInput[];
    using Delta for uint256[2];

    TrustedRiscZeroVerifier internal immutable _TRUSTED_RISC_ZERO_VERIFIER;
    uint8 internal immutable _ACTION_TREE_DEPTH;

    uint256 private _txCount;

    error InvalidRootRef(bytes32 root);
    error InvalidNullifierRef(bytes32 nullifier);
    error InvalidCommitmentRef(bytes32 commitment);
    error ForwarderCallOutputMismatch(bytes expected, bytes actual);

    error RootMismatch(bytes32 expected, bytes32 actual);
    error LogicRefMismatch(bytes32 expected, bytes32 actual);

    error CalldataCarrierKindMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierAppDataMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierLabelMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierCommitmentNotFound(bytes32 commitment);

    constructor(TrustedRiscZeroVerifier riscZeroVerifier, uint8 commitmentTreeDepth, uint8 actionTreeDepth)
        CommitmentAccumulator(commitmentTreeDepth)
    {
        _TRUSTED_RISC_ZERO_VERIFIER = riscZeroVerifier;
        _ACTION_TREE_DEPTH = actionTreeDepth;
    }

    /// @inheritdoc IProtocolAdapter
    // slither-disable-next-line reentrancy-no-eth
    function execute(Transaction calldata transaction) external override nonReentrant {
        _verify(transaction);

        emit TransactionExecuted({id: ++_txCount, transaction: transaction});

        bytes32 newRoot = 0;

        uint256 nActions = transaction.actions.length;
        for (uint256 i = 0; i < nActions; ++i) {
            Action calldata action = transaction.actions[i];

            uint256 nResources = action.logicVerifierInputs.length;
            for (uint256 j = 0; j < nResources; ++j) {
                Logic.Instance calldata instance = action.logicVerifierInputs[j].instance;

                if (instance.isConsumed) {
                    // Nullifier non-existence was already checked in `_verify(transaction);` at the top.
                    _addNullifierUnchecked(instance.tag);
                } else {
                    // Commitment non-existence was already checked in `_verify(transaction);` at the top.
                    newRoot = _addCommitmentUnchecked(instance.tag);
                }

                uint256 nBlobs = instance.appData.length;
                for (uint256 k = 0; k < nBlobs; ++k) {
                    _storeBlob(instance.appData[k]);
                }
            }

            uint256 nForwarderCalls = action.resourceCalldataPairs.length;
            for (uint256 j = 0; j < nForwarderCalls; ++j) {
                _executeForwarderCall(action.resourceCalldataPairs[j].call);
            }
        }

        _storeRoot(newRoot);
    }

    /// @inheritdoc IProtocolAdapter
    function verify(Transaction calldata transaction) external view override {
        _verify(transaction);
    }

    // slither-disable-next-line calls-loop
    function _executeForwarderCall(ForwarderCalldata calldata call) internal {
        bytes memory output = IForwarder(call.untrustedForwarder).forwardCall(call.input);

        if (keccak256(output) != keccak256(call.output)) {
            revert ForwarderCallOutputMismatch({expected: call.output, actual: output});
        }
    }

    // slither-disable-next-line calls-loop
    function _verify(Transaction calldata transaction) internal view {
        uint256[2] memory transactionDelta = [uint256(0), uint256(0)];

        uint256 nActions = transaction.actions.length;

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

            _verifyForwarderCalls(action);

            // Compliance Proofs
            {
                uint256 nCUs = action.complianceUnits.length;
                for (uint256 j = 0; j < nCUs; ++j) {
                    Compliance.Unit calldata cu = action.complianceUnits[j];

                    // Check consumed resources
                    _checkRootPreExistence(cu.instance.consumed.commitmentTreeRoot);
                    _checkNullifierNonExistence(cu.instance.consumed.nullifier);

                    // Check created resources
                    _checkCommitmentNonExistence(cu.instance.created.commitment);

                    _TRUSTED_RISC_ZERO_VERIFIER.verify({
                        seal: cu.proof,
                        imageId: Compliance._CIRCUIT_ID,
                        journalDigest: cu.instance.toJournalDigest()
                    });

                    // Check the logic ref consistency
                    {
                        bytes32 nf = cu.instance.consumed.nullifier;
                        Logic.VerifierInput calldata logicVerifierInputs = action.logicVerifierInputs.lookup(nf);

                        if (cu.instance.consumed.logicRef != logicVerifierInputs.verifyingKey) {
                            revert LogicRefMismatch({
                                expected: logicVerifierInputs.verifyingKey,
                                actual: cu.instance.consumed.logicRef
                            });
                        }
                        // solhint-disable-next-line  gas-increment-by-one
                        tags[resCounter++] = nf;
                    }
                    {
                        bytes32 cm = cu.instance.created.commitment;
                        Logic.VerifierInput calldata input = action.logicVerifierInputs.lookup(cm);

                        if (cu.instance.created.logicRef != input.verifyingKey) {
                            revert LogicRefMismatch({expected: input.verifyingKey, actual: cu.instance.created.logicRef});
                        }
                        // solhint-disable-next-line  gas-increment-by-one
                        tags[resCounter++] = cm;
                    }

                    // Compute transaction delta
                    if (i == 0 && j == 0) {
                        transactionDelta = [uint256(cu.instance.unitDeltaX), uint256(cu.instance.unitDeltaY)];
                    } else {
                        transactionDelta =
                            transactionDelta.add([uint256(cu.instance.unitDeltaX), uint256(cu.instance.unitDeltaY)]);
                    }
                }
            }

            // Logic Proofs
            {
                uint256 nResources = action.logicVerifierInputs.length;

                bytes32[] memory actionTags = new bytes32[](nResources);
                for (uint256 j = 0; j < nResources; ++j) {
                    actionTags[j] = action.logicVerifierInputs[j].instance.tag;
                }
                bytes32 computedActionTreeRoot = MerkleTree.computeRoot(actionTags, _ACTION_TREE_DEPTH);

                for (uint256 j = 0; j < nResources; ++j) {
                    Logic.VerifierInput calldata input = action.logicVerifierInputs[j];

                    // Check root consistency
                    if (input.instance.actionTreeRoot != computedActionTreeRoot) {
                        revert RootMismatch({expected: computedActionTreeRoot, actual: input.instance.actionTreeRoot});
                    }

                    _TRUSTED_RISC_ZERO_VERIFIER.verify({
                        seal: input.proof,
                        imageId: input.verifyingKey,
                        journalDigest: input.instance.toJournalDigest()
                    });
                }
            }
        }

        if (nActions != 0) {
            // Check delta proof.
            Delta.verify({
                proof: transaction.deltaProof,
                instance: transactionDelta,
                verifyingKey: Delta.computeVerifyingKey(tags)
            });
        }
    }

    // slither-disable-next-line calls-loop
    function _verifyForwarderCalls(Action calldata action) internal view {
        uint256 nForwarderCalls = action.resourceCalldataPairs.length;
        for (uint256 i = 0; i < nForwarderCalls; ++i) {
            Resource calldata carrier = action.resourceCalldataPairs[i].carrier;
            ForwarderCalldata calldata call = action.resourceCalldataPairs[i].call;

            // Kind integrity check
            {
                bytes32 passedKind = carrier.kind();

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
}
