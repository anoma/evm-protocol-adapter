// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "./Compliance.sol";
import {Logic} from "./Logic.sol";

/// @title Aggregation
/// @author Anoma Foundation, 2025
/// @notice A library containing type definitions of the aggregation proving system.
/// @custom:security-contact security@anoma.foundation
library Aggregation {
    /// @notice An instance struct containing aggregated instances of all resources and compliance
    /// units in a given transaction.
    /// @param loficRefs The logic references of all resources in a transaction.
    /// @param complianceInstances The aggregated compliance instances of a transaction.
    /// @param logicInstances The instances for checking logic proofs in a transaction.
    struct Instance {
        bytes32[] logicRefs;
        Compliance.Instance[] complianceInstances;
        Logic.Instance[] logicInstances;
    }

    /// @notice The aggregation verifying key.
    /// @dev The key is fixed as long as the aggregation circuit binary is not changed.
    bytes32 internal constant _VERIFYING_KEY = 0x5fa611e4c78bd728efdd65f356ac9a89b3beab18e5ecd414ea9ef6750595279a;
}
