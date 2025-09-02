pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Emitter} from "../src/emitter.sol";

contract EmitterDeployAndEmit is Script {
    function run() public returns (address emitterAddress) {
        vm.startBroadcast();

        Emitter emitter = new Emitter();

        emitterAddress = address(emitter);

        emitter.seedTransactionExecutedEvent("tag1", "cipher1");
        emitter.seedTransactionExecutedEvent("tag2", "cipher2");
        emitter.seedTransactionExecutedEvent("tag3", "cipher3");
        emitter.seedTransactionExecutedEvent("tag4", "cipher4");

        vm.stopBroadcast();
    }
}
