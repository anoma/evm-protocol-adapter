// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {ResourceForwarderCalldataPair, EMPTY_RESOURCE_FORWARDER_CALLDATA_PAIR_HASH} from "../src/Resource.sol";

contract ResourceTest is Test {
    function test_empty_resource_forwarder_calldata_pair_hash() public pure {
        ResourceForwarderCalldataPair memory empty;

        assertEq(keccak256(abi.encode(empty)), EMPTY_RESOURCE_FORWARDER_CALLDATA_PAIR_HASH);
    }
}
