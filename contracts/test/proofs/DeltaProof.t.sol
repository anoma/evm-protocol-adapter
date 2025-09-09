// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Test } from "forge-std/Test.sol";
import { VmSafe } from "forge-std/Vm.sol";
import { Delta } from "./../../src/proving/Delta.sol";
import { Transaction } from "./../../src/Types.sol";
import {TransactionExample} from "../examples/Transaction.e.sol";
import {TxGen} from "../examples/TxGen.sol";

contract DeltaProofTest is Test {
    // The parameters required to generate a delta instance
    struct DeltaInstanceInputs {
        // The identifier of the asset
        uint256 kind;
        // The quantity of the asset
        int256 quantity;
        // Value commitment randomness
        uint256 rcv;
    }

    // The parameters required to generate a delta proof
    struct DeltaProofInputs {
        // Value commitment randomness
        uint256 rcv;
        // The hash being signed over
        bytes32 verifyingKey;
    }

    /// @notice Convert a int256 exponent to an equivalent uin256 assuming an order of SECP256K1_ORDER
    function canonize_quantity(int256 quantity) public pure returns (uint256 quantityu) {
        // If positive, leave the number unchanged
        quantityu = quantity >= 0 ? uint256(quantity) : (SECP256K1_ORDER - 1 - (uint256(-(quantity + 1)) % SECP256K1_ORDER));
    }

    /// @notice Generates a transaction delta proof by signing verifyingKey with
    /// rcv, and a delta instance by computing a(kind)^quantity * b^rcv
    function generateDeltaInstance(DeltaInstanceInputs memory deltaInputs) public returns (uint256[2] memory instance) {
        deltaInputs.rcv = deltaInputs.rcv % SECP256K1_ORDER;
        vm.assume(deltaInputs.rcv != 0);
        vm.assume(deltaInputs.kind != 0);
        uint256 quantity = canonize_quantity(deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.rcv, SECP256K1_ORDER);
        vm.assume(preDelta != 0);
        // Derive address and public key from transaction delta
        VmSafe.Wallet memory valueWallet = vm.createWallet(preDelta);
        // Extract the transaction delta from the wallet
        instance[0] = valueWallet.publicKeyX;
        instance[1] = valueWallet.publicKeyY;
    }

    function generateDeltaProof(DeltaProofInputs memory deltaInputs) public returns (bytes memory proof) {
        deltaInputs.rcv = deltaInputs.rcv % SECP256K1_ORDER;
        vm.assume(deltaInputs.rcv != 0);
        // Compute the components of the transaction delta proof
        VmSafe.Wallet memory randomWallet = vm.createWallet(deltaInputs.rcv);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(randomWallet, deltaInputs.verifyingKey);
        // Finally compute the transaction delta proof
        proof = abi.encodePacked(r, s, v);
    }

    /// @notice Test that Delta.verify accepts a well-formed delta proof and instance
    function test_verify_delta_succeeds(DeltaInstanceInputs memory deltaInstanceInputs, DeltaProofInputs memory deltaProofInputs) public {
        // Generate a delta proof and instance from the above tags and preimage
        deltaInstanceInputs.quantity = 0;
        deltaProofInputs.rcv = deltaInstanceInputs.rcv;
        uint256[2] memory instance = generateDeltaInstance(deltaInstanceInputs);
        bytes memory proof = generateDeltaProof(deltaProofInputs);
        // Verify that the generated delta proof is valid
        Delta.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    /// @notice Test that Delta.add correctly adds deltas
    function test_add_delta_correctness(DeltaInstanceInputs memory deltaInputs1, DeltaInstanceInputs memory deltaInputs2) public {
        // Ensure that we're adding assets of the same kind over the same verifying key
        deltaInputs2.kind = deltaInputs1.kind;
        // Filter out overflows
        vm.assume(deltaInputs1.quantity < 0 || deltaInputs2.quantity <= type(int256).max - deltaInputs1.quantity);
        vm.assume(deltaInputs1.quantity >= 0 || type(int256).min - deltaInputs1.quantity <= deltaInputs2.quantity);
        vm.assume(0 < deltaInputs2.rcv && deltaInputs2.rcv <= type(uint256).max - deltaInputs1.rcv);
        // Compute the inputs corresponding to the sum of deltas
        DeltaInstanceInputs memory deltaInputs3 = DeltaInstanceInputs({
            kind: deltaInputs1.kind,
            quantity: deltaInputs1.quantity + deltaInputs2.quantity,
            rcv: deltaInputs1.rcv + deltaInputs2.rcv
        });
        // Generate a delta proof and instance from the above tags and preimage
        uint256[2] memory instance1 = generateDeltaInstance(deltaInputs1);
        uint256[2] memory instance2 = generateDeltaInstance(deltaInputs2);
        uint256[2] memory instance3 = generateDeltaInstance(deltaInputs3);
        // Verify that the deltas add correctly
        uint256[2] memory instance4 = Delta.add(instance1, instance2);
        assertEq(instance3[0], instance4[0]);
        assertEq(instance3[1], instance4[1]);
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function test_verify_inconsistent_delta_fails1(DeltaInstanceInputs memory deltaInstanceInputs, DeltaProofInputs memory deltaProofInputs) public {
        // Filter out inadmissible private keys or equal keys
        deltaProofInputs.rcv = deltaInstanceInputs.rcv;
        vm.assume(deltaInstanceInputs.kind % SECP256K1_ORDER != 0);
        vm.assume(canonize_quantity(deltaInstanceInputs.quantity) != 0);
        // Generate a delta proof and instance from the above tags and preimage
        uint256[2] memory instance = generateDeltaInstance(deltaInstanceInputs);
        bytes memory proof = generateDeltaProof(deltaProofInputs);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function test_verify_inconsistent_delta_fails2(DeltaProofInputs memory deltaInputs1, DeltaInstanceInputs memory deltaInputs2) public {
        deltaInputs2.quantity = 0;
        // Filter out inadmissible private keys or equal keys
        vm.assume((deltaInputs1.rcv % SECP256K1_ORDER) != (deltaInputs2.rcv % SECP256K1_ORDER));
        // Generate a delta proof and instance from the above tags and preimage
        bytes memory proof1 = generateDeltaProof(deltaInputs1);
        uint256[2] memory instance2 = generateDeltaInstance(deltaInputs2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: deltaInputs1.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to the verifying key
    function test_verify_inconsistent_delta_fails3(DeltaProofInputs memory deltaInputs1, DeltaInstanceInputs memory deltaInputs2, bytes32 verifyingKey) public {
        deltaInputs2.rcv = deltaInputs1.rcv;
        deltaInputs2.quantity = 0;
        // Filter out inadmissible private keys or equal keys
        vm.assume(deltaInputs1.verifyingKey != verifyingKey);
        // Generate a delta proof and instance from the above tags and preimage
        bytes memory proof1 = generateDeltaProof(deltaInputs1);
        uint256[2] memory instance2 = generateDeltaInstance(deltaInputs2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: verifyingKey});
    }

    /// @notice Check that a balanced transaction does pass verification
    function test_verify_balanced_delta_succeeds(DeltaInstanceInputs[] memory deltaInputs, bytes32 verifyingKey) public {
        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];
        // Truncate the delta inputs to improve test performance
        uint256 maxDeltaLen = 10;
        deltaInputs = truncateDeltaInputs(deltaInputs, deltaInputs.length % maxDeltaLen);
        // Make sure that the delta quantities balance out
        (DeltaInstanceInputs[] memory wrappedDeltaInputs, int256 quantity, uint256 rcv) = wrapDeltaInputs(deltaInputs);
        // Adjust the last delta so that the full sum is zero
        if(quantity != 0) {
            wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity -= quantity;
        }
        for(uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            uint256[2] memory instance = generateDeltaInstance(wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }
        // Compute the proof for the balanced transaction
        DeltaProofInputs memory sumDeltaInputs = DeltaProofInputs({
            rcv: rcv,
            verifyingKey: verifyingKey
            });
        bytes memory proof = generateDeltaProof(sumDeltaInputs);
        // Verify that the balanced transaction proof succeeds
        Delta.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
    }

    /// @notice Check that an imbalanced transaction fails verification
    function test_verify_imbalanced_delta_fails(DeltaInstanceInputs[] memory deltaInputs, bytes32 verifyingKey) public {
        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];
        // Truncate the delta inputs to improve test performance
        uint256 maxDeltaLen = 10;
        deltaInputs = truncateDeltaInputs(deltaInputs, deltaInputs.length % maxDeltaLen);
        // Accumulate the total quantity and randomness commitment
        (DeltaInstanceInputs[] memory wrappedDeltaInputs, int256 quantity, uint256 rcv) = wrapDeltaInputs(deltaInputs);
        // Assume that the deltas are imbalanced
        vm.assume(canonize_quantity(quantity) != 0);
        for(uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            uint256[2] memory instance = generateDeltaInstance(wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }
        // Compute the proof for the balanced transaction
        DeltaProofInputs memory sumDeltaInputs = DeltaProofInputs({
            rcv: rcv,
            verifyingKey: verifyingKey
            });
        bytes memory proof = generateDeltaProof(sumDeltaInputs);
        // Verify that the imbalanced transaction proof fails
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
    }

    /// @notice Wrap the delta inputs in such a way that they can be balanced
    /// and also return the total quantity and value commitment randomness
    function wrapDeltaInputs(DeltaInstanceInputs[] memory deltaInputs) public pure returns (DeltaInstanceInputs[] memory wrappedDeltaInputs, int256 quantityAcc, uint256 rcvAcc) {
        // Compute the window into which the deltas should sum
        int256 halfMax = type(int256).max >> 1;
        int256 halfMin = type(int256).min >> 1;
        // Track the current quantity and value commitment randomness
        quantityAcc = 0;
        rcvAcc = 0;
        if (deltaInputs.length == 0) {
            return (deltaInputs, quantityAcc, rcvAcc);
        }
        // Grab the kind to use for all deltas
        uint256 kind = deltaInputs[0].kind;
        vm.assume(deltaInputs[0].kind % SECP256K1_ORDER != 0);
        // Wrap the deltas
        for(uint256 i = 0; i < deltaInputs.length; i++) {
            // Ensure that all the deltas have the same kind
            deltaInputs[i].kind = kind;
            // Accumulate the randomness commitments modulo SECP256K1_ORDER
            rcvAcc = addmod(rcvAcc, deltaInputs[i].rcv, SECP256K1_ORDER);
            // Adjust the delta inputs so that the sum remains in a specific range
            if(deltaInputs[i].quantity >= 0 && quantityAcc > halfMax - deltaInputs[i].quantity) {
                int256 overflow = quantityAcc - (halfMax - deltaInputs[i].quantity);
                deltaInputs[i].quantity = halfMin + overflow - 1 - quantityAcc;
            } else if(deltaInputs[i].quantity < 0 && quantityAcc < halfMin - deltaInputs[i].quantity) {
                int256 underflow = (halfMin - deltaInputs[i].quantity) - quantityAcc;
                deltaInputs[i].quantity = halfMax + 1 - underflow - quantityAcc;
            }
            // Finally, accumulate the adjusted quantity
            quantityAcc += deltaInputs[i].quantity;
        }
        // Finally, return tbe wrapped deltas
        wrappedDeltaInputs = deltaInputs;
    }

    /// @notice Grab the first length elements from deltaInputs
    function truncateDeltaInputs(DeltaInstanceInputs[] memory deltaInputs, uint256 length) public pure returns (DeltaInstanceInputs[] memory truncatedDeltaInputs) {
        truncatedDeltaInputs = new DeltaInstanceInputs[](length);
        for(uint256 i = 0; i < length; i++) {
            truncatedDeltaInputs[i] = deltaInputs[i];
        }
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
