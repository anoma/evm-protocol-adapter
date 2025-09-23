// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Transaction} from "../Types.sol";

/// @title IProtocolAdapter
/// @author Anoma Foundation, 2025
/// @notice The interface of the protocol adapter contract.
/// @custom:security-contact security@anoma.foundation
interface IProtocolAdapter {
    /// @notice Emitted when a transaction is executed.
    /// @param tags The tags of resources being consumed and created in this transaction in alternating order.
    /// @param logicRefs The logic references of resources being consumed and created in this transaction.
    event TransactionExecuted(bytes32[] tags, bytes32[] logicRefs);

    /// @notice Emitted when an action is executed.
    /// @param actionTreeRoot The action tree root.
    /// @param actionTagCount The number of tags in the action.
    event ActionExecuted(bytes32 actionTreeRoot, uint256 actionTagCount);

    /// @notice Emitted when a forwarder call is executed.
    /// @param untrustedForwarder The forwarder contract forwarding the call.
    /// @param input The input data for the forwarded call.
    /// @param output The expected output data from the forwarded call.
    event ForwarderCallExecuted(address indexed untrustedForwarder, bytes input, bytes output);

    /// @notice Emitted to store a resource payload blob persistently.
    /// @param tag The tag of the resource this blob belongs to.
    /// @param index The index of the blob in the payload array.
    /// @param blob The blob.
    event ResourcePayload(bytes32 indexed tag, uint256 index, bytes blob);

    /// @notice Emitted to store a discovery payload blob persistently.
    /// @param tag The tag of the resource this blob belongs to.
    /// @param index The index of the blob in the payload array.
    /// @param blob The blob.
    event DiscoveryPayload(bytes32 indexed tag, uint256 index, bytes blob);

    /// @notice Emitted to store a external payload blob persistently.
    /// @param tag The tag of the resource this blob belongs to.
    /// @param index The index of the blob in the payload array.
    /// @param blob The blob.
    event ExternalPayload(bytes32 indexed tag, uint256 index, bytes blob);

    /// @notice Emitted to store an application payload blob persistently.
    /// @param tag The tag of the resource this blob belongs to.
    /// @param index The index of the blob in the payload array.
    /// @param blob The blob.
    event ApplicationPayload(bytes32 indexed tag, uint256 index, bytes blob);

    /// @notice Executes a transaction by adding the commitments and nullifiers to the commitment tree and nullifier
    /// set, respectively.
    /// @param transaction The transaction to execute.
    function execute(Transaction calldata transaction) external;

    /// @notice Stops the protocol adapter permanently in case of an emergency.
    function emergencyStop() external;

    /// @notice Returns the semantic version number of the protocol adapter.
    /// @return version The semantic version number.
    function getProtocolAdapterVersion() external view returns (string memory version);

    /// @notice Returns the RISC Zero verifier selector associated with the protocol adapter.
    /// @return verifierSelector The RISC Zero verifier selector.
    function getRiscZeroVerifierSelector() external view returns (bytes4 verifierSelector);

    /// @notice Returns whether the RISC Zero verifier associated with the protocol adapter has been stopped or not.
    /// @return isStopped Whether the RISC Zero verifier has been stopped.
    function isEmergencyStopped() external view returns (bool isStopped);
}
