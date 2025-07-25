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
}
