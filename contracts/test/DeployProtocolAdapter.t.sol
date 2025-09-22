// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {DeployProtocolAdapter} from "../script/DeployProtocolAdapter.s.sol";

contract DeployProtocolAdapterTest is Test {
    function test_DeployProtocolAdapter_deploys_on_sepolia() public {
        vm.selectFork(vm.createFork("sepolia"));
        new DeployProtocolAdapter().run({isTestDeployment: true, owner: msg.sender});
    }

    function test_DeployProtocolAdapter_deploys_on_arbitrum_sepolia() public {
        vm.selectFork(vm.createFork("arbitrum-sepolia"));
        new DeployProtocolAdapter().run({isTestDeployment: true, owner: msg.sender});
    }

    function test_DeployProtocolAdapter_deploys_on_base_sepolia() public {
        vm.selectFork(vm.createFork("base-sepolia"));
        new DeployProtocolAdapter().run({isTestDeployment: true, owner: msg.sender});
    }
}
