// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// TODO! Rename
library ArrayLookup {
    error ElementNotFound(bytes32 tag);

    function contains(bytes32[] memory set, bytes32 tag) internal pure returns (bool success) {
        uint256 len = set.length;
        for (uint256 i = 0; i < len; ++i) {
            if (set[i] == tag) {
                return success = true;
            }
        }
        return success = false;
    }

    // TODO! write test to make sure that this works
    function removeElementStorage(bytes32[] storage array, bytes32 elem)
        internal
        returns (bytes32[] storage modified)
    {
        modified = array;
        for (uint256 i = 0; i < array.length; i++) {
            if (modified[i] == elem) {
                // Swap with last and pop for gas-efficient removal
                modified[i] = array[array.length - 1];
                modified.pop();
                break;
            }
        }
        revert ElementNotFound(elem);
    }

    function removeElement(bytes32[] memory arr, bytes32 elem) internal pure returns (bytes32[] memory) {
        uint256 indexToRemove = 0;
        bool found = false;

        // Find index of the elem
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == elem) {
                indexToRemove = i;
                found = true;
                break;
            }
        }

        if (!found) revert ElementNotFound(elem);

        // Create new array with one less element
        bytes32[] memory result = new bytes32[](arr.length - 1);
        uint256 j = 0;

        // Copy all elements except the one to remove
        for (uint256 i = 0; i < arr.length; i++) {
            if (i != indexToRemove) {
                result[j] = arr[i];
                j++;
            }
        }

        return result;
    }
}
