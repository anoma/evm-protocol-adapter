// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
// import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";
// import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { ReentrancyGuardTransient } from "@openzeppelin/contracts/utils/ReentrancyGuardTransient.sol";

import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IWrapper } from "./interfaces/IWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { Reference } from "./libs/Reference.sol";
import { Delta } from "./libs/Delta.sol";

//import { UNIVERSAL_NULLIFIER_KEY, WRAP_MAGIC_NUMBER, UNWRAP_MAGIC_NUMBER } from "./Constants.sol";
import { CommitmentAccumulator } from "./state/CommitmentAccumulator.sol";
import { NullifierSet } from "./state/NullifierSet.sol";
import { BlobStorage } /*, ExpirableBlob, DeletionCriterion*/ from "./state/BlobStorage.sol";

import { IRiscZeroVerifier } from "@risc0-ethereum/contracts/src/IRiscZeroVerifier.sol";

import { ComplianceUnit, ComplianceInstance } from "./proving/Compliance.sol";
import { DeltaInstance } from "./proving/Delta.sol";
import { LogicProofMap, LogicInstance, LogicRefHashProofPair } from "./proving/Logic.sol";
import { Resource, Transaction, Action, AppDataMap, TagSet, EVMCall } from "./Types.sol";
import { UNIVERSAL_NULLIFIER_KEY_COMMITMENT } from "./Constants.sol";

