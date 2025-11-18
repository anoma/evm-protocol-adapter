// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Vm} from "forge-std/Vm.sol";

import {Transaction} from "../../src/Types.sol";

library Parsing {
    function parseTransaction(Vm vm, string memory path) internal view returns (Transaction memory txn) {
        string memory fullPath = string.concat(vm.projectRoot(), "/", path);
        bytes memory data = vm.readFileBinary(fullPath);

        txn = abi.decode(data, (Transaction));
    }
}
