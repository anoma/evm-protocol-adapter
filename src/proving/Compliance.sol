// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

struct ComplianceUnit {
    bytes proof;
    ComplianceInstance instance;
    bytes32 verifyingKey;
}

struct ComplianceInstance {
    ConsumedRefs[] consumed;
    CreatedRefs[] created;
    uint256[2] unitDelta; // DeltaHash ? TODO
}

struct ConsumedRefs {
    bytes32 nullifierRef;
    bytes32 rootRef;
    bytes32 logicRef;
}

struct CreatedRefs {
    bytes32 commitmentRef;
    bytes32 logicRef;
}
