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

struct Action {
    bytes32[] commitments;
    bytes32[] nullifiers;
    uint256[][] complianceProofs; // TODO Use bytes32? (StarkVerifier requires uint256[].)
    uint256[][] logicProofs; // TODO Use bytes32? (StarkVerifier requires uint256[].)
    Map.KeyValuePair[] appData;
}

struct Transaction {
    uint256 delta;
    bytes32[] roots;
    Action[] actions;
    uint256[] deltaProof; // TODO Use bytes32? (StarkVerifier requires uint256[].)
}

struct LogicInstance {
    bytes32 tag;
    bool isConsumed;
    bytes32[] consumed;
    bytes32[] created;
    Map.KeyValuePair[] appDataForTag; // TODO Revisit.
}
