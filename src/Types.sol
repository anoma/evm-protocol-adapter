// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { TagLogicProofPair } from "./proving/Logic.sol";
import { ComplianceUnit } from "./proving/Compliance.sol";
import { TagAppDataPair } from "./libs/AppData.sol";
import { IWrapper } from "./interfaces/IWrapper.sol";

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
    TagLogicProofPair[] logicProofs;
    ComplianceUnit[] complianceUnits;
    TagAppDataPair[] tagAppDataPairs;
    KindFFICallPair[] kindFFICallPairs; // NOTE: This saves us from doing the subset check.
        // FFICall[] ffiCalls;
}

struct KindFFICallPair {
    bytes32 kind;
    FFICall ffiCall;
}

struct FFICall {
    IWrapper wrapperContract;
    //bytes4 functionSelector; // TODO add?
    bytes input;
    bytes output;
}
