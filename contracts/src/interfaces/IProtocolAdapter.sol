// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Transaction} from "../Types.sol";

/// @title IProtocolAdapter
/// @author Anoma Foundation, 2025
/// @notice The interface of the protocol adapter contract.
/// @custom:security-contact security@anoma.foundation
interface IProtocolAdapter {
    /// @notice Emitted when a transaction is executed.
    /// @param id The transaction ID.
    /// @param transaction The executed transaction.
    /// @param newRoot The new commitment tree root.
    event TransactionExecuted(uint256 indexed id, Transaction transaction, bytes32 newRoot);

    /// @notice Emitted when a forwarder call is executed.
    /// @param carrierTag The tag of the carrier resource.
    /// @param untrustedForwarder The forwarder contract forwarding the call.
    /// @param input The input data for the forwarded call.
    /// @param output The expected output data from the forwarded call.
    event ForwarderCallExecuted(bytes32 carrierTag, address indexed untrustedForwarder, bytes input, bytes output);

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
