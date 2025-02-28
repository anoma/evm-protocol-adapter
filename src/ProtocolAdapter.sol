// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// External imports
import { ReentrancyGuardTransient } from "@openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
import { IRiscZeroVerifier as TrustedRiscZeroVerifier } from "@risc0-ethereum/IRiscZeroVerifier.sol";

import { MockDelta } from "../test/MockDelta.sol"; // TODO remove

import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IWrapper as UntrustedWrapper } from "./interfaces/IWrapper.sol";

// Libraries
import { AppData } from "./libs/AppData.sol";
import { ArrayLookup } from "./libs/ArrayLookup.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { Universal } from "./libs/Identities.sol";
import { Reference } from "./libs/Reference.sol";

// State-related modules

import { ComplianceUnit } from "./proving/Compliance.sol";
import { Delta } from "./proving/Delta.sol";
import { LogicInstance, LogicProofs, TagLogicProofPair, LogicRefProofPair } from "./proving/Logic.sol";

import { BlobStorage, DeletionCriterion, ExpirableBlob } from "./state/BlobStorage.sol";
import { CommitmentAccumulator } from "./state/CommitmentAccumulator.sol";
import { NullifierSet } from "./state/NullifierSet.sol";

// Proving-related modules

// Types
import { Action, FFICall, KindFFICallPair, Resource, TagAppDataPair, Transaction } from "./Types.sol";

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

    TrustedRiscZeroVerifier internal immutable _TRUSTED_RISC_ZERO_VERIFIER;
    bytes32 internal immutable _COMPLIANCE_CIRCUIT_ID;
    bytes32 internal immutable _LOGIC_CIRCUIT_ID;

    uint256 private _txCount;

    event TransactionExecuted(uint256 indexed id, Transaction transaction);

    error InvalidRootRef(bytes32 root);
    error InvalidNullifierRef(bytes32 nullifier);
    error InvalidCommitmentRef(bytes32 commitment);
    error FFICallOutputMismatch(bytes expected, bytes actual);

    error WrapperResourceKindMismatch(bytes32 expected, bytes32 actual);
    error WrapperContractResourceLabelMismatch(bytes32 expected, bytes32 actual);
    error WrapperContractResourceCommitmentNotFound(bytes32 commitment);
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

        uint256 nActions = transaction.actions.length;
        for (uint256 i = 0; i < nActions; ++i) {
            Action calldata action = transaction.actions[i];

            uint256 len = action.tagAppDataPairs.length;
            for (uint256 j = 0; j < len; ++j) {
                _storeBlob(action.tagAppDataPairs[j].appData);
            }

            len = action.nullifiers.length;
            for (uint256 j = 0; j < len; ++j) {
                // Nullifier non-existence was already checked in `_verify(transaction);` at the top.
                _addNullifierUnchecked(action.nullifiers[j]);
            }

            len = action.commitments.length;
            for (uint256 j = 0; j < len; ++j) {
                // Commitment non-existence was already checked in `_verify(transaction);` at the top.
                _addCommitmentUnchecked(action.commitments[j]);
            }

            len = action.kindFFICallPairs.length;
            for (uint256 j = 0; j < len; ++j) {
                _executeFFICall(action.kindFFICallPairs[j].ffiCall);
            }
        }
    }

    /// @inheritdoc IProtocolAdapter
    function createWrapperContractResource(UntrustedWrapper wrapperContract) external override {
        _createWrapperContractResource(wrapperContract);
    }

    /// @inheritdoc IProtocolAdapter
    function verify(Transaction calldata transaction) external view override {
        _verify(transaction);
    }

    // TODO Consider DoS attacks https://detectors.auditbase.com/avoid-external-calls-in-unbounded-loops-solidity
    // slither-disable-next-line calls-loop
    function _executeFFICall(FFICall calldata ffiCall) internal {
        bytes memory output = UntrustedWrapper(ffiCall.wrapperContract).evmCall(ffiCall.input);

        if (keccak256(output) != keccak256(ffiCall.output)) {
            revert FFICallOutputMismatch({ expected: ffiCall.output, actual: output });
        }
    }

    /// @notice Computes the commitment of a wrapper contract resource that can be consumed by the universal identity.
    // @param logicRef The wrapper contract logic reference.
    /// @param labelRef The wrapper contract label reference.
    /// @param valueRef The wrapper contract value reference.
    function _wrapperContractResourceCommitment(
        UntrustedWrapper untrustedWrapperContract,
        bytes32 labelRef,
        bytes32 valueRef
    )
        internal
        returns (bytes32 wrapperResource)
    {
        wrapperResource = Resource({
            logicRef: untrustedWrapperContract.wrapperResourceLogicRef(),
            labelRef: labelRef,
            valueRef: valueRef,
            nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
            quantity: 1,
            nonce: untrustedWrapperContract.newNonce(),
            randSeed: 0,
            ephemeral: false
        }).commitment();
    }

    function _createWrapperContractResource(UntrustedWrapper untrustedWrapperContract) internal {
        bytes32 computedWrapperLabelRef = _computeWrapperLabelRef(untrustedWrapperContract);
        bytes32 expectedWrapperLabelRef = untrustedWrapperContract.wrapperResourceLabelRef();

        // Check integrity
        if (computedWrapperLabelRef != expectedWrapperLabelRef) {
            revert WrapperContractResourceLabelMismatch({
                expected: expectedWrapperLabelRef,
                actual: computedWrapperLabelRef
            });
        }

        bytes memory empty = bytes("");
        _addCommitment(
            _wrapperContractResourceCommitment({
                untrustedWrapperContract: untrustedWrapperContract,
                labelRef: computedWrapperLabelRef,
                valueRef: abi.encode(untrustedWrapperContract.wrappedResourceKind(), empty, empty).toRefCalldata()
            })
        );
    }

    // solhint-disable-next-line function-max-lines
    function _verify(Transaction calldata transaction) internal view {
        // Can also be named DeltaHash (which is what Yulia does).
        uint256[2] memory transactionDelta = Delta.zero();

        // Helper variable
        uint256 resourceCount;

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

            len = action.kindFFICallPairs.length;
            for (uint256 j; j < len; ++j) {
                _verifyFFICall(action.kindFFICallPairs[j]);
            }

            // Compliance Proofs
            len = action.complianceUnits.length;
            for (uint256 j; j < len; ++j) {
                ComplianceUnit calldata unit = action.complianceUnits[j];

                // Check consumed resources
                if (!transaction.roots.contains(unit.instance.consumed.rootRef)) {
                    revert InvalidRootRef(unit.instance.consumed.rootRef);
                }
                _checkRootPreExistence(unit.instance.consumed.rootRef);

                if (!action.nullifiers.contains(unit.instance.consumed.nullifierRef)) {
                    revert InvalidNullifierRef(unit.instance.consumed.nullifierRef);
                }
                _checkNullifierNonExistence(unit.instance.consumed.nullifierRef);

                // Check created resources
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
                appDataForTag: ExpirableBlob({ deletionCriterion: DeletionCriterion.Immediately, blob: bytes("") })
            });
            LogicRefProofPair memory logicRefProofPair;

            // Check consumed resources
            len = action.nullifiers.length;
            for (uint256 j; j < len; ++j) {
                bytes32 tag = action.nullifiers[j];

                tags[resourceCount] = tag;
                ++resourceCount;

                instance.tag = tag;
                instance.appDataForTag = action.tagAppDataPairs.lookupCalldata(tag);

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

                tags[resourceCount] = tag;
                ++resourceCount;

                instance.tag = tag;
                instance.appDataForTag = action.tagAppDataPairs.lookup(tag);

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

    function _verifyFFICall(KindFFICallPair calldata kindFFICallPair) internal view {
        bytes32 passedKind = kindFFICallPair.kind;
        bytes32 fetchedKind = UntrustedWrapper(kindFFICallPair.ffiCall.wrapperContract).wrapperResourceKind();

        if (passedKind != fetchedKind) {
            revert WrapperResourceKindMismatch({ expected: fetchedKind, actual: passedKind });
        }
    }

    function _transactionHash(bytes32[] memory tags) internal pure returns (bytes32 txHash) {
        txHash = sha256(abi.encode(tags));
    }

    function _computeWrapperLabelRef(UntrustedWrapper wrapperContract)
        internal
        pure
        returns (bytes32 wrapperLabelRef)
    {
        wrapperLabelRef = abi.encode(wrapperContract).toRefCalldata();
    }
}
