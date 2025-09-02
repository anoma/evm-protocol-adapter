// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {Permit2Lib} from "@permit2/src/libraries/Permit2Lib.sol";
import {PermitHash} from "@permit2/src/libraries/PermitHash.sol";

// solhint-disable comprehensive-interface
/// @title ERC20ForwarderInput
/// @author Anoma Foundation, 2025
/// @notice A contract containing definitions and methods related to forwarder input en- and decoding.
/// @custom:security-contact security@anoma.foundation
contract ERC20ForwarderInput {
    enum CallType {
        Transfer,
        TransferFrom,
        PermitWitnessTransferFrom
    }

    /// @notice The canonical Uniswap Permit2 contract deployed at the same address on all supported chains
    /// (see [Uniswap's announcement](https://blog.uniswap.org/permit2-and-universal-router)).
    IPermit2 internal constant _PERMIT2 = IPermit2(address(Permit2Lib.PERMIT2));

    error CallTypeInvalid();

    /// @notice Computes the `permitWitnessTransferFrom` digest.
    /// @param permit The permit data constituted by the token address, token amount, nonce, and deadline.
    /// @param spender The address being allowed to execute the `permitWitnessTransferFrom` call.
    /// @param witness The witness information.
    /// @return digest The digest.
    function computePermitWitnessTransferFromDigest(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        bytes32 witness
    ) public view returns (bytes32 digest) {
        string memory witnessTypeString = "bytes32 witness";

        bytes32 structHash = keccak256(
            abi.encode(
                keccak256(abi.encodePacked(PermitHash._PERMIT_TRANSFER_FROM_WITNESS_TYPEHASH_STUB, witnessTypeString)),
                keccak256(
                    abi.encode(PermitHash._TOKEN_PERMISSIONS_TYPEHASH, permit.permitted.token, permit.permitted.amount)
                ),
                spender,
                permit.nonce,
                permit.deadline,
                witness
            )
        );

        digest = keccak256(abi.encodePacked("\x19\x01", _PERMIT2.DOMAIN_SEPARATOR(), structHash));
    }

    /// @notice Encodes the input for the ERC-20 transfer call.
    /// @param to The address receiving the tokens.
    /// @param value The value to send.
    /// @return input The encoded input.
    function encodeTransfer(address to, uint256 value) public pure returns (bytes memory input) {
        input = abi.encode(CallType.Transfer, to, value);
    }

    /// @notice Decodes the input for the ERC-20 transfer call.
    /// @param input The encoded input.
    /// @return to The address receiving the tokens.
    /// @return value The value to send.
    function decodeTransfer(bytes calldata input) public pure returns (address to, uint256 value) {
        CallType callType;
        (callType, to, value) = abi.decode(input, (CallType, address, uint256));

        if (callType != CallType.Transfer) {
            revert CallTypeInvalid();
        }
    }

    /// @notice Encodes the input for the ERC-20 `transferFrom` call.
    /// @param from The address to withdraw the tokens from.
    /// @param value The value to send.
    /// @return input The encoded input.
    function encodeTransferFrom(address from, uint256 value) public pure returns (bytes memory input) {
        input = abi.encode(CallType.TransferFrom, from, value);
    }

    /// @notice Decodes the input for the ERC-20 `transferFrom` call.
    /// @param input The encoded input.
    /// @return from The address to withdraw the tokens from.
    /// @return value The value to send.
    function decodeTransferFrom(bytes calldata input) public pure returns (address from, uint256 value) {
        CallType callType;
        (callType, from, value) = abi.decode(input, (CallType, address, uint256));

        if (callType != CallType.TransferFrom) {
            revert CallTypeInvalid();
        }
    }

    /// @notice Encodes the input for the Permit2 `permitWitnessTransferFrom` call.
    /// @param from The address to withdraw the tokens from.
    /// @param value The value to send.
    /// @param permit The permit data constituted by the token address, token amount, nonce, and deadline.
    /// @param witness The witness information.
    /// @param signature The signature over the `PermitWitnessTransferFrom` message.
    /// @return input The encoded input.
    function encodePermitWitnessTransferFrom(
        address from,
        uint256 value,
        ISignatureTransfer.PermitTransferFrom memory permit,
        bytes32 witness,
        bytes memory signature
    ) public pure returns (bytes memory input) {
        input = abi.encode(CallType.PermitWitnessTransferFrom, from, value, permit, witness, signature);
    }

    /// @notice Decodes the input for the Permit2 `permitWitnessTransferFrom` call.
    /// @param input The encoded input.
    /// @return from The address to withdraw the tokens from.
    /// @return value The value to send.
    /// @return permit The permit data constituted by the token address, token amount, nonce, and deadline.
    /// @return witness The witness information.
    /// @return signature The signature over the `PermitWitnessTransferFrom` message.
    function decodePermitWitnessTransferFrom(bytes calldata input)
        public
        pure
        returns (
            address from,
            uint256 value,
            ISignatureTransfer.PermitTransferFrom memory permit,
            bytes32 witness,
            bytes memory signature
        )
    {
        CallType callType;
        (callType, from, value, permit, witness, signature) =
            abi.decode(input, (CallType, address, uint256, ISignatureTransfer.PermitTransferFrom, bytes32, bytes));

        if (callType != CallType.PermitWitnessTransferFrom) {
            revert CallTypeInvalid();
        }
    }
}
// solhint-enable comprehensive-interface
