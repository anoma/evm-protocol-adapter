// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IForwarder} from "../interfaces/IForwarder.sol";

/// @title ForwarderBase
/// @author Anoma Foundation, 2025
/// @notice The base contract to inherit from to create a forwarder contracts owning EVM state and executing EVM calls.
/// @custom:security-contact security@anoma.foundation
abstract contract ForwarderBase is IForwarder {
    /// @notice The protocol adapter contract that can forward calls.
    address internal immutable _PROTOCOL_ADAPTER;

    /// @notice The the calldata carrier resource logic reference.
    bytes32 internal immutable _CALLDATA_CARRIER_LOGIC_REF;

    error ZeroNotAllowed();
    error UnauthorizedCaller(address expected, address actual);
    error UnauthorizedLogicRef(bytes32 expected, bytes32 actual);

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef) {
        if (protocolAdapter == address(0) || calldataCarrierLogicRef == bytes32(0)) {
            revert ZeroNotAllowed();
        }

        _PROTOCOL_ADAPTER = protocolAdapter;

        _CALLDATA_CARRIER_LOGIC_REF = calldataCarrierLogicRef;
    }

    /// @inheritdoc IForwarder
    function forwardCall(bytes32 logicRef, bytes calldata input) external returns (bytes memory output) {
        _checkCaller(_PROTOCOL_ADAPTER);

        if (_CALLDATA_CARRIER_LOGIC_REF != logicRef) {
            revert UnauthorizedLogicRef({expected: _CALLDATA_CARRIER_LOGIC_REF, actual: logicRef});
        }

        output = _forwardCall(input);
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal virtual returns (bytes memory output);

    /// @notice Checks that an expected caller is calling the function and reverts otherwise.
    /// @param expected The expected caller.
    function _checkCaller(address expected) internal view {
        if (msg.sender != expected) {
            revert UnauthorizedCaller({expected: expected, actual: msg.sender});
        }
    }
}
