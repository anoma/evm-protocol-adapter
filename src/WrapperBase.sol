// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { IWrapper } from "./interfaces/IWrapper.sol";

/// A contract owning EVM state and executing EVM calls.
abstract contract WrapperBase is IWrapper, Ownable {
    /// @notice The kind of the EVM state wrapping resource kind.
    bytes32 internal immutable WRAPPED_KIND;

    /// @notice The binding reference to the label of the wrapper contract resource.
    /// @dev Determined by the protocol adapter on deployment.
    bytes32 internal immutable WRAPPER_LABEL_REF;

    constructor(
        address protocolAdapter,
        bytes32 wrappedResourceLogicRef,
        bytes32 wrappedResourceLabelRef
    )
        Ownable(protocolAdapter)
    {
        WRAPPED_KIND =
            ComputableComponents.kind({ logicRef: wrappedResourceLogicRef, labelRef: wrappedResourceLabelRef });

        WRAPPER_LABEL_REF = sha256(abi.encode(address(this), WRAPPED_KIND));
    }

    function wrappedKind() external view returns (bytes32) {
        return WRAPPED_KIND;
    }

    function wrapperLabelRef() external view returns (bytes32) {
        return WRAPPER_LABEL_REF;
    }

    function evmCall(bytes calldata input) external onlyOwner returns (bytes memory output) {
        output = _evmCall(input);
    }

    function _evmCall(bytes calldata input) internal virtual returns (bytes memory output);
}
