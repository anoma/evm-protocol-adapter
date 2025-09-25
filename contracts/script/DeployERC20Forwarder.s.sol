// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {LibString} from "@solady/utils/LibString.sol";

import {Script} from "forge-std/Script.sol";

import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";
import {Versioning} from "../src/libs/Versioning.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

contract DeployERC20Forwarder is Script {
    using LibString for bytes32;

    ProtocolAdapter internal constant _PROTOCOL_ADAPTER = ProtocolAdapter(address(0));

    address internal constant _EMERGENCY_COMMITTEE = address(0);

    bytes32 internal constant _CALLDATA_CARRIER_LOGIC_REF = bytes32(0);

    function run(bool isTestDeployment) public {
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
            protocolAdapter: address(_PROTOCOL_ADAPTER),
            emergencyCommittee: _EMERGENCY_COMMITTEE,
            calldataCarrierLogicRef: _CALLDATA_CARRIER_LOGIC_REF
        });
        vm.stopBroadcast();
    }
}
