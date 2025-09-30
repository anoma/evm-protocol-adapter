// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Aggregation
/// @author Anoma Foundation, 2025
/// @notice A library containing type definitions of the aggregation proving system.
/// @custom:security-contact security@anoma.foundation
library Aggregation {
    struct Instance {
        bytes packedComplianceProofJournals;
        bytes packedLogicProofJournals;
        bytes32[] logicRefs;
    }

    /// @notice The aggregation verifying key.
    /// @dev The key is fixed as long as the aggregation circuit binary is not changed.
    bytes32 internal constant _VERIFYING_KEY = 0x96dcbee66a8780979442bd2abc2f7373957e450336f377704041ba6f9b95ff6a;
}
