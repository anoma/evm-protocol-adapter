// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library Compliance {
    bytes32 internal constant _CIRCUIT_ID = 0x7004946d81df7a5c47b7d3b8359654e9bb81190f0705be69d54f15391fff2248;

    /// @notice // TODO
    /// @dev Since the compliance circuit ID (i.e., the verifying key) remains fixed,
    /// it does not need to be passed as part of the transaction.
    struct Unit {
        bytes proof;
        Instance instance;
    }

    // verifying key
    // TOBIAS: PACompliance.Unit + erklärung

    /// @notice The compliance instance containing data to verify the compliance unit.
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

    /// @notice References to resources consumed in a compliance instance.
    /// @param nullifier The unique identifier nullifying the resource to prevent double-spending.
    /// @param logicRef A reference to the logic function associated with the consumed resource.
    /// @param commitmentTreeRoot The root of the commitment tree from which this resource is derived.
    struct ConsumedRefs {
        bytes32 nullifier;
        bytes32 logicRef;
        bytes32 commitmentTreeRoot;
    }

    /// @notice References to resources created in a compliance instance.
    /// @param commitment The commitment representing the newly created resource.
    /// @param logicRef A reference to the logic function associated with the created resource.
    struct CreatedRefs {
        bytes32 commitment;
        bytes32 logicRef;
    }
}
