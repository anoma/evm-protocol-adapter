// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { ReentrancyGuardTransient } from "@openzeppelin/contracts/utils/ReentrancyGuardTransient.sol";
import { IRiscZeroVerifier } from "risc0-ethereum/IRiscZeroVerifier.sol";

import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IWrapper } from "./interfaces/IWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { Reference } from "./libs/Reference.sol";
import { ArrayLookup } from "./libs/ArrayLookup.sol";

import { CommitmentAccumulator } from "./state/CommitmentAccumulator.sol";
import { NullifierSet } from "./state/NullifierSet.sol";
import { BlobStorage, ExpirableBlob, DeletionCriterion } from "./state/BlobStorage.sol";

import { ComplianceUnit } from "./proving/Compliance.sol";
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

    // solhint-disable-next-line code-complexity
    function _verify(Transaction calldata transaction) internal view {
        // Can also be named DeltaHash (which is what Yulia does).
        uint256[2] memory transactionDelta = _zeroDelta();

        // Helper variable
        uint256 resourceCount;

        for (uint256 i; i < transaction.actions.length; ++i) {
            resourceCount += transaction.actions[i].commitments.length;
            resourceCount += transaction.actions[i].nullifiers.length;
        }
        bytes32[] memory tags = new bytes32[](resourceCount);
        // Reset resource count for later use.
        resourceCount = 0;

        for (uint256 i; i < transaction.actions.length; ++i) {
            Action calldata action = transaction.actions[i];

            for (uint256 j; j < action.kindFFICallPairs.length; ++j) {
                _verifyFFICall(action.kindFFICallPairs[j]);
            }

            // Compliance Proofs
            for (uint256 j; j < action.complianceUnits.length; ++j) {
                ComplianceUnit calldata unit = action.complianceUnits[j];

                // Prepare delta proof
                transactionDelta = Delta.add({ p1: transactionDelta, p2: unit.instance.unitDelta });

                // Check consumed resources
                for (uint256 k; k < unit.instance.consumed.length; ++k) {
                    transaction.roots.contains(unit.instance.consumed[k].rootRef);
                    _checkRootPreExistence(unit.instance.consumed[k].rootRef);

                    action.nullifiers.contains(unit.instance.consumed[k].nullifierRef);
                    _checkNullifierNonExistence(unit.instance.consumed[k].nullifierRef);
                }

                // Check created resources
                for (uint256 k; k < unit.instance.created.length; ++k) {
                    action.commitments.contains(unit.instance.created[k].commitmentRef);
                    _checkCommitmentNonExistence(unit.instance.created[k].commitmentRef);
                }

                RISC_ZERO_VERIFIER.verify({
                    seal: unit.proof,
                    imageId: COMPLIANCE_CIRCUIT_ID,
                    journalDigest: sha256(abi.encode(unit.verifyingKey, unit.instance))
                });
            }

            // Logic Proofs
            {
                LogicInstance memory instance = LogicInstance({
                    tag: bytes32(0),
                    isConsumed: true,
                    consumed: action.nullifiers,
                    created: action.commitments,
                    appDataForTag: ExpirableBlob({ deletionCriterion: DeletionCriterion.Immediately, blob: bytes("") })
                });
                LogicRefProofPair memory logicRefProofPair;

                // Check consumed resources
                for (uint256 j; j < action.nullifiers.length; ++j) {
                    bytes32 tag = action.nullifiers[j];

                    tags[resourceCount] = tag;
                    resourceCount++;

                    instance.tag = tag;
                    instance.appDataForTag = action.tagAppDataPairs.lookup(tag);

                    {
                        logicRefProofPair = action.logicProofs.lookup(tag);
                        RISC_ZERO_VERIFIER.verify({
                            seal: logicRefProofPair.proof,
                            imageId: LOGIC_CIRCUIT_ID,
                            journalDigest: sha256(abi.encode( /*verifying key*/ logicRefProofPair.logicRef, instance))
                        });
                    }
                }
                // Check created resources
                instance.isConsumed = false;
                for (uint256 j; j < action.commitments.length; ++j) {
                    bytes32 tag = action.commitments[j];

                    tags[resourceCount] = tag;
                    resourceCount++;

                    instance.tag = tag;
                    instance.appDataForTag = action.tagAppDataPairs.lookup(tag);

                    {
                        logicRefProofPair = action.logicProofs.lookup(tag);
                        RISC_ZERO_VERIFIER.verify({
                            seal: logicRefProofPair.proof,
                            imageId: LOGIC_CIRCUIT_ID,
                            journalDigest: sha256(abi.encode( /*verifying key*/ logicRefProofPair.logicRef, instance))
                        });
                    }
                }
            }
        }

        {
            // Delta Proof
            Delta.verify({
                transactionHash: sha256(abi.encode(tags)),
                delta: transactionDelta,
                deltaProof: transaction.deltaProof // TODO delta proof needed?
             });

            // TODO needed?
            if (transactionDelta[0] != ZERO_DELTA_X) {
                revert TransactionUnbalanced({ expected: ZERO_DELTA_X, actual: transactionDelta[0] });
            }
            if (transactionDelta[1] != ZERO_DELTA_Y) {
                revert TransactionUnbalanced({ expected: ZERO_DELTA_Y, actual: transactionDelta[1] });
            }
        }
    }

    function _verifyFFICall(KindFFICallPair calldata kindFFICallPair) internal view {
        bytes32 passedKind = kindFFICallPair.kind;
        bytes32 fetchedKind = kindFFICallPair.ffiCall.wrapperContract.wrapperResourceKind();

        if (passedKind != fetchedKind) {
            revert WrapperResourceKindMismatch({ expected: fetchedKind, actual: passedKind });
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
