// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EnumerableSet} from "@openzeppelin-contracts-5.5.0/utils/structs/EnumerableSet.sol";

import {INullifierSet} from "../interfaces/INullifierSet.sol";

/// @title NullifierSet
/// @author Anoma Foundation, 2025
/// @notice A nullifier set being inherited by the protocol adapter.
/// @dev The implementation is based on OpenZeppelin's `EnumerableSet` implementation.
/// @custom:security-contact security@anoma.foundation
contract NullifierSet is INullifierSet {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    /// @notice The nullifier set data structure.
    EnumerableSet.Bytes32Set internal _nullifierSet;

    error PreExistingNullifier(bytes32 nullifier);

    /// @inheritdoc INullifierSet
    function isNullifierContained(bytes32 nullifier) external view override returns (bool isContained) {
        isContained = _nullifierSet.contains(nullifier);
    }

    /// @inheritdoc INullifierSet
    function nullifierCount() external view override returns (uint256 count) {
        count = _nullifierSet.length();
    }

    /// @inheritdoc INullifierSet
    function nullifierAtIndex(uint256 index) external view override returns (bytes32 nullifier) {
        nullifier = _nullifierSet.at(index);
    }

    /// @notice Adds a nullifier to the set, if it does not exist already.
    /// @param nullifier The nullifier to add.
    function _addNullifier(bytes32 nullifier) internal {
        bool success = _nullifierSet.add(nullifier);
        require(success, PreExistingNullifier(nullifier));
    }
}
