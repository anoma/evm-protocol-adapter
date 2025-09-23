// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";

import {IEmergencyMigratable} from "../interfaces/IEmergencyMigratable.sol";
import {INullifierSet} from "../interfaces/INullifierSet.sol";

import {NullifierSet} from "../state/NullifierSet.sol";

import {EmergencyMigratableForwarderBase} from "./EmergencyMigratableForwarderBase.sol";

/// @title ERC20ForwarderV2
/// @author Anoma Foundation, 2025
/// @notice Version 2 of the forwarder contract forwarding calls and holding funds to wrap and unwrap ERC-20 tokens as
/// resources allowing to mint resources based on their state in a specified stopped protocol adapter.
/// @custom:security-contact security@anoma.foundation
contract ERC20ForwarderV2 is EmergencyMigratableForwarderBase, NullifierSet {
    using SafeERC20 for IERC20;

    enum CallType {
        Unwrap,
        Wrap,
        Upgrade
    }

    /// @notice The canonical Uniswap Permit2 contract deployed at the same address on all supported chains
    /// (see [Uniswap's announcement](https://blog.uniswap.org/permit2-and-universal-router)).
    IPermit2 internal constant _PERMIT2 = IPermit2(0x000000000022D473030F116dDEE9F6B43aC78BA3);

    address internal immutable _OLD_PROTOCOL_ADAPTER;

    address internal immutable _ERC20_FORWARDER_V1;

    // solhint-disable gas-indexed-events
    /// @notice Emitted when the resource representing ERC20 wrapped token gets upgraded.
    /// @param  nullifier The nullifier of the previous token.
    event Upgraded(bytes32 indexed nullifier);

    /// @notice Emitted when ERC20 tokens get wrapped.
    /// @param token The ERC20 token address.
    /// @param from The address from which tokens were withdrawn.
    /// @param value The token amount being deposited into the ERC20 forwarder contract.
    event Wrapped(address indexed token, address indexed from, uint256 value);

    /// @notice Emitted when ERC20 tokens get unwrapped.
    /// @param token The ERC20 token address.
    /// @param to The address to which tokens were deposited.
    /// @param value The token amount being withdrawn from the ERC20 forwarder contract.
    event Unwrapped(address indexed token, address indexed to, uint256 value);
    // solhint-enable gas-indexed-events

    error CallTypeInvalid();
    error TypeOverflow(uint256 limit, uint256 actual);

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    /// @param emergencyCommittee The emergency committee address that is allowed to set the emergency caller if the
    /// RISC Zero verifier has been stopped.
    /// @param oldProtocolAdapter The stopped protocol adapter address.
    /// @param oldTokenForwarder The forwarder address connected to the stopped PA.
    constructor(
        address protocolAdapter,
        bytes32 calldataCarrierLogicRef,
        address emergencyCommittee,
        address oldProtocolAdapter,
        address oldTokenForwarder
    ) EmergencyMigratableForwarderBase(protocolAdapter, calldataCarrierLogicRef, emergencyCommittee) {
        if (oldProtocolAdapter == address(0) || oldTokenForwarder == address(0)) {
            revert ZeroNotAllowed();
        }

        _OLD_PROTOCOL_ADAPTER = oldProtocolAdapter;
        _ERC20_FORWARDER_V1 = oldTokenForwarder;
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        CallType callType = CallType(uint8(input[31]));

        if (callType == CallType.Unwrap) {
            // slither-disable-next-line unused-return
            (
                , // CallType
                address token,
                address to,
                uint256 value
            ) = abi.decode(input, (CallType, address, address, uint128));

            emit Unwrapped({token: token, to: to, value: value});

            IERC20(token).safeTransfer({to: to, value: value});
        } else if (callType == CallType.Wrap) {
            // slither-disable-next-line unused-return
            (
                , // CallType
                address from,
                ISignatureTransfer.PermitTransferFrom memory permit,
                bytes32 witness,
                bytes memory signature
            ) = abi.decode(input, (CallType, address, ISignatureTransfer.PermitTransferFrom, bytes32, bytes));

            if (permit.permitted.amount > type(uint128).max) {
                revert TypeOverflow({limit: type(uint128).max, actual: permit.permitted.amount});
            }

            emit Wrapped({token: permit.permitted.token, from: from, value: permit.permitted.amount});

            _PERMIT2.permitWitnessTransferFrom({
                permit: permit,
                // solhint-disable-next-line max-line-length
                transferDetails: ISignatureTransfer.SignatureTransferDetails({
                    to: address(this),
                    requestedAmount: permit.permitted.amount
                }),
                owner: from,
                witness: witness,
                witnessTypeString: "bytes32 witness",
                signature: signature
            });
        } else if (callType == CallType.Upgrade) {
            (
                , // CallType
                bytes32 nf,
                address token,
                uint256 value
            ) = abi.decode(input, (CallType, bytes32, address, uint128));

            // Check that the resource being upgraded has not been consumed.
            if (INullifierSet(_OLD_PROTOCOL_ADAPTER).contains(nf)) {
                revert NullifierSet.PreExistingNullifier(nf);
            }

            // Make sure that the nullifier has not been added before
            _addNullifier(nf);

            // Move funds connected to the resource into the current forwarder.
            bytes memory emergencyInput = abi.encode(CallType.Unwrap, token, address(this), value);
            // slither-disable-next-line unused-return
            IEmergencyMigratable(_ERC20_FORWARDER_V1).forwardEmergencyCall(emergencyInput);
        } else {
            // This branch will never be reached. This is because the call will already panic when attempting to decode
            // a non-existing `Calltype` enum value greater than `type(Calltype).max = 3`.
            revert CallTypeInvalid();
        }

        output = "";
    }

    /// @notice Forwards emergency calls.
    /// @param input The `bytes`  encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardEmergencyCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _forwardCall(input);
    }
}
