// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IEmergencyMigratable} from "../interfaces/IEmergencyMigratable.sol";

import {ProtocolAdapter} from "../ProtocolAdapter.sol";
import {ForwarderBase} from "./ForwarderBase.sol";

/// @title EmergencyMigratableForwarderBase
/// @author Anoma Foundation, 2025
/// @notice A forwarder contract forwarding calls and holding funds to wrap and unwrap ERC-20 tokens as resources that
/// supports emergency migration to a future protocol adapter version.
/// @custom:security-contact security@anoma.foundation
abstract contract EmergencyMigratableForwarderBase is IEmergencyMigratable, ForwarderBase {
    /// @notice The emergency committee address allowed to set an emergency caller in case the RISC Zero has caused
    /// the protocol adapter to stop.
    address internal immutable _EMERGENCY_COMMITTEE;

    /// @notice The emergency caller that the emergency committee can set once.
    address internal _emergencyCaller;

    error EmergencyCallerNotSet();
    error EmergencyCallerAlreadySet(address emergencyCaller);
    error ProtocolAdapterNotStopped();

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    /// @param emergencyCommittee The emergency committee address that is allowed to set the emergency caller if the
    /// RISC Zero verifier has been stopped.
    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef, address emergencyCommittee)
        ForwarderBase(protocolAdapter, calldataCarrierLogicRef)
    {
        if (emergencyCommittee == address(0)) {
            revert ZeroNotAllowed();
        }

        _EMERGENCY_COMMITTEE = emergencyCommittee;
    }

    /// @inheritdoc IEmergencyMigratable
    function forwardEmergencyCall(bytes32 logicRef, bytes calldata input) external returns (bytes memory output) {
        if (_emergencyCaller == address(0)) {
            revert EmergencyCallerNotSet();
        }

        _checkCaller(_emergencyCaller);

        _checkEmergencyStopped();

        _checkLogicRef(logicRef);

        output = _forwardEmergencyCall(input);
    }

    /// @inheritdoc IEmergencyMigratable
    function setEmergencyCaller(address newEmergencyCaller) external {
        _checkCaller(_EMERGENCY_COMMITTEE);

        if (newEmergencyCaller == address(0)) {
            revert ZeroNotAllowed();
        }

        if (_emergencyCaller != address(0)) {
            revert EmergencyCallerAlreadySet(_emergencyCaller);
        }

        _checkEmergencyStopped();

        _emergencyCaller = newEmergencyCaller;
    }

    /// @inheritdoc IEmergencyMigratable
    function emergencyCaller() external view returns (address caller) {
        caller = _emergencyCaller;
    }

    /// @notice Forwards emergency calls.
    /// @param input The `bytes`  encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardEmergencyCall(bytes calldata input) internal virtual returns (bytes memory output);

    /// @notice Checks that the protocol adapter has been emergency stopped.
    function _checkEmergencyStopped() internal view {
        if (!ProtocolAdapter(_PROTOCOL_ADAPTER).isEmergencyStopped()) {
            revert ProtocolAdapterNotStopped();
        }
    }
}
