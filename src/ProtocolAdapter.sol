// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { ReentrancyGuardTransient } from "@openzeppelin/contracts/utils/ReentrancyGuardTransient.sol";

import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IWrapper } from "./interfaces/IWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { Reference } from "./libs/Reference.sol";
import { ArrayLookup } from "./libs/ArrayLookup.sol";

import { CommitmentAccumulator } from "./state/CommitmentAccumulator.sol";
import { NullifierSet } from "./state/NullifierSet.sol";
import { BlobStorage } from "./state/BlobStorage.sol";

import { IRiscZeroVerifier } from "risc0-ethereum/contracts/src/IRiscZeroVerifier.sol";

import { ComplianceInstance, ComplianceUnit } from "./proving/Compliance.sol";
import { Delta } from "./proving/Delta.sol";
import { LogicInstance, LogicProofs, TagLogicProofPair, LogicRefProofPair } from "./proving/Logic.sol";

import { AppData } from "./libs/AppData.sol";

import { Resource, Transaction, Action, TagAppDataPair, KindFFICallPair, FFICall } from "./Types.sol";
import { UNIVERSAL_NULLIFIER_KEY_COMMITMENT } from "./Constants.sol";

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

    IRiscZeroVerifier private immutable RISC_ZERO_VERIFIER;
    bytes32 private immutable COMPLIANCE_CIRCUIT_ID;
    bytes32 private immutable LOGIC_CIRCUIT_ID;
    uint256 private immutable ZERO_DELTA_X;
    uint256 private immutable ZERO_DELTA_Y;

    uint256 private _txCount;

    event TransactionExecuted(uint256 indexed id, Transaction transaction);

    error WrapperResourceKindMismatch(bytes32 expected, bytes32 actual);
    error WrapperContractResourceLabelMismatch(bytes32 expected, bytes32 actual);
    error WrapperContractResourceCommitmentNotFound(bytes32 commitment);
    error TransactionUnbalanced(uint256 expected, uint256 actual);

    constructor(
        bytes32 logicCircuitID,
        bytes32 complianceCircuitID,
        address riscZeroVerifier,
        uint8 treeDepth
    )
        CommitmentAccumulator(treeDepth)
    {
        COMPLIANCE_CIRCUIT_ID = complianceCircuitID;
        LOGIC_CIRCUIT_ID = logicCircuitID;

        uint256[2] memory zeroDelta = Delta.zero();
        ZERO_DELTA_X = zeroDelta[0];
        ZERO_DELTA_Y = zeroDelta[1];

        RISC_ZERO_VERIFIER = IRiscZeroVerifier(riscZeroVerifier);
    }

    /// @notice Verifies a transaction by checking the delta, resource logic, and compliance proofs.
    /// @param transaction The transaction to verify.
    function verify(Transaction calldata transaction) external view {
        _verify(transaction);
    }

    function lookupFFICall() external { }

    /// @notice Executes a transaction by adding the commitments and nullifiers to the commitment tree and nullifier
    /// set, respectively.
    /// @param transaction The transaction to execute.
    /// @dev This function is non-reentrant.
    function execute(Transaction calldata transaction) external nonReentrant {
        _verify(transaction);

        for (uint256 i = 0; i < transaction.actions.length; ++i) {
            Action calldata action = transaction.actions[i];

            for (uint256 j = 0; j < action.kindFFICallPairs.length; ++j) {
                _executeFFICall(action.kindFFICallPairs[j].ffiCall);
            }

            for (uint256 j = 0; j < action.tagAppDataPairs.length; ++j) {
                _storeBlob(action.tagAppDataPairs[j].appData);
            }

            for (uint256 j = 0; j < action.nullifiers.length; ++j) {
                _addNullifier(action.nullifiers[j]);
            }

            for (uint256 j = 0; j < action.commitments.length; ++j) {
                _addCommitment(action.commitments[j]);
            }
        }
        emit TransactionExecuted({ id: _txCount++, transaction: transaction });
    }

    /// @notice Creates a wrapper contract resource object and adds the commitment to the commitment accumulator
    /// @param wrapperContract The wrapper contract.
    function createWrapperContractResource(IWrapper wrapperContract) external {
        _createWrapperContractResource(wrapperContract);
    }

    function _zeroDelta() internal view returns (uint256[2] memory zeroDelta) {
        zeroDelta[0] = ZERO_DELTA_X;
        zeroDelta[1] = ZERO_DELTA_Y;
    }

    function _transactionDigest(Transaction calldata transaction) internal pure returns (bytes32) {
        uint256 commitmentCount = 0;
        uint256 nullifierCount = 0;

        for (uint256 i; i < transaction.actions.length; ++i) {
            commitmentCount += transaction.actions[i].commitments.length;
            nullifierCount += transaction.actions[i].nullifiers.length;
        }

        bytes32[] memory cmsAndNfs = new bytes32[](commitmentCount + nullifierCount);

        for (uint256 i; i < transaction.actions.length; ++i) {
            for (uint256 j; j < commitmentCount; ++j) {
                cmsAndNfs[j] = transaction.actions[i].commitments[j];
            }
            for (uint256 j; j < nullifierCount; ++j) {
                cmsAndNfs[nullifierCount + j] = transaction.actions[i].nullifiers[j];
            }
        }

        return sha256(abi.encode(cmsAndNfs));
    }

    function _verify(Transaction calldata transaction) internal view {
        // Can also be named DeltaHash (which is what Yulia does).
        uint256[2] memory transactionDelta = _zeroDelta();

        for (uint256 i; i < transaction.actions.length; ++i) {
            // Compute the transaction delta
            transactionDelta = Delta.add({ p1: transactionDelta, p2: _actionDelta(transaction.actions[i]) });

            // Verify resource logics and compliance proofs.
            _verifyAction(transaction.actions[i]);
        }

        bytes32 transactionDigest = sha256(abi.encode(transaction)); // TODO Use _transactionDigest instead

        _verifyDelta(transactionDigest, transactionDelta, transaction.deltaProof);
    }

    function _actionDelta(Action calldata action) internal view returns (uint256[2] memory delta) {
        delta = _zeroDelta();

        for (uint256 i; i < action.complianceUnits.length; ++i) {
            delta = Delta.add({
                p1: delta,
                p2: action.complianceUnits[i].refInstance.referencedComplianceInstance.unitDelta
            });
        }
    }

    function _verifyAction(Action calldata action) internal view {
        for (uint256 i; i < action.kindFFICallPairs.length; ++i) {
            _verifyFFICall(action.kindFFICallPairs[i]);
        }

        for (uint256 i; i < action.complianceUnits.length; ++i) {
            _verifyComplianceUnit(action.complianceUnits[i]);
        }

        for (uint256 i; i < action.nullifiers.length; ++i) {
            _verifyLogicProof({ tag: action.nullifiers[i], action: action, isConsumed: true });
        }

        for (uint256 i; i < action.commitments.length; ++i) {
            _verifyLogicProof({ tag: action.commitments[i], action: action, isConsumed: false });
        }
    }

    function _verifyFFICall(KindFFICallPair calldata kindFFICallPair) internal view {
        bytes32 passedKind = kindFFICallPair.kind;
        bytes32 fetchedKind = kindFFICallPair.ffiCall.wrapperContract.wrapperResourceKind();

        if (passedKind != fetchedKind) {
            revert WrapperResourceKindMismatch({ expected: fetchedKind, actual: passedKind });
        }
    }

    /// @notice Checks the
    /// For ephemeral resources, the check is skipped in the circuit. Still, a fake root can be provided.
    function _verifyComplianceUnit(ComplianceUnit calldata complianceUnit) internal view {
        ComplianceInstance calldata instance = complianceUnit.refInstance.referencedComplianceInstance;
        // Note: referenced, because the instance contains data that we use in other places.
        // Note: If we provide a copy, we have to ensure that both things are really the same.

        for (uint256 i; i < instance.consumed.length; ++i) {
            _checkRootPreExistence(instance.consumed[i].rootRef);
            // NOTE: For ephemeral resources, a fake root is provided.
            // Initial root of the empty tree.

            // TODO Is it ok if we make these checks for ephemeral resources?
            _checkNullifierNonExistence(instance.consumed[i].nullifierRef);
        }

        for (uint256 i; i < instance.created.length; ++i) {
            // TODO Is it ok if we make these checks for ephemeral resources?
            _checkCommitmentNonExistence(instance.created[i].commitmentRef);
        }

        RISC_ZERO_VERIFIER.verify({
            seal: complianceUnit.proof,
            imageId: COMPLIANCE_CIRCUIT_ID,
            journalDigest: sha256(abi.encode(complianceUnit.verifyingKey, instance))
        });
    }

    function _verifyLogicProof(bytes32 tag, Action calldata action, bool isConsumed) internal view {
        LogicRefProofPair memory logicRefProofPair = action.logicProofs.lookup(tag);

        bytes memory proof = logicRefProofPair.proof;

        bytes32 verifyingKey = logicRefProofPair.logicRef;

        LogicInstance memory instance = LogicInstance({
            tag: tag,
            isConsumed: isConsumed,
            consumed: action.nullifiers,
            created: action.commitments,
            appDataForTag: action.tagAppDataPairs.lookup(tag)
        });

        RISC_ZERO_VERIFIER.verify({
            seal: proof,
            imageId: LOGIC_CIRCUIT_ID,
            journalDigest: sha256(abi.encode(verifyingKey, instance))
        });
    }

    function _verifyDelta(
        bytes32 transactionDigest,
        uint256[2] memory delta, // deltaHash,
        bytes calldata deltaProof
    )
        internal
        view
    {
        Delta.verify(transactionDigest, delta, deltaProof);

        // TODO needed?
        if (delta[0] != ZERO_DELTA_X) {
            revert TransactionUnbalanced({ expected: ZERO_DELTA_X, actual: delta[0] });
        }
        if (delta[1] != ZERO_DELTA_Y) {
            revert TransactionUnbalanced({ expected: ZERO_DELTA_Y, actual: delta[1] });
        }
    }

    function _executeFFICall(FFICall calldata ffiCall) internal {
        ffiCall.wrapperContract.evmCall(ffiCall.input);
    }

    function _computeWrapperLabelRef(IWrapper wrapperContract) internal pure returns (bytes32) {
        return abi.encode(wrapperContract).toRefCalldata();
    }

    /// @notice Computes the commitment of a wrapper contract resource that can be consumed by the universal identity.
    // @param logicRef The wrapper contract logic reference.
    /// @param labelRef The wrapper contract label reference.
    /// @param valueRef The wrapper contract value reference.
    function _wrapperContractResourceCommitment(
        IWrapper wrapperContract,
        bytes32 labelRef,
        bytes32 valueRef
    )
        internal
        returns (bytes32)
    {
        return Resource({
            logicRef: wrapperContract.wrapperResourceLogicRef(),
            labelRef: labelRef,
            valueRef: valueRef,
            nullifierKeyCommitment: UNIVERSAL_NULLIFIER_KEY_COMMITMENT,
            quantity: 1,
            nonce: wrapperContract.newNonce(),
            randSeed: 0,
            ephemeral: false
        }).commitment();
    }

    function _createWrapperContractResource(IWrapper wrapperContract) internal {
        bytes32 computedWrapperLabelRef = _computeWrapperLabelRef(wrapperContract);
        bytes32 expectedWrapperLabelRef = wrapperContract.wrapperResourceLabelRef();

        // Check integrity
        if (computedWrapperLabelRef != expectedWrapperLabelRef) {
            revert WrapperContractResourceLabelMismatch({
                expected: expectedWrapperLabelRef,
                actual: computedWrapperLabelRef
            });
        }

        _addCommitment(
            _wrapperContractResourceCommitment({
                wrapperContract: wrapperContract,
                labelRef: computedWrapperLabelRef,
                valueRef: abi.encode(wrapperContract.wrappedResourceKind(), bytes(""), bytes("")).toRefCalldata()
            })
        );
    }
}
