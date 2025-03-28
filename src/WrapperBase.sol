// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Ownable } from "@openzeppelin-contracts/access/Ownable.sol";

import { IWrapper } from "./interfaces/IWrapper.sol";
import { ComputableComponents } from "./libs/ComputableComponents.sol";

/// A contract owning EVM state and executing EVM calls.
abstract contract WrapperBase is IWrapper, Ownable {
    /// @notice The binding reference to the logic of the wrapper contract resource.
    bytes32 internal immutable _WRAPPER_RESOURCE_LOGIC_REF;

    /// @notice The binding reference to the label of the wrapper contract resource.
    /// @dev Determined by the protocol adapter on deployment.
    bytes32 internal immutable _WRAPPER_RESOURCE_LABEL_REF;

    /// @notice The the wrapper resource kind.
    bytes32 internal immutable _WRAPPER_RESOURCE_KIND;

    /// @notice The EVM state wrapping resource kind.
    bytes32 internal immutable _WRAPPING_RESOURCE_KIND;

    constructor(address protocolAdapter, bytes32 wrapperLogicRef, bytes32 wrappingKind) Ownable(protocolAdapter) {
        _WRAPPER_RESOURCE_LOGIC_REF = wrapperLogicRef;
        _WRAPPER_RESOURCE_LABEL_REF = sha256(abi.encode(address(this)));
        _WRAPPER_RESOURCE_KIND =
            ComputableComponents.kind({ logicRef: _WRAPPER_RESOURCE_LOGIC_REF, labelRef: _WRAPPER_RESOURCE_LABEL_REF });

        _WRAPPING_RESOURCE_KIND = wrappingKind;
    }

    function ffiCall(bytes calldata input) external onlyOwner returns (bytes memory output) {
        output = _ffiCall(input);
    }

    /// @inheritdoc IWrapper
    function wrapperResourceLogicRef() external view returns (bytes32 wrapperLogicRef) {
        wrapperLogicRef = _WRAPPER_RESOURCE_LOGIC_REF;
    }

    /// @inheritdoc IWrapper
    function wrapperResourceLabelRef() external view returns (bytes32 wrapperLabelRef) {
        wrapperLabelRef = _WRAPPER_RESOURCE_LABEL_REF;
    }

    /// @inheritdoc IWrapper
    function wrapperResourceKind() external view returns (bytes32 wrapperKind) {
        wrapperKind = _WRAPPER_RESOURCE_KIND;
    }

    /// @inheritdoc IWrapper
    function wrappingResourceKind() external view returns (bytes32 wrappingKind) {
        wrappingKind = _WRAPPING_RESOURCE_KIND;
    }

    function _ffiCall(bytes calldata input) internal virtual returns (bytes memory output);
}
