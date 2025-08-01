// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Script} from "forge-std/Script.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

contract Deploy is Script {
    function run() public returns (address protocolAdapter) {
        string memory path = "script/constructor-args.txt";

        RiscZeroVerifierRouter trustedSepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));

        uint8 commitmentTreeDepth = uint8(vm.parseUint(vm.readLine(path)));

        uint8 actionTagTreeDepth = uint8(vm.parseUint(vm.readLine(path)));

        vm.startBroadcast();
        protocolAdapter = address(
            new ProtocolAdapter{salt: sha256("ProtocolAdapterDraft")}({
                riscZeroVerifierRouter: trustedSepoliaVerifierRouter,
                commitmentTreeDepth: commitmentTreeDepth,
                actionTagTreeDepth: actionTagTreeDepth
            })
        );
        vm.stopBroadcast();
    }
}
