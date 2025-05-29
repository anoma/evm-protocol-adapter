// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Address} from "@openzeppelin-contracts/utils/Address.sol";

import {ForwarderBase} from "./ForwarderBase.sol";

contract ERC20Forwarder is ForwarderBase {
    using Address for address;

    address internal immutable _ERC20_CONTRACT;

    error ZeroAddressNotAllowed();

    constructor(address protocolAdapter, address erc20, bytes32 calldataCarrierLogicRef)
        ForwarderBase(protocolAdapter, calldataCarrierLogicRef)
    {
        if (erc20 == address(0)) revert ZeroAddressNotAllowed();
        _ERC20_CONTRACT = erc20;
    }

    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _ERC20_CONTRACT.functionCall(input);
    }
}
