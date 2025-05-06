// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

enum DeletionCriterion {
    Immediately,
    Never
}

struct ExpirableBlob {
    DeletionCriterion deletionCriterion;
    bytes blob;
}

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

struct LogicInstance {
    bytes32 tag;
    bool isConsumed;
    bytes32[] consumed;
    bytes32[] created;
    ExpirableBlob tagSpecificAppData;
}

struct TagLogicProofPair {
    bytes32 tag;
    LogicRefProofPair pair;
}

struct LogicRefProofPair {
    bytes32 logicRef;
    bytes proof;
}

struct ComplianceUnit {
    bytes proof;
    ComplianceInstance instance;
    bytes32 verifyingKey;
}

struct ComplianceInstance {
    ConsumedRefs consumed;
    CreatedRefs created;
    uint256[2] unitDelta;
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

struct ResourceForwarderCalldataPair {
    Resource carrier;
    ForwarderCalldata call;
}

/// @notice A data structure containing the input data to be forwarded to the untrusted forwarder contract
/// and the anticipated output data.
/// @param untrustedForwarder The forwarder contract forwarding the call.
/// @param input The input data for the forwarded call that might or might not include the `bytes4` function selector.
/// @param output The anticipated output data from the forwarded call.
struct ForwarderCalldata {
    address untrustedForwarder;
    bytes input;
    bytes output;
}

struct TagAppDataPair {
    bytes32 tag;
    ExpirableBlob appData;
}
