// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Example} from "../test/mocks/Example.sol";
import {BaseScript} from "./Base.s.sol";

contract ExecuteExampleTx is BaseScript {
    function run() public broadcast {
        ProtocolAdapter pa = ProtocolAdapter(0xFffb262057d35cd5fE71Bbed9cCb1f7B1dABF2FC);
        pa.execute(Example.transaction());
    }
}
