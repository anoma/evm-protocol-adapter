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
        assertEq(address(_pa), 0x7357F3235e49eA2F3e228CEABE394B155879Dc7D);
    }
}
