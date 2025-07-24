// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title ArrayLookup
/// @author Anoma Foundation, 2025
/// @notice A library containing utility function to do array lookups.
/// @custom:security-contact security@anoma.foundation
library ArrayLookup {
    /// @notice Returns whether an array contains an element or not.
    /// @param arr The array to check.
    /// @param elem The element to check.
    /// @return success Whether the element is contained in the array or not.
    function contains(bytes32[] memory arr, bytes32 elem) internal pure returns (bool success) {
        uint256 len = arr.length;
        for (uint256 i = 0; i < len; ++i) {
            if (arr[i] == elem) {
                return success = true;
            }
        }
        return success = false;
    }
}
