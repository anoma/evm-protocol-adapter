// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Map } from "./libs/Map.sol";

struct Resource {
    bytes32 logicRef;
    bytes32 labelRef;
    bytes32 valueRef;
    bytes32 nullifierKeyCommitment;
    uint256 quantity;
    uint256 nonce;
    uint256 randSeed;
    bool ephemeral;
}

struct Transaction {
    uint256 delta;
    bytes32[] roots;
    Action[] actions;
    uint256[] deltaProof;
}

struct Action {
    bytes32[] commitments;
    bytes32[] nullifiers;
    Map.KeyValuePair[] logicProofs;
    uint256[][] complianceProofs;
    Map.KeyValuePair[] appData;
}

struct LogicRefHashProofPair {
    bytes32 logicRefHash;
    uint256[] proof;
}

struct LogicInstance {
    bytes32 tag;
    bool isConsumed;
    bytes32[] consumed;
    bytes32[] created;
    Map.KeyValuePair[] appDataForTag; // TODO Revisit.
}

struct RefInstance {
    bool TODO_MISSING_DEFINITION;
}

struct VerifyingKey {
    bool TODO_MISSING_DEFINITION;
}

struct ComplianceUnit {
    uint256[] proof;
    RefInstance refInstance;
    VerifyingKey verifyingKey;
}

struct ComplianceInstance {
    ConsumedRefs[] consumed;
    CreatedRefs[] created;
    bytes32 unitDelta; // DeltaHash // TODO Is it 0?
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
