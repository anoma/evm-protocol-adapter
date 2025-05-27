// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Compliance} from "./proving/Compliance.sol";
import {Logic} from "./proving/Logic.sol";

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
    uint256 quantity;
    uint256 nonce;
    uint256 randSeed;
    bool ephemeral;
}

/// @notice The transaction object containing all required data to conduct a RM state transition
/// in which resource get consumed and created.
/// @param actions The list of actions to be executed.
/// @param deltaProof The proof for the transaction delta value.
struct Transaction {
    Action[] actions;
    bytes deltaProof;
}

/// @notice The action object providing context separation between non-intersecting sets of resources.
/// @param logicProofs The logic proofs of each resource consumed or created in the action.
/// @param complianceVerifierInputs The compliance units comprising one consumed and one created resource, each.
/// @param resourceCalldataPairs The external calls
struct Action {
    Logic.VerifierInput[] logicVerifierInputs;
    Compliance.VerifierInput[] complianceVerifierInputs;
    ResourceForwarderCalldataPair[] resourceCalldataPairs;
}

/// @notice A tuple containing data to allow the protocol adapter to call external contracts
/// and to create and consume resources in correspondence to this external call.
/// @param carrier The carrier resource making the calldata available in the RM state space.
/// @param call The calldata containing in- and outputs of the external call being routed through a forwarder contract.
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
