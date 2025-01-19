// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

library Map {
    error KeyNotFound(bytes32 key);
    error IndexOutBounds(uint256 index, uint256 max);

    struct KeyValuePair {
        bytes32 key;
        bytes value;
    }

    function lookup(KeyValuePair[] memory map, bytes32 key) internal pure returns (bool success, bytes memory) {
        for (uint256 i = 0; i < map.length; i++) {
            if (map[i].key == key) {
                return (true, map[i].value);
            }
        }
        return (false, bytes(""));
    }

    function at(KeyValuePair[] memory map, uint256 index) internal pure returns (bytes memory) {
        uint256 lastIndex = map.length - 1;
        if (index > lastIndex) {
            revert IndexOutBounds({ index: index, max: lastIndex });
        }
        return map[index].value;
    }
}
