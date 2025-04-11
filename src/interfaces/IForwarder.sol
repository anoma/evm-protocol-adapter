// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface IForwarder {
    // TODO add events

    /// @notice Forwards an external call to read or write EVM state.
    /// @param input The `bytes` encoded calldata (including the `bytes4` function selector).
    /// @return output The `bytes` encoded output of the call.
    function forwardCall(bytes memory input) external returns (bytes memory output);

    /// @notice Returns the kind of the calldata carrier resource.
    /// @return calldataCarrierKind The calldata carrier kind.
    function calldataCarrierResourceKind() external view returns (bytes32 calldataCarrierKind);
}
