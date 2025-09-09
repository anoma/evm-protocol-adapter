// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

contract DeployERC20Forwarder is Script {
    ProtocolAdapter internal constant _PROTOCOL_ADAPTER = ProtocolAdapter(address(0));

    address internal constant _EMERGENCY_COMMITTEE = address(0);

    bytes32 internal constant _CALLDATA_CARRIER_LOGIC_REF = bytes32(0);

    function run() public {
        vm.startBroadcast();
        new ERC20Forwarder{salt: sha256("ERC20ForwarderExample")}({
            protocolAdapter: address(_PROTOCOL_ADAPTER),
            emergencyCommittee: _EMERGENCY_COMMITTEE,
            calldataCarrierLogicRef: _CALLDATA_CARRIER_LOGIC_REF
        });
        vm.stopBroadcast();
    }
}
// forge script script/DeployERC20Forwarder.s.sol:DeployERC20Forwarder --rpc-url sepolia --broadcast --verify --slow --account dev-wallet --resume
