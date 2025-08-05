// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ECDSA } from "@openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import { Test } from "forge-std/Test.sol";
import { VmSafe } from "forge-std/Vm.sol";
import { Delta } from "./../../src/proving/Delta.sol";
import { Transaction } from "./../../src/Types.sol";
import {TransactionExample} from "../examples/Transaction.e.sol";
import {TxGen} from "../examples/TxGen.sol";
import {VmSafe} from "forge-std/Vm.sol";

contract DeltaProofTest is Test {
    struct DeltaInputs {
        uint128 kind;
        int128 quantity;
        uint256 rcv;
        bytes32 verifyingKey;
    }

    /// @notice Generates a transaction delta proof by signing verifyingKey with
    /// rcv, and a delta instance by computing a(kind)^quantity * b^rcv
    function generateDelta(DeltaInputs memory deltaInputs) public returns (bytes memory proof, uint256[2] memory instance) {
        deltaInputs.rcv = deltaInputs.rcv % SECP256K1_ORDER;
        vm.assume(deltaInputs.rcv != 0);
        vm.assume(deltaInputs.kind != 0);
        int256 prod_aux = (int256(uint256(deltaInputs.kind)) * int256(deltaInputs.quantity));
        uint256 prod = prod_aux >= 0 ? uint256(prod_aux) % SECP256K1_ORDER : SECP256K1_ORDER - (uint256(-prod_aux) % SECP256K1_ORDER);
        vm.assume(prod < SECP256K1_ORDER - deltaInputs.rcv);
        uint256 preDelta = (prod + deltaInputs.rcv) % SECP256K1_ORDER;
        vm.assume(preDelta != 0);
        // Derive address and public key from transaction delta
        VmSafe.Wallet memory valueWallet = vm.createWallet(preDelta);
        // Extract the transaction delta from the wallet
        instance[0] = valueWallet.publicKeyX;
        instance[1] = valueWallet.publicKeyY;
        // Compute the components of the transaction delta proof
        VmSafe.Wallet memory randomWallet = vm.createWallet(deltaInputs.rcv);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(randomWallet, deltaInputs.verifyingKey);
        // Finally compute the transaction delta proof
        proof = abi.encodePacked(r, s, v);
    }

    /// @notice Test that Delta.verify accepts a well-formed delta proof and instance
    function test_verify_delta_succeeds(DeltaInputs memory deltaInputs) public {
        // Generate a delta proof and instance from the above tags and preimage
        deltaInputs.quantity = 0;
        (bytes memory proof, uint256[2] memory instance) = generateDelta(deltaInputs);
        // Verify that the generated delta proof is valid
        Delta.verify({proof: proof, instance: instance, verifyingKey: deltaInputs.verifyingKey});
    }

    /// @notice Test that Delta.add correctly adds deltas
    function test_add_delta_correctness(DeltaInputs memory deltaInputs1, DeltaInputs memory deltaInputs2) public {
        // Ensure that we're adding assets of the same kind over the same verifying key
        deltaInputs2.kind = deltaInputs1.kind;
        deltaInputs2.verifyingKey = deltaInputs1.verifyingKey;
        // Filter out overflows
        vm.assume(deltaInputs1.quantity < 0 || deltaInputs2.quantity <= type(int128).max - deltaInputs1.quantity);
        vm.assume(deltaInputs1.quantity >= 0 || type(int128).min - deltaInputs1.quantity <= deltaInputs2.quantity);
        vm.assume(0 < deltaInputs2.rcv && deltaInputs2.rcv <= type(uint256).max - deltaInputs1.rcv);
        // Compute the inputs corresponding to the sum of deltas
        DeltaInputs memory deltaInputs3 = DeltaInputs({
            kind: deltaInputs1.kind,
            quantity: deltaInputs1.quantity + deltaInputs2.quantity,
            rcv: deltaInputs1.rcv + deltaInputs2.rcv,
            verifyingKey: deltaInputs1.verifyingKey
            });
        // Generate a delta proof and instance from the above tags and preimage
        (, uint256[2] memory instance1) = generateDelta(deltaInputs1);
        (, uint256[2] memory instance2) = generateDelta(deltaInputs2);
        (, uint256[2] memory instance3) = generateDelta(deltaInputs3);
        // Verify that the deltas add correctly
        uint256[2] memory instance4 = Delta.add(instance1, instance2);
        assertEq(instance3[0], instance4[0]);
        assertEq(instance3[1], instance4[1]);
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function test_verify_inconsistent_delta_fails1(DeltaInputs memory deltaInputs) public {
        // Filter out inadmissible private keys or equal keys
        vm.assume(deltaInputs.kind != 0);
        vm.assume(deltaInputs.quantity != 0);
        // Generate a delta proof and instance from the above tags and preimage
        (bytes memory proof, uint256[2] memory instance) = generateDelta(deltaInputs);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof, instance: instance, verifyingKey: deltaInputs.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function test_verify_inconsistent_delta_fails2(DeltaInputs memory deltaInputs1, DeltaInputs memory deltaInputs2) public {
        deltaInputs2.verifyingKey = deltaInputs1.verifyingKey;
        deltaInputs2.kind = deltaInputs1.kind;
        deltaInputs2.quantity = deltaInputs1.quantity;
        // Filter out inadmissible private keys or equal keys
        vm.assume(deltaInputs1.rcv != deltaInputs2.rcv);
        // Generate a delta proof and instance from the above tags and preimage
        (bytes memory proof1, ) = generateDelta(deltaInputs1);
        (, uint256[2] memory instance2) = generateDelta(deltaInputs2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: deltaInputs1.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to the verifying key
    function test_verify_inconsistent_delta_fails3(DeltaInputs memory deltaInputs1, DeltaInputs memory deltaInputs2) public {
        deltaInputs2.kind = deltaInputs1.kind;
        deltaInputs2.quantity = deltaInputs1.quantity;
        deltaInputs2.rcv = deltaInputs1.rcv;
        // Filter out inadmissible private keys or equal keys
        vm.assume(deltaInputs1.verifyingKey != deltaInputs2.verifyingKey);
        // Generate a delta proof and instance from the above tags and preimage
        (bytes memory proof1, ) = generateDelta(deltaInputs1);
        (, uint256[2] memory instance2) = generateDelta(deltaInputs2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: deltaInputs2.verifyingKey});
    }

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
