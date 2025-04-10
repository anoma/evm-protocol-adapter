// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Ownable } from "@openzeppelin-contracts/access/Ownable.sol";

import { IForwarder } from "./interfaces/IForwarder.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";

/// A contract owning EVM state and executing EVM calls.
abstract contract ForwarderBase is IForwarder, Ownable {
    /// @notice The binding reference to the logic of the calldata carrier resource.
    bytes32 internal immutable _CALLDATA_CARRIER_RESOURCE_LOGIC_REF;

    /// @notice The binding reference to the label of the calldata carrier resource.
    /// @dev Determined by the protocol adapter on deployment.
    bytes32 internal immutable _CALLDATA_CARRIER_RESOURCE_LABEL_REF;

    /// @notice The the calldata carrier resource kind.
    bytes32 internal immutable _CALLDATA_CARRIER_RESOURCE_KIND;

    /// @notice The EVM state wrapping resource kind.
    bytes32 internal immutable _STATE_WRAPPER_RESOURCE_KIND;

    constructor(
        address protocolAdapter,
        bytes32 calldataCarrierLogicRef,
        bytes32 stateWrapperKind
    )
        Ownable(protocolAdapter)
    {
        _CALLDATA_CARRIER_RESOURCE_LOGIC_REF = calldataCarrierLogicRef;
        _CALLDATA_CARRIER_RESOURCE_LABEL_REF = sha256(abi.encode(address(this)));
        _CALLDATA_CARRIER_RESOURCE_KIND = ComputableComponents.kind({
            logicRef: _CALLDATA_CARRIER_RESOURCE_LOGIC_REF,
            labelRef: _CALLDATA_CARRIER_RESOURCE_LABEL_REF
        });

        _STATE_WRAPPER_RESOURCE_KIND = stateWrapperKind;
    }

    function forwardCall(bytes calldata input) external onlyOwner returns (bytes memory output) {
        output = _forwardCall(input);
    }

    /// @inheritdoc IForwarder
    function calldataCarrierResourceLogicRef() external view returns (bytes32 calldataCarrierLogicRef) {
        calldataCarrierLogicRef = _CALLDATA_CARRIER_RESOURCE_LOGIC_REF;
    }

    /// @inheritdoc IForwarder
    function calldataCarrierResourceLabelRef() external view returns (bytes32 calldataCarrierLabelRef) {
        calldataCarrierLabelRef = _CALLDATA_CARRIER_RESOURCE_LABEL_REF;
    }

    /// @inheritdoc IForwarder
    function calldataCarrierResourceKind() external view returns (bytes32 calldataCarrierKind) {
        calldataCarrierKind = _CALLDATA_CARRIER_RESOURCE_KIND;
    }

    /// @inheritdoc IForwarder
    function stateWrapperResourceKind() external view returns (bytes32 stateWrapperKind) {
        stateWrapperKind = _STATE_WRAPPER_RESOURCE_KIND;
    }

    function _forwardCall(bytes calldata input) internal virtual returns (bytes memory output);
}
