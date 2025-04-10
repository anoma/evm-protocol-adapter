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
    ResourceForwarderCalldataPair[] resourceCalldataPairs;
}

struct ResourceForwarderCalldataPair {
    Resource carrier;
    ForwarderCalldata call;
}

/// @notice A data structure containing the input data to be forwarded to the untrusted forwarder contract and the anticipated output data.
/// @param untrustedForwarder The forwarder contract forwarding the call.
/// @param input The input data for the forwarded call that might or might not include the `bytes4` function selector.
/// @param output The anticipated output data from the forwarded call.
struct ForwarderCalldata {
    address untrustedForwarder;
    bytes input;
    bytes output;
}
