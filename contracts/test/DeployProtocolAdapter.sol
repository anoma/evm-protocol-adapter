// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {DeployProtocolAdapter} from "../script/DeployProtocolAdapter.s.sol";

contract DeployProtocolAdapterTest is Test {
    function test_deploy() public {
        DeployProtocolAdapter deployScript = new DeployProtocolAdapter();

        vm.expectRevert(); // TODO! Remove this when the RISC Zero version has been updated.
        deployScript.run();
    }
}
