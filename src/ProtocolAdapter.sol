// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ReentrancyGuardTransient} from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
import {IRiscZeroVerifier as TrustedRiscZeroVerifier} from "@risc0-ethereum/IRiscZeroVerifier.sol";

import {IForwarder} from "./interfaces/IForwarder.sol";
import {IProtocolAdapter} from "./interfaces/IProtocolAdapter.sol";

import {ComputableComponents} from "./libs/ComputableComponents.sol";
import {MerkleTree} from "./libs/MerkleTree.sol";

import {Delta} from "./proving/Delta.sol";
import {LogicProofs} from "./proving/Logic.sol";
import {BlobStorage} from "./state/BlobStorage.sol";
import {CommitmentAccumulator} from "./state/CommitmentAccumulator.sol";

import {NullifierSet} from "./state/NullifierSet.sol";

import {
    Action, ForwarderCalldata, Resource, Transaction, LogicProof, LogicInstance, ComplianceUnit
} from "./Types.sol";

contract ProtocolAdapter is
    IProtocolAdapter,
    ReentrancyGuardTransient,
    CommitmentAccumulator,
    NullifierSet,
    BlobStorage
{
    using ComputableComponents for Resource;
    using LogicProofs for LogicProof[];

    TrustedRiscZeroVerifier internal immutable _TRUSTED_RISC_ZERO_VERIFIER;
    bytes32 internal immutable _COMPLIANCE_CIRCUIT_ID;
    uint8 internal immutable _ACTION_TREE_DEPTH;

    uint256 private _txCount;

    error InvalidRootRef(bytes32 root);
    error InvalidNullifierRef(bytes32 nullifier);
    error InvalidCommitmentRef(bytes32 commitment);
    error ForwarderCallOutputMismatch(bytes expected, bytes actual);
    error NonEmptyDelta();

    error RootMismatch(bytes32 expected, bytes32 actual);
    error LogicRefMismatch(bytes32 expected, bytes32 actual);

    error CalldataCarrierKindMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierAppDataMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierLabelMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierCommitmentNotFound(bytes32 commitment);

    constructor(
        TrustedRiscZeroVerifier riscZeroVerifier,
        bytes32 complianceCircuitID,
        uint8 commitmentTreeDepth,
        uint8 actionTreeDepth
    ) CommitmentAccumulator(commitmentTreeDepth) {
        _TRUSTED_RISC_ZERO_VERIFIER = riscZeroVerifier;
        _ACTION_TREE_DEPTH = actionTreeDepth;
        _COMPLIANCE_CIRCUIT_ID = complianceCircuitID;
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

            uint256 nResources = action.logicProofs.length;
            for (uint256 j = 0; j < nResources; ++j) {
                LogicInstance calldata instance = action.logicProofs[j].instance;

                if (instance.isConsumed) {
                    // Nullifier non-existence was already checked in `_verify(transaction);` at the top.
                    _addNullifierUnchecked(instance.tag);
                } else {
                    // Commitment non-existence was already checked in `_verify(transaction);` at the top.
                    newRoot = _addCommitmentUnchecked(instance.tag);
                }

                uint256 nBlobs = instance.appData.length;
                for (uint256 k = 0; k < nBlobs; ++j) {
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

    // solhint-disable-next-line function-max-lines
    // slither-disable-next-line calls-loop
    function _verify(Transaction calldata transaction) internal view {
        uint256[2] memory transactionDelta = Delta.zero();

        uint256 nActions = transaction.actions.length;

        uint256 resCounter = 0;
        for (uint256 i = 0; i < nActions; ++i) {
            resCounter += transaction.actions[i].logicProofs.length;
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
                    ComplianceUnit calldata unit = action.complianceUnits[j];

                    // Check consumed resources
                    _checkRootPreExistence(unit.instance.consumed.commitmentTreeRoot);
                    _checkNullifierNonExistence(unit.instance.consumed.nullifier);

                    // Check created resources
                    _checkCommitmentNonExistence(unit.instance.created.commitment);

                    _TRUSTED_RISC_ZERO_VERIFIER.verify({
                        seal: unit.proof,
                        imageId: _COMPLIANCE_CIRCUIT_ID,
                        journalDigest: sha256(
                            abi.encode(
                                unit.instance.consumed.nullifier,
                                unit.instance.created.commitment,
                                unit.instance.consumed.logicRef,
                                unit.instance.created.logicRef,
                                unit.instance.consumed.commitmentTreeRoot,
                                unit.instance.unitDelta[0],
                                unit.instance.unitDelta[1]
                            )
                        )
                    });

                    // Check the logic ref consistency
                    {
                        bytes32 nf = unit.instance.consumed.nullifier;
                        LogicProof calldata logicProof = action.logicProofs.lookup(nf);

                        if (unit.instance.consumed.logicRef != logicProof.logicRef) {
                            revert LogicRefMismatch({
                                expected: logicProof.logicRef,
                                actual: unit.instance.consumed.logicRef
                            });
                        }
                        // solhint-disable-next-line  gas-increment-by-one
                        tags[resCounter++] = nf;
                    }
                    {
                        bytes32 cm = unit.instance.created.commitment;
                        LogicProof calldata logicProof = action.logicProofs.lookup(cm);

                        if (unit.instance.created.logicRef != logicProof.logicRef) {
                            revert LogicRefMismatch({
                                expected: logicProof.logicRef,
                                actual: unit.instance.created.logicRef
                            });
                        }
                        // solhint-disable-next-line  gas-increment-by-one
                        tags[resCounter++] = cm;
                    }

                    // Compute transaction delta
                    if (i == 0 && j == 0) {
                        transactionDelta = unit.instance.unitDelta;
                    } else {
                        transactionDelta = Delta.add({p1: transactionDelta, p2: unit.instance.unitDelta});
                    }
                }
            }

            // Logic Proofs
            {
                uint256 nResources = action.logicProofs.length;

                bytes32[] memory actionTags = new bytes32[](nResources);
                for (uint256 j = 0; j < nResources; ++j) {
                    actionTags[j] = action.logicProofs[j].instance.tag;
                }
                bytes32 computedActionTreeRoot = MerkleTree.computeRoot(actionTags, _ACTION_TREE_DEPTH);

                for (uint256 j = 0; j < nResources; ++j) {
                    LogicProof calldata proof = action.logicProofs[j];

                    // Check root consistency
                    if (proof.instance.actionTreeRoot != computedActionTreeRoot) {
                        revert RootMismatch({expected: computedActionTreeRoot, actual: proof.instance.actionTreeRoot});
                    }

                    _TRUSTED_RISC_ZERO_VERIFIER.verify({
                        seal: proof.proof,
                        imageId: proof.logicRef,
                        journalDigest: sha256(abi.encode(proof.instance))
                    });
                }
            }
        }

        if (nActions == 0) {
            if (transactionDelta[0] == 0 && transactionDelta[1] == 0) {
                // Skip the delta proof check.
                return;
            } else {
                revert NonEmptyDelta();
            }
        } else {
            // Check delta proof.
            Delta.verify({
                tagsHash: ComputableComponents.tagsHash(tags),
                transactionDelta: transactionDelta,
                deltaProof: transaction.deltaProof
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
                    keccak256(abi.encode(action.logicProofs.lookup(carrier.commitment()).instance.appData[0]));

                if (actualAppDataHash != expectedAppDataHash) {
                    revert CalldataCarrierAppDataMismatch({actual: actualAppDataHash, expected: expectedAppDataHash});
                }
            }
        }
    }
}
