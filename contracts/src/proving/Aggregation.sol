// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "./Compliance.sol";
import {Logic} from "./Logic.sol";

/// @title Aggregation
/// @author Anoma Foundation, 2025
/// @notice A library containing type definitions of the aggregation proving system.
/// @custom:security-contact security@anoma.foundation
library Aggregation {
    struct Instance {
        bytes32[] logicRefs;
        Compliance.Instance[] complianceInstances;
        Logic.Instance[] logicInstances;
    }

    /// @notice The aggregation verifying key.
    /// @dev The key is fixed as long as the aggregation circuit binary is not changed.
    bytes32 internal constant _VERIFYING_KEY = 0xa9c9a22ee9df47fd35ed2b319cd272c3f328a171ea04dab5e44ee15e33f5b9ce;
}
