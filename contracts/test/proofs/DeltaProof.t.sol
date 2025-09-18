// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Test } from "forge-std/Test.sol";
import { VmSafe } from "forge-std/Vm.sol";
import { Delta } from "./../../src/proving/Delta.sol";
import { EllipticCurveK256 } from "../../src/libs/EllipticCurveK256.sol";
import { Transaction } from "./../../src/Types.sol";
import { TransactionExample } from "./../examples/Transaction.e.sol";
import { TxGen } from "./../examples/TxGen.sol";

library DeltaGen {
    /// @notice The parameters required to generate a mock delta instance for a .
    /// @param valueCommitmentRandomness The value commitment randomness.
    /// @param kind The resource kind that this delta instance mocks.
    /// @param quantity The resource quantity that this delta instance mocks
    /// @param consumed Whether the delta instance mocks a consumed resource or not.
    struct InstanceInputs {
        uint256 kind;
        uint256 valueCommitmentRandomness;
        uint128 quantity;
        bool consumed;
    }

    /// @notice The parameters required to generate a delta proof
    /// @notice valueCommitmentRandomness Value commitment randomness
    /// @notice verifyingKey The hash being signed over
    struct ProofInputs {
        uint256 valueCommitmentRandomness;
        bytes32 verifyingKey;
    }

    // Resource kind must be non-zero
    error KindZero();
    // Value commitment randomness must be non-zero
    error ValueCommitmentRandomnessZero();
    // Private key corresponding to delta instance must be non-zero
    error PreDeltaZero();

    /// @notice Generates a transaction delta instance by computing the public
    /// key corresponding to a(kind)^quantity * b^valueCommitmentRandomness
    /// @param vm VmSafe instance with which to compute public key
    /// @param deltaInputs Parameters required to determine a delta instance
    /// @return instance The delta instance corresponding to the parameters
    function generateInstance(VmSafe vm, InstanceInputs memory deltaInputs) public returns (uint256[2] memory instance) {
        deltaInputs.valueCommitmentRandomness = deltaInputs.valueCommitmentRandomness % EllipticCurveK256.SECP256K1_ORDER;
        if(deltaInputs.valueCommitmentRandomness == 0) {
            revert DeltaGen.ValueCommitmentRandomnessZero();
        }
        deltaInputs.kind = deltaInputs.kind % EllipticCurveK256.SECP256K1_ORDER;
        if(deltaInputs.kind == 0) {
            revert DeltaGen.KindZero();
        }
        uint256 quantity = canonicalizeQuantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, EllipticCurveK256.SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.valueCommitmentRandomness, EllipticCurveK256.SECP256K1_ORDER);
        if(preDelta == 0) {
            revert DeltaGen.PreDeltaZero();
        }
        // Derive address and public key from transaction delta
        VmSafe.Wallet memory valueWallet = vm.createWallet(preDelta);
        // Extract the transaction delta from the wallet
        instance[0] = valueWallet.publicKeyX;
        instance[1] = valueWallet.publicKeyY;
    }

    /// @notice Generates a transaction delta proof by signing verifyingKey with
    /// valueCommitmentRandomness
    /// @param vm VmSafe instance with which to sign verifyingKey
    /// @param deltaInputs Parameters required to construct a delta proof
    /// @return proof The delta proof corresponding to the parameters
    function generateProof(VmSafe vm, ProofInputs memory deltaInputs) public returns (bytes memory proof) {
        deltaInputs.valueCommitmentRandomness = deltaInputs.valueCommitmentRandomness % EllipticCurveK256.SECP256K1_ORDER;
        if(deltaInputs.valueCommitmentRandomness == 0) {
            revert DeltaGen.ValueCommitmentRandomnessZero();
        }
        // Compute the components of the transaction delta proof
        VmSafe.Wallet memory randomWallet = vm.createWallet(deltaInputs.valueCommitmentRandomness);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(randomWallet, deltaInputs.verifyingKey);
        // Finally compute the transaction delta proof
        proof = abi.encodePacked(r, s, v);
    }

    /// @notice Convert an exponent represented as a boolean sign and a uint128
    /// magnitude to an equivalent uint256 assuming an order of SECP256K1_ORDER
    /// @param consumed False represents a non-negative quantity, true a non-positive quantity
    /// @param quantity The magnitude of the quantity being caanonicalized
    /// @return quantityRepresentative The non-negative number less than SECP256K1_ORDER
    /// that's equivalent to the exponent modulo SECP256K1_ORDER
    function canonicalizeQuantity(bool consumed, uint128 quantity) public pure returns (uint256 quantityRepresentative) {
        // If positive, leave the number unchanged
        quantityRepresentative = consumed ? ((EllipticCurveK256.SECP256K1_ORDER - uint256(quantity)) % EllipticCurveK256.SECP256K1_ORDER) : uint256(quantity);
    }
}

