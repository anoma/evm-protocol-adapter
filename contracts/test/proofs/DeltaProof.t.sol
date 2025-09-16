// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";
import { Test } from "forge-std/Test.sol";
import { VmSafe } from "forge-std/Vm.sol";
import { EllipticCurveK256 } from "./../../src/libs/EllipticCurveK256.sol";
import { Delta } from "./../../src/proving/Delta.sol";
import { Transaction } from "./../../src/Types.sol";
import { TransactionExample } from "./../examples/Transaction.e.sol";
import { TxGen } from "./../examples/TxGen.sol";

library DeltaGen {
    // The order of the secp256k1 curve.
    uint256 internal constant SECP256K1_ORDER =
        115792089237316195423570985008687907852837564279074904382605163141518161494337;
    // secp256k1 base point
    uint256 internal constant GX =
        0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
    uint256 internal constant GY =
        0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
    
    // The parameters required to generate a delta instance
    struct DeltaInstanceInputs {
        // The identifier of the asset
        uint256 kind;
        // Whether this input is being consumed or not
        bool consumed;
        // The quantity of the asset
        uint128 quantity;
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

    /// @notice Generates a transaction delta proof by signing verifyingKey with
    /// rcv, and a delta instance by computing a(kind)^quantity * b^rcv
    function genInstance(DeltaInstanceInputs memory deltaInputs) public returns (uint256[2] memory instance) {
        // The value commitment randomness must be non-zero modulo the base
        // point order
        deltaInputs.rcv = deltaInputs.rcv % SECP256K1_ORDER;
        require(deltaInputs.rcv != 0, "value commitment randomness must be non-zero");
        // The kind must be non-zero modulo the base point order
        deltaInputs.kind = deltaInputs.kind % SECP256K1_ORDER;
        require(deltaInputs.kind != 0, "resource kind must be non-zero");
        // The exponent must be non-zero modulo the base point order
        uint256 quantity = canonize_quantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.rcv, SECP256K1_ORDER);
        assert(preDelta != 0);
        // Derive address and public key from transaction delta
        (uint256 qx, uint256 qy) = EllipticCurveK256.derivePubKey(preDelta);
        // Extract the transaction delta from the wallet
        instance[0] = qx;
        instance[1] = qy;
    }

    /// @notice Generate a delta proof without using vm.sign
    function genProof(DeltaProofInputs memory deltaInputs) public returns (bytes memory proof) {
        deltaInputs.rcv = deltaInputs.rcv % SECP256K1_ORDER;
        require(deltaInputs.rcv != 0, "value commitment randomness must be non-zero");
        for (uint256 k = 1; k < SECP256K1_ORDER; k++) {
            // Compute kG
            (uint256 x1, uint256 y1) = EllipticCurveK256.ecMul(k, GX, GY);
            uint256 r = x1 % SECP256K1_ORDER;
            if (r == 0) { continue; }
            // Compute k^-1 (verifyingKey + r*rcv) mod N
            uint256 s = mulmod(Math.invMod(k, SECP256K1_ORDER), addmod(uint256(deltaInputs.verifyingKey), mulmod(r, deltaInputs.rcv, SECP256K1_ORDER), SECP256K1_ORDER), SECP256K1_ORDER) % SECP256K1_ORDER;
            if (s == 0) { continue; }
            // Compute the recovery ID
            uint8 v = uint8(y1 & 1);
            if (s > SECP256K1_ORDER/2) {
                v = v ^ 1;
                // Flip to canonical (r, -s mod n)
                s = SECP256K1_ORDER - s;
            }
            v += 27;
            // Finally compute the transaction delta proof
            return abi.encodePacked(r, s, v);
        }
        require(false, "unable to find integer k to generate signature");
    }

    /// @notice Convert a int256 exponent to an equivalent uin256 assuming an order of SECP256K1_ORDER
    function canonize_quantity(bool consumed, uint128 quantity) public pure returns (uint256 quantityu) {
        // If positive, leave the number unchanged
        quantityu = consumed ? ((SECP256K1_ORDER - uint256(quantity)) % SECP256K1_ORDER) : uint256(quantity);
    }
}

