// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

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
