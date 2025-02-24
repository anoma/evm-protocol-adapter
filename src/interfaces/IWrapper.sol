// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

interface IWrapper {
    // TODO add events

    /// @notice Returns the binding reference to the logic of the wrapper contract resource.
    /// @return The binding logic reference.
    function wrapperResourceLogicRef() external view returns (bytes32);

    /// @notice Returns the binding reference to the label of the wrapper contract resource.
    /// @return The binding label reference.
    function wrapperResourceLabelRef() external view returns (bytes32);

    /// @notice Returns the kind of the wrapper contract resource.
    /// @return The wrapper resource kind.
    function wrapperResourceKind() external view returns (bytes32);

    /// @notice Returns the kind of the resource this contract is wrapping EVM state in.
    /// @return The wrapped resource kind.
    function wrappedResourceKind() external view returns (bytes32);

    /// @notice Conducts an external call to read or write EVM state.
    /// @param input The `bytes` encoded calldata (including the `bytes4` function selector).
    /// @return output The `bytes` encoded output of the call.
    function evmCall(bytes memory input) external returns (bytes memory output);

    function newNonce() external returns (uint256);
}
