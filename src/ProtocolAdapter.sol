// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";

import { IStarkVerifier } from "./interfaces/IStarkVerifier.sol";
import { IProtocolAdapter } from "./interfaces/IProtocolAdapter.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { Map } from "./libs/Map.sol";
import { Resource, Action, Transaction } from "./Types.sol";
import { CommitmentAccumulator } from "./CommitmentAccumulator.sol";
import { NullifierSet } from "./NullifierSet.sol";

import { MAGIC_NUMBER, UNIVERSAL_NULLIFIER_KEY } from "./Constants.sol";

contract ProtocolAdapter is IProtocolAdapter, CommitmentAccumulator, NullifierSet {
    using ComputableComponents for Resource;
    using Address for address;
    using Map for Map.KeyValuePair[];

    IStarkVerifier private starkVerifier;
    uint256 private txCount;

    event TransactionExecuted(uint256 indexed id, Transaction transaction);
    event EVMStateChangeExecuted(address indexed wrapper, bytes data);

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

    function _executeWrapCall(bytes32 nullifier, Map.KeyValuePair[] memory appData) internal {
        (bool success, Resource memory resource) = _lookupConsumedResource(appData, nullifier);

        if (success && resource.ephemeral) {
            // Lookup `label` from `labelRef` in `appData`
            bytes memory label = appData.lookup(resource.labelRef); // TODO Require `Label` to be a map

            // Decode the wrapper contract and `wrap` function selector.
            (address wrapper, bytes4 wrapSelector) = abi.decode(label, (address, bytes4));

            // Prepare the `wrap` call
            bytes memory wrapCall = abi.encodeWithSelector(wrapSelector, resource, appData);

            // Call `wrap` in the wrapper contract
            wrapper.functionCall({ data: wrapCall });

            emit EVMStateChangeExecuted(wrapper, wrapCall);
        }
    }

    function _executeUnwrapCall(bytes32 commitment, Map.KeyValuePair[] memory appData) internal {
        (bool success, Resource memory resource) = _lookupCreatedResource(appData, commitment);

        if (success && resource.ephemeral) {
            // Lookup `label` from `labelRef` in `appData`.
            bytes memory label = appData.lookup(resource.labelRef); // TODO Require `Label` to be a map

            // Decode the wrapper contract and `unwrap` function selector.
            (address wrapper,, bytes4 unwrapSelector) = abi.decode(label, (address, bytes4, bytes4));

            // Prepare the `unwrap` call
            bytes memory unwrapCall = abi.encodeWithSelector(unwrapSelector, resource, appData);

            // Call `unwrap` in the wrapper contract
            wrapper.functionCall({ data: unwrapCall });

            emit EVMStateChangeExecuted(wrapper, unwrapCall);
        }
    }

    function _lookupConsumedResource(
        Map.KeyValuePair[] memory appData,
        bytes32 nullifier
    )
        internal
        pure
        returns (bool success, Resource memory resource)
    {
        resource = _lookupResource(appData, nullifier);
        success = ComputableComponents.nullifier(resource, UNIVERSAL_NULLIFIER_KEY) == nullifier;
    }

    function _lookupCreatedResource(
        Map.KeyValuePair[] memory appData,
        bytes32 commitment
    )
        internal
        pure
        returns (bool success, Resource memory resource)
    {
        resource = _lookupResource(appData, commitment);
        success = ComputableComponents.commitment(resource) == commitment;
    }

    function _lookupResource(
        Map.KeyValuePair[] memory appData,
        bytes32 tag
    )
        internal
        pure
        returns (Resource memory resource)
    {
        bytes32 lookupKey = tag ^ MAGIC_NUMBER;

        // Lookup resource
        resource = abi.decode(appData.lookup(lookupKey), (Resource));
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
}
