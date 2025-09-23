// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {NullifierSet} from "../../state/NullifierSet.sol";

import {ERC20Forwarder} from "../ERC20Forwarder.sol";

/// @title ERC20ForwarderV2
/// @author Anoma Foundation, 2025
/// @notice Version 2 of the forwarder contract forwarding calls and holding funds to wrap and unwrap ERC-20 tokens as
/// resources allowing to mint resources based on their state in a specified stopped protocol adapter.
/// @custom:security-contact security@anoma.foundation
contract ERC20ForwarderV2 is ERC20Forwarder, NullifierSet {
    enum CallTypeV2 {
        Unwrap,
        Wrap,
        Migrate
    }

    address internal immutable _PROTOCOL_ADAPTER_V1;
    ERC20Forwarder internal immutable _ERC20_FORWARDER_V1;

    /// @notice Emitted when an created and unconsumed resource representing ERC20 tokens is migrated from the protocol
    /// adapter v1.
    /// @param  nullifier The nullifier of the created and unconsumed resource.
    event Migrated(bytes32 indexed nullifier);

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    /// @param emergencyCommittee The emergency committee address that is allowed to set the emergency caller if the
    /// RISC Zero verifier has been stopped.
    /// @param protocolAdapterV1 The stopped protocol adapter address.
    /// @param erc20ForwarderV1 The forwarder address connected to the stopped PA.
    constructor(
        address protocolAdapter,
        bytes32 calldataCarrierLogicRef,
        address emergencyCommittee,
        address protocolAdapterV1,
        address erc20ForwarderV1
    ) ERC20Forwarder(protocolAdapter, calldataCarrierLogicRef, emergencyCommittee) {
        if (protocolAdapterV1 == address(0) || erc20ForwarderV1 == address(0)) {
            revert ZeroNotAllowed();
        }

        _PROTOCOL_ADAPTER_V1 = protocolAdapterV1;
        _ERC20_FORWARDER_V1 = ERC20Forwarder(erc20ForwarderV1);
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        CallTypeV2 callType = CallTypeV2(uint8(input[31]));

        if (callType == CallTypeV2.Unwrap) {
            _unwrap(input);
        } else if (callType == CallTypeV2.Wrap) {
            _wrap(input);
        } else if (callType == CallTypeV2.Migrate) {
            _migrate(input);
        } else {
            // This branch will never be reached. This is because the call will already panic when attempting to decode
            // a non-existing `Calltype` enum value greater than `type(Calltype).max = 3`.
            revert CallTypeInvalid();
        }

        output = "";
    }

    /// @notice Migrates ERC20 tokens by transferring funds from the ERC20Forwarder V1 and storing the associated
    /// nullifier.
    /// @param input The input bytes containing the encoded arguments for the migration call:
    /// * `nullifier`: The nullifier of the resource to be migrated.
    /// * `token`: The address of the token to migrated.
    /// * `amount`: The amount to be migrated.
    function _migrate(bytes calldata input) internal {
        (
            , // CallType
            bytes32 nullifier,
            address token,
            uint256 value
        ) = abi.decode(input, (CallTypeV2, bytes32, address, uint128));

        // Check that the resource being upgraded has not been consumed.
        if (NullifierSet(_PROTOCOL_ADAPTER_V1).contains(nullifier)) {
            revert NullifierSet.PreExistingNullifier(nullifier);
        }

        // Make sure that the nullifier has not been added before
        _addNullifier(nullifier);

        // slither-disable-next-line unused-return
        _ERC20_FORWARDER_V1.forwardEmergencyCall({input: abi.encode(CallType.Unwrap, token, address(this), value)});
    }
}
