// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library ArrayLookup {
    error ElementNotFound(bytes32 tag);

    function contains(bytes32[] memory set, bytes32 elem) internal pure returns (bool success) {
        uint256 len = set.length;
        for (uint256 i = 0; i < len; ++i) {
            if (set[i] == elem) {
                return success = true;
            }
        }
        return success = false;
    }
}
