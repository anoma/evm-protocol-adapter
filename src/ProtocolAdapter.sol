// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";

import { IStarkVerifier } from "./interfaces/IStarkVerifier.sol";
import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { IResourceWrapper } from "./interfaces/IResourceWrapper.sol";
import { AppData, Map } from "./libs/AppData.sol";

import { Resource, Action, Transaction } from "./Types.sol";
import { CommitmentAccumulator } from "./CommitmentAccumulator.sol";
import { NullifierSet } from "./NullifierSet.sol";

contract ProtocolAdapter is IProtocolAdapter, CommitmentAccumulator, NullifierSet {
    using AppData for Map.KeyValuePair[];
    using Address for address;

    IStarkVerifier private starkVerifier;
    uint256 private txCount;

    event TransactionExecuted(uint256 indexed id, Transaction transaction);
    event EVMStateChangeExecuted(IResourceWrapper indexed wrapper, bytes32 indexed tag);

    error InvalidProof(uint256[] proofParams, uint256[] proof, uint256[] publicInput);

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
            Action memory action = transaction.actions[i];
            Map.KeyValuePair[] memory appData = action.appData;

            for (uint256 j = 0; j < action.nullifiers.length; ++j) {
                _addNullifier(action.nullifiers[j]);
                _executeWrapCall(action.nullifiers[j], appData);
            }

            for (uint256 j = 0; j < action.commitments.length; ++j) {
                _addCommitment(action.commitments[j]);
                _executeUnwrapCall(action.commitments[j], appData);
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
        for (uint256 i; i < action.proofs.length; ++i) {
            _verifyProof({ proofParams: EMPTY_UINT256_ARR, proof: action.proofs[i], publicInput: EMPTY_UINT256_ARR });
        }
    }

    function _verifyProof(
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

    function _executeWrapCall(bytes32 nullifier, Map.KeyValuePair[] memory appData) internal {
        (bool success, Resource memory resource) = AppData.lookupConsumedResource(appData, nullifier);

        if (success && resource.ephemeral) {
            // Lookup the wrapper contract from the resource label.
            IResourceWrapper wrapper = AppData.lookupWrapperFromResourceLabel(resource, appData);
            // Call the wrapper
            wrapper.wrap(nullifier, resource, appData);

            emit EVMStateChangeExecuted(wrapper, nullifier);
        }
    }

    function _executeUnwrapCall(bytes32 commitment, Map.KeyValuePair[] memory appData) internal {
        (bool success, Resource memory resource) = AppData.lookupCreatedResource(appData, commitment);

        if (success && resource.ephemeral) {
            // Lookup the wrapper contract from the resource label.
            IResourceWrapper wrapper = AppData.lookupWrapperFromResourceLabel(resource, appData);

            // Call the wrapper contract.
            wrapper.unwrap(commitment, resource, appData);

            emit EVMStateChangeExecuted(wrapper, commitment);
        }
    }
}
