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
    function removeElement(bytes32[] storage array, bytes32 elem) internal returns (bytes32[] storage modified) {
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
}
