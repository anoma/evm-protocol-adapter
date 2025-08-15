pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Emitter} from "../src/emitter.sol";

contract EmitterDeployAndEmit is Script {
    function run() public returns (address emitterAddress) {
        vm.startBroadcast();

        Emitter emitter = new Emitter();

        emitterAddress = address(emitter);

        emitter.emitEvents("cipher1", "resource1", "tag1");
        emitter.emitEvents("cipher2", "resource2", "tag2");
        emitter.emitEvents("cipher3", "resource3", "tag3");
        emitter.emitEvents("cipher4", "resource4", "tag4");

        vm.stopBroadcast();
    }
}