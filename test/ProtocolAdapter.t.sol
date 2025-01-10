// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";

import { ProtocolAdapter } from "../src/ProtocolAdapter.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract ProtocolAdapterTest is Test {
    uint256 internal testNumber;
    ProtocolAdapter internal protocolAdapter;

    // TODO: Fork mainnet https://docs.starknet.io/architecture-and-concepts/solidity-verifier/
    address internal constant STARK_VERIFIER = address(0);
    uint8 internal constant TREE_DEPTH = 2; // NOTE: 2^2 = 4 nodes are possible.

    function setUp() public {
        testNumber = 42;
        protocolAdapter = new ProtocolAdapter(STARK_VERIFIER, TREE_DEPTH);
    }

    function test_NumberIs42() public view {
        console2.log(vm.toString(testNumber));
        assertEq(testNumber, 42);
    }
}
