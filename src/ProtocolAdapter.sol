// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ReentrancyGuardTransient } from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
import { EnumerableSet } from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import { IRiscZeroVerifier as TrustedRiscZeroVerifier } from "@risc0-ethereum/IRiscZeroVerifier.sol";

import { MockDelta } from "../test/mocks/MockDelta.sol"; // TODO remove

import { IForwarder } from "./interfaces/IForwarder.sol";
import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";

import { AppData } from "./libs/AppData.sol";
import { ArrayLookup } from "./libs/ArrayLookup.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { Reference } from "./libs/Reference.sol";

import { ComplianceUnit } from "./proving/Compliance.sol";
import { Delta } from "./proving/Delta.sol";
import { LogicInstance, LogicProofs, TagLogicProofPair, LogicRefProofPair } from "./proving/Logic.sol";

import { BlobStorage, DeletionCriterion, ExpirableBlob } from "./state/BlobStorage.sol";
import { CommitmentAccumulator } from "./state/CommitmentAccumulator.sol";
import { NullifierSet } from "./state/NullifierSet.sol";

import { Action, ForwarderCalldata, Resource, TagAppDataPair, Transaction } from "./Types.sol";

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
    using AppData for TagAppDataPair[];
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
    )
        CommitmentAccumulator(treeDepth)
    {
        _TRUSTED_RISC_ZERO_VERIFIER = riscZeroVerifier;
        _LOGIC_CIRCUIT_ID = logicCircuitID;
        _COMPLIANCE_CIRCUIT_ID = complianceCircuitID;
    }

    /// @inheritdoc IProtocolAdapter
    // slither-disable-next-line reentrancy-no-eth
    function execute(Transaction calldata transaction) external override nonReentrant {
        _verify(transaction);

        emit TransactionExecuted({ id: ++_txCount, transaction: transaction });

        uint256 n = transaction.actions.length;
        uint256 m;
        uint256 j;
        bytes32 newRoot = 0;
        for (uint256 i = 0; i < n; ++i) {
            Action calldata action = transaction.actions[i];

            m = action.tagAppDataPairs.length;
            for (j = 0; j < m; ++j) {
                _storeBlob(action.tagAppDataPairs[j].appData);
            }

            m = action.nullifiers.length;
            for (j = 0; j < m; ++j) {
                // Nullifier non-existence was already checked in `_verify(transaction);` at the top.
                _addNullifierUnchecked(action.nullifiers[j]);
            }

            m = action.commitments.length;

            for (j = 0; j < m; ++j) {
                // Commitment non-existence was already checked in `_verify(transaction);` at the top.
                newRoot = _addCommitmentUnchecked(action.commitments[j]);
            }

            m = action.resourceCalldataPairs.length;
            for (j = 0; j < m; ++j) {
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
            revert ForwarderCallOutputMismatch({ expected: call.output, actual: output });
        }
    }

    // solhint-disable-next-line function-max-lines
    // slither-disable-next-line calls-loop
    function _verify(Transaction calldata transaction) internal view {
        // Can also be named DeltaHash (which is what Yulia does).
        uint256[2] memory transactionDelta = Delta.zero();

        // Helper variable
        uint256 resourceCount = 0;

        uint256 nActions = transaction.actions.length;
        for (uint256 i; i < nActions; ++i) {
            resourceCount += transaction.actions[i].commitments.length;
            resourceCount += transaction.actions[i].nullifiers.length;
        }
        bytes32[] memory tags = new bytes32[](resourceCount);

        // Reset resource count for later use.
        resourceCount = 0;

        uint256 len;
        for (uint256 i; i < nActions; ++i) {
            Action calldata action = transaction.actions[i];

            _verifyForwarderCalls(action);

            // Compliance Proofs
            len = action.complianceUnits.length;
            for (uint256 j; j < len; ++j) {
                ComplianceUnit calldata unit = action.complianceUnits[j];

                // Check consumed resources
                // TODO This check can be removed after Xuyang's and Artem's specs change proposal gets merged.
                if (!transaction.roots.contains(unit.instance.consumed.rootRef)) {
                    revert InvalidRootRef(unit.instance.consumed.rootRef);
                }
                _checkRootPreExistence(unit.instance.consumed.rootRef);

                // TODO This check can be removed after Xuyang's and Artem's specs change proposal gets merged.
                if (!action.nullifiers.contains(unit.instance.consumed.nullifierRef)) {
                    revert InvalidNullifierRef(unit.instance.consumed.nullifierRef);
                }
                _checkNullifierNonExistence(unit.instance.consumed.nullifierRef);

                // Check created resources
                // TODO This check can be removed after Xuyang's and Artem's specs change proposal gets merged.
                if (!action.commitments.contains(unit.instance.created.commitmentRef)) {
                    revert InvalidCommitmentRef(unit.instance.created.commitmentRef);
                }
                _checkCommitmentNonExistence(unit.instance.created.commitmentRef);

                _TRUSTED_RISC_ZERO_VERIFIER.verify({
                    seal: unit.proof,
                    imageId: _COMPLIANCE_CIRCUIT_ID,
                    journalDigest: sha256(abi.encode(unit.verifyingKey, unit.instance))
                });

                // Prepare delta proof
                transactionDelta = Delta.add({ p1: transactionDelta, p2: unit.instance.unitDelta });
            }

            // Logic Proofs
            LogicInstance memory instance = LogicInstance({
                tag: bytes32(0),
                isConsumed: true,
                consumed: action.nullifiers,
                created: action.commitments,
                tagSpecificAppData: ExpirableBlob({ deletionCriterion: DeletionCriterion.Immediately, blob: bytes("") })
            });
            LogicRefProofPair memory logicRefProofPair;

            // Check consumed resources
            len = action.nullifiers.length;
            for (uint256 j; j < len; ++j) {
                bytes32 tag = action.nullifiers[j];

                tags[j] = tag;
                ++resourceCount;

                instance.tag = tag;
                instance.tagSpecificAppData = action.tagAppDataPairs.lookupCalldata(tag);

                {
                    logicRefProofPair = action.logicProofs.lookup(tag);

                    _TRUSTED_RISC_ZERO_VERIFIER.verify({
                        seal: logicRefProofPair.proof,
                        imageId: _LOGIC_CIRCUIT_ID,
                        journalDigest: sha256(abi.encode( /*verifying key*/ logicRefProofPair.logicRef, instance))
                    });
                }
            }
            // Check created resources
            instance.isConsumed = false;

            len = action.commitments.length;
            for (uint256 j; j < len; ++j) {
                bytes32 tag = action.commitments[j];

                tags[action.nullifiers.length + j] = tag;
                ++resourceCount;

                instance.tag = tag;
                instance.tagSpecificAppData = action.tagAppDataPairs.lookup(tag);

                {
                    logicRefProofPair = action.logicProofs.lookup(tag);
                    _TRUSTED_RISC_ZERO_VERIFIER.verify({
                        seal: logicRefProofPair.proof,
                        imageId: _LOGIC_CIRCUIT_ID,
                        journalDigest: sha256(abi.encode( /*verifying key*/ logicRefProofPair.logicRef, instance))
                    });
                }
            }
        }

        // Delta Proof
        // TODO: THIS IS A TEMPORARY MOCK PROOF AND MUST BE REMOVED.
        // NOTE: The `transactionHash(tags)` and `transactionDelta` are not used here.
        _transactionHash(tags);
        MockDelta.verify({ deltaProof: transaction.deltaProof });
        /*
        Delta.verify({
            transactionHash: _transactionHash(tags),
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
                    revert CalldataCarrierKindMismatch({ expected: fetchedKind, actual: passedKind });
                }
            }

            // AppData integrity check
            {
                bytes32 expectedAppDataHash = keccak256(abi.encode(call.untrustedForwarder, call.input, call.output));

                bytes32 actualAppDataHash = keccak256(action.tagAppDataPairs.lookup(carrier.commitment()).blob);

                if (actualAppDataHash != expectedAppDataHash) {
                    revert CalldataCarrierAppDataMismatch({ actual: actualAppDataHash, expected: expectedAppDataHash });
                }
            }
        }
    }

    function _transactionHash(bytes32[] memory tags) internal pure returns (bytes32 txHash) {
        txHash = sha256(abi.encode(tags));
    }
}
