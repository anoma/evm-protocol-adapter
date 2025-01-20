// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

struct ComplianceUnit {
    bytes proof;
    RefInstance refInstance; // TODO
    bytes32 verifyingKey; // TODO ask Yulia what this is? The latest root?
}

// TODO Can we deviate here for the EVM?
struct RefInstance {
    // ReferenceInstance is a modified PS.Instance structure in which some elements are replaced by their references. To get PS.Instance from ReferencedInstance the referenced structures must be dereferenced. The structures we assume to be referenced here are:
    // - CMtree roots (stored in transaction)
    // - commitments and nullifiers (stored in action)
    ComplianceInstance referencedComplianceInstance;
}

struct ComplianceInstance {
    ConsumedRefs[] consumed;
    CreatedRefs[] created;
    bytes32 unitDelta; // DeltaHash // TODO Is it 0?
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
