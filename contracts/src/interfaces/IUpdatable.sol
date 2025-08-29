// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title IUpdatable
/// @author Anoma Foundation, 2025
/// @notice The interface of the commitment accumulator contract.
/// @custom:security-contact security@anoma.foundation
interface IUpdatable {
    /// @notice Adds a label for the contract to support.
    /// @param labelRef Reference to be added.
    /// @return success true iff the update is succesful.
    function addLabel(bytes32 labelRef) external returns (bool success);

    /// @notice Adds a logic for the contract to support.
    /// @param logicRef Reference to be added.
    /// @return success true iff the update is succesful.
    function addLogic(bytes32 logicRef) external returns (bool success);
}
