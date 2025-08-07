// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "./proving/Compliance.sol";
import {Logic} from "./proving/Logic.sol";

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

struct Action {
    Logic.VerifierInput[] logicVerifierInputs;
    Compliance.VerifierInput[] complianceVerifierInputs;
}
