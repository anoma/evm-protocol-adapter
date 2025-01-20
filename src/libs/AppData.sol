// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

struct AppData {
    DeletionCriterion deletionCriterion;
    bytes data;
}

enum DeletionCriterion {
    AfterTransaction,
    Never
}

library AppDataMap {
    error KeyNotFound(bytes32 key);
    error IndexOutBounds(uint256 index, uint256 max);

    struct TagAppDataPair {
        bytes32 tag;
        AppData appData;
    }

    function lookup(TagAppDataPair[] memory map, bytes32 tag) internal pure returns (bool success, AppData memory) {
        for (uint256 i = 0; i < map.length; i++) {
            if (map[i].tag == tag) {
                return (true, map[i].appData);
            }
        }
        return (false, AppData(DeletionCriterion.AfterTransaction, bytes("")));
    }

    function lookupCalldata(TagAppDataPair[] calldata map, bytes32 tag) internal pure returns (AppData calldata) {
        for (uint256 i = 0; i < map.length; i++) {
            if (map[i].tag == tag) {
                return (map[i].appData);
            }
        }
        revert KeyNotFound(tag);
    }

    function at(TagAppDataPair[] memory map, uint256 index) internal pure returns (AppData memory) {
        uint256 lastIndex = map.length - 1;
        if (index > lastIndex) {
            revert IndexOutBounds({ index: index, max: lastIndex });
        }
        return map[index].appData;
    }
}
