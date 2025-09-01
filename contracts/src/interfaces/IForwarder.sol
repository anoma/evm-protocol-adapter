// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IForwarder
/// @author Anoma Foundation, 2025
/// @notice The interface of the forwarder base contract.
/// @custom:security-contact security@anoma.foundation
interface IForwarder {
    /// @notice Forwards an external call to read or write EVM state. This function can only be called by the
    /// protocol adapter contract.
    /// @param actionTreeRoot The tag of the carrier resource.
    /// @param input The `bytes` encoded calldata.
    /// @return output The `bytes` encoded output of the call.
    function forwardCall(bytes32 actionTreeRoot, bytes memory input) external returns (bytes memory output);

    /// @notice Returns the kind of the calldata carrier resource.
    /// @return calldataCarrierKind The calldata carrier kind.
    function calldataCarrierResourceKind() external view returns (bytes32 calldataCarrierKind);
}
