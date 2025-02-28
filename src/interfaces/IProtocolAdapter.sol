// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Transaction } from "../Types.sol";

import { IWrapper } from "../interfaces/IWrapper.sol";

interface IProtocolAdapter {
    function verify(Transaction calldata transaction) external view;

    function execute(Transaction calldata transaction) external;

    function createWrapperContractResource(IWrapper wrapper) external;
}
