// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ECDSA} from "@openzeppelin-contracts-5.6.1/utils/cryptography/ECDSA.sol";
import {EllipticCurve} from "elliptic-curve-solidity-0.2.5/contracts/EllipticCurve.sol";
import {Test, Vm} from "forge-std-1.15.0/src/Test.sol";

import {Delta} from "../../src/libs/proving/Delta.sol";
import {Transaction} from "../../src/Types.sol";

import {DeltaGen} from "../libs/DeltaGen.sol";
import {Parsing} from "../libs/Parsing.sol";
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
    using Delta for Delta.Point;
    using DeltaGen for DeltaGen.InstanceInputs[];
    using DeltaGen for DeltaGen.InstanceInputs;
    using DeltaGen for uint256;

    function testFuzz_add_adds_deltas(
        uint256 kind,
        DeltaFuzzing.InstanceInputsExceptKind memory input1,
        DeltaFuzzing.InstanceInputsExceptKind memory input2
    ) public {
        kind = bound(kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        input1.valueCommitmentRandomness = bound(input1.valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);
        input2.valueCommitmentRandomness = bound(input2.valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);

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

        // The expected summed delta is the curve point derived from the sum of the two pre-delta scalars: scalar
        // addition modulo the curve order matches point addition on the curve.
        uint256 expectedPreDelta =
            addmod(deltaInputs1.computePreDelta(), deltaInputs2.computePreDelta(), DeltaGen.SECP256K1_ORDER);
        vm.assume(expectedPreDelta != 0);

        // Generate a delta proof and instance from the above tags and preimage
        Delta.Point memory instance1 = DeltaGen.generateInstance(vm, deltaInputs1);
        Delta.Point memory instance2 = DeltaGen.generateInstance(vm, deltaInputs2);
        Delta.Point memory expectedDelta = DeltaGen.generateInstanceFromPreDelta(vm, expectedPreDelta);

        // Verify that the deltas add correctly
        Delta.Point memory computedDelta = Delta.add(instance1, instance2);

        assertEq(computedDelta.x, expectedDelta.x, "computed delta x should match expected");
        assertEq(computedDelta.y, expectedDelta.y, "computed delta y should match expected");
    }

    function testFuzz_verify_reverts_if_the_delta_is_non_zero(
        DeltaGen.InstanceInputs memory deltaInstanceInputs,
        bytes32 verifyingKey
    ) public {
        deltaInstanceInputs.kind = bound(deltaInstanceInputs.kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        deltaInstanceInputs.valueCommitmentRandomness =
            bound(deltaInstanceInputs.valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);

        // Ensure that the quantity and pre-delta are non-zero.
        vm.assume(DeltaGen.signedQuantityModOrder(deltaInstanceInputs.consumed, deltaInstanceInputs.quantity) != 0);
        vm.assume(deltaInstanceInputs.computePreDelta() != 0);

        // Generate a delta proof and instance from the above tags and preimage
        Delta.Point memory instance = DeltaGen.generateInstance(vm, deltaInstanceInputs);

        // Construct delta proof inputs from the above parameters
        DeltaGen.ProofInputs memory deltaProofInputs = DeltaGen.ProofInputs({
            summedValueCommitmentRandomness: deltaInstanceInputs.valueCommitmentRandomness,
            verifyingKey: verifyingKey
        });
        bytes memory proof = DeltaGen.generateProof(vm, deltaProofInputs);

        address expected = instance.toAccount();
        address actual = ECDSA.recover(deltaProofInputs.verifyingKey, proof);
        vm.expectRevert(abi.encodeWithSelector(Delta.DeltaMismatch.selector, expected, actual));
        DeltaFuzzing.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    function testFuzz_verify_reverts_if_value_commitment_randomness_of_instance_and_proof_mismatch(
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

        DeltaGen.InstanceInputs memory deltaInputs = DeltaGen.InstanceInputs({
            kind: kind, quantity: 0, consumed: consumed, valueCommitmentRandomness: valueCommitmentRandomness1
        });
        vm.assume(deltaInputs.computePreDelta() != 0);
        Delta.Point memory instanceRcv1 = DeltaGen.generateInstance(vm, deltaInputs);

        bytes memory proofRcv2 = DeltaGen.generateProof(
            vm,
            DeltaGen.ProofInputs({
                summedValueCommitmentRandomness: valueCommitmentRandomness2,
                verifyingKey: verifyingKey
            })
        );

        address expected = instanceRcv1.toAccount();
        address actual = ECDSA.recover(verifyingKey, proofRcv2);
        vm.expectRevert(abi.encodeWithSelector(Delta.DeltaMismatch.selector, expected, actual));
        DeltaFuzzing.verify({proof: proofRcv2, instance: instanceRcv1, verifyingKey: verifyingKey});
    }

    function testFuzz_verify_reverts_if_verifying_keys_mismatch(
        uint256 kind,
        uint256 valueCommitmentRandomness,
        bool consumed,
        bytes32 verifyingKey1,
        bytes32 verifyingKey2
    ) public {
        kind = bound(kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        valueCommitmentRandomness = bound(valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);
        vm.assume(verifyingKey1 != verifyingKey2);

        DeltaGen.InstanceInputs memory deltaInputs = DeltaGen.InstanceInputs({
            kind: kind, quantity: 0, consumed: consumed, valueCommitmentRandomness: valueCommitmentRandomness
        });
        vm.assume(deltaInputs.computePreDelta() != 0);
        Delta.Point memory instance = DeltaGen.generateInstance(vm, deltaInputs);

        bytes memory proofForVk1 = DeltaGen.generateProof(
            vm,
            DeltaGen.ProofInputs({
                summedValueCommitmentRandomness: valueCommitmentRandomness,
                verifyingKey: verifyingKey1
            })
        );

        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        DeltaFuzzing.verify({proof: proofForVk1, instance: instance, verifyingKey: verifyingKey2});
    }

    function testFuzz_verify_passes_if_delta_is_zero(
        uint256 kind,
        uint256 valueCommitmentRandomness,
        bool consumed,
        bytes32 verifyingKey
    ) public {
        kind = bound(kind, 1, DeltaGen.SECP256K1_ORDER - 1);
        valueCommitmentRandomness = bound(valueCommitmentRandomness, 1, DeltaGen.SECP256K1_ORDER - 1);

        // Construct delta instance inputs from the above parameters for quantity zero.
        DeltaGen.InstanceInputs memory deltaInstanceInputs = DeltaGen.InstanceInputs({
            kind: kind, quantity: 0, consumed: consumed, valueCommitmentRandomness: valueCommitmentRandomness
        });
        vm.assume(deltaInstanceInputs.computePreDelta() != 0);

        // Construct delta proof inputs from the above parameters
        DeltaGen.ProofInputs memory deltaProofInputs =
            DeltaGen.ProofInputs({
                summedValueCommitmentRandomness: valueCommitmentRandomness,
                verifyingKey: verifyingKey
            });

        // Generate a delta instance from the above inputs
        Delta.Point memory instance = DeltaGen.generateInstance(vm, deltaInstanceInputs);

        // Generate a delta proof from the above inputs
        bytes memory proof = DeltaGen.generateProof(vm, deltaProofInputs);

        // Verify that the generated delta proof is valid
        DeltaFuzzing.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    function testFuzz_verify_passes_if_balanced_kind_and_quantity_pairs_accumulate_to_a_zero_delta(
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
            vm.assume(pairedInputs[i].computePreDelta() != 0);

            Delta.Point memory instance = DeltaGen.generateInstance(vm, pairedInputs[i]);
            deltaAcc = deltaAcc.add(instance);
        }

        // Generate proof with the total accumulated randomness
        bytes memory proof = DeltaGen.generateProof(
            vm,
            DeltaGen.ProofInputs({summedValueCommitmentRandomness: totalRandomness, verifyingKey: verifyingKey})
        );

        // Verify: should succeed because quantities are balanced (sum to zero)
        DeltaFuzzing.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
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
        assertEq(sum.x, rhs.x, "zero + rhs x should equal rhs x");
        assertEq(sum.y, rhs.y, "zero + rhs y should equal rhs y");
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
        assertFalse(
            EllipticCurve.isOnCurve({_x: p2.x, _y: p2.y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "zero point should not be on the curve"
        );
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
