// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Ownable } from "@openzeppelin-contracts/access/Ownable.sol";
import { Address } from "@openzeppelin-contracts/utils/Address.sol";
//import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";

import { WrapperBase } from "./WrapperBase.sol";

contract ERC20Wrapper is Ownable, WrapperBase {
    using Address for address;

    address internal immutable _ERC20_CONTRACT;

    error ZeroAddressNotAllowed();

    constructor(
        address protocolAdapter,
        address erc20,
        bytes32 wrapperLogicRef,
        bytes32 wrappedKind
    )
        WrapperBase(protocolAdapter, wrapperLogicRef, wrappedKind)
    {
        if (erc20 == address(0)) revert ZeroAddressNotAllowed();
        _ERC20_CONTRACT = erc20;
    }

    // TODO make generic proxy, allow native ETH transfers
    function _evmCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _ERC20_CONTRACT.functionCall(input);
    }

    // Native ETH transfer
    // TODO! The msg.sender must call directly, but the protocol adapter is the caller. This won't work.
    //receive() external payable {
    //    emit NativeTokenDeposited(msg.sender, msg.value);
    //}
}
