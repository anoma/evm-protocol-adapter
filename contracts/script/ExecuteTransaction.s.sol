// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std-1.14.0/src/Script.sol";
import {Vm} from "forge-std-1.14.0/src/Vm.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Transaction} from "../src/Types.sol";

import {Parsing} from "../test/libs/Parsing.sol";

/// @title ExecuteTransaction
/// @author Anoma Foundation, 2025
/// @notice A script to execute a transaction binary file on a given protocol adapter contract.
/// @custom:security-contact security@anoma.foundation
contract ExecuteTransaction is Script {
    using Parsing for Vm;

    /// @notice Executes a transaction binary file on a given protocol adapter contract.
    /// @param protocolAdapter The protocol adapter address.
    /// @param filepath The transaction binary file path relative to the `contracts` folder
    /// (e.g., `"tx.bin"` or `"test/examples/transactions/test_tx_agg_01_01.bin"`).
    /// @dev Run with
    /// ```sh
    /// forge script script/ExecuteTransaction.s.sol:ExecuteTransaction \
    /// --sig "run(address,string)" <PA_ADDRESS> <FILE_PATH> --broadcast --rpc-url <CHAIN> --account <ACCOUNT_NAME>
    /// ```
    function run(address protocolAdapter, string memory filepath) public {
        Transaction memory parsedTransaction = vm.parseTransaction(filepath);

        vm.startBroadcast();

        ProtocolAdapter(protocolAdapter).execute(parsedTransaction);

        vm.stopBroadcast();
    }
}
