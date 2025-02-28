// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Ownable } from "@openzeppelin-contracts/access/Ownable.sol";

import { IWrapper } from "./interfaces/IWrapper.sol";

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
    bytes32 internal immutable _WRAPPED_RESOURCE_KIND;

    uint256 private _nonce;

    constructor(address protocolAdapter, bytes32 wrapperLogicRef, bytes32 wrappedKind) Ownable(protocolAdapter) {
        _WRAPPER_RESOURCE_LOGIC_REF = wrapperLogicRef;
        _WRAPPER_RESOURCE_LABEL_REF = sha256(abi.encode(address(this), wrappedKind));
        _WRAPPER_RESOURCE_KIND = sha256(abi.encode(_WRAPPER_RESOURCE_LOGIC_REF, _WRAPPER_RESOURCE_LABEL_REF));

        _WRAPPED_RESOURCE_KIND = wrappedKind;
    }

    function evmCall(bytes calldata input) external onlyOwner returns (bytes memory output) {
        output = _evmCall(input);
    }

    // TODO can be used to grief transactions
    function newNonce() external returns (uint256 nonce) {
        nonce = _newNonce();
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
    function wrappedResourceKind() external view returns (bytes32 wrappedKind) {
        wrappedKind = _WRAPPED_RESOURCE_KIND;
    }

    function _evmCall(bytes calldata input) internal virtual returns (bytes memory output);

    function _newNonce() internal returns (uint256 nonce) {
        nonce = ++_nonce;
    }
}
