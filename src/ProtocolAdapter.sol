// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ReentrancyGuardTransient } from "openzeppelin-contracts/utils/ReentrancyGuardTransient.sol";
import { IRiscZeroVerifier } from "risc0-ethereum/IRiscZeroVerifier.sol";

import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IWrapper } from "./interfaces/IWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { Reference } from "./libs/Reference.sol";
import { ArrayLookup } from "./libs/ArrayLookup.sol";

import { CommitmentAccumulator } from "./state/CommitmentAccumulator.sol";
import { NullifierSet } from "./state/NullifierSet.sol";
import { BlobStorage, ExpirableBlob, DeletionCriterion } from "./state/BlobStorage.sol";

import { LogicInstance, LogicProofs, TagLogicProofPair, LogicRefProofPair } from "./proving/Logic.sol";
import { ComplianceUnit } from "./proving/Compliance.sol";
import { Delta } from "./proving/Delta.sol";
import { MockDelta } from "../test/MockDelta.sol"; // TODO remove
import { AppData } from "./libs/AppData.sol";
import { Universal } from "./libs/Identities.sol";
import { Resource, Transaction, Action, TagAppDataPair, KindFFICallPair, FFICall } from "./Types.sol";

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

    IRiscZeroVerifier private immutable riscZeroVerifier;
    bytes32 private immutable complianceCircuitID;
    bytes32 private immutable logicCircuitID;

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
        IRiscZeroVerifier _riscZeroVerifier,
        bytes32 _logicCircuitID,
        bytes32 _complianceCircuitID,
        uint8 _treeDepth
    )
        CommitmentAccumulator(_treeDepth)
    {
        riscZeroVerifier = _riscZeroVerifier;
        logicCircuitID = _logicCircuitID;
        complianceCircuitID = _complianceCircuitID;
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
    // slither-disable-next-line reentrancy-no-eth
    function execute(Transaction calldata transaction) external nonReentrant {
        _verify(transaction);

        emit TransactionExecuted({ id: _txCount++, transaction: transaction });

        for (uint256 i = 0; i < transaction.actions.length; ++i) {
            Action calldata action = transaction.actions[i];

            for (uint256 j = 0; j < action.tagAppDataPairs.length; ++j) {
                _storeBlob(action.tagAppDataPairs[j].appData);
            }

            for (uint256 j = 0; j < action.nullifiers.length; ++j) {
                _addNullifier(action.nullifiers[j]);
            }

            for (uint256 j = 0; j < action.commitments.length; ++j) {
                // Commitment pre-existence was already checked in `_verify(transaction);` at the top.
                _addCommitmentUnchecked(action.commitments[j]);
            }

            for (uint256 j = 0; j < action.kindFFICallPairs.length; ++j) {
                _executeFFICall(action.kindFFICallPairs[j].ffiCall);
            }
        }
    }

    /// @notice Creates a wrapper contract resource object and adds the commitment to the commitment accumulator
    /// @param wrapperContract The wrapper contract.
    function createWrapperContractResource(IWrapper wrapperContract) external {
        _createWrapperContractResource(wrapperContract);
    }

    // slither-disable-next-line code-complexity
    function _verify(Transaction calldata transaction) internal view {
        // Can also be named DeltaHash (which is what Yulia does).
        uint256[2] memory transactionDelta = Delta.zero();

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

                riscZeroVerifier.verify({
                    seal: unit.proof,
                    imageId: complianceCircuitID,
                    journalDigest: sha256(abi.encode(unit.verifyingKey, unit.instance))
                });

                // Prepare delta proof
                transactionDelta = Delta.add({ p1: transactionDelta, p2: unit.instance.unitDelta });
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
                    instance.appDataForTag = action.tagAppDataPairs.lookupCalldata(tag);

                    {
                        logicRefProofPair = action.logicProofs.lookup(tag);
                        riscZeroVerifier.verify({
                            seal: logicRefProofPair.proof,
                            imageId: logicCircuitID,
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
                        riscZeroVerifier.verify({
                            seal: logicRefProofPair.proof,
                            imageId: logicCircuitID,
                            journalDigest: sha256(abi.encode( /*verifying key*/ logicRefProofPair.logicRef, instance))
                        });
                    }
                }
            }
        }

        // Delta Proof
        // TODO: THIS IS A TEMPORARY MOCK PROOF AND MUST BE REMOVED.
        // NOTE: The `transactionHash(tags)` and `transactionDelta` are not used here.
        MockDelta.verify({ deltaProof: transaction.deltaProof });
        /*
        Delta.verify({
            transactionHash: _transactionHash(tags),
            transactionDelta: transactionDelta,
            deltaProof: transaction.deltaProof
         });
        */
    }

    function transactionHash(bytes32[] calldata tags) external pure returns (bytes32) {
        return _transactionHash(tags);
    }

    function _transactionHash(bytes32[] memory tags) internal pure returns (bytes32) {
        return sha256(abi.encode(tags));
    }

    function _verifyFFICall(KindFFICallPair calldata kindFFICallPair) internal view {
        bytes32 passedKind = kindFFICallPair.kind;
        bytes32 fetchedKind = IWrapper(kindFFICallPair.ffiCall.wrapperContract).wrapperResourceKind();

        if (passedKind != fetchedKind) {
            revert WrapperResourceKindMismatch({ expected: fetchedKind, actual: passedKind });
        }
    }

    // TODO Consider DoS attacks https://detectors.auditbase.com/avoid-external-calls-in-unbounded-loops-solidity
    // slither-disable-next-line calls-loop
    function _executeFFICall(FFICall calldata ffiCall) internal {
        bytes memory output = IWrapper(ffiCall.wrapperContract).evmCall(ffiCall.input);

        if (keccak256(output) != keccak256(ffiCall.output)) {
            revert FFICallOutputMismatch({ expected: ffiCall.output, actual: output });
        }
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
            nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
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
