// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "./libs/proving/Compliance.sol";
import {Logic} from "./libs/proving/Logic.sol";

/// @notice The resource object constituting the atomic unit of state in the Anoma protocol.
/// @param  logicRef The hash of the resource logic function.
/// @param  labelRef The hash of the resource label, which can contain arbitrary data.
/// @param  valueRef The hash of the resource value, which can contain arbitrary data.
/// @param  nullifierKeyCommitment The commitment to the nullifier key.
/// @param  quantity The quantity that the resource represents.
/// @param  nonce The nonce guaranteeing the resource's uniqueness.
/// @param  randSeed The randomness seed that can be used to derive pseudo-randomness for applications.
/// @param  ephemeral The resource's ephemerality.
struct Resource {
    bytes32 logicRef;
    bytes32 labelRef;
    bytes32 valueRef;
    bytes32 nullifierKeyCommitment;
    bytes32 nonce;
    bytes32 randSeed;
    uint128 quantity;
    bool ephemeral;
}

/// @notice The transaction object containing all required data to conduct a RM state transition
/// in which resources get consumed and created.
/// @param actions The list of actions to be executed.
/// @param deltaProof The proof for the transaction delta value.
/// @param aggregationProof A recursive proof of all compliance and resource logics in the transaction.
struct Transaction {
    Action[] actions;
    bytes deltaProof;
    bytes aggregationProof;
}

/// @notice The action object providing context separation between non-intersecting sets of resources.
/// @param logicVerifierInputs The logic inputs of each resource consumed or created in the action.
/// @param complianceVerifierInputs The compliance units comprising one consumed and one created resource, each.
struct Action {
    Logic.VerifierInput[] logicVerifierInputs;
    Compliance.VerifierInput[] complianceVerifierInputs;
}
