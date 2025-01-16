pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/src/Test.sol";

import { SHA256 } from "../src/libs/SHA256.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract SHA256Benchmark is Test {
    bytes32 constant SOME_BYTES = 0x65a2f0bfdc75b4bf69f8f39db78498f05445a0160897c2b0107d29d9db4fd9f5;

    function test_sha256_1() public pure {
        SHA256.hash(SOME_BYTES);
    }

    function test_sha256_2() public pure {
        SHA256.hash(SOME_BYTES, SOME_BYTES);
    }
}
