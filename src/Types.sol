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
    bytes32[] roots;
    Action[] actions;
    bytes deltaProof;
}

struct Action {
    bytes32[] commitments;
    bytes32[] nullifiers;
    Map.KeyValuePair[] logicProofs;
    ComplianceUnit[] complianceUnits;
    Map.KeyValuePair[] appData;
}

struct DeltaInstance {
    bytes32 delta; // DeltaHash
    uint256 expectedBalance; // Balance
}

struct LogicInstance {
    bytes32 tag;
    bool isConsumed;
    bytes32[] consumed;
    bytes32[] created;
    Map.KeyValuePair[] appDataForTag; // TODO Revisit.
}

struct ComplianceInstance {
    ConsumedRefs[] consumed;
    CreatedRefs[] created;
    bytes32 unitDelta; // DeltaHash // TODO Is it 0?
}

struct LogicRefHashProofPair {
    bytes32 logicRefHash;
    bytes proof;
}

struct RefInstance {
    bool TODO_MISSING_DEFINITION;
}

struct VerifyingKey {
    bool TODO_MISSING_DEFINITION;
}

struct ComplianceUnit {
    uint256[] proof;
    ComplianceInstance refInstance; // TODO - use ref instance!
    VerifyingKey verifyingKey;
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

library LogicProofMap {
    error KeyNotFound(bytes32 key);
    error IndexOutBounds(uint256 index, uint256 max);

    struct TagLogicProofPair {
        bytes32 tag;
        LogicRefHashProofPair pair;
    }

    function lookup(
        TagLogicProofPair[] memory map,
        bytes32 tag
    )
        internal
        pure
        returns (bool success, LogicRefHashProofPair memory)
    {
        for (uint256 i = 0; i < map.length; i++) {
            if (map[i].tag == tag) {
                return (true, map[i].pair);
            }
        }
        return (false, LogicRefHashProofPair({ logicRefHash: bytes32(0), proof: bytes("") }));
    }

    function at(TagLogicProofPair[] memory map, uint256 index) internal pure returns (LogicRefHashProofPair memory) {
        uint256 lastIndex = map.length - 1;
        if (index > lastIndex) {
            revert IndexOutBounds({ index: index, max: lastIndex });
        }
        return map[index].pair;
    }
}
