// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {TagLogicProofPair, LogicProof} from "../Types.sol";

library LogicProofs {
    error LogicProofTagNotFound(bytes32 tag);
    error LogicProofIndexOutBounds(uint256 index, uint256 max);

    function lookup(TagLogicProofPair[] calldata map, bytes32 tag) internal pure returns (LogicProof calldata elem) {
        uint256 len = map.length;
        for (uint256 i = 0; i < len; ++i) {
            if (map[i].tag == tag) {
                return elem = (map[i].logicProof);
            }
        }
        revert LogicProofTagNotFound(tag);
    }

    function at(TagLogicProofPair[] calldata map, uint256 index) internal pure returns (LogicProof memory elem) {
        uint256 lastIndex = map.length - 1;
        if (index > lastIndex) {
            revert LogicProofIndexOutBounds({index: index, max: lastIndex});
        }
        elem = map[index].logicProof;
    }
}
