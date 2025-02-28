// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ExpirableBlob } from "../state/BlobStorage.sol";

struct TagAppDataPair {
    bytes32 tag;
    ExpirableBlob appData;
}

library AppData {
    error AppDataTagNotFound(bytes32 tag);
    error AppDataIndexOutBounds(uint256 index, uint256 max);

    function lookupCalldata(
        TagAppDataPair[] calldata map,
        bytes32 tag
    )
        internal
        pure
        returns (ExpirableBlob memory appData)
    {
        uint256 len = map.length;
        for (uint256 i = 0; i < len; ++i) {
            if (map[i].tag == tag) {
                return appData = map[i].appData;
            }
        }
        revert AppDataTagNotFound(tag);
    }

    function lookup(TagAppDataPair[] memory map, bytes32 tag) internal pure returns (ExpirableBlob memory appData) {
        uint256 len = map.length;
        for (uint256 i = 0; i < len; ++i) {
            if (map[i].tag == tag) {
                return appData = map[i].appData;
            }
        }
        revert AppDataTagNotFound(tag);
    }

    function at(TagAppDataPair[] calldata map, uint256 index) internal pure returns (ExpirableBlob memory appData) {
        uint256 lastIndex = map.length - 1;
        if (index > lastIndex) {
            revert AppDataIndexOutBounds({ index: index, max: lastIndex });
        }
        appData = map[index].appData;
    }
}
