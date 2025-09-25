// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IForwarder} from "../interfaces/IForwarder.sol";

/// @title ForwarderBase
/// @author Anoma Foundation, 2025
/// @notice The forwarder contract returning whether a specific block time has passed.
/// @custom:security-contact security@anoma.foundation

contract BlockTimeForwarder is IForwarder {
    /// @inheritdoc IForwarder
    function forwardCall(bytes32, /* logicRef */ bytes calldata input)
        external
        override
        returns (bytes memory output)
    {
        (uint256 expectedTime) = abi.decode(input, (uint256));

        // solhint-disable-next-line not-rely-on-time
        abi.encode(expectedTime < block.timestamp);
    }
}
