// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title INullifierSet
/// @author Anoma Foundation, 2025
/// @notice The interface of the nullifier set contract.
/// @custom:security-contact security@anoma.foundation
interface INullifierSet {
    /// @notice Emitted if a nullifier is added to the nullifier set.
    /// @param nullifier The nullifier being stored.
    /// @param index The index of the nullifier in the enumerable set.
    event NullifierAdded(bytes32 indexed nullifier, uint256 indexed index);

    /// @notice Returns whether the set contains a given nullifier or not.
    /// @param nullifier The nullifier to check.
    /// @return isContained Whether the nullifier is contained or not.
    function contains(bytes32 nullifier) external view returns (bool isContained);

    /// @notice Returns the number of nullifiers in the set.
    /// @return len The number of nullifiers in the set.
    function length() external view returns (uint256 len);

    /// @notice Returns the nullifier with the given index.
    /// @param index The index to return the nullifier for.
    /// @return nullifier The nullifier at the given index.
    function at(uint256 index) external view returns (bytes32 nullifier);
}
