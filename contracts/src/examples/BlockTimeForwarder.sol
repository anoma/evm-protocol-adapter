// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Time} from "@openzeppelin-contracts-5.5.0/utils/types/Time.sol";

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
    function forwardCall( /* logicRef */
        bytes32,
        bytes calldata input
    )
        external
        view
        override
        returns (bytes memory output)
    {
        (uint48 expectedTime) = abi.decode(input, (uint48));

        uint48 currentTime = Time.timestamp();

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
