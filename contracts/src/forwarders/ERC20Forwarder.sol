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

    error ZeroAddressNotAllowed();

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param erc20 The ERC-20 token contract to forward calls to.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    constructor(address protocolAdapter, address erc20, bytes32 calldataCarrierLogicRef)
        ForwarderBase(protocolAdapter, calldataCarrierLogicRef)
    {
        if (erc20 == address(0)) revert ZeroAddressNotAllowed();
        _ERC20_CONTRACT = erc20;
    }

    /// @notice The implementation of the  abstract `ForwarderBase` contract forwarding the calls to the ERC-20 token
    /// contract.
    /// @param input The `bytes` encoded calldata (including the `bytes4` function selector).
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _ERC20_CONTRACT.functionCall(input);
    }
}
