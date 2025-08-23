// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title TagLookup
/// @author Anoma Foundation, 2025
/// @notice A library containing utility functions for tag lookups.
/// @custom:security-contact security@anoma.foundation
library TagLookup {
    error NullifierDuplicated(bytes32 nullifier);
    error CommitmentDuplicated(bytes32 commitment);

    /// @notice Returns whether an array contains a tag or not in even or odd positions.
    /// @param tags The tags array to check.
    /// @param tag The tag to check.
    /// @param even Whether even or odd positions should be checked.
    /// @return found Whether the element was found in the array or not.
    function isFoundInEvenOrOddPosition(bytes32[] memory tags, bytes32 tag, bool even)
        internal
        pure
        returns (bool found)
    {
        uint256 len = tags.length;

        for (uint256 i = even ? 0 : 1; i < len; i += 2) {
            if (tags[i] == tag) {
                return found = true;
            }
        }
        return found = false;
    }

    /// @notice Checks if a nullifier is non-existent in an array of tags and reverts if it not.
    /// @param tags The tags array to check.
    /// @param nullifier The nullifier to check non-existence for.
    function checkNullifierNonExistence(bytes32[] memory tags, bytes32 nullifier) internal pure {
        if (isFoundInEvenOrOddPosition({tags: tags, tag: nullifier, even: true})) {
            revert NullifierDuplicated(nullifier);
        }
    }
}