contract DeltaProofTest is Test {
    /// @notice Assume that the delta instance inputs are well-formed. I.e. the
    /// value commitment randomness and resource kind are both non-zero.
    function assumeDeltaInstance(DeltaGen.DeltaInstanceInputs memory deltaInputs) internal {
        // The value commitment randomness must be non-zero modulo the base
        // point order
        deltaInputs.rcv = deltaInputs.rcv % SECP256K1_ORDER;
        vm.assume(deltaInputs.rcv != 0);
        // The kind must be non-zero modulo the base point order
        deltaInputs.kind = deltaInputs.kind % SECP256K1_ORDER;
        vm.assume(deltaInputs.kind != 0);
        // The exponent must be non-zero modulo the base point order
        uint256 quantity = DeltaGen.canonize_quantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.rcv, SECP256K1_ORDER);
        vm.assume(preDelta != 0);
    }

    /// @notice Assume that the delta proof inputs are well-formed. I.e. the
    /// value commitment randomness is non-zero.
    function assumeDeltaProof(DeltaGen.DeltaProofInputs memory deltaInputs) internal {
        deltaInputs.rcv = deltaInputs.rcv % SECP256K1_ORDER;
        vm.assume(deltaInputs.rcv != 0);
    }

    /// @notice Generates a transaction delta proof by signing verifyingKey with
    /// rcv, and a delta instance by computing a(kind)^quantity * b^rcv
    function genInstance(DeltaGen.DeltaInstanceInputs memory deltaInputs) public returns (uint256[2] memory instance) {
        deltaInputs.rcv = deltaInputs.rcv % SECP256K1_ORDER;
        vm.assume(deltaInputs.rcv != 0);
        vm.assume(deltaInputs.kind != 0);
        uint256 quantity = DeltaGen.canonize_quantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.rcv, SECP256K1_ORDER);
        vm.assume(preDelta != 0);
        // Derive address and public key from transaction delta
        VmSafe.Wallet memory valueWallet = vm.createWallet(preDelta);
        // Extract the transaction delta from the wallet
        instance[0] = valueWallet.publicKeyX;
        instance[1] = valueWallet.publicKeyY;
    }
    
    /// @notice Generate a delta proof
    function genProof(DeltaGen.DeltaProofInputs memory deltaInputs) public returns (bytes memory proof) {
        deltaInputs.rcv = deltaInputs.rcv % SECP256K1_ORDER;
        vm.assume(deltaInputs.rcv != 0);
        // Compute the components of the transaction delta proof
        VmSafe.Wallet memory randomWallet = vm.createWallet(deltaInputs.rcv);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(randomWallet, deltaInputs.verifyingKey);
        // Finally compute the transaction delta proof
        proof = abi.encodePacked(r, s, v);
    }

    /// @notice Test that Delta.verify accepts a well-formed delta proof and instance
    function test_verify_delta_succeeds(DeltaGen.DeltaInstanceInputs memory deltaInstanceInputs, DeltaGen.DeltaProofInputs memory deltaProofInputs) public {
        // Generate a delta proof and instance from the above tags and preimage
        deltaInstanceInputs.quantity = 0;
        deltaProofInputs.rcv = deltaInstanceInputs.rcv;
        assumeDeltaInstance(deltaInstanceInputs);
        assumeDeltaProof(deltaProofInputs);
        uint256[2] memory instance = genInstance(deltaInstanceInputs);
        bytes memory proof = genProof(deltaProofInputs);
        // Verify that the generated delta proof is valid
        Delta.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    /// @notice Test that Delta.add correctly adds deltas
    function test_add_delta_correctness(DeltaGen.DeltaInstanceInputs memory deltaInputs1, DeltaGen.DeltaInstanceInputs memory deltaInputs2) public {
        // Ensure that we're adding assets of the same kind over the same verifying key
        deltaInputs2.kind = deltaInputs1.kind;
        // Filter out overflows
        vm.assume(deltaInputs1.consumed != deltaInputs2.consumed || deltaInputs2.quantity <= type(uint128).max - deltaInputs1.quantity);
        vm.assume(0 < deltaInputs2.rcv && deltaInputs2.rcv <= type(uint256).max - deltaInputs1.rcv);
        // Add the deltas
        uint128 quantity;
        bool consumed;
        if (deltaInputs1.consumed == deltaInputs2.consumed) {
            consumed = deltaInputs1.consumed;
            quantity = deltaInputs1.quantity + deltaInputs2.quantity;
        } else if(deltaInputs1.quantity >= deltaInputs2.quantity) {
            quantity = deltaInputs1.quantity - deltaInputs2.quantity;
            consumed = deltaInputs1.consumed;
        } else {
            quantity = deltaInputs2.quantity - deltaInputs1.quantity;
            consumed = deltaInputs2.consumed;
        }
        // Compute the inputs corresponding to the sum of deltas
        DeltaGen.DeltaInstanceInputs memory deltaInputs3 = DeltaGen.DeltaInstanceInputs({
            kind: deltaInputs1.kind,
            quantity: quantity,
            consumed: consumed,
            rcv: deltaInputs1.rcv + deltaInputs2.rcv
        });
        assumeDeltaInstance(deltaInputs1);
        assumeDeltaInstance(deltaInputs2);
        assumeDeltaInstance(deltaInputs3);
        // Generate a delta proof and instance from the above tags and preimage
        uint256[2] memory instance1 = genInstance(deltaInputs1);
        uint256[2] memory instance2 = genInstance(deltaInputs2);
        uint256[2] memory instance3 = genInstance(deltaInputs3);
        // Verify that the deltas add correctly
        uint256[2] memory instance4 = Delta.add(instance1, instance2);
        assertEq(instance3[0], instance4[0]);
        assertEq(instance3[1], instance4[1]);
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function test_verify_inconsistent_delta_fails1(DeltaGen.DeltaInstanceInputs memory deltaInstanceInputs, DeltaGen.DeltaProofInputs memory deltaProofInputs) public {
        // Filter out inadmissible private keys or equal keys
        deltaProofInputs.rcv = deltaInstanceInputs.rcv;
        vm.assume(deltaInstanceInputs.kind % SECP256K1_ORDER != 0);
        vm.assume(DeltaGen.canonize_quantity(deltaInstanceInputs.consumed, deltaInstanceInputs.quantity) != 0);
        assumeDeltaInstance(deltaInstanceInputs);
        assumeDeltaProof(deltaProofInputs);
        // Generate a delta proof and instance from the above tags and preimage
        uint256[2] memory instance = genInstance(deltaInstanceInputs);
        bytes memory proof = genProof(deltaProofInputs);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function test_verify_inconsistent_delta_fails2(DeltaGen.DeltaProofInputs memory deltaInputs1, DeltaGen.DeltaInstanceInputs memory deltaInputs2) public {
        deltaInputs2.quantity = 0;
        // Filter out inadmissible private keys or equal keys
        vm.assume((deltaInputs1.rcv % SECP256K1_ORDER) != (deltaInputs2.rcv % SECP256K1_ORDER));
        assumeDeltaInstance(deltaInputs2);
        assumeDeltaProof(deltaInputs1);
        // Generate a delta proof and instance from the above tags and preimage
        bytes memory proof1 = genProof(deltaInputs1);
        uint256[2] memory instance2 = genInstance(deltaInputs2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: deltaInputs1.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to the verifying key
    function test_verify_inconsistent_delta_fails3(DeltaGen.DeltaProofInputs memory deltaInputs1, DeltaGen.DeltaInstanceInputs memory deltaInputs2, bytes32 verifyingKey) public {
        deltaInputs2.rcv = deltaInputs1.rcv;
        deltaInputs2.quantity = 0;
        // Filter out inadmissible private keys or equal keys
        vm.assume(deltaInputs1.verifyingKey != verifyingKey);
        assumeDeltaInstance(deltaInputs2);
        assumeDeltaProof(deltaInputs1);
        // Generate a delta proof and instance from the above tags and preimage
        bytes memory proof1 = genProof(deltaInputs1);
        uint256[2] memory instance2 = genInstance(deltaInputs2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: verifyingKey});
    }

    /// @notice Check that a balanced transaction does pass verification
    function test_verify_balanced_delta_succeeds(DeltaGen.DeltaInstanceInputs[] memory deltaInputs, bytes32 verifyingKey) public {
        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];
        // Truncate the delta inputs to improve test performance
        uint256 maxDeltaLen = 10;
        deltaInputs = truncateDeltaInputs(deltaInputs, deltaInputs.length % maxDeltaLen);
        // Make sure that the delta quantities balance out
        (DeltaGen.DeltaInstanceInputs[] memory wrappedDeltaInputs, bool consumed, uint128 quantity, uint256 rcv) = wrapDeltaInputs(deltaInputs);
        // Adjust the last delta so that the full sum is zero
        if(quantity != 0) {
            if(wrappedDeltaInputs[wrappedDeltaInputs.length - 1].consumed != consumed) {
                wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity += quantity;
            } else if(wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity >= quantity) {
                wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity -= quantity;
            } else {
                wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity = quantity - wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity;
                wrappedDeltaInputs[wrappedDeltaInputs.length - 1].consumed = !consumed;
            }
        }
        for(uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            assumeDeltaInstance(wrappedDeltaInputs[i]);
            uint256[2] memory instance = genInstance(wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }
        // Compute the proof for the balanced transaction
        DeltaGen.DeltaProofInputs memory sumDeltaInputs = DeltaGen.DeltaProofInputs({
            rcv: rcv,
            verifyingKey: verifyingKey
            });
        assumeDeltaProof(sumDeltaInputs);
        bytes memory proof = genProof(sumDeltaInputs);
        // Verify that the balanced transaction proof succeeds
        Delta.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
    }

    /// @notice Check that an imbalanced transaction fails verification
    function test_verify_imbalanced_delta_fails(DeltaGen.DeltaInstanceInputs[] memory deltaInputs, bytes32 verifyingKey) public {
        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];
        // Truncate the delta inputs to improve test performance
        uint256 maxDeltaLen = 10;
        deltaInputs = truncateDeltaInputs(deltaInputs, deltaInputs.length % maxDeltaLen);
        // Accumulate the total quantity and randomness commitment
        (DeltaGen.DeltaInstanceInputs[] memory wrappedDeltaInputs, bool consumed, uint128 quantity, uint256 rcv) = wrapDeltaInputs(deltaInputs);
        // Assume that the deltas are imbalanced
        vm.assume(DeltaGen.canonize_quantity(consumed, quantity) != 0);
        for(uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            assumeDeltaInstance(wrappedDeltaInputs[i]);
            uint256[2] memory instance = genInstance(wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }
        // Compute the proof for the balanced transaction
        DeltaGen.DeltaProofInputs memory sumDeltaInputs = DeltaGen.DeltaProofInputs({
            rcv: rcv,
            verifyingKey: verifyingKey
            });
        assumeDeltaProof(sumDeltaInputs);
        bytes memory proof = genProof(sumDeltaInputs);
        // Verify that the imbalanced transaction proof fails
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
    }

    /// @notice Wrap the delta inputs in such a way that they can be balanced
    /// and also return the total quantity and value commitment randomness
    function wrapDeltaInputs(DeltaGen.DeltaInstanceInputs[] memory deltaInputs) public pure returns (DeltaGen.DeltaInstanceInputs[] memory wrappedDeltaInputs, bool consumedAcc, uint128 quantityMagAcc, uint256 rcvAcc) {
        // Compute the window into which the deltas should sum
        int256 halfMax = int256(uint256(type(uint128).max >> 1));
        int256 halfMin = -halfMax;
        // Track the current quantity and value commitment randomness
        int256 quantityAcc = 0;
        quantityMagAcc = 0;
        consumedAcc = false;
        rcvAcc = 0;
        if (deltaInputs.length == 0) {
            return (deltaInputs, consumedAcc, quantityMagAcc, rcvAcc);
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
            if (currentQuantity >= 0) {
                deltaInputs[i].quantity = uint128(uint256(currentQuantity));
                deltaInputs[i].consumed = false;
            } else {
                deltaInputs[i].quantity = uint128(uint256(-currentQuantity));
                deltaInputs[i].consumed = true;
            }
        }
        // Finally, return tbe wrapped deltas
        wrappedDeltaInputs = deltaInputs;
        if (quantityAcc >= 0) {
            quantityMagAcc = uint128(uint256(quantityAcc));
            consumedAcc = false;
        } else {
            quantityMagAcc = uint128(uint256(-quantityAcc));
            consumedAcc = true;
        }
    }

    /// @notice Grab the first length elements from deltaInputs
    function truncateDeltaInputs(DeltaGen.DeltaInstanceInputs[] memory deltaInputs, uint256 length) public pure returns (DeltaGen.DeltaInstanceInputs[] memory truncatedDeltaInputs) {
        truncatedDeltaInputs = new DeltaGen.DeltaInstanceInputs[](length);
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
