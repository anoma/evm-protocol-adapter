// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";

import {Permit2Dummy} from "../src/forwarders/Permit2Dummy.sol";

contract DeployPermit2Dummy is Script {
    function run() public {
        vm.startBroadcast();
        new Permit2Dummy();
        vm.stopBroadcast();
    }
}
