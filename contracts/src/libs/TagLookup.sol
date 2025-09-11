// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title TagLookup
/// @author Anoma Foundation, 2025
/// @notice A library containing utility functions for tag lookups.
/// @custom:security-contact security@anoma.foundation
library TagLookup {
    error NullifierDuplicated(bytes32 nullifier);

    /// @notice Returns whether an array of tags contains a nullifier or not.
    /// @param tags The tags array to check.
    /// @param nullifier The nullifier to check.
    /// @return isContained Whether the element is contained in the array or not.
    /// @dev This assumes that nullifiers and commitments are found in even and odd positions, respectively.
    function isNullifierContained(bytes32[] memory tags, bytes32 nullifier) internal pure returns (bool isContained) {
        uint256 len = tags.length;

        for (uint256 i = 0; i < len; i += 2) {
            if (tags[i] == nullifier) {
                return isContained = true;
            }
        }
        return isContained = false;
    }

    /// @notice Checks if a nullifier is non-existent in an array of tags and reverts if it not.
    /// @param tags The tags array to check.
    /// @param nullifier The nullifier to check non-existence for.
    function checkNullifierNonExistence(bytes32[] memory tags, bytes32 nullifier) internal pure {
        if (isNullifierContained(tags, nullifier)) {
            revert NullifierDuplicated(nullifier);
        }
    }
}
