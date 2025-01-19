// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Map } from "./libs/Map.sol";

import { LogicProofMap } from "./ProvingSystem/Logic.sol";
import { ComplianceUnit } from "./ProvingSystem/Compliance.sol";
import { DeltaInstance } from "./ProvingSystem/Delta.sol";

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
    bytes deltaProof; // => DeltaInstance
}

struct Action {
    bytes32[] commitments;
    bytes32[] nullifiers;
    LogicProofMap.TagLogicProofPair[] logicProofs;
    ComplianceUnit[] complianceUnits;
    Map.KeyValuePair[] appData;
}
