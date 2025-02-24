// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { IWrapper } from "./interfaces/IWrapper.sol";

/// A contract owning EVM state and executing EVM calls.
abstract contract WrapperBase is IWrapper, Ownable {
    /// @notice The binding reference to the logic of the wrapper contract resource.
    bytes32 internal immutable WRAPPER_RESOURCE_LOGIC_REF;

    /// @notice The binding reference to the label of the wrapper contract resource.
    /// @dev Determined by the protocol adapter on deployment.
    bytes32 internal immutable WRAPPER_RESOURCE_LABEL_REF;

    /// @notice The kind of the wrapper resource kind.
    bytes32 internal immutable WRAPPER_RESOURCE_KIND;

    /// @notice The kind of the EVM state wrapping resource kind.
    bytes32 internal immutable WRAPPED_RESOURCE_KIND;

    uint256 private nonce;

    constructor(address protocolAdapter, bytes32 wrapperLogicRef, bytes32 wrappedKind) Ownable(protocolAdapter) {
        WRAPPER_RESOURCE_LOGIC_REF = wrapperLogicRef;
        WRAPPER_RESOURCE_LABEL_REF = sha256(abi.encode(address(this), wrappedKind));
        WRAPPER_RESOURCE_KIND = sha256(abi.encode(WRAPPER_RESOURCE_LOGIC_REF, WRAPPER_RESOURCE_LABEL_REF));

        WRAPPED_RESOURCE_KIND = wrappedKind;
    }

    function wrapperResourceLogicRef() external view returns (bytes32) {
        return WRAPPER_RESOURCE_LOGIC_REF;
    }

    function wrapperResourceLabelRef() external view returns (bytes32) {
        return WRAPPER_RESOURCE_LABEL_REF;
    }

    function wrapperResourceKind() external view returns (bytes32) {
        return WRAPPED_RESOURCE_KIND;
    }

    function wrappedResourceKind() external view returns (bytes32) {
        return WRAPPED_RESOURCE_KIND;
    }

    function evmCall(bytes calldata input) external onlyOwner returns (bytes memory output) {
        output = _evmCall(input);
    }

    // TODO can be used to grief transactions
    function newNonce() external returns (uint256) {
        return _newNonce();
    }

    function _evmCall(bytes calldata input) internal virtual returns (bytes memory output);

    function _newNonce() internal returns (uint256) {
        return ++nonce;
    }
}