contract ProtocolAdapter is
    IProtocolAdapter,
    ReentrancyGuardTransient,
    // TODO Factor out CommitmentAccumulator and NullifierSet
    CommitmentAccumulator,
    NullifierSet,
    BlobStorage
{
    using TagSet for bytes32[];
    using Address for address;
    using ComputableComponents for Resource;
    using Reference for address;
    using Reference for bytes;
    using AppDataMap for AppDataMap.TagAppDataPair[];
    using LogicProofMap for LogicProofMap.TagLogicProofPair[];
    using Delta for bytes32;

    uint256 private constant BALANCED = uint256(0);

    IRiscZeroVerifier private immutable RISC_ZERO_VERIFIER;
    bytes32 private immutable COMPLIANCE_CIRCUIT_ID;
    bytes32 private immutable LOGIC_CIRCUIT_ID;
    bytes32 private immutable DELTA_CIRCUIT_ID;

    /// @notice The binding reference to the logic of the wrapper contract resource.
    /// @dev Determined by the protocol adapter on deployment.
    bytes32 private immutable WRAPPER_LOGIC_REF;

    uint256 private _txCount;
    uint256 private _nonce;

    event TransactionExecuted(uint256 indexed id, Transaction transaction);
    event EVMStateChangeExecuted(IWrapper indexed wrapper, bytes32 indexed tag);

    error WrapperContractResourceLabelMismatch(bytes32 expected, bytes32 actual);
    error WrapperContractResourceCommitmentNotFound(bytes32 commitment);

    constructor(
        bytes32 logicCircuitID,
        bytes32 complianceCircuitID,
        bytes32 deltaCircuitID,
        bytes32 wrapperLogicRef,
        address riscZeroVerifier,
        uint8 treeDepth
    )
        CommitmentAccumulator(treeDepth)
    {
        COMPLIANCE_CIRCUIT_ID = complianceCircuitID;
        LOGIC_CIRCUIT_ID = logicCircuitID;
        DELTA_CIRCUIT_ID = deltaCircuitID;

        WRAPPER_LOGIC_REF = wrapperLogicRef;
        RISC_ZERO_VERIFIER = IRiscZeroVerifier(riscZeroVerifier);
    }

    /// TODO REFACTOR
    /// @notice Creates a wrapper contract resource object and adds the commitment to the commitment accumulator
    // @param wrappedResourceKind The wrapped resource kind (that must not be confused with the wrapper contract resource kind).
    /// @param wrapper The wrapper contract.
    function createWrapperContractResource(IWrapper wrapper) internal {
        _addCommitment(
            _wrapperContractResourceCommitment({ labelRef: wrapper.wrapperLabelRef(), valueRef: bytes32(0), nonce: 0 })
        );
        revert("UNSAFE: ALLOWS ARBITRARY WRAPPER RESOURCe CREATION OUTSIDE TRANSACTIONS");
    }

    /// @notice Executes a transaction by adding the commitments and nullifiers to the commitment tree and nullifier
    /// set, respectively.
    /// @param transaction The transaction to execute.
    /// @dev This function is non-reentrant.
    function execute(Transaction calldata transaction) external nonReentrant {
        verify(transaction);

        for (uint256 i = 0; i < transaction.actions.length; ++i) {
            Action calldata action = transaction.actions[i];

            for (uint256 j = 0; j < action.evmCalls.length; ++j) {
                _executeEvmCall(action, action.evmCalls[j]);
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

    /// @notice This call expects the consumed & created wrapper resource to be already part of the transaction object and to be proven.
    // TODO think if this is needed.
    function _executeEvmCall(Action memory action, EVMCall memory evmCall) internal {
        IWrapper wrapperContract = IWrapper(evmCall.to);

        // Execute EVM call
        // TODO How can this output be available during proving times?
        // TODO Ask Chris. Probably this requires the full protocol adapter.
        bytes memory evmCallOutput = wrapperContract.evmCall(evmCall.input);

        bytes32 computedWrapperLabelRef = abi.encode(evmCall.to).toRefCalldata();
        bytes32 expectedWrapperLabelRef = wrapperContract.wrapperLabelRef();

        // TODO This check is implicitly included in the commitment lookup and therefore redundant.
        if (computedWrapperLabelRef != expectedWrapperLabelRef) {
            revert WrapperContractResourceLabelMismatch({
                expected: expectedWrapperLabelRef,
                actual: computedWrapperLabelRef
            });
        }
        bytes32 valueRef = abi.encode(evmCall.input, evmCallOutput).toRefCalldata();

        // NOTE: The full protocol adapter can store the logic, label, and value data as blobs.
        //bytes32 labelRef = _storeBlob(abi.encode(evmCall.to), DeletionCriterion.AfterTransaction);
        //bytes32 valueRef = _storeBlob(abi.encode(evmCall.input, output), DeletionCriterion.AfterTransaction);

        // Create a new wrapper contract resource.
        // NOTE: The delta proof requires the old wrapper contract to be consumed.
        bytes32 commitment = _wrapperContractResourceCommitment({
            valueRef: valueRef,
            labelRef: computedWrapperLabelRef,
            nonce: ++_nonce
        });

        // Check that the commitment is part of the commitment set.
        bool commitmentLookupSuccess = action.commitments.contains(commitment);
        if (!commitmentLookupSuccess) revert WrapperContractResourceCommitmentNotFound(commitment);

        // TODO This is not needed because proof generation has already happened.
        /*{
            // Check that an app data entry exists for wrapper contract resource with the commitment as the tag.
            (bool appDataLookupSuccess, ExpirableBlob memory appDataBlob) = action.tagAppDataPairs.lookup(commitment);

            if (!appDataLookupSuccess) revert AppDataMap.KeyNotFound({ key: commitment });

            // Expect blob to be deleted after the transaction. // TODO necessary?
            if (appDataBlob.deletionCriterion != DeletionCriterion.AfterTransaction) {
                revert DeletionCriterionNotSupported(appDataBlob.deletionCriterion);
            }

            bytes32 foundBlobHash = sha256(appDataBlob.blob);
            if (foundBlobHash == valueRef) {
                revert BlobHashMismatch({ expected: valueRef, actual: foundBlobHash });
            }
        }*/
    }

    /// @notice Verifies a transaction by checking the delta, resource logic, and compliance proofs.
    /// @param transaction The transaction to verify.
    function verify(Transaction calldata transaction) public view {
        // compute delta
        bytes32 transactionDelta;

        // Verify resource logics and compliance proofs.
        for (uint256 i; i < transaction.actions.length; ++i) {
            transactionDelta = transactionDelta.add(_actionDelta(transaction.actions[i]));

            _verifyAction(transaction.actions[i]);
        }

        _verifyDelta(transactionDelta, transaction.deltaProof);
    }

    function _actionDelta(Action calldata action) internal pure returns (bytes32 delta) {
        for (uint256 i; i < action.complianceUnits.length; ++i) {
            delta = delta.add(action.complianceUnits[i].refInstance.referencedComplianceInstance.unitDelta);
        }
    }

    function _verifyAction(Action calldata action) internal view {
        for (uint256 i; i < action.complianceUnits.length; ++i) {
            _verifyComplianceUnit(action.complianceUnits[i]);
        }

        for (uint256 i; i < action.commitments.length; ++i) {
            _verifyLogicProof({ tag: action.commitments[i], action: action, isConsumed: false });
        }

        for (uint256 i; i < action.nullifiers.length; ++i) {
            _verifyLogicProof({ tag: action.nullifiers[i], action: action, isConsumed: true });
        }
    }

    function _verifyDelta(bytes32 computedDelta, bytes calldata deltaProof) internal pure {
        DeltaInstance memory instance = DeltaInstance({ delta: computedDelta, expectedBalance: 0 });
        bytes32 verifyingKey = bytes32(sha256("TODO")); // Signature of verifying key, public key

        {
            //TODO
            deltaProof;
            verifyingKey;
            instance;
        }

        // Proof is signature over the verifying key.
        // Public key that signs the message is derived from some values.
        // -> Yulia: https://research.anoma.net/t/sapling-binding-signature/121
        // Xuyang can tell me what to do concretely.
    }

    function _verifyComplianceUnit(ComplianceUnit calldata complianceUnit) internal view {
        ComplianceInstance calldata instance = complianceUnit.refInstance.referencedComplianceInstance;
        // Note: referenced, because the instance contains things that we use in other places (see definiton of compliance instance).
        // Note: If we provide a copy, we have to ensure that both things are really the same.

        for (uint256 i; i < instance.consumed.length; ++i) {
            _checkRootPreExistence(instance.consumed[i].rootRef);

            _checkNullifierNonExistence(instance.consumed[i].nullifierRef);
        }

        for (uint256 i; i < instance.created.length; ++i) {
            _checkCommitmentNonExistence(instance.created[i].commitmentRef);
        }

        // TODO Ask Yulia / Xuyang if inputs are roughly correct.
        RISC_ZERO_VERIFIER.verify({
            seal: complianceUnit.proof,
            imageId: COMPLIANCE_CIRCUIT_ID,
            journalDigest: sha256(abi.encode(complianceUnit.verifyingKey, instance))
        });
        // Logic ref + commitment + nullifier derivation.
    }

    function _verifyLogicProof(bytes32 tag, Action calldata action, bool isConsumed) internal view {
        LogicRefHashProofPair calldata logicRefHashProofPair = action.logicProofs.lookupCalldata(tag);
        // hash of the logifRef -> function privacy requires and additional layer of verification.

        bytes calldata proof = logicRefHashProofPair.proof;
        // NOTE: Yulia: The following is NOT correct.
        // //bytes32 verifyingKey = logicRefHashProofPair.logicRefHash;

        // For below, see https://research.anoma.net/t/zkvm-compilers-goals/459.
        // TODO Yulia, specs will change. Afterwards, the transaction object will most likely contain the verifying key in some form. Alternatively, the verifying key could be part of app data, but this should be avoided to not overcomplicate things/lookups.
        bytes32 verifyingKey = sha256("TODO - REQUIRES SPECS UPDATE");

        // NOTE: Yulia: The instance
        LogicInstance memory instance = LogicInstance({
            tag: tag,
            isConsumed: isConsumed,
            consumed: action.nullifiers,
            created: action.commitments,
            appDataForTag: action.tagAppDataPairs.lookupCalldata(tag)
        });

        // NOTE: Yulia: This is a outer proof (recursive proof) verifying that the resource logic proof was verified.
        // Accordingly, this doesn't receive the LogicInstance as defined above.
        RISC_ZERO_VERIFIER.verify({
            seal: proof,
            imageId: LOGIC_CIRCUIT_ID,
            journalDigest: sha256(abi.encode(verifyingKey, instance))
        });
    }

    /// @notice Computes the commitment of a wrapper contract resource that can be consumed by the universal identity.
    /// @param labelRef The wrapper contract label reference.
    /// @param nonce The resource nonce.
    function _wrapperContractResourceCommitment(
        bytes32 labelRef,
        bytes32 valueRef,
        uint256 nonce
    )
        internal
        view
        returns (bytes32)
    {
        return Resource({
            logicRef: WRAPPER_LOGIC_REF,
            labelRef: labelRef,
            valueRef: valueRef,
            nullifierKeyCommitment: UNIVERSAL_NULLIFIER_KEY_COMMITMENT,
            quantity: 1,
            nonce: nonce,
            randSeed: 0,
            ephemeral: false
        }).commitment();
    }
}
