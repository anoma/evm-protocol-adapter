// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Script} from "forge-std/Script.sol";

import {ProtocolAdapter, PROTOCOL_ADAPTER_VERSION} from "../src/ProtocolAdapter.sol";

contract DeployProtocolAdapter is Script {
    mapping(uint256 chainId => string network) internal _networks;
    mapping(string network => RiscZeroVerifierRouter router) internal _routers;

    constructor() {
        _networks[11155111] = "sepolia";
        _networks[421614] = "arbitrum-sepolia";
        _networks[84532] = "base-sepolia";

        _routers["sepolia"] = RiscZeroVerifierRouter(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187);
        _routers["arbitrum-sepolia"] = RiscZeroVerifierRouter(0x0b144E07A0826182B6b59788c34b32Bfa86Fb711);
        _routers["base-sepolia"] = RiscZeroVerifierRouter(0x0b144E07A0826182B6b59788c34b32Bfa86Fb711);
    }

    function run(bool isTestDeployment) public returns (address protocolAdapter) {
        vm.startBroadcast();

        bytes32 salt;
        if (isTestDeployment) {
            salt = bytes32(block.prevrandao);
        } else {
            salt = keccak256(bytes(string.concat("ProtocolAdapter", " ", PROTOCOL_ADAPTER_VERSION)));
        }

        protocolAdapter =
            address(new ProtocolAdapter{salt: salt}({riscZeroVerifierRouter: _routers[_networks[block.chainid]]}));
        vm.stopBroadcast();
    }
}
