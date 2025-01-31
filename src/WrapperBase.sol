// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { IWrapper } from "./interfaces/IWrapper.sol";

/// A contract owning EVM state and executing EVM calls.
abstract contract WrapperBase is IWrapper, Ownable {
    /// @notice The kind of the EVM state wrapping resource kind.
    bytes32 internal immutable WRAPPED_RESOURCE_KIND;

    /// @notice The binding reference to the label of the wrapper contract resource.
    /// @dev Determined by the protocol adapter on deployment.
    bytes32 internal immutable WRAPPER_RESOURCE_LABEL_REF;

    constructor(address protocolAdapter, bytes32 wrappedResourceKind) Ownable(protocolAdapter) {
        WRAPPED_RESOURCE_KIND = wrappedResourceKind;
        WRAPPER_RESOURCE_LABEL_REF = sha256(abi.encode(address(this), wrappedResourceKind));
    }

    function wrappedResourceKind() external view returns (bytes32) {
        return WRAPPED_RESOURCE_KIND;
    }

    function wrapperResourceLabelRef() external view returns (bytes32) {
        return WRAPPER_RESOURCE_LABEL_REF;
    }

    function evmCall(bytes calldata input) external onlyOwner returns (bytes memory output) {
        output = _evmCall(input);
    }

    function _evmCall(bytes calldata input) internal virtual returns (bytes memory output);
}
