// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {LibString} from "@solady/utils/LibString.sol";

import {Script} from "forge-std/Script.sol";

import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";
import {Versioning} from "../src/libs/Versioning.sol";

contract DeployERC20Forwarder is Script {
    using LibString for bytes32;

    function run(
        bool isTestDeployment,
        address protocolAdapter,
        address emergencyCommittee,
        bytes32 calldataCarrierLogicRef
    ) public {
        bytes32 salt;
        if (isTestDeployment) {
            salt = bytes32(block.prevrandao);
        } else {
            salt = keccak256(
                bytes(string.concat("ERC20Forwarder", Versioning._PROTOCOL_ADAPTER_VERSION.fromSmallString()))
            );
        }

        vm.startBroadcast();
        new ERC20Forwarder{salt: salt}({
            protocolAdapter: protocolAdapter,
            emergencyCommittee: emergencyCommittee,
            calldataCarrierLogicRef: calldataCarrierLogicRef
        });
        vm.stopBroadcast();
    }
}
