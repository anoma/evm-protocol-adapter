// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Ownable } from "@openzeppelin-contracts/access/Ownable.sol";

import { IForwarder } from "./interfaces/IForwarder.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";

/// A contract owning EVM state and executing EVM calls.
abstract contract ForwarderBase is IForwarder, Ownable {
    /// @notice The the calldata carrier resource kind.
    bytes32 internal immutable _CALLDATA_CARRIER_RESOURCE_KIND;

    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef) Ownable(protocolAdapter) {
        _CALLDATA_CARRIER_RESOURCE_KIND = ComputableComponents.kind({
            logicRef: calldataCarrierLogicRef,
            labelRef: sha256(abi.encode(address(this)))
        });
    }

    /// @inheritdoc IForwarder
    function forwardCall(bytes calldata input) external onlyOwner returns (bytes memory output) {
        output = _forwardCall(input);
    }

    /// @inheritdoc IForwarder
    function calldataCarrierResourceKind() external view returns (bytes32 calldataCarrierKind) {
        calldataCarrierKind = _CALLDATA_CARRIER_RESOURCE_KIND;
    }

    function _forwardCall(bytes calldata input) internal virtual returns (bytes memory output);
}
