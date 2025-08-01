// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Address} from "@openzeppelin-contracts/utils/Address.sol";

import {ForwarderBase} from "./ForwarderBase.sol";

/// @title ERC20Forwarder
/// @author Anoma Foundation, 2025
/// @notice A forwarder contract forwarding calls and holding funds to wrap and unwrap ERC-20 tokens as resources.
/// @custom:security-contact security@anoma.foundation
contract ERC20Forwarder is ForwarderBase {
    using Address for address;

    /// @notice The ERC-20 token contract address to forward calls to.
    address internal immutable _ERC20_CONTRACT;

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param emergencyCommittee The emergency committee address that is allowed to set the emergency caller if the
    /// RISC Zero verifier has been stopped.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    /// @param erc20 The ERC-20 token contract to forward calls to.
    constructor(address protocolAdapter, address emergencyCommittee, bytes32 calldataCarrierLogicRef, address erc20)
        ForwarderBase(protocolAdapter, emergencyCommittee, calldataCarrierLogicRef)
    {
        if (erc20 == address(0)) {
            revert ZeroNotAllowed();
        }
        _ERC20_CONTRACT = erc20;
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _ERC20_CONTRACT.functionCall(input);
    }

    /// @notice Forwards emergency calls.
    /// @param input The `bytes`  encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardEmergencyCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _ERC20_CONTRACT.functionCall(input);
    }
}
