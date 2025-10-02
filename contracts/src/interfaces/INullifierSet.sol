// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title INullifierSet
/// @author Anoma Foundation, 2025
/// @notice The interface of the nullifier set contract.
/// @custom:security-contact security@anoma.foundation
interface INullifierSet {
    /// @notice Returns whether the set contains a given nullifier or not.
    /// @param nullifier The nullifier to check.
    /// @return isContained Whether the nullifier is contained or not.
    function isNullifierContained(bytes32 nullifier) external view returns (bool isContained);

    /// @notice Returns the number of nullifiers in the nullifier set.
    /// @return count The number of nullifiers in the set.
    function nullifierCount() external view returns (uint256 count);

    /// @notice Returns the nullifier with the given index.
    /// @param index The index to return the nullifier for.
    /// @return nullifier The nullifier at the given index.
    function nullifierAtIndex(uint256 index) external view returns (bytes32 nullifier);
}
