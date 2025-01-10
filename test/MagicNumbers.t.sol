// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/src/Test.sol";

import { WRAP_MAGIC_NUMBER, UNWRAP_MAGIC_NUMBER } from "../src/Constants.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract MagicNumbersTest is Test {
    function test_Reproducibility() public pure {
        assertEq(WRAP_MAGIC_NUMBER, keccak256("WRAP_MAGIC_NUMBER"));
        assertEq(UNWRAP_MAGIC_NUMBER, keccak256("UNWRAP_MAGIC_NUMBER"));
    }

    function test_Consistency() public pure {
        assertEq(WRAP_MAGIC_NUMBER, 0xefe6a86099c7598e6b4a0ad71fc9857bd338d2476cea49f5c892e57384c6e915);
        assertEq(UNWRAP_MAGIC_NUMBER, 0x65a2f0bfdc75b4bf69f8f39db78498f05445a0160897c2b0107d29d9db4fd9f5);
    }
}
