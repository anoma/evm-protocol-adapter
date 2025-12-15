// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IVersion
/// @author Anoma Foundation, 2025
/// @notice The interface for versioned contracts.
/// @custom:security-contact security@anoma.foundation
interface IVersion {
    /// @notice Returns the semantic version number of the contract.
    /// @return version The semantic version number.
    function getVersion() external view returns (bytes32 version);
}
