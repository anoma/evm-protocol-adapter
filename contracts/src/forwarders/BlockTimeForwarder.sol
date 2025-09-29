// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IForwarder} from "../interfaces/IForwarder.sol";

/// @title BlockTimeForwarder
/// @author Anoma Foundation, 2025
/// @notice A forwarder contract allowing to check whether a certain block time has passed.
/// @custom:security-contact security@anoma.foundation
contract BlockTimeForwarder is IForwarder {
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
        output = abi.encode(expectedTime < block.timestamp);  // solhint-disable-line not-rely-on-time
    }
}
