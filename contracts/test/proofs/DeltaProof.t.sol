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
    /// @notice Generates a transaction delta proof and delta
    /// @param preDelta The input/preimage to the delta hash
    /// @param verifyingKey The bytes being authorized
    function generateDelta(uint256 preDelta, bytes32 verifyingKey) public returns (bytes memory proof, uint256[2] memory instance) {
        // Derive address and public key from transaction delta
        VmSafe.Wallet memory wallet = vm.createWallet(preDelta);
        // Extract the transaction delta from the wallet
        instance[0] = wallet.publicKeyX;
        instance[1] = wallet.publicKeyY;
        // Compute the components of the transaction delta proof
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(wallet, verifyingKey);
        // Finally compute the transaction delta proof
        proof = abi.encodePacked(r, s, v);
    }

    /// @notice Test that Delta.verify accepts a well-formed delta proof and instance
    /// @param preDelta The input/preimage to the delta hash
    function test_verify_delta_succeeds(uint256 preDelta, bytes32 verifyingKey) public {
        // Filter out inadmissible private keys
        vm.assume(0 < preDelta && preDelta < SECP256K1_ORDER);
        // Generate a delta proof and instance from the above tags and preimage
        (bytes memory proof, uint256[2] memory instance) = generateDelta(preDelta, verifyingKey);
        // Verify that the generated delta proof is valid
        Delta.verify({proof: proof, instance: instance, verifyingKey: verifyingKey});
    }

    /// @notice Test that Delta.add correctly adds deltas
    /// @param preDelta1 The input/preimage to the first delta hash
    /// @param preDelta2 The input/preimage to the second delta hash
    function test_add_delta_correctness(uint256 preDelta1, uint256 preDelta2, bytes32 verifyingKey) public {
        // Filter out inadmissible private keys
        vm.assume(0 < preDelta1 && preDelta1 < SECP256K1_ORDER);
        vm.assume(0 < preDelta2 && preDelta2 < SECP256K1_ORDER - preDelta1);
        uint256 preDelta3 = preDelta1 + preDelta2;
        // Generate a delta proof and instance from the above tags and preimage
        (, uint256[2] memory instance1) = generateDelta(preDelta1, verifyingKey);
        (, uint256[2] memory instance2) = generateDelta(preDelta2, verifyingKey);
        (, uint256[2] memory instance3) = generateDelta(preDelta3, verifyingKey);
        // Verify that the deltas add correctly
        uint256[2] memory instance4 = Delta.add(instance1, instance2);
        assertEq(instance3[0], instance4[0]);
        assertEq(instance3[1], instance4[1]);
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    /// @param preDelta1 The input/preimage to the first delta hash
    /// @param preDelta2 The input/preimage to the second delta hash
    /// @param verifyingKey The hash being authorized
    function test_verify_inconsistent_delta_fails1(uint256 preDelta1, uint256 preDelta2, bytes32 verifyingKey) public {
        // Filter out inadmissible private keys or equal keys
        vm.assume(0 < preDelta1 && preDelta1 < SECP256K1_ORDER);
        vm.assume(0 < preDelta2 && preDelta2 < SECP256K1_ORDER);
        vm.assume(preDelta1 != preDelta2);
        // Generate a delta proof and instance from the above tags and preimage
        (bytes memory proof1, ) = generateDelta(preDelta1, verifyingKey);
        (, uint256[2] memory instance2) = generateDelta(preDelta2, verifyingKey);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to the verifying key
    /// @param preDelta The input/preimage to the delta hash
    /// @param verifyingKey1 The first hash being authorized
    /// @param verifyingKey2 The second hash being authorized
    function test_verify_inconsistent_delta_fails2(uint256 preDelta, bytes32 verifyingKey1, bytes32 verifyingKey2) public {
        // Filter out inadmissible private keys or equal keys
        vm.assume(0 < preDelta && preDelta < SECP256K1_ORDER);
        vm.assume(verifyingKey1 != verifyingKey2);
        // Generate a delta proof and instance from the above tags and preimage
        (bytes memory proof1, ) = generateDelta(preDelta, verifyingKey1);
        (, uint256[2] memory instance2) = generateDelta(preDelta, verifyingKey2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: verifyingKey2});
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
