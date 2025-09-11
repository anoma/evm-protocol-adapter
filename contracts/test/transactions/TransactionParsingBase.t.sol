// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {Test} from "forge-std/Test.sol";

import {Transaction} from "../../src/Types.sol";

contract TransactionParsingBaseTest is Test {
    function _parseTransaction(string memory path) internal view returns (Transaction memory txn) {
        string memory fullPath = string.concat(vm.projectRoot(), path);
        bytes memory data = vm.readFileBinary(fullPath);

        txn = abi.decode(data, (Transaction));
    }
}
