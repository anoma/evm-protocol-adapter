// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Aggregation
/// @author Anoma Foundation, 2025
/// @notice A library containing type definitions of the aggregation proving system.
/// @custom:security-contact security@anoma.foundation
library Aggregation {
    /// @notice The aggregation verifying key.
    /// @dev The key is fixed as long as the aggregation circuit binary is not changed.
    bytes32 internal constant _VERIFYING_KEY = 0x70fd3ecf35047fe9c86ff4167530b154049dda93fd7e78b65a80c57f1132b8af;
}
