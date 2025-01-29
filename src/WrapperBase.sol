// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { IWrapper } from "./interfaces/IWrapper.sol";

/// A contract owning EVM state and executing EVM calls.
abstract contract WrapperBase is IWrapper, Ownable {
    /// @notice The binding reference to the logic of the EVM state wrapping resources.
    /// @dev Determined by Anoma and checked by the protocol adapter.
    bytes32 internal immutable WRAPPED_LOGIC_REF;
    /// @notice The binding reference to the label of the EVM state wrapping resources.
    /// @dev Determined by 3rd party developer
    bytes32 internal immutable WRAPPED_LABEL_REF;
    /// @notice The kind of the EVM state wrapping resource kind.
    bytes32 internal immutable WRAPPED_KIND; // TODO Needed?

    // /// @notice The binding reference to the logic of the wrapper contract resource.
    // /// @dev Determined by the protocol adapter on deployment.
    // bytes32 internal immutable WRAPPER_LOGIC_REF;
    /// @notice The binding reference to the label of the wrapper contract resource.
    /// @dev Determined by the protocol adapter on deployment.
    bytes32 internal immutable WRAPPER_LABEL_REF;
    // /// @notice The kind of the wrapper contract resource.
    // bytes32 internal immutable WRAPPER_KIND; // TODO Needed?

    mapping(bytes4 functionSelector => bool allowed) private isFunctionAllowed;

    error KindMismatch(bytes32 expected, bytes32 actual);
    error ForbiddenFunctionCall(bytes4 functionSelector);

    constructor(
        address protocolAdapter,
        bytes32 wrappedResourceLogicRef,
        bytes32 wrappedResourceLabelRef,
        // TODO Needs the resource kind of the wrapped resources
        bytes4[] memory allowedFunctionSelectors
    )
        Ownable(protocolAdapter)
    {
        WRAPPED_LOGIC_REF = wrappedResourceLogicRef;
        WRAPPED_LABEL_REF = wrappedResourceLabelRef;
        WRAPPED_KIND =
            ComputableComponents.kind({ logicRef: wrappedResourceLogicRef, labelRef: wrappedResourceLabelRef });

        WRAPPER_LABEL_REF = sha256(abi.encode(protocolAdapter, WRAPPED_KIND));

        // TODO needed?
        for (uint256 i; i < allowedFunctionSelectors.length; ++i) {
            isFunctionAllowed[allowedFunctionSelectors[i]] = true;
        }
    }

    // function kind() external view returns (bytes32) {
    //     return WRAPPED_KIND;
    // }

    function wrappedLabelRef() external view returns (bytes32) {
        return WRAPPED_LABEL_REF;
    }

    function wrappedLogicRef() external view returns (bytes32) {
        return WRAPPED_LOGIC_REF;
    }

    function wrapperLabelRef() external view returns (bytes32) {
        return WRAPPED_LABEL_REF;
    }

    // function logicRef() external view returns (bytes32) {
    //     return WRAPPED_LOGIC_REF;
    // }

    function evmCall(bytes calldata input) external returns (bytes memory output) {
        bytes4 selector = bytes4(input[:4]);

        if (!isFunctionAllowed[selector]) {
            revert ForbiddenFunctionCall(selector);
        }
        output = _evmCall(input);
    }

    function isAllowed(bytes4 functionSelector) external view returns (bool) {
        return _isAllowed(functionSelector);
    }

    function _evmCall(bytes calldata input) internal virtual returns (bytes memory output);

    function _isAllowed(bytes4 functionSelector) internal view returns (bool) {
        return isFunctionAllowed[functionSelector];
    }
}
