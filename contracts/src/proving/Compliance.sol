// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Compliance
/// @author Anoma Foundation, 2025
/// @notice A library containing type definitions of the compliance proving system.
/// @custom:security-contact security@anoma.foundation
library Compliance {
    /// @notice The compliance instance containing the data required to verify the compliance unit.
    /// @param consumed References associated with the consumed resource in the compliance unit.
    /// @param created References associated with the created resource in the compliance unit.
    /// @param unitDeltaX The x-coordinate of the delta value of this unit.
    /// @param unitDeltaY The y-coordinate of the delta value of this unit.
    struct Instance {
        ConsumedRefs consumed;
        CreatedRefs created;
        bytes32 unitDeltaX;
        bytes32 unitDeltaY;
    }

    /// @notice A struct containing references associated with the consumed resource of the compliance unit.
    /// @param nullifier The nullifier t associated with the resource.
    /// @param logicRef A reference to the logic function associated with the consumed resource.
    /// @param commitmentTreeRoot The root of the commitment tree from which this resource is derived.
    struct ConsumedRefs {
        bytes32 nullifier;
        bytes32 logicRef;
        bytes32 commitmentTreeRoot;
    }

    /// @notice A struct containing references associated with the created resource of the compliance unit.
    /// @param commitment The commitment associated with the resource.
    /// @param logicRef The reference to the logic function associated with the created resource.
    struct CreatedRefs {
        bytes32 commitment;
        bytes32 logicRef;
    }

    /// @notice A struct containing all information required to verify a compliance unit.
    /// @param proof The compliance proof.
    /// @param instance The instance to the compliance proof.
    /// @dev Since the verifying key (i.e., the compliance circuit ID) is fixed, it is hard coded below.
    struct VerifierInput {
        bytes proof;
        Instance instance;
    }

    /// @notice The compliance verifying key.
    /// @dev The key is fixed as long as the compliance circuit binary is not changed.
    bytes32 internal constant _VERIFYING_KEY = 0xab5a67860b67f0bc448c1ac55d71561e837601a85591581055cf80e216ddc216;
}
