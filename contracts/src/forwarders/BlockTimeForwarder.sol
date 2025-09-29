// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IForwarder} from "../interfaces/IForwarder.sol";

/// @title BlockTimeForwarder
/// @author Anoma Foundation, 2025
/// @notice A forwarder contract allowing to check whether a certain block time has passed.
/// @custom:security-contact security@anoma.foundation
contract BlockTimeForwarder is IForwarder {
    enum TimeComparison {
        LT,
        EQ,
        GT
    }

    /// @inheritdoc IForwarder
    function forwardCall(bytes32, /* logicRef */ bytes calldata input)
        external
        view
        override
        returns (bytes memory output)
    {
        // 248-limit is imposed by Risc0 not accepting 256-bit inputs.
        (uint256 expectedTime) = abi.decode(input, (uint248));

        // slither-disable-next-line timestamp
        uint256 currentTime = block.timestamp; // solhint-disable-line not-rely-on-time

        TimeComparison result;
        if (expectedTime < currentTime) {
            result = TimeComparison.LT;
        } else if (expectedTime > currentTime) {
            result = TimeComparison.GT;
        } else {
            result = TimeComparison.EQ;
        }

        output = abi.encode(result);
    }
}
