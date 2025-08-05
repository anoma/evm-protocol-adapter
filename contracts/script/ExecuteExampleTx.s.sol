// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {TransactionExample} from "../test/examples/Transaction.e.sol";

contract ExecuteExampleTx is Script {
    function run() public {
        vm.startBroadcast();
        ProtocolAdapter(0xC5033726a1fb969743A6f5Baf1753D56c6e1692b).execute(TransactionExample.transaction());
        vm.stopBroadcast();
    }
}
