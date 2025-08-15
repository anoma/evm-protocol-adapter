// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Script} from "forge-std/Script.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

contract DeployProtocolAdapter is Script {
    function run() public returns (address protocolAdapter) {
        string memory path = "script/constructor-args.txt";

        RiscZeroVerifierRouter trustedSepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));

        vm.startBroadcast();
        protocolAdapter =
            address(new ProtocolAdapter{salt: sha256("ProtocolAdapterDraft")}(trustedSepoliaVerifierRouter));
        vm.stopBroadcast();
    }
}
