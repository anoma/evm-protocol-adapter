// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Deploy} from "../script/Deploy.s.sol";

contract ProtocolAdapterTest is Test {
    function test_deploy() public {
        Deploy deployScript = new Deploy();

        deployScript.run();
    }
}
