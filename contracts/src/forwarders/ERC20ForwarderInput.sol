// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";

// solhint-disable comprehensive-interface
/// @title ERC20ForwarderInput
/// @author Anoma Foundation, 2025
/// @notice A contract containing definitions and methods related to forwarder input en- and decoding.
/// @custom:security-contact security@anoma.foundation
library ERC20ForwarderInput {
    enum CallType {
        Unwrap,
        Wrap
    }

    /// @notice Encodes the input for the ERC-20 transfer call.
    /// @param token The ERC-20 token.
    /// @param to The address receiving the tokens.
    /// @param value The value to send.
    /// @return input The encoded input.
    function encodeUnwrap(address token, address to, uint128 value) public pure returns (bytes memory input) {
        input = abi.encode(CallType.Unwrap, token, to, value);
    }

    /// @notice Decodes the input for the ERC-20 transfer call.
    /// @param input The encoded input.
    /// @return callType The call type.
    /// @return token The ERC-20 token.
    /// @return to The address receiving the tokens.
    /// @return value The value to send. Note that value is limited to `uint128` to fit the in the
    /// `Resource.quantity` field.
    function decodeUnwrap(bytes calldata input)
        public
        pure
        returns (CallType callType, address token, address to, uint128 value)
    {
        (callType, token, to, value) = abi.decode(input, (CallType, address, address, uint128));
    }

    /// @notice Encodes the input for the Permit2 `permitWitnessTransferFrom` call.
    /// @param from The address to withdraw the tokens from.
    /// @param permit The permit data constituted by the token address, token amount, nonce, and deadline.
    /// @param witness The witness information.
    /// @param signature The signature over the `PermitWitnessTransferFrom` message.
    /// @return input The encoded input.
    function encodeWrap(
        address from,
        ISignatureTransfer.PermitTransferFrom memory permit,
        bytes32 witness,
        bytes memory signature
    ) public pure returns (bytes memory input) {
        input = abi.encode(CallType.Wrap, from, permit, witness, signature);
    }

    /// @notice Decodes the input for the Permit2 `permitWitnessTransferFrom` call.
    /// @param input The encoded input.
    /// @return callType The call type.
    /// @return from The address to withdraw the tokens from.
    /// @return permit The permit data constituted by the token address, token amount, nonce, and deadline.
    /// @return witness The witness information.
    /// @return signature The signature over the `PermitWitnessTransferFrom` message.
    function decodeWrap(bytes calldata input)
        public
        pure
        returns (
            CallType callType,
            address from,
            ISignatureTransfer.PermitTransferFrom memory permit,
            bytes32 witness,
            bytes memory signature
        )
    {
        (callType, from, permit, witness, signature) =
            abi.decode(input, (CallType, address, ISignatureTransfer.PermitTransferFrom, bytes32, bytes));
    }
}
// solhint-enable comprehensive-interface
