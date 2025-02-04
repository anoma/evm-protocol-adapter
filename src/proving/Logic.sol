// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { ExpirableBlob } from "../libs/AppData.sol";

library LogicProofMap {
    error KeyNotFound(bytes32 key);
    error IndexOutBounds(uint256 index, uint256 max);

    struct TagLogicProofPair {
        bytes32 tag;
        LogicRefHashProofPair pair;
    }

    function lookup(
        TagLogicProofPair[] memory map,
        bytes32 tag
    )
        internal
        pure
        returns (bool success, LogicRefHashProofPair memory)
    {
        for (uint256 i = 0; i < map.length; i++) {
            if (map[i].tag == tag) {
                return (true, map[i].pair);
            }
        }
        return (false, LogicRefHashProofPair({ logicRefHash: bytes32(0), proof: bytes("") }));
    }

    function lookupCalldata(
        TagLogicProofPair[] calldata map,
        bytes32 tag
    )
        internal
        pure
        returns (LogicRefHashProofPair calldata)
    {
        for (uint256 i = 0; i < map.length; i++) {
            if (map[i].tag == tag) {
                return (map[i].pair);
            }
        }

        revert KeyNotFound(tag);
    }

    function at(TagLogicProofPair[] memory map, uint256 index) internal pure returns (LogicRefHashProofPair memory) {
        uint256 lastIndex = map.length - 1;
        if (index > lastIndex) {
            revert IndexOutBounds({ index: index, max: lastIndex });
        }
        return map[index].pair;
    }
}

struct LogicRefHashProofPair {
    bytes32 logicRefHash;
    bytes proof;
}

// TODO Needed? Ask Yulia or Xuyang.
struct LogicInstance {
    bytes32 tag;
    bool isConsumed;
    bytes32[] consumed;
    bytes32[] created;
    ExpirableBlob appDataForTag; // TODO Revisit.
}
