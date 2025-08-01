// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IForwarder} from "../interfaces/IForwarder.sol";
import {ComputableComponents} from "../libs/ComputableComponents.sol";

import {ProtocolAdapter} from "../ProtocolAdapter.sol";

/// @title ForwarderBase
/// @author Anoma Foundation, 2025
/// @notice The base contract to inherit from to create a forwarder contracts owning EVM state and executing EVM calls.
/// @custom:security-contact security@anoma.foundation
abstract contract ForwarderBase is IForwarder {
    /// @notice The protocol adapter contract that can forward calls.
    ProtocolAdapter internal immutable _PROTOCOL_ADAPTER;

    /// @notice The emergency committee address allowed to set an emergency caller in case the RISC Zero has caused
    /// the protocol adapter to stop.
    address internal immutable _EMERGENCY_COMMITTEE;

    /// @notice The the calldata carrier resource kind.
    bytes32 internal immutable _CALLDATA_CARRIER_RESOURCE_KIND;

    /// @notice The emergency caller that the emergency committee can set once.
    address internal _emergencyCaller;

    error ZeroNotAllowed();
    error EmergencyCallerNotSet();
    error EmergencyCallerAlreadySet(address emergencyCaller);
    error ProtocolAdapterNotStopped();
    error UnauthorizedCaller(address expected, address actual);

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param emergencyCommittee The emergency committee address that is allowed to set the emergency caller if the
    /// RISC Zero verifier has been stopped.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    constructor(address protocolAdapter, address emergencyCommittee, bytes32 calldataCarrierLogicRef) {
        if (protocolAdapter == address(0) || emergencyCommittee == address(0) || calldataCarrierLogicRef == bytes32(0))
        {
            revert ZeroNotAllowed();
        }

        _PROTOCOL_ADAPTER = ProtocolAdapter(protocolAdapter);
        _EMERGENCY_COMMITTEE = emergencyCommittee;

        _CALLDATA_CARRIER_RESOURCE_KIND =
            ComputableComponents.kind({logicRef: calldataCarrierLogicRef, labelRef: sha256(abi.encode(address(this)))});
    }

    /// @inheritdoc IForwarder
    function forwardCall(bytes calldata input) external returns (bytes memory output) {
        _checkCaller(address(_PROTOCOL_ADAPTER));

        output = _forwardCall(input);
    }

    /// @inheritdoc IForwarder
    function forwardEmergencyCall(bytes calldata input) external returns (bytes memory output) {
        if (_emergencyCaller == address(0)) {
            revert EmergencyCallerNotSet();
        }

        _checkCaller(_emergencyCaller);

        _checkEmergencyStopped();

        output = _forwardEmergencyCall(input);
    }

    /// @inheritdoc IForwarder
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

    /// @inheritdoc IForwarder
    function calldataCarrierResourceKind() external view returns (bytes32 kind) {
        kind = _CALLDATA_CARRIER_RESOURCE_KIND;
    }

    /// @inheritdoc IForwarder
    function emergencyCaller() external view returns (address caller) {
        caller = _emergencyCaller;
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal virtual returns (bytes memory output);

    /// @notice Forwards emergency calls.
    /// @param input The `bytes`  encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardEmergencyCall(bytes calldata input) internal virtual returns (bytes memory output);

    /// @notice Checks that an expected caller is calling the function and reverts otherwise.
    /// @param expected The expected caller.
    function _checkCaller(address expected) internal view {
        if (msg.sender != expected) {
            revert UnauthorizedCaller({expected: expected, actual: msg.sender});
        }
    }

    /// @notice Checks that the protocol adapter has been emergency stopped.
    function _checkEmergencyStopped() internal view {
        if (!_PROTOCOL_ADAPTER.isEmergencyStopped()) {
            revert ProtocolAdapterNotStopped();
        }
    }
}
