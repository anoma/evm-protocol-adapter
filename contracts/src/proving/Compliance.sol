// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Compliance
/// @author Anoma Foundation, 2025
/// @notice A library containing type definitions and verifying key of the compliance proving system.
/// @custom:security-contact security@anoma.foundation
library Compliance {
    /// @notice The compliance instance containing the data required to verify the compliance unit being constituted by
    /// one consumed and one created resource.
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
    /// @param nullifier The nullifier associated with the resource.
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
    /// @dev Since the verifying key (i.e., the compliance circuit ID) is fixed, it is hardcoded below.
    struct VerifierInput {
        bytes proof;
        Instance instance;
    }

    /// @notice The compliance verifying key.
    /// @dev The key is fixed as long as the compliance circuit binary is not changed.
    /// The compliance circuit should ensure that the created resources use the consumed resource's nullifier
    /// as nonce.
    bytes32 internal constant _VERIFYING_KEY = 0x2652d58ac2fba40aa5811adf2cee2314c4dc2168ae93dab069c8eb7496107c99;
}
