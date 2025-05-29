// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IForwarder} from "./interfaces/IForwarder.sol";
import {ComputableComponents} from "./libs/ComputableComponents.sol";

/// A contract owning EVM state and executing EVM calls.
abstract contract ForwarderBase is IForwarder {
    address internal immutable _PROTOCOL_ADAPTER;

    /// @notice The the calldata carrier resource kind.
    bytes32 internal immutable _CALLDATA_CARRIER_RESOURCE_KIND;

    error UnauthorizedCaller(address caller);

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

    function _forwardCall(bytes calldata input) internal virtual returns (bytes memory output);
}
