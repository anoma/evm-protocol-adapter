// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";
import {ProtocolAdapter, PROTOCOL_ADAPTER_VERSION} from "../src/ProtocolAdapter.sol";

contract DeployERC20Forwarder is Script {
    ProtocolAdapter internal constant _PROTOCOL_ADAPTER = ProtocolAdapter(address(0));

    address internal constant _EMERGENCY_COMMITTEE = address(0);

    bytes32 internal constant _CALLDATA_CARRIER_LOGIC_REF = bytes32(0);

    function run(bool isTestDeployment) public {
        bytes32 salt;
        if (isTestDeployment) {
            salt = bytes32(block.prevrandao);
        } else {
            salt = keccak256(bytes(string.concat("ERC20Forwarder", " ", PROTOCOL_ADAPTER_VERSION)));
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
