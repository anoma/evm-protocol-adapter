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

    // slither-disable-start dead-code
    /// @notice Adds a nullifier to to the set, if it does not exist already.
    /// @param nullifier The nullifier to add.
    function _addNullifier(bytes32 nullifier) internal {
        (bool success) = _nullifierSet.add(nullifier);
        if (!success) {
            revert PreExistingNullifier(nullifier);
        }
        emit NullifierAdded({nullifier: nullifier, index: _nullifierSet.length() - 1});
    }
    // slither-disable-end dead-code

    /// @notice Adds a nullifier to the set without checking if it exists already.
    /// @param nullifier The nullifier to add.
    function _addNullifierUnchecked(bytes32 nullifier) internal {
        // slither-disable-next-line unused-return
        _nullifierSet.add(nullifier);

        emit NullifierAdded({nullifier: nullifier, index: _nullifierSet.length() - 1});
    }

    /// @notice Checks if a nullifier does not exists already and reverts otherwise.
    /// @param nullifier The nullifier to check existence for.
    function _checkNullifierNonExistence(bytes32 nullifier) internal view {
        if (_nullifierSet.contains(nullifier)) {
            revert PreExistingNullifier(nullifier);
        }
    }
}
