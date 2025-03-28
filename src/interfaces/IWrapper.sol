// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface IWrapper {
    // TODO add events

    /// @notice Conducts an external call to read or write EVM state.
    /// @param input The `bytes` encoded calldata (including the `bytes4` function selector).
    /// @return output The `bytes` encoded output of the call.
    function ffiCall(bytes memory input) external returns (bytes memory output);

    /// @notice Returns the binding reference to the logic of the wrapper contract resource.
    /// @return wrapperLogicRef The binding logic reference.
    function wrapperResourceLogicRef() external view returns (bytes32 wrapperLogicRef);

    /// @notice Returns the binding reference to the label of the wrapper contract resource.
    /// @return wrapperLabelRef The binding label reference.
    function wrapperResourceLabelRef() external view returns (bytes32 wrapperLabelRef);

    /// @notice Returns the kind of the wrapper contract resource.
    /// @return wrapperKind The wrapper resource kind.
    function wrapperResourceKind() external view returns (bytes32 wrapperKind);

    /// @notice Returns the kind of the resource this contract is wrapping EVM state in.
    /// @return wrappingKind The wrapping resource kind.
    function wrappingResourceKind() external view returns (bytes32 wrappingKind);
}
