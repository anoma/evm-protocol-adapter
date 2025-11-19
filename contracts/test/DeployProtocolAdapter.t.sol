// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {DeployProtocolAdapter} from "../script/DeployProtocolAdapter.s.sol";

contract DeployProtocolAdapterTest is Test {
    struct TestCase {
        string name;
    }

    function tableNetworksTest_DeployProtocolAdapter_test_deployment_succeeds_on_all_supported_networks(TestCase memory network)
        public
    {
        vm.selectFork(vm.createFork(network.name));

        new DeployProtocolAdapter().run({isTestDeployment: true, emergencyStopCaller: msg.sender});
    }

    function tableNetworksTest_DeployProtocolAdapter_prod_deployment_succeeds_on_all_supported_networks(TestCase memory network)
        public
    {
        vm.selectFork(vm.createFork(network.name));

        new DeployProtocolAdapter().run({isTestDeployment: false, emergencyStopCaller: msg.sender});
    }

    function fixtureNetwork() public pure returns (TestCase[] memory network) {
        network = new TestCase[](8);
        network[0] = TestCase({name: "sepolia"});
        network[1] = TestCase({name: "mainnet"});

        network[2] = TestCase({name: "arbitrum-sepolia"});
        network[3] = TestCase({name: "arbitrum"});

        network[4] = TestCase({name: "base-sepolia"});
        network[5] = TestCase({name: "base"});

        network[6] = TestCase({name: "optimism-sepolia"});
        network[7] = TestCase({name: "optimism"});

        return network;
    }
}
