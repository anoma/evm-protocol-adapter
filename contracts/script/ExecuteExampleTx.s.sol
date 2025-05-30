// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Example} from "../test/mocks/Example.sol";
import {BaseScript} from "./Base.s.sol";

contract ExecuteExampleTx is BaseScript {
    function run() public broadcast {
        ProtocolAdapter pa = ProtocolAdapter(0xC5033726a1fb969743A6f5Baf1753D56c6e1692b);
        pa.execute(Example.transaction());
    }
}
