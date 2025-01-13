// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";

import { IStarkVerifier } from "./interfaces/IStarkVerifier.sol";
import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IResourceWrapper } from "./interfaces/IResourceWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { AppData, Map } from "./libs/AppData.sol";

import { Resource, Action, Transaction, LogicInstance, ComplianceInstance } from "./Types.sol";
import { UNIVERSAL_NULLIFIER_KEY, WRAP_MAGIC_NUMBER, UNWRAP_MAGIC_NUMBER } from "./Constants.sol";
import { CommitmentAccumulator } from "./CommitmentAccumulator.sol";
import { NullifierSet } from "./NullifierSet.sol";

contract ProtocolAdapter is IProtocolAdapter, CommitmentAccumulator, NullifierSet {
    using ComputableComponents for Resource;
    using AppData for Map.KeyValuePair[];
    using Address for address;

    IStarkVerifier private starkVerifier;
    uint256 private txCount;

    event TransactionExecuted(uint256 indexed id, Transaction transaction);
    event EVMStateChangeExecuted(IResourceWrapper indexed wrapper, bytes32 indexed tag);

    error InvalidProof(uint256[] proofParams, uint256[] proof, uint256[] publicInput);
    error KindMismatch(bytes32 expected, bytes32 actual);
    error CommitmentMismatch(bytes32 expected, bytes32 actual);
    error NullifierMismatch(bytes32 expected, bytes32 actual);
    error WrongEphemerality(bytes32 tag, bool ephemeral);

    bytes32 private constant EMPTY_BYTES32 = bytes32(0);
    // solhint-disable-next-line var-name-mixedcase
    uint256[] private EMPTY_UINT256_ARR = new uint256[](0);

    constructor(address _starkVerifier, uint8 _treeDepth) CommitmentAccumulator(_treeDepth) {
        starkVerifier = IStarkVerifier(_starkVerifier);
    }

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

    function _verifyDelta(uint256 delta, uint256[] calldata deltaProof) internal {
        uint256[] memory publicInput = new uint256[](1);
        publicInput[0] = delta;

        _verifyProof({ proofParams: EMPTY_UINT256_ARR, proof: deltaProof, publicInput: publicInput });
    }

    function _verifyAction(Action calldata action) internal {
        for (uint256 i; i < action.complianceProofs.length; ++i) {
            _verifyComplianceProof(action, action.complianceProofs[i]);
        }
        for (uint256 i; i < action.logicProofs.length; ++i) {
            _verifyLogicProof(action, action.complianceProofs[i]);
        }
    }

    function _verifyComplianceProof(Action calldata action, uint256[] calldata proof) internal {
        // TODO 1. Ask Xuyang if there are discrepancies to the specs and if I need to follow the node implementation.
        // TODO 2. Populate.
        ComplianceInstance memory instance = ComplianceInstance({
            consumed: new ConsumedRefs[](0),
            created: new CreatedRefs[](0),
            unitDelta: bytes32(0) // DeltaHash - what hash function?
         });

        // TODO 3. `verify_compliance_hash(proofRecords)` ?

        verifyMerklePath({ root: bytes(0), commitmentIdentifier: bytes(0), witness: new bytes32[](0) });

        _verifyProof({ proofParams: EMPTY_UINT256_ARR, proof: proof, publicInput: EMPTY_UINT256_ARR });
    }

    function _verifyLogicProof(Action calldata action, uint256[] calldata proof) internal {
        // TODO 1. Ask Xuyang if there are discrepancies to the specs and if I need to follow the node implementation.
        // TODO 2. Populate.
        LogicInstance memory instance = LogicInstance({
            tag: bytes32(0),
            isConsumed: true,
            consumed: new bytes32[](0),
            created: new bytes32[](0),
            appDataForTag: new Map.KeyValuePair[](0)
        });
        // TODO Convert into `StarkVerifier` format.
        _verifyProof({ proofParams: EMPTY_UINT256_ARR, proof: proof, publicInput: EMPTY_UINT256_ARR });
    }

    function _verifyProof(
        // TODO use calldata if possible.
        uint256[] memory proofParams,
        uint256[] memory proof,
        uint256[] memory publicInput
    )
        internal
    {
        // solhint-disable-next-line no-empty-blocks
        try starkVerifier.verifyProofExternal({ proofParams: proofParams, proof: proof, publicInput: publicInput }) {
            // Nothing
        } catch {
            revert InvalidProof({ proofParams: proofParams, proof: proof, publicInput: publicInput });
        }
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
