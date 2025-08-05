// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ECDSA} from "@openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import {Test} from "forge-std/Test.sol";

import {Delta} from "../../src/proving/Delta.sol";
import {Transaction} from "../../src/Types.sol";
import {TransactionExample} from "../examples/Transaction.e.sol";
import {DeltaMock} from "../mocks/Delta.m.sol";

contract DeltaProofTest is Test {
    function test_signatureIntegrity() public pure {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(DeltaMock.SIGNER_PRIVATE_KEY, DeltaMock.MESSAGE_HASH);
        assertEq(r, DeltaMock.R);
        assertEq(s, DeltaMock.S);
        assertEq(v, DeltaMock.V);
    }

    function test_signatureRecovery() public pure {
        address recovered = ECDSA.recover({hash: DeltaMock.MESSAGE_HASH, signature: DeltaMock.PROOF});
        assertEq(recovered, DeltaMock.SIGNER_ACCOUNT);
    }

    function test_verify_mock_delta_proof() public pure {
        Delta.verify({
            proof: DeltaMock.PROOF,
            instance: DeltaMock.transactionDelta(),
            verifyingKey: DeltaMock.MESSAGE_HASH
        });
    }

    function test_verify_example_delta_proof() public pure {
        bytes32[] memory tags = new bytes32[](2);
        tags[0] = TransactionExample._CONSUMED_NULLIFIER;
        tags[1] = TransactionExample._CREATED_COMMITMENT;

        Transaction memory txn = TransactionExample.transaction();

        uint256[2] memory transactionDelta = [
            uint256(txn.actions[0].complianceVerifierInputs[0].instance.unitDeltaX),
            uint256(txn.actions[0].complianceVerifierInputs[0].instance.unitDeltaY)
        ];

        Delta.verify({proof: txn.deltaProof, instance: transactionDelta, verifyingKey: Delta.computeVerifyingKey(tags)});
    }
}
