// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

struct ComplianceUnit {
    bytes32 verifyingKey;
    ComplianceInstance instance;
    bytes proof;
}

struct ComplianceInstance {
    ConsumedRefs consumed;
    CreatedRefs created;
    uint256[2] unitDelta;
}

struct ConsumedRefs {
    bytes32 nullifier;
    bytes32 rootRef;
    bytes32 logicRef;
}

struct CreatedRefs {
    bytes32 commitment;
    bytes32 logicRef;
}
