// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {VmSafe} from "forge-std/Vm.sol";

import {Delta} from "../../src/proving/Delta.sol";
import {Transaction} from "../../src/Types.sol";
import {TransactionExample} from "../examples/Transaction.e.sol";
import {TxGen} from "../examples/TxGen.sol";

contract DeltaProofGen is Test {
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

    error KindZero();
    error RcvZero();
    error PreDeltaZero();
    error KindModCurveOrderZero();

    /// @notice Generates a transaction delta proof by signing verifyingKey with
    /// rcv, and a delta instance by computing a(kind)^quantity * b^rcv
    function generateDeltaInstance(
        DeltaInstanceInputs memory deltaInputs // TODO! Rename
    ) public returns (uint256[2] memory instance) {
        // TODO remove?
        vm.assume(deltaInputs.rcv != 0);
        if (deltaInputs.rcv == 0) {
            revert RcvZero();
        }

        // TODO remove?
        vm.assume(deltaInputs.kind != 0);
        if (deltaInputs.kind == 0) {
            revert KindZero();
        }

        uint256 quantity = _canonicalizeQuantity(deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.rcv, SECP256K1_ORDER);

        // TODO remove?
        vm.assume(preDelta != 0);
        if (preDelta == 0) {
            revert PreDeltaZero();
        }

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

    /// @notice Wrap the delta inputs in such a way that they can be balanced
    /// and also return the total quantity and value commitment randomness
    function wrapDeltaInputs(DeltaInstanceInputs[] memory deltaInputs)
        public
        pure
        returns (DeltaInstanceInputs[] memory wrappedDeltaInputs, int256 quantityAcc, uint256 rcvAcc)
    {
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

        // TODO remove?
        vm.assume(deltaInputs[0].kind % SECP256K1_ORDER != 0);
        if (deltaInputs[0].kind % SECP256K1_ORDER == 0) {
            revert KindModCurveOrderZero();
        }

        // Wrap the deltas
        for (uint256 i = 0; i < deltaInputs.length; i++) {
            // Ensure that all the deltas have the same kind
            deltaInputs[i].kind = kind;
            // Accumulate the randomness commitments modulo SECP256K1_ORDER
            rcvAcc = addmod(rcvAcc, deltaInputs[i].rcv, SECP256K1_ORDER);
            // Adjust the delta inputs so that the sum remains in a specific range
            if (deltaInputs[i].quantity >= 0 && quantityAcc > halfMax - deltaInputs[i].quantity) {
                int256 overflow = quantityAcc - (halfMax - deltaInputs[i].quantity);
                deltaInputs[i].quantity = halfMin + overflow - 1 - quantityAcc;
            } else if (deltaInputs[i].quantity < 0 && quantityAcc < halfMin - deltaInputs[i].quantity) {
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
    function truncateDeltaInputs(DeltaInstanceInputs[] memory deltaInputs, uint256 length)
        public
        pure
        returns (DeltaInstanceInputs[] memory truncatedDeltaInputs)
    {
        truncatedDeltaInputs = new DeltaInstanceInputs[](length);
        for (uint256 i = 0; i < length; i++) {
            truncatedDeltaInputs[i] = deltaInputs[i];
        }
    }

    /// @notice Convert a int256 exponent to an equivalent uin256 assuming an order of SECP256K1_ORDER
    function _canonicalizeQuantity(int256 quantity) internal pure returns (uint256 canonicalized) {
        // If positive, leave the number unchanged
        canonicalized =
            quantity >= 0 ? uint256(quantity) : (SECP256K1_ORDER - 1 - (uint256(-(quantity + 1)) % SECP256K1_ORDER));
    }
}

contract DeltaProofTest is DeltaProofGen {
    /// @notice Test that Delta.verify accepts a well-formed delta proof and instance
    function testFuzz_verify_delta_succeeds(uint256 kind, uint256 rcv, bytes32 verifyingKey) public {
        kind = bound(kind, 1, type(uint256).max); // vm.assume(input.kind != 0);
        rcv = bound(rcv, 1, SECP256K1_ORDER - 1); // vm.assume(input.rcv != 0);

        uint256[2] memory transactionDelta =
            generateDeltaInstance({deltaInputs: DeltaInstanceInputs({kind: kind, quantity: 0, rcv: rcv})});

        bytes memory proof = generateDeltaProof({deltaInputs: DeltaProofInputs({rcv: rcv, verifyingKey: verifyingKey})});

        // Verify that the generated delta proof is valid
        Delta.verify({proof: proof, instance: transactionDelta, verifyingKey: verifyingKey});
    }

    /// @notice Test that Delta.add correctly adds deltas
    function testFuzz_add_delta_correctness(
        uint256 kind,
        int256 quantity1,
        int256 quantity2,
        uint256 rcv1,
        uint256 rcv2
    ) public {
        kind = bound(kind, 1, type(uint256).max);
        rcv1 = bound(rcv1, 1, SECP256K1_ORDER - 1);
        rcv2 = bound(rcv2, 1, SECP256K1_ORDER - 1);

        // Filter out overflows
        // TODO! Simplify by using `uint128`
        vm.assume(quantity1 < 0 || quantity2 <= type(int256).max - quantity1);
        vm.assume(quantity1 >= 0 || type(int256).min - quantity1 <= quantity2);
        vm.assume(0 < rcv2 && rcv2 <= type(uint256).max - rcv1);

        // Compute the inputs corresponding to the sum of deltas
        DeltaInstanceInputs memory deltaInputs3 =
            DeltaInstanceInputs({kind: kind, quantity: quantity1 + quantity2, rcv: rcv1 + rcv2});
        // Generate a delta proof and instance from the above tags and preimage

        uint256[2] memory instance1 =
            generateDeltaInstance(DeltaInstanceInputs({kind: kind, quantity: quantity1, rcv: rcv1}));
        uint256[2] memory instance2 =
            generateDeltaInstance(DeltaInstanceInputs({kind: kind, quantity: quantity2, rcv: rcv2}));

        vm.assume(deltaInputs3.rcv != 0);
        vm.assume(deltaInputs3.kind != 0);
        uint256[2] memory instance3 = generateDeltaInstance(deltaInputs3);

        // Verify that the deltas add correctly
        uint256[2] memory instance4 = Delta.add(instance1, instance2);
        assertEq(instance3[0], instance4[0]);
        assertEq(instance3[1], instance4[1]);
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function testFuzz_verify_inconsistent_delta_fails1(uint256 kind, int256 quantity, uint256 rcv, bytes32 verifyingKey)
        public
    {
        // Filter out inadmissible private keys or equal keys
        kind = bound(kind, 1, SECP256K1_ORDER - 1);
        vm.assume(_canonicalizeQuantity(quantity) != 0);
        rcv = bound(rcv, 1, type(uint256).max);

        // Generate a delta proof and instance from the above tags and preimage // TODO: what tags?
        uint256[2] memory instance =
            generateDeltaInstance({deltaInputs: DeltaInstanceInputs({kind: kind, quantity: quantity, rcv: rcv})});
        bytes memory proof = generateDeltaProof({deltaInputs: DeltaProofInputs({rcv: rcv, verifyingKey: verifyingKey})});

        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector); // TODO: Can we use a more explicit revert?
        Delta.verify({proof: proof, instance: instance, verifyingKey: verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function testFuzz_verify_inconsistent_delta_fails2(
        DeltaProofInputs memory deltaInputs1,
        DeltaInstanceInputs memory deltaInputs2
    ) public {
        deltaInputs2.quantity = 0;
        // Filter out inadmissible private keys or equal keys
        vm.assume((deltaInputs1.rcv % SECP256K1_ORDER) != (deltaInputs2.rcv % SECP256K1_ORDER));
        // Generate a delta proof and instance from the above tags and preimage

        bytes memory proof1 = generateDeltaProof(deltaInputs1);
        uint256[2] memory instance2 = generateDeltaInstance(deltaInputs2);

        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector); // TODO: Can we use a more explicit revert?
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: deltaInputs1.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to the verifying key
    function testFuzz_verify_inconsistent_delta_fails3(
        uint256 kind,
        uint256 rcv,
        bytes32 verifyingKey1,
        bytes32 verifyingKey2
    ) public {
        // Filter out inadmissible private keys or equal keys
        vm.assume(verifyingKey1 != verifyingKey2);

        DeltaProofInputs memory proofInputs = DeltaProofInputs({rcv: rcv, verifyingKey: verifyingKey1});
        DeltaInstanceInputs memory instanceInputs = DeltaInstanceInputs({kind: kind, quantity: 0, rcv: rcv});

        // Generate a delta proof and instance from the above tags and preimage
        bytes memory proof = generateDeltaProof(proofInputs);
        uint256[2] memory instance = generateDeltaInstance(instanceInputs);

        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector); // TODO: Can we use a more explicit revert?
        Delta.verify({proof: proof, instance: instance, verifyingKey: verifyingKey2});
    }

    /// @notice Check that a balanced transaction does pass verification
    function testFuzz_verify_balanced_delta_succeeds(DeltaInstanceInputs[] memory deltaInputs, bytes32 verifyingKey)
        public
    {
        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];

        // Truncate the delta inputs to improve test performance
        uint256 maxDeltaLen = 10;
        deltaInputs = truncateDeltaInputs(deltaInputs, deltaInputs.length % maxDeltaLen);
        // Make sure that the delta quantities balance out
        (DeltaInstanceInputs[] memory wrappedDeltaInputs, int256 quantity, uint256 rcv) = wrapDeltaInputs(deltaInputs);

        // Adjust the last delta so that the full sum is zero
        if (quantity != 0) {
            wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity -= quantity;
        }
        for (uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            uint256[2] memory instance = generateDeltaInstance(wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }

        // Compute the proof for the balanced transaction
        DeltaProofInputs memory sumDeltaInputs = DeltaProofInputs({rcv: rcv, verifyingKey: verifyingKey});
        bytes memory proof = generateDeltaProof(sumDeltaInputs);

        // Verify that the balanced transaction proof succeeds
        Delta.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
    }

    /// @notice Check that an imbalanced transaction fails verification
    function testFuzz_verify_imbalanced_delta_fails(DeltaInstanceInputs[] memory deltaInputs, bytes32 verifyingKey)
        public
    {
        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];

        // Truncate the delta inputs to improve test performance
        uint256 maxDeltaLen = 10;
        deltaInputs = truncateDeltaInputs(deltaInputs, deltaInputs.length % maxDeltaLen);

        // Accumulate the total quantity and randomness commitment
        (DeltaInstanceInputs[] memory wrappedDeltaInputs, int256 quantity, uint256 rcv) = wrapDeltaInputs(deltaInputs);

        // Assume that the deltas are imbalanced
        vm.assume(_canonicalizeQuantity(quantity) != 0);
        for (uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            uint256[2] memory instance = generateDeltaInstance(wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }

        // Compute the proof for the balanced transaction
        DeltaProofInputs memory sumDeltaInputs = DeltaProofInputs({rcv: rcv, verifyingKey: verifyingKey});
        bytes memory proof = generateDeltaProof(sumDeltaInputs);

        // Verify that the imbalanced transaction proof fails
        vm.expectPartialRevert(Delta.DeltaMismatch.selector); // TODO: Can we use a more explicit revert?
        Delta.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
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
