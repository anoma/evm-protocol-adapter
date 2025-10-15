// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";

import {EmergencyMigratableForwarderBase} from "./bases/EmergencyMigratableForwarderBase.sol";
import {ERC20ForwarderPermit2} from "./ERC20ForwarderPermit2.sol";

/// @title ERC20Forwarder
/// @author Anoma Foundation, 2025
/// @notice A forwarder contract forwarding calls and holding funds to wrap and unwrap ERC-20 tokens as resources.
/// @custom:security-contact security@anoma.foundation
contract ERC20Forwarder is EmergencyMigratableForwarderBase {
    using ERC20ForwarderPermit2 for ERC20ForwarderPermit2.Witness;
    using SafeERC20 for IERC20;

    enum CallType {
        Unwrap,
        Wrap
    }

    /// @notice The canonical Uniswap Permit2 contract being deployed at the same address on all supported chains.
    /// (see [Uniswap's announcement](https://blog.uniswap.org/permit2-and-universal-router)).
    IPermit2 internal constant _PERMIT2 = IPermit2(0x000000000022D473030F116dDEE9F6B43aC78BA3);

    /// @notice Emitted when ERC20 tokens get wrapped.
    /// @param token The ERC20 token address.
    /// @param from The address from which tokens were withdrawn.
    /// @param amount The token amount being deposited into the ERC20 forwarder contract.
    event Wrapped(address indexed token, address indexed from, uint128 amount);

    /// @notice Emitted when ERC20 tokens get unwrapped.
    /// @param token The ERC20 token address.
    /// @param to The address to which tokens were deposited.
    /// @param amount The token amount being withdrawn from the ERC20 forwarder contract.
    event Unwrapped(address indexed token, address indexed to, uint128 amount);

    error CallTypeInvalid();
    error TypeOverflow(uint256 limit, uint256 actual);

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    /// @param emergencyCommittee The emergency committee address that is allowed to set the emergency caller if the
    /// RISC Zero verifier has been stopped.
    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef, address emergencyCommittee)
        EmergencyMigratableForwarderBase(protocolAdapter, calldataCarrierLogicRef, emergencyCommittee)
    {}

    // slither-disable-start dead-code /* NOTE: This code is not dead and falsely flagged as such by slither. */
    /// @notice Forwards a call wrapping or unwrapping ERC20 tokens based on the provided input.
    /// @param input Contains data to withdraw or send ERC20 tokens from or to a user, respectively.
    /// @return output The empty string signaling that the function call has succeeded.
    function _forwardCall(bytes calldata input) internal virtual override returns (bytes memory output) {
        CallType callType = CallType(uint8(input[31]));

        if (callType == CallType.Unwrap) {
            _unwrap(input);
        } else if (callType == CallType.Wrap) {
            _wrap(input);
        } else {
            // This branch will never be reached. This is because the call will already panic when attempting to decode
            // a non-existing `Calltype` enum value greater than `type(Calltype).max = 2`.
            revert CallTypeInvalid();
        }

        output = "";
    }

    // slither-disable-end dead-code

    /// @notice Unwraps an ERC20 token and transfers funds to the recipient using the `SafeERC20.safeTransfer`.
    /// @param input The input bytes containing the encoded arguments for the unwrap call:
    /// * `token`: The address of the token to be transferred.
    /// * `to`: The address to transfer the funds to.
    /// * `amount`: The amount to be transferred.
    function _unwrap(bytes calldata input) internal {
        // slither-disable-next-line unused-return
        (, // CallType
            address token,
            address to,
            uint128 amount
        ) = abi.decode(input, (CallType, address, address, uint128));

        emit Unwrapped({token: token, to: to, amount: amount});

        IERC20(token).safeTransfer({to: to, value: amount});
    }

    /// @notice Wraps an ERC20 token and transfers funds from the user that must have authorized the call using
    /// `Permit2.permitWitnessTransferFrom`.
    /// @param input The input bytes containing the encoded arguments for the wrap call:
    /// * `from`: The signer of the Permit2 message from which the funds a transferred from.
    /// * `permit`: The permit data that was signed constituted by:
    /// * * `token`: The address of the token to be transferred.
    /// * * `amount`: The amount to be transferred.
    /// * * `nonce`: A unique value to prevent signature replays.
    /// * * `deadline`: The deadline of the permit signature.
    /// * `witness`: The witness information (the action tree root) that was signed over in addition to the permit data.
    /// * `signature`: The Permit2 signature.
    function _wrap(bytes calldata input) internal {
        // slither-disable-next-line unused-return
        (, // CallType
            address from,
            ISignatureTransfer.PermitTransferFrom memory permit,
            bytes32 actionTreeRoot,
            bytes memory signature
        ) = abi.decode(input, (CallType, address, ISignatureTransfer.PermitTransferFrom, bytes32, bytes));

        if (permit.permitted.amount > type(uint128).max) {
            revert TypeOverflow({limit: type(uint128).max, actual: permit.permitted.amount});
        }

        emit Wrapped({token: permit.permitted.token, from: from, amount: uint128(permit.permitted.amount)});

        _PERMIT2.permitWitnessTransferFrom({
            permit: permit,
            transferDetails: ISignatureTransfer.SignatureTransferDetails({
                to: address(this), requestedAmount: permit.permitted.amount
            }),
            owner: from,
            witness: ERC20ForwarderPermit2.Witness({actionTreeRoot: actionTreeRoot}).hash(),
            witnessTypeString: ERC20ForwarderPermit2._WITNESS_TYPE_STRING,
            signature: signature
        });
    }

    /// @notice Forwards an emergency call wrapping or unwrapping ERC20 tokens based on the provided input.
    /// @param input Contains data to withdraw or send ERC20 tokens from or to a user, respectively.
    /// @return output The empty string signaling that the function call has succeeded.
    /// @dev This function internally uses the `SafeERC20` library.
    function _forwardEmergencyCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _forwardCall(input);
    }
}
