// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Logic} from "../proving/Logic.sol";
import {Transaction} from "../Types.sol";

/// @title IProtocolAdapter
/// @author Anoma Foundation, 2025
/// @notice The interface of the protocol adapter contract.
/// @custom:security-contact security@anoma.foundation
interface IProtocolAdapter {
    /// @notice Emitted when a transaction is executed.
    /// @param id The transaction ID.
    /// @param transaction The executed transaction.
    event TransactionExecuted(uint256 indexed id, Transaction transaction);

    /// @notice Emitted if a blob is to be stored by an indexer.
    /// @param expirableBlob The blob to be stored.
    event Blob(Logic.ExpirableBlob indexed expirableBlob);

    /// @notice Executes a transaction by adding the commitments and nullifiers to the commitment tree and nullifier
    /// set, respectively.
    /// @param transaction The transaction to execute.
    function execute(Transaction calldata transaction) external;

    /// @notice Verifies a transaction by checking the delta, resource logic, and compliance proofs.
    /// @param transaction The transaction to verify.
    function verify(Transaction calldata transaction) external view;

    /// @notice Returns the RISC Zero verifier selector associated with the protocol adapter.
    /// @return verifierSelector The RISC Zero verifier selector.
    function getRiscZeroVerifierSelector() external view returns (bytes4 verifierSelector);

    /// @notice Returns whether the RISC Zero verifier associated with the protocol adapter has been stopped or not.
    /// @return isStopped Whether the RISC Zero verifier has been stopped.
    function isEmergencyStopped() external view returns (bool isStopped);
}
