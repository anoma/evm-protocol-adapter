// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ReentrancyGuardTransient} from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {IRiscZeroVerifier as TrustedRiscZeroVerifier} from "@risc0-ethereum/IRiscZeroVerifier.sol";

import {MockDelta} from "../test/mocks/MockDelta.sol"; // TODO remove

import {IForwarder} from "./interfaces/IForwarder.sol";
import {IProtocolAdapter} from "./interfaces/IProtocolAdapter.sol";

import {ArrayLookup} from "./libs/ArrayLookup.sol";
import {ComputableComponents} from "./libs/ComputableComponents.sol";
import {Reference} from "./libs/Reference.sol";

import {ComplianceUnit} from "./proving/Compliance.sol";
import {Delta} from "./proving/Delta.sol";
import {LogicInstance, LogicProofs, LogicProof, TagLogicProofPair} from "./proving/Logic.sol";

import {BlobStorage, DeletionCriterion, ExpirableBlob} from "./state/BlobStorage.sol";
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
    using ArrayLookup for bytes32[];
    using ComputableComponents for Resource;
    using Reference for bytes;
    using LogicProofs for TagLogicProofPair[];
    using EnumerableSet for EnumerableSet.Bytes32Set;

    TrustedRiscZeroVerifier internal immutable _TRUSTED_RISC_ZERO_VERIFIER;
    bytes32 internal immutable _COMPLIANCE_CIRCUIT_ID;
    bytes32 internal immutable _LOGIC_CIRCUIT_ID;

    uint256 private _txCount;

    event TransactionExecuted(uint256 indexed id, Transaction transaction);

    error InvalidRootRef(bytes32 root);
    error InvalidNullifierRef(bytes32 nullifier);
    error InvalidCommitmentRef(bytes32 commitment);
    error ForwarderCallOutputMismatch(bytes expected, bytes actual);

    error CalldataCarrierKindMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierAppDataMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierLabelMismatch(bytes32 expected, bytes32 actual);
    error CalldataCarrierCommitmentNotFound(bytes32 commitment);
    error TransactionUnbalanced(uint256 expected, uint256 actual);

    constructor(
        TrustedRiscZeroVerifier riscZeroVerifier,
        bytes32 logicCircuitID,
        bytes32 complianceCircuitID,
        uint8 treeDepth
    ) CommitmentAccumulator(treeDepth) {
        _TRUSTED_RISC_ZERO_VERIFIER = riscZeroVerifier;
        _LOGIC_CIRCUIT_ID = logicCircuitID;
        _COMPLIANCE_CIRCUIT_ID = complianceCircuitID;
    }

    /// @inheritdoc IProtocolAdapter
    // slither-disable-next-line reentrancy-no-eth
    function execute(Transaction calldata transaction) external override nonReentrant {
        _verify(transaction);

        emit TransactionExecuted({id: ++_txCount, transaction: transaction});

        bytes32 newRoot = 0;
        for (uint256 i = 0; i < transaction.actions.length; ++i) {
            Action calldata action = transaction.actions[i];

            uint256 nResources = action.logicProofs.length;
            for (uint256 j = 0; j < nResources; ++j) {
                TagLogicProofPair calldata pair = action.logicProofs[j];

                if (pair.logicProof.isConsumed) {
                    // Nullifier non-existence was already checked in `_verify(transaction);` at the top.
                    _addNullifierUnchecked(pair.tag);
                } else {
                    // Commitment non-existence was already checked in `_verify(transaction);` at the top.
                    newRoot = _addCommitmentUnchecked(pair.tag);
                }

                uint256 nBlobs = pair.logicProof.appData.length;
                for (uint256 k = 0; k < nBlobs; ++j) {
                    _storeBlob(pair.logicProof.appData[k]);
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

    // TODO Consider DoS attacks https://detectors.auditbase.com/avoid-external-calls-in-unbounded-loops-solidity
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
        // Can also be named DeltaHash (which is what Yulia does).

        uint256[2] memory transactionDelta = Delta.zero();
        bytes32[] storage tags;

        uint256 nActions = transaction.actions.length;
        for (uint256 i; i < nActions; ++i) {
            Action calldata action = transaction.actions[i];

            _verifyForwarderCalls(action);

            // Compliance Proofs
            uint256 nCUs = action.complianceUnits.length;
            for (uint256 j = 0; j < nCUs; ++j) {
                ComplianceUnit calldata unit = action.complianceUnits[j];

                // Check consumed resources
                _checkRootPreExistence(unit.instance.consumed.rootRef);
                _checkNullifierNonExistence(unit.instance.consumed.nullifier);

                // Check created resources
                _checkCommitmentNonExistence(unit.instance.created.commitment);

                _TRUSTED_RISC_ZERO_VERIFIER.verify({
                    seal: unit.proof,
                    imageId: _COMPLIANCE_CIRCUIT_ID,
                    journalDigest: sha256(abi.encode(unit.verifyingKey, unit.instance))
                });

                // Prepare delta proof
                transactionDelta = Delta.add({p1: transactionDelta, p2: unit.instance.unitDelta});
            }

            uint256 nResources = action.logicProofs.length;

            bytes32[] storage allNullifiers;
            bytes32[] storage allCommitments;
            for (uint256 j = 0; j < nResources; ++j) {
                TagLogicProofPair calldata pair = action.logicProofs[j];

                tags.push(pair.tag);
                if (pair.logicProof.isConsumed) {
                    allNullifiers.push(pair.tag);
                } else {
                    allCommitments.push(pair.tag);
                }
            }

            for (uint256 j = 0; j < nResources; ++j) {
                bytes32 tag = action.logicProofs[j].tag;
                LogicProof calldata proof = action.logicProofs[j].logicProof;

                LogicInstance memory instance;

                if (proof.isConsumed) {
                    instance = LogicInstance({
                        tag: tag,
                        isConsumed: true,
                        consumed: allNullifiers.removeElement(tag),
                        created: allCommitments,
                        appData: proof.appData
                    });
                } else {
                    instance = LogicInstance({
                        tag: tag,
                        isConsumed: false,
                        consumed: allNullifiers,
                        created: allCommitments.removeElement(tag),
                        appData: proof.appData
                    });
                }

                _TRUSTED_RISC_ZERO_VERIFIER.verify({
                    seal: proof.proof,
                    imageId: _LOGIC_CIRCUIT_ID,
                    journalDigest: sha256(abi.encode(proof.logicVerifyingKeyOuter, instance))
                });
            }
        }

        // Delta Proof
        // TODO: THIS IS A TEMPORARY MOCK PROOF AND MUST BE REMOVED.
        // NOTE: The `transactionHash(tags)` and `transactionDelta` are not used here.
        ComputableComponents.transactionHash(tags);
        // TODO do we even needs this?
        // bytes32 deltaVerifyingKey;  // TransactionHash is part of the transaction
        MockDelta.verify({deltaProof: transaction.deltaProof});

        /*
        Delta.verify({
            transactionHash: transaction.deltaVerifyingKey,
            transactionDelta: transactionDelta,
            deltaProof: transaction.deltaProof
        });
        */
    }

    // slither-disable-next-line calls-loop
    function _verifyForwarderCalls(Action calldata action) internal view {
        uint256 len = action.resourceCalldataPairs.length;
        for (uint256 j; j < len; ++j) {
            Resource calldata carrier = action.resourceCalldataPairs[j].carrier;
            ForwarderCalldata calldata call = action.resourceCalldataPairs[j].call;

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

                bytes32 actualAppDataHash = keccak256(action.tagAppDataPairs.lookup(carrier.commitment()).blob);

                if (actualAppDataHash != expectedAppDataHash) {
                    revert CalldataCarrierAppDataMismatch({actual: actualAppDataHash, expected: expectedAppDataHash});
                }
            }
        }
    }
}
