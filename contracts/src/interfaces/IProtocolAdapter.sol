// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Transaction} from "../Types.sol";

interface IProtocolAdapter {
    event TransactionExecuted(uint256 indexed id, Transaction transaction);

    /// @notice Executes a transaction by adding the commitments and nullifiers to the commitment tree and nullifier
    /// set, respectively.
    /// @param transaction The transaction to execute.
    function execute(Transaction calldata transaction) external;

    /// @notice Verifies a transaction by checking the delta, resource logic, and compliance proofs.
    /// @param transaction The transaction to verify.
    function verify(Transaction calldata transaction) external view;
}
