// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { TagAppDataPair } from "./libs/AppData.sol";
import { ComplianceUnit } from "./proving/Compliance.sol";
import { TagLogicProofPair } from "./proving/Logic.sol";

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
    address untrustedWrapperContract;
    //bytes4 functionSelector; // TODO add?
    bytes input;
    bytes output;
}
