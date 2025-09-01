// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

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
    function contains(bytes32 nullifier) external view override returns (bool isContained) {
        isContained = _nullifierSet.contains(nullifier);
    }

    /// @inheritdoc INullifierSet
    function length() external view override returns (uint256 len) {
        len = _nullifierSet.length();
    }

    /// @inheritdoc INullifierSet
    function atIndex(uint256 index) external view override returns (bytes32 nullifier) {
        nullifier = _nullifierSet.at(index);
    }

    /// @notice Adds a nullifier to to the set, if it does not exist already.
    /// @param nullifier The nullifier to add.
    function _addNullifier(bytes32 nullifier) internal {
        (bool success) = _nullifierSet.add(nullifier);
        if (!success) {
            revert PreExistingNullifier(nullifier);
        }
    }
}
