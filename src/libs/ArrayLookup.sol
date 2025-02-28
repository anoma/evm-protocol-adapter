// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library ArrayLookup {
    function contains(bytes32[] memory set, bytes32 tag) internal pure returns (bool success) {
        uint256 len = set.length;
        for (uint256 i = 0; i < len; ++i) {
            if (set[i] == tag) {
                return success = true;
            }
        }
        return success = false;
    }
}
