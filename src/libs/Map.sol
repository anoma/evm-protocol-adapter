// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

library Map {
    struct KeyValuePair {
        bytes32 key;
        bytes value;
    }

    error KeyNotFound(bytes32 key);

    function lookup(KeyValuePair[] memory map, bytes32 key) internal pure returns (bytes memory) {
        for (uint256 i = 0; i < map.length; i++) {
            if (map[i].key == key) {
                return map[i].value;
            }
        }
        revert KeyNotFound(key);
    }
}
