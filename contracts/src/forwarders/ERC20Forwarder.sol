// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";

import {EmergencyMigratableForwarderBase} from "./EmergencyMigratableForwarderBase.sol";

import {ERC20ForwarderInput} from "./ERC20ForwarderInput.sol";

/// @title ERC20Forwarder
/// @author Anoma Foundation, 2025
/// @notice A forwarder contract forwarding calls and holding funds to wrap and unwrap ERC-20 tokens as resources.
/// @custom:security-contact security@anoma.foundation
contract ERC20Forwarder is EmergencyMigratableForwarderBase, ERC20ForwarderInput {
    using SafeERC20 for IERC20;

    /// @notice Emitted when ERC20 tokens get wrapped.
    /// @param token The ERC20 token address.
    /// @param from The address from which tokens were withdrawn.
    /// @param value The token amount being deposited into the ERC20 forwarder contract.
    event Wrapped(IERC20 indexed token, address indexed from, uint256 value); // solhint-disable-line gas-indexed-events

    /// @notice Emitted when ERC20 tokens get unwrapped.
    /// @param token The ERC20 token address.
    /// @param to The address to which tokens were deposited.
    /// @param value The token amount being withdrawn from the ERC20 forwarder contract.
    event Unwrapped(IERC20 indexed token, address indexed to, uint256 value); // solhint-disable-line gas-indexed-events

    error TokenMismatch(address expected, address actual);
    error ValueMismatch(uint256 expected, uint256 actual);

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    /// @param emergencyCommittee The emergency committee address that is allowed to set the emergency caller if the
    /// RISC Zero verifier has been stopped.
    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef, address emergencyCommittee)
        EmergencyMigratableForwarderBase(protocolAdapter, calldataCarrierLogicRef, emergencyCommittee)
    {}

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        CallType callType = CallType(uint8(input[31]));

        if (callType == CallType.Transfer) {
            (
                , // CallType
                IERC20 token,
                address to,
                uint256 value
            ) = decodeTransfer(input);

            emit Unwrapped({token: token, to: to, value: value});

            token.safeTransfer({to: to, value: value});
        } else if (callType == CallType.TransferFrom) {
            (
                , // CallType
                IERC20 token,
                address from,
                uint256 value
            ) = decodeTransferFrom(input);

            emit Wrapped({token: token, from: from, value: value});

            // slither-disable-next-line arbitrary-send-erc20
            token.safeTransferFrom({from: from, to: address(this), value: value});
        } else if (callType == CallType.PermitWitnessTransferFrom) {
            (
                , // CallType
                IERC20 token,
                address from,
                uint256 value,
                ISignatureTransfer.PermitTransferFrom memory permit,
                bytes32 witness,
                bytes memory signature
            ) = decodePermitWitnessTransferFrom(input);

            // NOTE: The following checks could be conducted on the carrier resource logic.
            {
                // Check that the permitted token address matches the ERC20 token this contract is forwarding calls to.
                if (permit.permitted.token != address(token)) {
                    revert TokenMismatch({expected: address(token), actual: permit.permitted.token});
                }

                // Check that the permitted and transferred amounts are exactly the same.
                if (permit.permitted.amount != value) {
                    revert ValueMismatch({expected: value, actual: permit.permitted.amount});
                }
            }

            emit Wrapped({token: token, from: from, value: value});

            _PERMIT2.permitWitnessTransferFrom({
                permit: permit,
                // solhint-disable-next-line max-line-length
                transferDetails: ISignatureTransfer.SignatureTransferDetails({to: address(this), requestedAmount: value}),
                owner: from,
                witness: witness,
                witnessTypeString: "bytes32 witness",
                signature: signature
            });
        } else {
            // This branch will never be reached. This is because the call will already panic when attempting to decode
            // a non-existing `Calltype` enum value greater than `type(Calltype).max = 2`.
            revert CallTypeInvalid();
        }

        output = abi.encode(true);
    }

    /// @notice Forwards emergency calls.
    /// @param input The `bytes`  encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardEmergencyCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _forwardCall(input);
    }
}
