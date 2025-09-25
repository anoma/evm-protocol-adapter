// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IEmergencyMigratable
/// @author Anoma Foundation, 2025
/// @notice The interface of the forwarder base contract.
interface IEmergencyMigratable {
    /// @notice Forwards an external call to read or write EVM state. This function can only be called by the address
    /// set by emergency committee if the RISC Zero emergency stop is active.
    /// @param input The `bytes` encoded calldata (including the `bytes4` function selector).
    /// @return output The `bytes` encoded output of the call.
    function forwardEmergencyCall(bytes memory input) external returns (bytes memory output);

    /// @notice Sets the emergency caller. This function can only be called by the address
    /// set by emergency committee if the RISC Zero emergency stop is active.
    /// @param newEmergencyCaller The emergency caller to set.
    function setEmergencyCaller(address newEmergencyCaller) external;

    /// @notice Returns the emergency caller.
    /// @return caller The emergency caller.
    function emergencyCaller() external view returns (address caller);
}
