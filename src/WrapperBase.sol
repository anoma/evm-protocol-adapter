// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { IWrapper } from "./interfaces/IWrapper.sol";

/// A contract owning EVM state and executing EVM calls.
abstract contract WrapperBase is IWrapper, Ownable {
    /// @notice The binding reference to the logic of the wrapper contract resource.
    bytes32 public immutable wrapperResourceLogicRef;

    /// @notice The binding reference to the label of the wrapper contract resource.
    /// @dev Determined by the protocol adapter on deployment.
    bytes32 public immutable wrapperResourceLabelRef;

    /// @notice The kind of the wrapper resource kind.
    bytes32 public immutable wrapperResourceKind;

    /// @notice The kind of the EVM state wrapping resource kind.
    bytes32 public immutable wrappedResourceKind;

    uint256 private nonce;

    constructor(address protocolAdapter, bytes32 wrapperLogicRef, bytes32 wrappedKind) Ownable(protocolAdapter) {
        wrapperResourceLogicRef = wrapperLogicRef;
        wrapperResourceLabelRef = sha256(abi.encode(address(this), wrappedKind));
        wrapperResourceKind = sha256(abi.encode(wrapperResourceLogicRef, wrapperResourceLabelRef));

        wrappedResourceKind = wrappedKind;
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
