// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract ProtocolAdapterTest is Test {
    uint256 internal testNumber;

    function setUp() public {
        testNumber = 42;
    }

    function test_NumberIs42() public view {
        console2.log(vm.toString(testNumber));
        assertEq(testNumber, 42);
    }
}
