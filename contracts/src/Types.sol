// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Logic} from "./proving/Logic.sol";

/// @notice The resource object.
/// @param  logicRef The hash of the resource logic function.
/// @param  labelRef The hash of the resource label, which can contain arbitrary data.
/// @param  valueRef The hash of the resource value, which can contain arbitrary data.
/// @param  nullifierKeyCommitment The commitment to the nullifier key.
/// @param  quantity The quantity that the resource represents.
/// @param  nonce The nonce guaranteeing the resource uniqueness.
/// @param  randSeed The randomness seed that can be used to derive pseudo-randomness.
/// @param  ephemeral The resource ephemerality.
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

/// @notice The transaction object.
/// @param actions The list of actions to be executed.
/// @param deltaProof The proof for the transaction delta value.
struct Transaction {
    Action[] actions;
    bytes deltaProof;
}

/// @notice The action data structure.
/// @param logicProofs The logic proofs of each resource consumed or created in the action.
/// @param complianceUnits The compliance units comprising one consumed and one created resource, each.
/// @param resourceCalldataPairs A tuple of a resource object and a
struct Action {
    Logic.VerifierInput[] logicVerifierInputs;
    ComplianceUnit[] complianceUnits;
    ResourceForwarderCalldataPair[] resourceCalldataPairs;
}

/// @notice // TODO
/// @dev Since the compliance circuit ID (i.e., the verifying key) remains fixed,
/// it does not need to be passed as part of the transaction.
struct ComplianceUnit {
    bytes proof;
    ComplianceInstance instance;
}

// verifying key
// TOBIAS: PAComplianceUnit + erklärung

/// @notice The compliance instance containing data to verify the compliance unit.
/// @param consumed References associated with the consumed resource in the compliance unit.
/// @param created References associated with the created resource in the compliance unit.
/// @param unitDeltaX The x-coordinate of the delta value of this unit.
/// @param unitDeltaY The y-coordinate of the delta value of this unit.
struct ComplianceInstance {
    ConsumedRefs consumed;
    CreatedRefs created;
    bytes32 unitDeltaX;
    bytes32 unitDeltaY;
}

/// @notice References to resources consumed in a compliance instance.
/// @param nullifier The unique identifier nullifying the resource to prevent double-spending.
/// @param logicRef A reference to the logic function associated with the consumed resource.
/// @param commitmentTreeRoot The root of the commitment tree from which this resource is derived.
struct ConsumedRefs {
    bytes32 nullifier;
    bytes32 logicRef;
    bytes32 commitmentTreeRoot;
}

/// @notice References to resources created in a compliance instance.
/// @param commitment The commitment representing the newly created resource.
/// @param logicRef A reference to the logic function associated with the created resource.
struct CreatedRefs {
    bytes32 commitment;
    bytes32 logicRef;
}

/// @notice // TODO
/// @param carrier
/// @param call
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
