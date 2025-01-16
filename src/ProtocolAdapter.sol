// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";

import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IResourceWrapper } from "./interfaces/IResourceWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { AppData, Map } from "./libs/AppData.sol";

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
    using Address for address;

    uint256 private txCount;

    event TransactionExecuted(uint256 indexed id, Transaction transaction);
    event EVMStateChangeExecuted(IResourceWrapper indexed wrapper, bytes32 indexed tag);

    error KindMismatch(bytes32 expected, bytes32 actual);
    error CommitmentMismatch(bytes32 expected, bytes32 actual);
    error NullifierMismatch(bytes32 expected, bytes32 actual);
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
        _verifyDelta(transaction.delta, transaction.deltaProof);

        // Verify resource logics and compliance proofs.
        for (uint256 i; i < transaction.actions.length; ++i) {
            _verifyAction(transaction.actions[i]);
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
        bytes32 expectedDelta = 0;

        {
            delta;
            expectedDelta;
        }

        _verifyProof({ seal: deltaProof, imageId: /*TODO*/ bytes32(0), journalDigest: /*TODO*/ bytes32(0) });
    }

    function _verifyAction(Action calldata action) internal {
        for (uint256 i; i < action.complianceProofs.length; ++i) {
            ComplianceInstance memory instance = ComplianceInstance({
                consumed: new ConsumedRefs[](0),
                created: new CreatedRefs[](0),
                unitDelta: bytes32(0) // DeltaHash - what hash function?
             });

            // TODO

            _verifyComplianceProof(instance);
        }
        for (uint256 i; i < action.logicProofs.length; ++i) {
            LogicInstance memory instance = LogicInstance({
                tag: bytes32(0),
                isConsumed: true,
                consumed: new bytes32[](0),
                created: new bytes32[](0),
                appDataForTag: new Map.KeyValuePair[](0)
            });

            // TODO

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
