// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library ArrayLookup {
    function contains(bytes32[] memory set, bytes32 tag) internal pure returns (bool success) {
        for (uint256 i = 0; i < set.length; i++) {
            if (set[i] == tag) {
                return true;
            }
        }
        return false;
    }
}
