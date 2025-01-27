// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

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
    bytes32 wrapperContractLogicRef;
    bytes32 wrapperContractResourceKind; // TODO needed?
    address wrapperContract;
    bytes4 functionSelector;
    bytes input;
}

struct FFICall {
    bytes4 functionSelector;
    bytes input;
    bytes output; // Must be predictable, if resource logics want to depend on it, so that proves can be conducted beforehand.
}
// TODO input format + output format?

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
    AppDataMap.TagAppDataPair[] tagAppDataPairs;
    EVMCall[] evmCalls;
}

library TagSet {
    function contains(bytes32[] memory set, bytes32 tag) internal pure returns (bool success) {
        for (uint256 i = 0; i < set.length; i++) {
            if (set[i] == tag) {
                return true;
            }
        }
        return false;
    }
}
