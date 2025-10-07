// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title ERC20ForwarderPermit2
/// @author Anoma Foundation, 2025
/// @notice A library containing definitions related to the Permit2 witness type.
/// @custom:security-contact security@anoma.foundation
library ERC20ForwarderPermit2 {
    struct Witness {
        bytes32 actionTreeRoot;
    }

    // solhint-disable-next-line gas-small-strings
    string internal constant _WITNESS_TYPE_STRING = "Witness witness)Witness(bytes32 actionTreeRoot)";
}
