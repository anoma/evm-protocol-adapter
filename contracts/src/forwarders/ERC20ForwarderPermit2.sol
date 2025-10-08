// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title ERC20ForwarderPermit2
/// @author Anoma Foundation, 2025
/// @notice A library containing definitions related to the Permit2 witness type.
/// @custom:security-contact security@anoma.foundation
library ERC20ForwarderPermit2 {
    /// @notice The Permit2 witness struct being used in `Wrap` (`permitWitnessTransferFrom`) calls of the forwarder.
    /// @param actionTreeRoot The action tree root of the action the external call is triggered from.
    struct Witness {
        bytes32 actionTreeRoot;
    }

    // solhint-disable-next-line gas-small-strings
    /// @notice The witness type string (see https://docs.uniswap.org/contracts/permit2/reference/signature-transfer).
    string internal constant _WITNESS_TYPE_STRING = "Witness witness)Witness(bytes32 actionTreeRoot)";
}
