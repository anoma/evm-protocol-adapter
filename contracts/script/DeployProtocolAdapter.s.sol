// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Script} from "forge-std/Script.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

contract DeployProtocolAdapter is Script {
    mapping(uint256 chainId => string network) networks;
    mapping(string network => RiscZeroVerifierRouter router) routers;

    constructor() {
        networks[11155111] = "sepolia";
        networks[421614] = "arbitrum-sepolia";
        networks[84532] = "base-sepolia";

        routers["sepolia"] = RiscZeroVerifierRouter(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187);
        routers["arbitrum-sepolia"] = RiscZeroVerifierRouter(0x0b144E07A0826182B6b59788c34b32Bfa86Fb711);
        routers["base-sepolia"] = RiscZeroVerifierRouter(0x0b144E07A0826182B6b59788c34b32Bfa86Fb711);
    }

    function run() public returns (address protocolAdapter) {
        vm.startBroadcast();
        protocolAdapter = address(
            new ProtocolAdapter{salt: sha256("ProtocolAdapterDraft")}({
                riscZeroVerifierRouter: routers[networks[block.chainid]],
                commitmentTreeDepth: 32,
                actionTagTreeDepth: 4
            })
        );
        vm.stopBroadcast();
    }
}
