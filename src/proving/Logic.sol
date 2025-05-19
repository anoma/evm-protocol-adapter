// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// TODO remove comment
import {LogicProof} from "../Types.sol";

library LogicProofs {
    error LogicProofTagNotFound(bytes32 tag);
    error LogicProofIndexOutBounds(uint256 index, uint256 max);

    function lookup(LogicProof[] calldata arr, bytes32 tag) internal pure returns (LogicProof calldata elem) {
        uint256 len = arr.length;
        for (uint256 i = 0; i < len; ++i) {
            if (arr[i].instance.tag == tag) {
                return elem = arr[i];
            }
        }
        revert LogicProofTagNotFound(tag);
    }
}
