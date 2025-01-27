// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IResourceWrapper } from "./interfaces/IResourceWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { Delta } from "./libs/Delta.sol";

//import { UNIVERSAL_NULLIFIER_KEY, WRAP_MAGIC_NUMBER, UNWRAP_MAGIC_NUMBER } from "./Constants.sol";
import { CommitmentAccumulator } from "./state/CommitmentAccumulator.sol";
import { NullifierSet } from "./state/NullifierSet.sol";
import { BlobStorage, ExpirableBlob, DeletionCriterion } from "./state/BlobStorage.sol";

import { RiscZeroVerifier } from "./proving/RiscZeroVerifier.sol";

import { ComplianceUnit, ComplianceInstance } from "./proving/Compliance.sol";
import { DeltaInstance } from "./proving/Delta.sol";
import { LogicProofMap, LogicInstance, LogicRefHashProofPair } from "./proving/Logic.sol";
import { Resource, Transaction, Action, AppDataMap, EVMCall, FFICall, TagSet } from "./Types.sol";
import { UNIVERSAL_NULLIFIER_KEY_COMMITMENT } from "./Constants.sol";

contract ProtocolAdapter is IProtocolAdapter, RiscZeroVerifier, CommitmentAccumulator, NullifierSet, BlobStorage {
    using TagSet for bytes32[];
    using Address for address;
    using ComputableComponents for Resource;
    using AppDataMap for AppDataMap.TagAppDataPair[];
    using LogicProofMap for LogicProofMap.TagLogicProofPair[];
    using Delta for bytes32;

    uint256 private txCount;
    uint256 internal constant BALANCED = uint256(0);
    bytes32 internal constant COMPLIANCE_CIRCUIT_ID = bytes32(0); //TODO
    bytes32 internal constant LOGIC_CIRCUIT_ID = bytes32(0); //TODO
    bytes32 internal constant DELTA_CIRCUIT_ID = bytes32(0); //TODO

    event TransactionExecuted(uint256 indexed id, Transaction transaction);
    event EVMStateChangeExecuted(IResourceWrapper indexed wrapper, bytes32 indexed tag);

    error KindMismatch(bytes32 expected, bytes32 actual);
    error CommitmentMismatch(bytes32 expected, bytes32 actual);
    error NullifierMismatch(bytes32 expected, bytes32 actual);
    error DeltaMismatch(bytes32 expected, bytes32 actual);
    error BalanceMismatch(uint256 expected, uint256 actual);
    error EVMCallWrapperContractResourceCommitmentNotFound(bytes32 commitment);

    error WrongEphemerality(bytes32 tag, bool ephemeral);

    bytes32 internal immutable PROTOCOL_ADAPTER_NULLIFIER_KEY;

    bytes32 private constant EMPTY_BYTES32 = bytes32(0);
    // solhint-disable-next-line var-name-mixedcase
    uint256[] private EMPTY_UINT256_ARR = new uint256[](0);

    uint256 internal nonce;

    constructor(
        address _riscZeroVerifier,
        uint8 _treeDepth
    )
        RiscZeroVerifier(_riscZeroVerifier)
        CommitmentAccumulator(_treeDepth)
    {
        PROTOCOL_ADAPTER_NULLIFIER_KEY = bytes32(uint256(uint160(address(this))));
    }

    /// TODO THIS FUNCTION IS UNSAFE AND CAN BE MISUSED TO CREATE RESOURCES WITH ARBITRARY LOGICS AND LABELS.
    /// @notice Creates a wrapper contract resource object and adds the commitment to the commitment accumulator
    // @param wrappedResourceKind The wrapped resource kind (that must not be confused with the wrapper contract resource kind).
    /// @param wrapperContract The wrapper contract
    function createWrapperContractResource(bytes32 wrapperContractLogicRef, address wrapperContract) internal {
        // Create a wrapper contract resource that can be consumed by the universal identity.
        Resource memory wrapperContractResource = Resource({
            logicRef: wrapperContractLogicRef,
            labelRef: wrapperContractLabelRef(wrapperContract),
            valueRef: EMPTY_BYTES32, // NOTE: The value is explicitly empty.
            nullifierKeyCommitment: UNIVERSAL_NULLIFIER_KEY_COMMITMENT,
            quantity: 1,
            nonce: 0, // NOTE: We explicitly set it to 0 to require the `labelRef` and `logicRef` to be different.
            randSeed: 0,
            ephemeral: false
        });

        _addCommitment(wrapperContractResource.commitment());
        revert("THIS FUNCTION IS UNSAFE AND CAN BE MISUSED TO CREATE RESOURCES WITH ARBITRARY LOGICS AND LABELS");
    }

    function wrapperContractLabelRef(address wrapperContract)
        //, bytes32 wrappedResourceKind
        internal
        pure
        returns (bytes32 labelRef)
    {
        labelRef = sha256(abi.encode(wrapperContract)); //sha256(abi.encode(wrappedResourceKind, wrapperContract));
    }

    /// @notice Executes a transaction by adding the commitments and nullifiers to the commitment tree and nullifier
    /// set, respectively.
    /// @param transaction The transaction to execute.
    function execute(Transaction calldata transaction) external {
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
        emit TransactionExecuted({ id: txCount++, transaction: transaction });
    }

    function _executeEvmCall(Action memory action, EVMCall memory evmCall) internal {
        // TODO How can this output be available during proving times?
        // TODO Ask Chris. Probably this requires the full protocol adapter.
        bytes memory output =
            evmCall.wrapperContract.functionCall(abi.encodeWithSelector(evmCall.functionSelector, evmCall.input));

        FFICall memory ffiCalldata =
            FFICall({ functionSelector: evmCall.functionSelector, input: evmCall.input, output: output });

        // bytes32 wrapperContractValueRef = sha256(abi.encode(ffiCalldata));
        bytes32 wrapperContractValueRef = _storeBlob(
            ExpirableBlob({ deletionCriterion: DeletionCriterion.AfterTransaction, blob: abi.encode(ffiCalldata) })
        );

        Resource memory wrapperContractResource = Resource({
            logicRef: evmCall.wrapperContractLogicRef,
            labelRef: wrapperContractLabelRef(evmCall.wrapperContract),
            valueRef: wrapperContractValueRef,
            nullifierKeyCommitment: UNIVERSAL_NULLIFIER_KEY_COMMITMENT,
            quantity: 1,
            nonce: 0, // NOTE: We explicitly set it to 0 to require the `labelRef` and `logicRef` to be different.
            randSeed: 0,
            ephemeral: false
        });
        // Lookup
        bytes32 commitment = wrapperContractResource.commitment();

        (bool appDataLookupSuccess, ExpirableBlob memory foundExpirableBlob) = action.tagAppDataPairs.lookup(commitment);

        // Check that an app data entry exists for wrapper contract resource with the commitment as the tag.
        if (!appDataLookupSuccess) revert AppDataMap.KeyNotFound({ key: commitment });

        // Check that the commitment is part of the commitment set.
        bool commitmentLookupSuccess = action.commitments.contains(commitment);
        if (!commitmentLookupSuccess) revert EVMCallWrapperContractResourceCommitmentNotFound(commitment);

        // Expect blob to be deleted after the transaction. // TODO necessary?
        if (foundExpirableBlob.deletionCriterion != DeletionCriterion.AfterTransaction) {
            revert DeletionCriterionNotSupported(foundExpirableBlob.deletionCriterion);
        }

        // Expect blob to equal the encoded EVM call.
        bytes32 foundBlobHash = sha256(foundExpirableBlob.blob);
        if (foundBlobHash == wrapperContractValueRef) {
            revert BlobHashMismatch({ expected: wrapperContractValueRef, actual: foundBlobHash });
        }
    }

    /*function _executeEvmCall(EVMCall memory evmCall) internal {
        bytes memory output = evmCall.wrapperContract.functionCall(evmCall.data);

        // TODO HOW TO PASS THE OUTPUT TO THE RESOURCE LOGIC?

        // TODO How can the output be available during prove times? // TODO ~!!!~

        Resource memory wrapperContractResource = Resource({
            logicRef: evmCall.wrapperContractLogicRef,
            labelRef: wrapperContractLabelRef(evmCall.wrapperContract),
            valueRef: EMPTY_BYTES32, // NOTE: The value is explicitly empty.
            nullifierKeyCommitment: UNIVERSAL_NULLIFIER_KEY_COMMITMENT,
            quantity: 1,
            nonce: 0, // NOTE: We explicitly set it to 0 to require the `labelRef` and `logicRef` to be different.
            randSeed: 0,
            ephemeral: false
        });

        _addCommitment(wrapperContractResource.commitment());
    }*/

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
            // TODO Ask Yulia if this is correct.
            delta = delta.add(action.complianceUnits[i].refInstance.referencedComplianceInstance.unitDelta);
        }
    }

    function _verifyDelta(bytes32 computedDelta, bytes calldata deltaProof) internal view {
        DeltaInstance memory instance = DeltaInstance({ delta: computedDelta, expectedBalance: 0 });
        bytes32 verifyingKey = bytes32(sha256("TODO"));

        /* Constraints (https://specs.anoma.net/latest/arch/system/state/resource_machine/data_structures/transaction/delta_proof.html#constraints)
        1. delta = sum(unit.delta() for unit in action.units for action in tx) - can be checked outside of the circuit since all values are public
        2. delta's preimage's quantity component is expectedBalance
        */
        /*
        if (instance.expectedBalance != BALANCED) {
            revert BalanceMismatch({ expected: BALANCED, actual: instance.expectedBalance });
        }

        // TODO is proof verification required? Can we use the computed delta?
        if (instance.delta != computedDelta) {
            revert DeltaMismatch({ expected: computedDelta, actual: instance.delta });
        }
        */
        // TODO Ask Yulia / Xuyang if inputs are roughly correct.
        _verifyProofCalldata({
            seal: deltaProof,
            imageId: DELTA_CIRCUIT_ID,
            journalDigest: sha256(abi.encode(verifyingKey, instance))
        });
    }

    function _verifyAction(Action calldata action) internal view {
        for (uint256 i; i < action.complianceUnits.length; ++i) {
            _verifyComplianceUnit(action.complianceUnits[i]);
        }

        for (uint256 i; i < action.commitments.length; ++i) {
            _verifyLogicProof({ tag: action.commitments[i], action: action });
        }

        for (uint256 i; i < action.nullifiers.length; ++i) {
            _verifyLogicProof({ tag: action.nullifiers[i], action: action });
        }
    }

    function _verifyComplianceUnit(ComplianceUnit calldata complianceUnit) internal view {
        ComplianceInstance calldata instance = complianceUnit.refInstance.referencedComplianceInstance;

        for (uint256 i; i < instance.consumed.length; ++i) {
            _checkRootPreExistence(instance.consumed[i].rootRef);

            // TODO Confirm with Yulia / Xuyang.
            _checkNullifierNonExistence(instance.consumed[i].nullifierRef);
            // TODO Confirm with Yulia, Xuyang that `_checkCommitmentExistence` is an in-circuit check.
        }

        for (uint256 i; i < instance.created.length; ++i) {
            // TODO Confirm with Yulia / Xuyang.
            _checkCommitmentNonExistence(instance.created[i].commitmentRef);
        }

        // TODO Ask Yulia / Xuyang if inputs are roughly correct.
        _verifyProofCalldata({
            seal: complianceUnit.proof,
            imageId: COMPLIANCE_CIRCUIT_ID,
            journalDigest: sha256(abi.encode(complianceUnit.verifyingKey, instance))
        });
    }

    function _verifyLogicProof(bytes32 tag, Action calldata action) internal view {
        LogicRefHashProofPair calldata logicRefHashProofPair = action.logicProofs.lookupCalldata(tag);
        ExpirableBlob calldata appData = action.tagAppDataPairs.lookupCalldata(tag);

        bytes calldata proof = logicRefHashProofPair.proof;
        bytes32 verifyingKey = logicRefHashProofPair.logicRefHash;

        LogicInstance memory instance = LogicInstance({
            tag: tag,
            isConsumed: false,
            consumed: action.nullifiers,
            created: action.commitments,
            appDataForTag: appData
        });

        // TODO Ask Yulia / Xuyang if inputs are roughly correct.
        _verifyProofCalldata({ // TODO Use calldata if possible
            seal: proof,
            imageId: LOGIC_CIRCUIT_ID,
            journalDigest: sha256(abi.encode(verifyingKey, instance)) // TODO Check
         });
    }

    function wrapperContractResourceCommitment(bytes32 logicRef, bytes32 labelRef) internal returns (bytes32) {
        return Resource({
            logicRef: logicRef,
            labelRef: labelRef,
            valueRef: EMPTY_BYTES32,
            nullifierKeyCommitment: UNIVERSAL_NULLIFIER_KEY_COMMITMENT,
            quantity: 1,
            nonce: nonce++,
            randSeed: 0,
            ephemeral: false
        }).commitment();
    }

    /*
    function _attemptWrapCall(bytes32 nullifier, Map.KeyValuePair[] memory appData) internal {
        // Resource object lookup from the app data
        Resource memory resource;
        {
            bool success;
            (success, resource) = appData.lookupResource({ key: nullifier ^ WRAP_MAGIC_NUMBER });
            if (!success) return;

            // Nullifier integrity check
            _checkResourceNullifierIntegrity(resource, nullifier);
        }
        // Wrapper contract lookup from the resource label reference
        IResourceWrapper wrapper;
        {
            bool success;
            (success, wrapper) = appData.lookupWrapper({ key: resource.labelRef });
            if (!success) revert Map.KeyNotFound({ key: resource.labelRef });

            _checkResourceWrapperIntegrity(resource, wrapper);
        }

        // Execute external state transition
        wrapper.wrap(nullifier, resource, appData);
        emit EVMStateChangeExecuted(wrapper, nullifier);
    }

    function _attemptUnwrapCall(bytes32 commitment, Map.KeyValuePair[] memory appData) internal {
        // Resource object lookup from the app data
        Resource memory resource;
        {
            bool success;
            (success, resource) = appData.lookupResource({ key: commitment ^ UNWRAP_MAGIC_NUMBER });
            if (!success) return;

            // Nullifier integrity check
            _checkResourceCommitmentIntegrity(resource, commitment);
        }
        // Wrapper contract lookup from the resource label reference
        IResourceWrapper wrapper;
        {
            bool success;
            (success, wrapper) = appData.lookupWrapper({ key: resource.labelRef });
            if (!success) revert Map.KeyNotFound({ key: resource.labelRef });

            _checkResourceWrapperIntegrity(resource, wrapper);
        }

        // Execute external state transition
        wrapper.unwrap(commitment, resource, appData);
        emit EVMStateChangeExecuted(wrapper, commitment);
    }

    function _checkResourceNullifierIntegrity(Resource memory resource, bytes32 nullifier) internal pure {
        bytes32 recomputedCommitment = resource.nullifier(UNIVERSAL_NULLIFIER_KEY);
        if (recomputedCommitment != nullifier) {
            revert NullifierMismatch({ expected: nullifier, actual: recomputedCommitment });
        }

        if (!resource.ephemeral) {
            revert WrongEphemerality(nullifier, resource.ephemeral);
        }
    }

    function _checkResourceCommitmentIntegrity(Resource memory resource, bytes32 commitment) internal pure {
        bytes32 recomputedCommitment = resource.commitment();
        if (recomputedCommitment != commitment) {
            revert CommitmentMismatch({ expected: commitment, actual: recomputedCommitment });
        }

        if (!resource.ephemeral) {
            revert WrongEphemerality(commitment, resource.ephemeral);
        }
    }

    /// @notice Checks the resource kind integrity.
    function _checkResourceWrapperIntegrity(Resource memory resource, IResourceWrapper wrapper) internal view {
        bytes32 resourceKind = resource.kind();
        bytes32 wrapperKind = wrapper.kind();

        if (resourceKind != wrapperKind) {
            revert KindMismatch({ expected: resourceKind, actual: wrapperKind });
        }
    }


    /// @notice Deploys the wrapper contract deterministically using `CREATE2`. // TODO is create2 needed?
    /// @param wrappedResourceKind The wrapped resource kind (that must not be confused with the wrapper contract resource kind) also acting as a salt for `CREATE2`. // TODO see if needed.
    /// @param wrapperContractBytecode The bytecode of the wrapper contract to deploy.
    function deployWrapperContract2(
        bytes32 wrappedResourceKind,
        bytes calldata wrapperContractBytecode
    )
        internal
        returns (address wrapperContract)
    {
        // NOTE: computeAddress(bytes32 salt, bytes32 bytecodeHash) must be used to
        // pre-determine the address so that it can be put in the wrapper contract resource label to ensure the correspondence.
        // TODO Is this even needed? Isn't the resource logic referenced in logic ref enough?

        // Deploy wrapper contract using `CREATE2`. // TODO Is this needed?
        wrapperContract = Create2.deploy({ amount: 0, salt: wrappedResourceKind, bytecode: wrapperContractBytecode });
        bytes32 label = wrapperContractLabelRef(wrapperContract); // `computeAddress(bytes32 salt, bytes32 bytecodeHash)` can be used to pre-compute it.

        // TODO 3. create resource

        // Create a wrapper contract resource that can be consumed by the universal identity.
        Resource memory wrapperContractResource = Resource({
            logicRef: EMPTY_BYTES32, // TODO, put the wrapper resource logic reference here
            labelRef: label,
            valueRef: EMPTY_BYTES32, // NOTE: The value can be empty.
            nullifierKeyCommitment: UNIVERSAL_NULLIFIER_KEY_COMMITMENT,
            quantity: 1,
            nonce: 0, // NOTE: We explicitly set it to 0 to require the `labelRef` and `logicRef` to be different.
            randSeed: 0,
            ephemeral: false
        });

        _addCommitment(wrapperContractResource.commitment());
        // _addNullifier(consumedWrapperContractResource.nullifier(PROTOCOL_ADAPTER_NULLIFIER_KEY));
    }
    */
}
