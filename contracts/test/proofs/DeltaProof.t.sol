// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Delta} from "../../src/proving/Delta.sol";
import {Transaction} from "../../src/Types.sol";
import {TransactionExample} from "../examples/Transaction.e.sol";
import {TxGen} from "../examples/TxGen.sol";

contract DeltaProofTest is Test {
    function test_verify_example_delta_proof() public pure {
        Transaction memory txn = TransactionExample.transaction();

        Delta.verify({
            proof: txn.deltaProof,
            instance: [
                uint256(txn.actions[0].complianceVerifierInputs[0].instance.unitDeltaX),
                uint256(txn.actions[0].complianceVerifierInputs[0].instance.unitDeltaY)
            ],
            verifyingKey: Delta.computeVerifyingKey(TxGen.collectTags(txn.actions))
        });
    }
}
