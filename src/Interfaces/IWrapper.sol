// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

interface IWrapper {
    // TODO add events

    /// @notice Returns the binding reference to the resource label this contract is wrapping EVM state in.
    /// @return The binding label reference.
    function wrappedLabelRef() external view returns (bytes32);

    /// @notice Returns the binding reference to the resource logic this contract is wrapping EVM state in.
    /// @return The binding logic reference.
    function wrappedLogicRef() external view returns (bytes32);

    /// @notice Returns the kind of the resource this contract is wrapping EVM state in.
    /// @return The binding label reference.
    function wrappedKind() external view returns (bytes32);

    /// @notice Returns the binding reference to the label of the wrapper contract resource.
    /// @return The binding label reference.
    function wrapperLabelRef() external view returns (bytes32);

    // /// @notice Returns the binding reference to the logic of the wrapper contract resource.
    // /// @return The binding logic reference.
    // function WrapperLogicRef() external view returns (bytes32);

    /// @notice Conducts an external call to read or write EVM state.
    /// @param input The `bytes` encoded calldata (including the `bytes4` function selector).
    /// @return output The `bytes` encoded output of the call.
    function evmCall(bytes memory input) external returns (bytes memory output);

    // TODO remove
    function isAllowed(bytes4 functionSelector) external returns (bool);
    /*
        function wrap(bytes calldata input) external returns (bytes memory output);
        function unwrap(bytes calldata input) external returns (bytes memory output);
    */
}
