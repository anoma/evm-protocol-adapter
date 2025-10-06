// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IForwarder
/// @author Anoma Foundation, 2025
/// @notice The interface for forwarder contracts that can be called from the protocol adapter and allow the resource
/// machine to interoperate with external EVM state.
/// @custom:security-contact security@anoma.foundation
interface IForwarder {
    /// @notice Forwards an external call to read or write EVM state. This function can only be called by the
    /// protocol adapter contract.
    /// @param  logicRef The resource logic hash.
    /// @param input The `bytes` encoded calldata (including the `bytes4` function selector).
    /// @return output The `bytes` encoded output of the call.
    function forwardCall(bytes32 logicRef, bytes memory input) external returns (bytes memory output);
}
