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
    Action[] actions;
    // DeltaProof deltaProof
    bytes deltaProof;
}

struct Action {
    LogicProof[] logicProofs;
    ComplianceUnit[] complianceUnits;
    ResourceForwarderCalldataPair[] resourceCalldataPairs;
}

struct LogicProof {
    bytes proof;
    LogicInstance instance;
    bytes32 logicRef; // logicVerifyingKeyOuter;
}

/// @param ciphertext Encrypted information for the receiver of the resource that will be emitted as an event. The ciphertext contains, at least, the resource plaintext and optional other application specific data.
struct LogicInstance {
    bytes32 tag;
    bool isConsumed;
    bytes32 root;
    bytes ciphertext;
    ExpirableBlob[] appData;
}

struct ComplianceUnit {
    bytes proof;
    ComplianceInstance instance;
}

struct ComplianceInstance {
    ConsumedRefs consumed;
    CreatedRefs created;
    uint256[2] unitDelta;
}

struct ConsumedRefs {
    bytes32 nullifier;
    bytes32 root;
    bytes32 logicRef;
}

struct CreatedRefs {
    bytes32 commitment;
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
