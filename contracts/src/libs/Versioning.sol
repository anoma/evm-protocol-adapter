// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Versioning
/// @author Anoma Foundation, 2025
/// @notice A library containing constants relevant to the protocol adapter versioning.
/// @custom:security-contact security@anoma.foundation
library Versioning {
    /// @notice The semantic version number of the Anoma protocol adapter.
    bytes32 internal constant _PROTOCOL_ADAPTER_VERSION = "1.1.0";

    /// @notice The RISC Zero verifier selector that the protocol adapter is associated with.
    bytes4 internal constant _RISC_ZERO_VERIFIER_SELECTOR = 0x73c457ba;
}
