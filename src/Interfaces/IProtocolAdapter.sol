// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Transaction } from "../Types.sol";

interface IProtocolAdapter {
    function verify(Transaction calldata transaction) external;

    function execute(Transaction calldata transaction) external;
}