contract DeltaProofTest is Test {
    /// @notice Test that Delta.verify accepts a well-formed delta proof and instance
    function test_verify_delta_succeeds(DeltaGen.InstanceInputs memory deltaInstanceInputs, DeltaGen.ProofInputs memory deltaProofInputs) public {
        // Generate a delta proof and instance from the above tags and preimage
        deltaInstanceInputs.quantity = 0;
        deltaProofInputs.valueCommitmentRandomness = deltaInstanceInputs.valueCommitmentRandomness;
        _assumeDeltaInstance(deltaInstanceInputs);
        _assumeDeltaProof(deltaProofInputs);
        uint256[2] memory instance = DeltaGen.generateInstance(vm, deltaInstanceInputs);
        bytes memory proof = DeltaGen.generateProof(vm, deltaProofInputs);
        // Verify that the generated delta proof is valid
        Delta.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    /// @notice Test that Delta.add correctly adds deltas
    function test_add_delta_correctness(DeltaGen.InstanceInputs memory deltaInputs1, DeltaGen.InstanceInputs memory deltaInputs2) public {
        // Ensure that we're adding assets of the same kind over the same verifying key
        deltaInputs2.kind = deltaInputs1.kind;
        // Filter out overflows
        vm.assume(deltaInputs1.consumed != deltaInputs2.consumed || deltaInputs2.quantity <= type(uint128).max - deltaInputs1.quantity);
        vm.assume(0 < deltaInputs2.valueCommitmentRandomness && deltaInputs2.valueCommitmentRandomness <= type(uint256).max - deltaInputs1.valueCommitmentRandomness);
        // Add the deltas
        (bool consumed, uint128 quantity) = _signMagAdd(deltaInputs1.consumed, deltaInputs1.quantity, deltaInputs2.consumed, deltaInputs2.quantity);
        // Compute the inputs corresponding to the sum of deltas
        DeltaGen.InstanceInputs memory deltaInputs3 = DeltaGen.InstanceInputs({
            kind: deltaInputs1.kind,
            quantity: quantity,
            consumed: consumed,
            valueCommitmentRandomness: deltaInputs1.valueCommitmentRandomness + deltaInputs2.valueCommitmentRandomness
        });
        _assumeDeltaInstance(deltaInputs1);
        _assumeDeltaInstance(deltaInputs2);
        _assumeDeltaInstance(deltaInputs3);
        // Generate a delta proof and instance from the above tags and preimage
        uint256[2] memory instance1 = DeltaGen.generateInstance(vm, deltaInputs1);
        uint256[2] memory instance2 = DeltaGen.generateInstance(vm, deltaInputs2);
        uint256[2] memory instance3 = DeltaGen.generateInstance(vm, deltaInputs3);
        // Verify that the deltas add correctly
        uint256[2] memory instance4 = Delta.add(instance1, instance2);
        assertEq(instance3[0], instance4[0]);
        assertEq(instance3[1], instance4[1]);
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function test_verify_inconsistent_delta_fails1(DeltaGen.InstanceInputs memory deltaInstanceInputs, DeltaGen.ProofInputs memory deltaProofInputs) public {
        // Filter out inadmissible private keys or equal keys
        deltaProofInputs.valueCommitmentRandomness = deltaInstanceInputs.valueCommitmentRandomness;
        vm.assume(deltaInstanceInputs.kind % SECP256K1_ORDER != 0);
        vm.assume(DeltaGen.canonicalizeQuantity(deltaInstanceInputs.consumed, deltaInstanceInputs.quantity) != 0);
        _assumeDeltaInstance(deltaInstanceInputs);
        _assumeDeltaProof(deltaProofInputs);
        // Generate a delta proof and instance from the above tags and preimage
        uint256[2] memory instance = DeltaGen.generateInstance(vm, deltaInstanceInputs);
        bytes memory proof = DeltaGen.generateProof(vm, deltaProofInputs);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function test_verify_inconsistent_delta_fails2(DeltaGen.ProofInputs memory deltaInputs1, DeltaGen.InstanceInputs memory deltaInputs2) public {
        deltaInputs2.quantity = 0;
        // Filter out inadmissible private keys or equal keys
        vm.assume((deltaInputs1.valueCommitmentRandomness % SECP256K1_ORDER) != (deltaInputs2.valueCommitmentRandomness % SECP256K1_ORDER));
        _assumeDeltaInstance(deltaInputs2);
        _assumeDeltaProof(deltaInputs1);
        // Generate a delta proof and instance from the above tags and preimage
        bytes memory proof1 = DeltaGen.generateProof(vm, deltaInputs1);
        uint256[2] memory instance2 = DeltaGen.generateInstance(vm, deltaInputs2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: deltaInputs1.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to the verifying key
    function test_verify_inconsistent_delta_fails3(DeltaGen.ProofInputs memory deltaInputs1, DeltaGen.InstanceInputs memory deltaInputs2, bytes32 verifyingKey) public {
        deltaInputs2.valueCommitmentRandomness = deltaInputs1.valueCommitmentRandomness;
        deltaInputs2.quantity = 0;
        // Filter out inadmissible private keys or equal keys
        vm.assume(deltaInputs1.verifyingKey != verifyingKey);
        _assumeDeltaInstance(deltaInputs2);
        _assumeDeltaProof(deltaInputs1);
        // Generate a delta proof and instance from the above tags and preimage
        bytes memory proof1 = DeltaGen.generateProof(vm, deltaInputs1);
        uint256[2] memory instance2 = DeltaGen.generateInstance(vm, deltaInputs2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: verifyingKey});
    }

    /// @notice Check that a balanced transaction does pass verification
    function test_verify_balanced_delta_succeeds(DeltaGen.InstanceInputs[] memory deltaInputs, bytes32 verifyingKey) public {
        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];
        // Truncate the delta inputs to improve test performance
        uint256 maxDeltaLen = 10;
        deltaInputs = truncateDeltaInputs(deltaInputs, deltaInputs.length % maxDeltaLen);
        // Make sure that the delta quantities balance out
        (DeltaGen.InstanceInputs[] memory wrappedDeltaInputs, bool consumed, uint128 quantity, uint256 valueCommitmentRandomness) = wrapDeltaInputs(deltaInputs);
        // Adjust the last delta so that the full sum is zero
        if(quantity != 0) {
            (wrappedDeltaInputs[wrappedDeltaInputs.length - 1].consumed, wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity) = _signMagSub(wrappedDeltaInputs[wrappedDeltaInputs.length - 1].consumed, wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity, consumed, quantity);
        }
        for(uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            _assumeDeltaInstance(wrappedDeltaInputs[i]);
            uint256[2] memory instance = DeltaGen.generateInstance(vm, wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }
        // Compute the proof for the balanced transaction
        DeltaGen.ProofInputs memory sumDeltaInputs = DeltaGen.ProofInputs({
            valueCommitmentRandomness: valueCommitmentRandomness,
            verifyingKey: verifyingKey
            });
        _assumeDeltaProof(sumDeltaInputs);
        bytes memory proof = DeltaGen.generateProof(vm, sumDeltaInputs);
        // Verify that the balanced transaction proof succeeds
        Delta.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
    }

    /// @notice Check that an imbalanced transaction fails verification
    function test_verify_imbalanced_delta_fails(DeltaGen.InstanceInputs[] memory deltaInputs, bytes32 verifyingKey) public {
        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];
        // Truncate the delta inputs to improve test performance
        uint256 maxDeltaLen = 10;
        deltaInputs = truncateDeltaInputs(deltaInputs, deltaInputs.length % maxDeltaLen);
        // Accumulate the total quantity and randomness commitment
        (DeltaGen.InstanceInputs[] memory wrappedDeltaInputs, bool consumed, uint128 quantity, uint256 valueCommitmentRandomness) = wrapDeltaInputs(deltaInputs);
        // Assume that the deltas are imbalanced
        vm.assume(DeltaGen.canonicalizeQuantity(consumed, quantity) != 0);
        for(uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            _assumeDeltaInstance(wrappedDeltaInputs[i]);
            uint256[2] memory instance = DeltaGen.generateInstance(vm, wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }
        // Compute the proof for the balanced transaction
        DeltaGen.ProofInputs memory sumDeltaInputs = DeltaGen.ProofInputs({
            valueCommitmentRandomness: valueCommitmentRandomness,
            verifyingKey: verifyingKey
            });
        _assumeDeltaProof(sumDeltaInputs);
        bytes memory proof = DeltaGen.generateProof(vm, sumDeltaInputs);
        // Verify that the imbalanced transaction proof fails
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
    }

    /// @notice Wrap the delta inputs in such a way that they can be balanced
    /// and also return the total quantity and value commitment randomness
    function wrapDeltaInputs(DeltaGen.InstanceInputs[] memory deltaInputs) public pure returns (DeltaGen.InstanceInputs[] memory wrappedDeltaInputs, bool consumedAcc, uint128 quantityMagAcc, uint256 valueCommitmentRandomnessAcc) {
        // Compute the window into which the deltas should sum
        int256 halfMax = int256(uint256(type(uint128).max >> 1));
        int256 halfMin = -halfMax;
        // Track the current quantity and value commitment randomness
        int256 quantityAcc = 0;
        quantityMagAcc = 0;
        consumedAcc = false;
        valueCommitmentRandomnessAcc = 0;
        if (deltaInputs.length == 0) {
            return (deltaInputs, consumedAcc, quantityMagAcc, valueCommitmentRandomnessAcc);
        }
        // Grab the kind to use for all deltas
        uint256 kind = deltaInputs[0].kind;
        vm.assume(deltaInputs[0].kind % SECP256K1_ORDER != 0);
        // Wrap the deltas
        for(uint256 i = 0; i < deltaInputs.length; i++) {
            // Ensure that all the deltas have the same kind
            deltaInputs[i].kind = kind;
            // Accumulate the randomness commitments modulo SECP256K1_ORDER
            valueCommitmentRandomnessAcc = addmod(valueCommitmentRandomnessAcc, deltaInputs[i].valueCommitmentRandomness, SECP256K1_ORDER);
            int256 currentQuantityMag = int256(uint256(deltaInputs[i].quantity));
            int256 currentQuantity = deltaInputs[i].consumed ? -currentQuantityMag : currentQuantityMag;
            // Adjust the delta inputs so that the sum remains in a specific range
            if(currentQuantity >= 0 && quantityAcc > halfMax - currentQuantity) {
                int256 overflow = quantityAcc - (halfMax - currentQuantity);
                currentQuantity = halfMin + overflow - 1 - quantityAcc;
            } else if(currentQuantity < 0 && quantityAcc < halfMin - currentQuantity) {
                int256 underflow = (halfMin - currentQuantity) - quantityAcc;
                currentQuantity = halfMax + 1 - underflow - quantityAcc;
            }
            // Finally, accumulate the adjusted quantity
            quantityAcc += currentQuantity;
            (deltaInputs[i].consumed, deltaInputs[i].quantity) = _toSignMag(currentQuantity);
        }
        // Finally, return tbe wrapped deltas
        wrappedDeltaInputs = deltaInputs;
        (consumedAcc, quantityMagAcc) = _toSignMag(quantityAcc);
    }

    /// @notice Grab the first length elements from deltaInputs
    function truncateDeltaInputs(DeltaGen.InstanceInputs[] memory deltaInputs, uint256 length) public pure returns (DeltaGen.InstanceInputs[] memory truncatedDeltaInputs) {
        truncatedDeltaInputs = new DeltaGen.InstanceInputs[](length);
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

    /// @notice Assume that the delta instance inputs are well-formed. I.e. the
    /// value commitment randomness and resource kind are both non-zero.
    function _assumeDeltaInstance(DeltaGen.InstanceInputs memory deltaInputs) internal pure {
        // The value commitment randomness must be non-zero modulo the base
        // point order
        deltaInputs.valueCommitmentRandomness = deltaInputs.valueCommitmentRandomness % SECP256K1_ORDER;
        vm.assume(deltaInputs.valueCommitmentRandomness != 0);
        // The kind must be non-zero modulo the base point order
        deltaInputs.kind = deltaInputs.kind % SECP256K1_ORDER;
        vm.assume(deltaInputs.kind != 0);
        // The exponent must be non-zero modulo the base point order
        uint256 quantity = DeltaGen.canonicalizeQuantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.valueCommitmentRandomness, SECP256K1_ORDER);
        vm.assume(preDelta != 0);
    }

    /// @notice Assume that the delta proof inputs are well-formed. I.e. the
    /// value commitment randomness is non-zero.
    function _assumeDeltaProof(DeltaGen.ProofInputs memory deltaInputs) internal pure {
        deltaInputs.valueCommitmentRandomness = deltaInputs.valueCommitmentRandomness % SECP256K1_ORDER;
        vm.assume(deltaInputs.valueCommitmentRandomness != 0);
    }

    /// @notice Add two numbers in sign magnitude representation. Positive
    /// numbers are represented with a false sign and negative numbers with a
    /// true sign.
    function _signMagAdd(bool s1, uint128 m1, bool s2, uint128 m2) internal pure returns (bool s3, uint128 m3) {
        if (s1 == s2) {
            return (s1, m1 + m2);
        } else if (m1 >= m2) {
            return (s1, m1 - m2);
        } else if (m2 > m1) {
            return (s2, m2 - m1);
        }
    }

    /// @notice Subtract two numbers in sign magnitude representation. Positive
    /// numbers are represented with a false sign and negative numbers with a
    /// true sign.
    function _signMagSub(bool s1, uint128 m1, bool s2, uint128 m2) internal pure returns (bool s3, uint128 m3) {
        if (s1 != s2) {
            return (s1, m1 + m2);
        } else if (m1 >= m2) {
            return (s1, m1 - m2);
        } else if (m2 > m1) {
            return (!s1, m2 - m1);
        }
    }

    /// @notice Convert the signed quantity whose magnitude fits into a uint128
    /// into a sign-magnitude representation. Positive numbers are represented
    /// with a false sign and negative numbers with a true sign.
    function _toSignMag(int256 quantity) internal pure returns (bool sign, uint128 magnitude) {
        if (quantity >= 0) {
            magnitude = uint128(uint256(quantity));
            sign = false;
        } else {
            magnitude = uint128(uint256(-quantity));
            sign = true;
        }
    }
}
