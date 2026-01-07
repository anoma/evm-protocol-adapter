// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {EfficientHashLib} from "solady/utils/EfficientHashLib.sol";

import {SHA256} from "../src/libs/SHA256.sol";

contract SHA256Test is Test {
    function testFuzz_hash_reproduces_the_EfficientHashLib_hash(bytes32 a) public view {
        assertEq(SHA256.hash(a), EfficientHashLib.sha2(a));
    }

    function testFuzz_hash2_reproduces_the_EfficientHashLib_hash(bytes32 a, bytes32 b) public view {
        assertEq(SHA256.hash(a, b), EfficientHashLib.sha2(abi.encodePacked(a, b)));
    }
}
