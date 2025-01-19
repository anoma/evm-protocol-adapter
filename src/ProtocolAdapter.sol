// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";

import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IResourceWrapper } from "./interfaces/IResourceWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { AppData, Map } from "./libs/AppData.sol";
import { Delta } from "./libs/Delta.sol";

import {
    Resource, Action, Transaction, LogicInstance, ComplianceInstance, ConsumedRefs, CreatedRefs
} from "./Types.sol";
import { UNIVERSAL_NULLIFIER_KEY, WRAP_MAGIC_NUMBER, UNWRAP_MAGIC_NUMBER } from "./Constants.sol";
import { CommitmentAccumulator } from "./CommitmentAccumulator.sol";
import { NullifierSet } from "./NullifierSet.sol";
import { RiscZeroVerifier } from "./RiscZeroVerifier.sol";

contract ProtocolAdapter is IProtocolAdapter, RiscZeroVerifier, CommitmentAccumulator, NullifierSet {
    using ComputableComponents for Resource;
    using AppData for Map.KeyValuePair[];
    using Delta for bytes32;
    using Address for address;

    uint256 private txCount;
    bytes32 internal constant EXPECTED_DELTA = bytes32(0);

    event TransactionExecuted(uint256 indexed id, Transaction transaction);
    event EVMStateChangeExecuted(IResourceWrapper indexed wrapper, bytes32 indexed tag);

    error KindMismatch(bytes32 expected, bytes32 actual);
    error CommitmentMismatch(bytes32 expected, bytes32 actual);
    error NullifierMismatch(bytes32 expected, bytes32 actual);
    error DeltaMismatch(bytes32 expected, bytes32 actual);
    error WrongEphemerality(bytes32 tag, bool ephemeral);

    bytes32 private constant EMPTY_BYTES32 = bytes32(0);
    // solhint-disable-next-line var-name-mixedcase
    uint256[] private EMPTY_UINT256_ARR = new uint256[](0);

    constructor(
        address _riscZeroVerifier,
        uint8 _treeDepth
    )
        RiscZeroVerifier(_riscZeroVerifier)
        CommitmentAccumulator(_treeDepth)
    { }

    /// @notice Verifies a transaction by checking the delta, resource logic, and compliance proofs.
    /// @param transaction The transaction to verify.
    function verify(Transaction calldata transaction) public {
        // compute delta
        bytes32 transactionDelta = 0;

        // Verify resource logics and compliance proofs.
        for (uint256 i; i < transaction.actions.length; ++i) {
            transactionDelta = transactionDelta.add(_actionDelta(transaction.actions[i]));

            _verifyAction(transaction.actions[i]);
        }

        _verifyDelta(transactionDelta, transaction.deltaProof);
    }

    function _actionDelta(Action memory action) internal pure returns (bytes32 delta) {
        for (uint256 i; i < action.complianceUnits.length; ++i) {
            bytes32 ref = action.complianceUnits[i].refInstance;

            // TODO use reference or ensure they match - maybe put in transient storage
            ComplianceInstance memory referencedInstance = ComplianceInstance({
                consumed: new ConsumedRefs[](0),
                created: new CreatedRefs[](0),
                unitDelta: bytes32(0)
            });

            delta = delta.add(referencedInstance.unitDelta);
        }
    }

    /// @notice Executes a transaction by adding the commitments and nullifiers to the commitment tree and nullifier
    /// set, respectively, and calling EVM.
    /// @param transaction The transaction to execute.
    function execute(Transaction calldata transaction) external {
        verify(transaction);

        for (uint256 i = 0; i < transaction.actions.length; ++i) {
            Action calldata action = transaction.actions[i];
            Map.KeyValuePair[] memory appData = action.appData;

            for (uint256 j = 0; j < action.nullifiers.length; ++j) {
                _addNullifier(action.nullifiers[j]);
                _attemptWrapCall(action.nullifiers[j], appData);
            }

            for (uint256 j = 0; j < action.commitments.length; ++j) {
                _addCommitment(action.commitments[j]);
                _attemptUnwrapCall(action.commitments[j], appData);
            }
        }
        emit TransactionExecuted({ id: txCount++, transaction: transaction });
    }

    function _verifyDelta(bytes32 delta, bytes calldata deltaProof) internal {
        /* Constraints (https://specs.anoma.net/latest/arch/system/state/resource_machine/data_structures/transaction/delta_proof.html#constraints)
        1. delta = sum(unit.delta() for unit in action.units for action in tx) - can be checked outside of the circuit since all values are public
        2. delta's preimage's quantity component is expectedBalance
        */

        if (delta != EXPECTED_DELTA) revert DeltaMismatch({ expected: EXPECTED_DELTA, actual: delta });

        // TODO is proof verification required?
        _verifyProof({ seal: deltaProof, imageId: /*TODO*/ bytes32(0), journalDigest: /*TODO*/ bytes32(0) });
    }

    function _verifyAction(Action calldata action) internal {
        for (uint256 i; i < action.complianceUnits.length; ++i) {
            /*
            1. Merkle path validity (for non-ephemeral resources only): CMTree::Verify(cm, path, root) = True for each resource associated with a nullifier from the consumedResourceTagSet
            2. for each consumed resource r:
                - Nullifier integrity: r.nullifier(nullifierKey) is in consumedResourceTagSet
                - consumed commitment integrity: r.commitment() = cm
                - Logic integrity: logicRefHash = hash(r.logicRef, ...)
            3. for each created resource r:
                - Commitment integrity: r.commitment() is in createdResourceTagSet
                - Logic integrity: logicRefHash = hash(r.logicRef, ...)
                - Delta integrity: unitDelta = sum(r.delta() for r in consumed) - sum(r.delta() for r in created)
            */

            for (uint256 j = 0; j < action.nullifiers.length; ++j) { }

            for (uint256 j = 0; j < action.commitments.length; ++j) { }

            verifyMerklePath({ root: bytes32(0), commitmentIdentifier: bytes32(0), witness: new bytes32[](0) });

            ComplianceInstance memory instance = ComplianceInstance({
                consumed: new ConsumedRefs[](0),
                created: new CreatedRefs[](0),
                unitDelta: bytes32(0) // DeltaHash - what hash function?
             });

            // TODO

            _verifyComplianceProof(instance);
        }

        for (uint256 i = 0; i < action.nullifiers.length; ++i) { }

        for (uint256 j = 0; j < action.commitments.length; ++j) { }

        for (uint256 i; i < action.logicProofs.length; ++i) {
            LogicRefHashProofPair memory instance = action.logicProofs.at(i);

            // TODO Is more information needed? What's the verifying key?

            _verifyLogicProof(instance);
        }
    }

    function _verifyComplianceProof(ComplianceInstance memory complianceInstance) internal {
        // TODO `verify_compliance_hash(proofRecords)` ?

        // TODO iterate over refs
        verifyMerklePath({ root: bytes32(0), commitmentIdentifier: bytes32(0), witness: new bytes32[](0) });

        _verifyProof({ seal: bytes(""), imageId: bytes32(0), journalDigest: bytes32(0) });
    }

    function _verifyLogicProof(LogicInstance memory instance) internal {
        // TODO
        _verifyProof({ seal: bytes(""), imageId: bytes32(0), journalDigest: bytes32(0) });
    }

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
}
