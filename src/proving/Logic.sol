// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ExpirableBlob } from "../state/BlobStorage.sol";

struct LogicInstance {
    bytes32 tag;
    bool isConsumed;
    bytes32[] consumed;
    bytes32[] created;
    ExpirableBlob appDataForTag; // TODO Revisit.
}

struct TagLogicProofPair {
    bytes32 tag;
    LogicRefProofPair pair;
}

struct LogicRefProofPair {
    bytes32 logicRef;
    bytes proof;
}

library LogicProofs {
    error LogicProofTagNotFound(bytes32 tag);
    error LogicProofIndexOutBounds(uint256 index, uint256 max);

    function lookup(
        TagLogicProofPair[] calldata map,
        bytes32 tag
    )
        internal
        pure
        returns (LogicRefProofPair memory elem)
    {
        uint256 len = map.length;
        for (uint256 i = 0; i < len; ++i) {
            if (map[i].tag == tag) {
                return elem = (map[i].pair);
            }
        }
        revert LogicProofTagNotFound(tag);
    }

    function at(
        TagLogicProofPair[] calldata map,
        uint256 index
    )
        internal
        pure
        returns (LogicRefProofPair memory elem)
    {
        uint256 lastIndex = map.length - 1;
        if (index > lastIndex) {
            revert LogicProofIndexOutBounds({ index: index, max: lastIndex });
        }
        elem = map[index].pair;
    }
}
