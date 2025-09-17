// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";

contract DeployERC20Forwarder is Script {
    function run(address protocolAdapter, address emergencyCommittee, bytes32 carrierLogicRef) public {
        vm.startBroadcast();
        new ERC20Forwarder{salt: sha256("ERC20ForwarderExample")}({
            protocolAdapter: protocolAdapter,
            emergencyCommittee: emergencyCommittee,
            calldataCarrierLogicRef: carrierLogicRef
        });
        vm.stopBroadcast();
    }
}
