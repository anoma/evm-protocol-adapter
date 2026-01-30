// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EllipticCurve} from "elliptic-curve-solidity-0.2.5/contracts/EllipticCurve.sol";
import {Test, Vm} from "forge-std-1.14.0/src/Test.sol";

import {Delta} from "../../src/libs/proving/Delta.sol";
import {Transaction} from "../../src/Types.sol";

import {DeltaGen} from "../libs/DeltaGen.sol";
import {Parsing} from "../libs/Parsing.sol";
import {SignMagnitude} from "../libs/SignMagnitude.sol";
import {TxGen} from "../libs/TxGen.sol";

library DeltaFuzzing {
    struct InstanceInputsExceptKind {
        uint256 valueCommitmentRandomness;
        uint128 quantity;
        bool consumed;
    }

    /// @dev This function exposes `Delta.verify` for the fuzzer.
    function verify(bytes memory proof, Delta.Point memory instance, bytes32 verifyingKey) public pure {
        Delta.verify({proof: proof, instance: instance, verifyingKey: verifyingKey});
    }
}

contract DeltaProofTest is Test {
    using Parsing for Vm;
    using SignMagnitude for SignMagnitude.Number;
    using Delta for Delta.Point;
    using DeltaGen for DeltaGen.InstanceInputs[];
    using DeltaGen for DeltaGen.InstanceInputs;
    using DeltaGen for uint256;

    function testFuzz_verify_delta_succeeds(
        uint256 kind,
        uint256 valueCommitmentRandomness,
        bool consumed,
        bytes32 verifyingKey
    ) public {
        kind = bound(kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        valueCommitmentRandomness = bound(valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);

        // Construct delta instance inputs from the above parameters
        DeltaGen.InstanceInputs memory deltaInstanceInputs = DeltaGen.InstanceInputs({
            kind: kind, quantity: 0, consumed: consumed, valueCommitmentRandomness: valueCommitmentRandomness
        });
        vm.assume(deltaInstanceInputs.computePreDelta() != 0);

        // Construct delta proof inputs from the above parameters
        DeltaGen.ProofInputs memory deltaProofInputs =
            DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness, verifyingKey: verifyingKey});

        // Generate a delta instance from the above inputs
        Delta.Point memory instance = DeltaGen.generateInstance(vm, deltaInstanceInputs);

        // Generate a delta proof from the above inputs
        bytes memory proof = DeltaGen.generateProof(vm, deltaProofInputs);

        // Verify that the generated delta proof is valid
        DeltaFuzzing.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    /// @notice Test that Delta.add correctly adds deltas
    function testFuzz_add_delta_correctness(
        uint256 kind,
        DeltaFuzzing.InstanceInputsExceptKind memory input1,
        DeltaFuzzing.InstanceInputsExceptKind memory input2
    ) public {
        kind = bound(kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        input1.valueCommitmentRandomness = bound(input1.valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);
        input2.valueCommitmentRandomness = bound(input2.valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);

        vm.assume(input1.consumed != input2.consumed || input2.quantity <= type(uint128).max - input1.quantity);
        vm.assume(
            0 < input1.valueCommitmentRandomness
                && input2.valueCommitmentRandomness <= type(uint256).max - input1.valueCommitmentRandomness
        );

        // Construct delta instance inputs from the above parameters
        DeltaGen.InstanceInputs memory deltaInputs1 = DeltaGen.InstanceInputs({
            kind: kind,
            quantity: input1.quantity,
            consumed: input1.consumed,
            valueCommitmentRandomness: input1.valueCommitmentRandomness
        });
        vm.assume(deltaInputs1.computePreDelta() != 0);
        DeltaGen.InstanceInputs memory deltaInputs2 = DeltaGen.InstanceInputs({
            kind: kind,
            quantity: input2.quantity,
            consumed: input2.consumed,
            valueCommitmentRandomness: input2.valueCommitmentRandomness
        });
        vm.assume(deltaInputs2.computePreDelta() != 0);

        // Add the deltas
        SignMagnitude.Number memory summedNumber = SignMagnitude.Number(deltaInputs1.consumed, deltaInputs1.quantity)
            .add(SignMagnitude.Number(deltaInputs2.consumed, deltaInputs2.quantity));

        // Compute the inputs corresponding to the sum of deltas
        DeltaGen.InstanceInputs memory summedDeltaInputs = DeltaGen.InstanceInputs({
            kind: deltaInputs1.kind,
            quantity: summedNumber.magnitude,
            consumed: summedNumber.isNegative,
            valueCommitmentRandomness: deltaInputs1.valueCommitmentRandomness + deltaInputs2.valueCommitmentRandomness
        });
        // TODO refactor?
        summedDeltaInputs.valueCommitmentRandomness = summedDeltaInputs.valueCommitmentRandomness.modOrder();
        vm.assume(summedDeltaInputs.valueCommitmentRandomness != 0);
        vm.assume(summedDeltaInputs.computePreDelta() != 0);

        // Generate a delta proof and instance from the above tags and preimage
        Delta.Point memory instance1 = DeltaGen.generateInstance(vm, deltaInputs1);
        Delta.Point memory instance2 = DeltaGen.generateInstance(vm, deltaInputs2);
        Delta.Point memory expectedDelta = DeltaGen.generateInstance(vm, summedDeltaInputs);

        // Verify that the deltas add correctly
        Delta.Point memory computedDelta = Delta.add(instance1, instance2);

        assertEq(computedDelta.x, expectedDelta.x);
        assertEq(computedDelta.y, expectedDelta.y);
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function testFuzz_verify_inconsistent_delta_fails1(
        DeltaGen.InstanceInputs memory deltaInstanceInputs,
        bytes32 fuzzedVerifyingKey
    ) public {
        deltaInstanceInputs.kind = bound(deltaInstanceInputs.kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        deltaInstanceInputs.valueCommitmentRandomness =
            bound(deltaInstanceInputs.valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);

        vm.assume(DeltaGen.canonicalizeQuantity(deltaInstanceInputs.consumed, deltaInstanceInputs.quantity) != 0);

        vm.assume(deltaInstanceInputs.computePreDelta() != 0);

        // Construct delta proof inputs from the above parameters
        DeltaGen.ProofInputs memory deltaProofInputs = DeltaGen.ProofInputs({
            valueCommitmentRandomness: deltaInstanceInputs.valueCommitmentRandomness, verifyingKey: fuzzedVerifyingKey
        });

        // Generate a delta proof and instance from the above tags and preimage
        Delta.Point memory instance = DeltaGen.generateInstance(vm, deltaInstanceInputs);
        bytes memory proof = DeltaGen.generateProof(vm, deltaProofInputs);
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        DeltaFuzzing.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to instance
    function testFuzz_verify_inconsistent_delta_fails2( // TODO Improve name
        uint256 kind,
        bool consumed,
        bytes32 verifyingKey,
        uint256 valueCommitmentRandomness1,
        uint256 valueCommitmentRandomness2
    ) public {
        kind = bound(kind, 1, DeltaGen.SECP256K1_ORDER - 1);

        valueCommitmentRandomness1 = bound(valueCommitmentRandomness1, 1, DeltaGen.SECP256K1_ORDER - 1);
        valueCommitmentRandomness2 = bound(valueCommitmentRandomness2, 1, DeltaGen.SECP256K1_ORDER - 1);
        vm.assume(valueCommitmentRandomness1.modOrder() != valueCommitmentRandomness2.modOrder());

        bytes memory proofRcv1 = DeltaGen.generateProof(
            vm,
            DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness1, verifyingKey: verifyingKey})
        );

        Delta.Point memory instanceRcv2;
        {
            DeltaGen.InstanceInputs memory deltaInputs2 = DeltaGen.InstanceInputs({
                kind: kind, quantity: 0, consumed: consumed, valueCommitmentRandomness: valueCommitmentRandomness2
            });
            vm.assume(deltaInputs2.computePreDelta() != 0); // TODO move?
            instanceRcv2 = DeltaGen.generateInstance(vm, deltaInputs2);
        }

        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        DeltaFuzzing.verify({proof: proofRcv1, instance: instanceRcv2, verifyingKey: verifyingKey});
    }

    /// @notice Test that Delta.verify rejects a delta proof that does not correspond to the verifying key
    function testFuzz_verify_fails_if_verifying_keys_of_instance_and_proof_mismatch(
        uint256 kind,
        uint256 valueCommitmentRandomness,
        bool consumed,
        bytes32 verifyingKey1,
        bytes32 verifyingKey2
    ) public {
        kind = bound(kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        valueCommitmentRandomness = bound(valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);
        vm.assume(verifyingKey1 != verifyingKey2);

        bytes memory proofForVk1 = DeltaGen.generateProof(
            vm,
            DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness, verifyingKey: verifyingKey1})
        );

        Delta.Point memory instance;
        {
            DeltaGen.InstanceInputs memory deltaInputs2 = DeltaGen.InstanceInputs({
                kind: kind, quantity: 0, consumed: consumed, valueCommitmentRandomness: valueCommitmentRandomness
            });
            vm.assume(deltaInputs2.computePreDelta() != 0);

            instance = DeltaGen.generateInstance(vm, deltaInputs2);
        }

        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        DeltaFuzzing.verify({proof: proofForVk1, instance: instance, verifyingKey: verifyingKey2});
    }

    /// @notice Check that an imbalanced transaction (non-zero quantity sum) fails verification.
    function testFuzz_verify_imbalanced_delta_fails(
        uint256 kind,
        uint256 valueCommitmentRandomness,
        uint128 quantity,
        bytes32 verifyingKey
    ) public {
        // Bound inputs to valid ranges
        kind = bound(kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        valueCommitmentRandomness = bound(valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);
        vm.assume(quantity > 0); // Must have non-zero quantity to be imbalanced

        // Create a single delta with non-zero quantity (imbalanced by definition)
        DeltaGen.InstanceInputs memory deltaInput = DeltaGen.InstanceInputs({
            kind: kind,
            valueCommitmentRandomness: valueCommitmentRandomness,
            quantity: quantity,
            consumed: false // positive quantity, doesn't balance to zero
        });
        vm.assume(deltaInput.isValid());

        // Generate the delta instance
        Delta.Point memory deltaInstance = DeltaGen.generateInstance(vm, deltaInput);

        // Generate proof with the same randomness
        bytes memory proof = DeltaGen.generateProof(
            vm, DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness, verifyingKey: verifyingKey})
        );

        // Verify should fail because quantity != 0 (transaction is imbalanced)
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        DeltaFuzzing.verify({proof: proof, instance: deltaInstance, verifyingKey: verifyingKey});
    }

    function testFuzz_add_reverts_when_adding_a_non_curve_from_the_right(uint32 k, Delta.Point memory rhs) public {
        // Ensure that `rhs` is not on the curve.
        vm.assume(!EllipticCurve.isOnCurve({_x: rhs.x, _y: rhs.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}));

        // Generate a random point on the curve.
        Delta.Point memory lhs = _mul({p: Delta.Point({x: Delta._GX, y: Delta._GY}), k: k});
        assertTrue(
            EllipticCurve.isOnCurve({_x: lhs.x, _y: lhs.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "Left-hand side point must be on the curve."
        );

        // Attempt to add a point being not on the curve.
        vm.expectRevert(abi.encodeWithSelector(Delta.PointNotOnCurve.selector, rhs), address(this));
        lhs.add(rhs);
    }

    function testFuzz_add_reverts_when_adding_zero_from_the_right(uint32 k) public {
        // Generate a random point on the curve.
        Delta.Point memory lhs = _mul({p: Delta.Point({x: Delta._GX, y: Delta._GY}), k: k});
        assertTrue(
            EllipticCurve.isOnCurve({_x: lhs.x, _y: lhs.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "Left-hand side point must be on the curve."
        );

        Delta.Point memory zero = Delta.zero();

        // Add the two points.
        vm.expectRevert(abi.encodeWithSelector(Delta.PointNotOnCurve.selector, zero), address(this));
        lhs.add(zero);
    }

    function test_verify_example_delta_proof() public view {
        Transaction memory txn = vm.parseTransaction("test/examples/transactions/test_tx_reg_01_01.bin");

        DeltaFuzzing.verify({
            proof: txn.deltaProof,
            instance: Delta.Point({
                x: uint256(txn.actions[0].complianceVerifierInputs[0].instance.unitDeltaX),
                y: uint256(txn.actions[0].complianceVerifierInputs[0].instance.unitDeltaY)
            }),
            verifyingKey: Delta.computeVerifyingKey(TxGen.collectTags(txn.actions))
        });
    }

    function testFuzz_add_adding_zero_from_the_left_produces_a_curve_point(uint32 k) public pure {
        Delta.Point memory zero = Delta.zero();

        // Generate a random point on the curve.
        Delta.Point memory rhs = _mul({p: Delta.Point({x: Delta._GX, y: Delta._GY}), k: k});
        assertTrue(
            EllipticCurve.isOnCurve({_x: rhs.x, _y: rhs.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "Right-hand side point must be on the curve."
        );

        // Add the two points and check that the sum is a curve point.
        Delta.Point memory sum = zero.add(rhs);
        assertTrue(
            EllipticCurve.isOnCurve({_x: sum.x, _y: sum.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "Sum must be on the curve."
        );
    }

    function testFuzz_add_adding_zero_from_the_left_is_the_identity_operation(uint32 k) public pure {
        Delta.Point memory zero = Delta.zero();

        // Generate a random point on the curve.
        Delta.Point memory rhs = _mul({p: Delta.Point({x: Delta._GX, y: Delta._GY}), k: k});
        assertTrue(
            EllipticCurve.isOnCurve({_x: rhs.x, _y: rhs.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "Right-hand side point must be on the curve."
        );

        // Add the two points and check that the sum is a curve point.
        Delta.Point memory sum = zero.add(rhs);
        assertEq(sum.x, rhs.x);
        assertEq(sum.y, rhs.y);
    }

    function testFuzz_add_adding_two_curve_points_produces_a_curve_point(uint32 k1, uint32 k2) public pure {
        // Generate two random points on the curve.
        Delta.Point memory lhs = _mul({p: Delta.Point({x: Delta._GX, y: Delta._GY}), k: k1});
        assertTrue(
            EllipticCurve.isOnCurve({_x: lhs.x, _y: lhs.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "Left-hand side point must be on the curve."
        );

        Delta.Point memory rhs = _mul({p: Delta.Point({x: Delta._GX, y: Delta._GY}), k: k2});
        assertTrue(
            EllipticCurve.isOnCurve({_x: rhs.x, _y: rhs.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "Right-hand side must be on the curve."
        );

        // Add the two points and check that the sum is a curve point.
        Delta.Point memory sum = lhs.add(rhs);
        assertTrue(
            EllipticCurve.isOnCurve({_x: sum.x, _y: sum.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "Sum must be on the curve."
        );
    }

    function test_zero_is_not_on_the_curve() public pure {
        Delta.Point memory p2 = Delta.zero();
        assertFalse(EllipticCurve.isOnCurve({_x: p2.x, _y: p2.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}));
    }

    /// @notice Check that balanced pairs (using the new simplified approach) pass verification.
    /// @dev createBalancedPairs guarantees quantities sum to zero by pairing each +q with -q.
    function testFuzz_verify_balanced_pairs_succeeds(
        uint256 kind,
        DeltaFuzzing.InstanceInputsExceptKind[] memory fuzzerInputs,
        bytes32 verifyingKey
    ) public {
        // Bound kind to valid range (non-zero, less than curve order)
        kind = bound(kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        DeltaGen.InstanceInputs[] memory baseInputs = _getBoundedDeltaInstances(kind, fuzzerInputs);
        vm.assume(baseInputs.length > 0);

        // Create balanced pairs: for each input with quantity q, creates +q and -q entries
        // This guarantees the quantities sum to zero by construction
        (DeltaGen.InstanceInputs[] memory pairedInputs, uint256 totalRandomness) =
            DeltaGen.createBalancedPairs(baseInputs);

        // Ensure accumulated randomness is valid for proof generation
        totalRandomness = totalRandomness.modOrder();
        vm.assume(totalRandomness != 0);

        // Generate and accumulate delta instances
        Delta.Point memory deltaAcc = Delta.zero();
        for (uint256 i = 0; i < pairedInputs.length; i++) {
            // Normalize and validate each input
            pairedInputs[i].valueCommitmentRandomness = pairedInputs[i].valueCommitmentRandomness.modOrder();
            vm.assume(pairedInputs[i].isValid());

            Delta.Point memory instance = DeltaGen.generateInstance(vm, pairedInputs[i]);
            deltaAcc = deltaAcc.add(instance);
        }

        // Generate proof with the total accumulated randomness
        bytes memory proof = DeltaGen.generateProof(
            vm, DeltaGen.ProofInputs({valueCommitmentRandomness: totalRandomness, verifyingKey: verifyingKey})
        );

        // Verify: should succeed because quantities are balanced (sum to zero)
        DeltaFuzzing.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
    }

    function _getBoundedDeltaInstances(uint256 kind, DeltaFuzzing.InstanceInputsExceptKind[] memory fuzzerInputs)
        internal
        pure
        returns (DeltaGen.InstanceInputs[] memory deltaInputs)
    {
        // Array length
        uint256 boundedLength = bound(fuzzerInputs.length, 0, 10);

        // solhint-disable-next-line no-inline-assembly
        assembly {
            mstore(fuzzerInputs, boundedLength)
        }

        deltaInputs = new DeltaGen.InstanceInputs[](fuzzerInputs.length);
        for (uint256 i = 0; i < fuzzerInputs.length; i++) {
            deltaInputs[i] = DeltaGen.InstanceInputs({
                kind: kind,
                valueCommitmentRandomness: fuzzerInputs[i].valueCommitmentRandomness,
                quantity: fuzzerInputs[i].quantity,
                consumed: fuzzerInputs[i].consumed
            });
        }
    }

    function _mul(Delta.Point memory p, uint256 k) internal pure returns (Delta.Point memory product) {
        (product.x, product.y) = EllipticCurve.ecMul({_k: k, _x: p.x, _y: p.y, _aa: Delta._AA, _pp: Delta._PP});
    }
}
