// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IForwarder} from "../interfaces/IForwarder.sol";
import {ComputableComponents} from "../libs/ComputableComponents.sol";

/// @title ForwarderBase
/// @author Anoma Foundation, 2025
/// @notice The base contract to inherit from to create a forwarder contracts owning EVM state and executing EVM calls.
/// @custom:security-contact security@anoma.foundation
abstract contract ForwarderBase is IForwarder {
    address internal immutable _PROTOCOL_ADAPTER;

    /// @notice The the calldata carrier resource kind.
    bytes32 internal immutable _CALLDATA_CARRIER_RESOURCE_KIND;

    error UnauthorizedCaller(address caller);

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef) {
        _CALLDATA_CARRIER_RESOURCE_KIND =
            ComputableComponents.kind({logicRef: calldataCarrierLogicRef, labelRef: sha256(abi.encode(address(this)))});

        _PROTOCOL_ADAPTER = protocolAdapter;
    }

    /// @inheritdoc IForwarder
    function forwardCall(bytes calldata input) external returns (bytes memory output) {
        if (msg.sender != _PROTOCOL_ADAPTER) {
            revert UnauthorizedCaller(msg.sender);
        }
        output = _forwardCall(input);
    }

    /// @inheritdoc IForwarder
    function calldataCarrierResourceKind() external view returns (bytes32 kind) {
        kind = _CALLDATA_CARRIER_RESOURCE_KIND;
    }

    /// @notice Forwards  calls to a target contract.
    /// @param input The `bytes` encoded calldata (including the `bytes4` function selector).
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal virtual returns (bytes memory output);
}
