// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Deploy} from "../script/Deploy.s.sol";

contract DeployTest is Test {
    function test_deploy() public {
        Deploy deployScript = new Deploy();

        vm.expectRevert(); // TODO! Remove this when the RISC Zero version has been updated.
        deployScript.run();
    }
}
