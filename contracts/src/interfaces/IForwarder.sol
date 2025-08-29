// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IForwarder
/// @author Anoma Foundation, 2025
/// @notice The interface of the forwarder base contract.
/// @custom:security-contact security@anoma.foundation
interface IForwarder {
    /// @notice Forwards an external call to read or write EVM state.
    /// @param input Arbitrary bytes.
    /// @return output The `bytes` encoded output of the call.
    function forwardCall(bytes memory input) external returns (bytes memory output);

    /// @notice Function checking call authorization.
    /// @param logicRef The logic of the resource making the call.
    /// @param labelRef The label of the resource making the call.
    function authorizeCall(bytes32 logicRef, bytes32 labelRef) external view;
}
