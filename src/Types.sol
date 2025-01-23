// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { LogicProofMap } from "./proving/Logic.sol";
import { ComplianceUnit } from "./proving/Compliance.sol";

import { AppDataMap } from "./libs/AppData.sol";

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

struct EVMCall {
    address to;
    bytes data;
}

struct Transaction {
    bytes32[] roots;
    Action[] actions;
    bytes deltaProof; // => DeltaInstance
    EVMCall[] evmCalls;
}

struct Action {
    bytes32[] commitments;
    bytes32[] nullifiers;
    LogicProofMap.TagLogicProofPair[] logicProofs;
    ComplianceUnit[] complianceUnits;
    AppDataMap.TagAppDataPair[] tagAppDataPairs;
}
