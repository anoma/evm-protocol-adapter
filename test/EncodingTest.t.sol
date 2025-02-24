// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/src/Test.sol";

import { console } from "forge-std/src/console.sol";

contract EncodingTest is Test {
    function test1() public view {
        bytes32[] memory list1 = new bytes32[](2);
        list1[0] = bytes32(uint256(1));
        list1[1] = bytes32(uint256(2));

        bytes32[] memory list2 = new bytes32[](2);
        list2[0] = bytes32(uint256(3));
        list2[1] = bytes32(uint256(4));

        bytes32[] memory both = new bytes32[](4);
        both[0] = list1[0];
        both[1] = list1[1];
        both[2] = list2[0];
        both[3] = list2[1];

        console.logBytes(abi.encode(bytes32(uint256(1)), bytes32(uint256(2))));
        console.logBytes(abi.encode(list1));
        console.log("\n");

        console.logBytes(abi.encode(list2));
        console.log("\n");

        console.logBytes32(sha256(abi.encode(list1, list2)));

        console.logBytes32(sha256(abi.encode(both)));
    }
}
