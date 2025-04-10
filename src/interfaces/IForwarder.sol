// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface IForwarder {
    // TODO add events

    /// @notice Forwards an external call to read or write EVM state.
    /// @param input The `bytes` encoded calldata (including the `bytes4` function selector).
    /// @return output The `bytes` encoded output of the call.
    function forwardCall(bytes memory input) external returns (bytes memory output);

    /// @notice Returns the binding reference to the logic of the calldata carrier resource.
    /// @return calldataCarrierLogicRef The binding logic reference.
    function calldataCarrierResourceLogicRef() external view returns (bytes32 calldataCarrierLogicRef);

    /// @notice Returns the binding reference to the label of the calldata carrier resource.
    /// @return calldataCarrierLabelRef The binding label reference.
    function calldataCarrierResourceLabelRef() external view returns (bytes32 calldataCarrierLabelRef);

    /// @notice Returns the kind of the calldata carrier resource.
    /// @return calldataCarrierKind The calldata carrier kind.
    function calldataCarrierResourceKind() external view returns (bytes32 calldataCarrierKind);

    /// @notice Returns the kind of the resource this contract is wrapping EVM state in.
    /// @return stateWrapperKind The state-wrapping resource kind.
    function stateWrapperResourceKind() external view returns (bytes32 stateWrapperKind);
}
