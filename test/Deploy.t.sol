// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";

import {Deploy} from "../script/Deploy.s.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

contract ProtocolAdapterTest is Test {
    ProtocolAdapter internal _pa;

    function setUp() public {
        Deploy deployScript = new Deploy();

        _pa = ProtocolAdapter(deployScript.run());
    }

    function test_run_deploys_deterministically() public view {
        assertEq(address(_pa), 0xB05E5d1B64538F6a2b4A97E8c793A84779d36F08);
    }
}
