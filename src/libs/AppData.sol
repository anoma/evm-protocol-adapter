// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { ExpirableBlob, DeletionCriterion } from "../state/BlobStorage.sol";

library AppDataMap {
    error KeyNotFound(bytes32 key);
    error IndexOutBounds(uint256 index, uint256 max);

    struct TagAppDataPair {
        bytes32 tag;
        ExpirableBlob appData;
    }

    function lookup(
        TagAppDataPair[] memory map,
        bytes32 tag
    )
        internal
        pure
        returns (bool success, ExpirableBlob memory)
    {
        for (uint256 i = 0; i < map.length; i++) {
            if (map[i].tag == tag) {
                return (true, map[i].appData);
            }
        }
        return (false, ExpirableBlob(DeletionCriterion.AfterTransaction, bytes("")));
    }

    function lookupCalldata(
        TagAppDataPair[] calldata map,
        bytes32 tag
    )
        internal
        pure
        returns (ExpirableBlob calldata)
    {
        for (uint256 i = 0; i < map.length; i++) {
            if (map[i].tag == tag) {
                return (map[i].appData);
            }
        }
        revert KeyNotFound(tag);
    }

    function at(TagAppDataPair[] memory map, uint256 index) internal pure returns (ExpirableBlob memory) {
        uint256 lastIndex = map.length - 1;
        if (index > lastIndex) {
            revert IndexOutBounds({ index: index, max: lastIndex });
        }
        return map[index].appData;
    }
}
