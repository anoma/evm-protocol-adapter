// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {EllipticCurveK256} from "../../src/libs/EllipticCurveK256.sol";

import {Delta} from "../../src/proving/Delta.sol";
import {Transaction} from "../../src/Types.sol";

import {TransactionExample} from "../examples/Transaction.e.sol";
import {TxGen} from "../examples/TxGen.sol";

import {DeltaGen} from "../libs/DeltaGen.sol";
import {SignMagnitude} from "../libs/SignMagnitude.sol";

contract DeltaProofTest is Test {
    using SignMagnitude for SignMagnitude.Number;
    using EllipticCurveK256 for uint256;
    using DeltaGen for DeltaGen.InstanceInputs[];
    using DeltaGen for DeltaGen.InstanceInputs;

    struct FuzzerInstanceInputsExceptKind {
        uint256 valueCommitmentRandomness;
        uint128 quantity;
        bool consumed;
    }

    function test_verify_delta_succeeds(
        uint256 kind,
        uint256 valueCommitmentRandomness,
        bool consumed,
        bytes32 verifyingKey
    ) public {
        // Construct delta instance inputs from the above parameters
        DeltaGen.InstanceInputs memory deltaInstanceInputs = DeltaGen.InstanceInputs({
            kind: kind,
            quantity: 0,
            consumed: consumed,
            valueCommitmentRandomness: valueCommitmentRandomness
        });
        _assumeDeltaInstance(deltaInstanceInputs);
        // Construct delta proof inputs from the above parameters
        DeltaGen.ProofInputs memory deltaProofInputs =
            DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness, verifyingKey: verifyingKey});
        _assumeDeltaProof(deltaProofInputs);
        // Generate a delta instance from the above inputs
        uint256[2] memory instance = DeltaGen.generateInstance(vm, deltaInstanceInputs);
        // Generate a delta proof from the above inputs
        bytes memory proof = DeltaGen.generateProof(vm, deltaProofInputs);
        // Verify that the generated delta proof is valid
        Delta.verify({proof: proof, instance: instance, verifyingKey: deltaProofInputs.verifyingKey});
    }

    /// @notice Test that Delta.add correctly adds deltas
    function test_add_delta_correctness(
        uint256 kind,
        uint256 valueCommitmentRandomness1,
        uint128 quantity1,
        bool consumed1,
        uint256 valueCommitmentRandomness2,
        uint128 quantity2,
        bool consumed2
    ) public {
        // Construct delta instance inputs from the above parameters
        DeltaGen.InstanceInputs memory deltaInputs1 = DeltaGen.InstanceInputs({
            kind: kind,
            quantity: quantity1,
            consumed: consumed1,
            valueCommitmentRandomness: valueCommitmentRandomness1
        });
        DeltaGen.InstanceInputs memory deltaInputs2 = DeltaGen.InstanceInputs({
            kind: kind,
            quantity: quantity2,
            consumed: consumed2,
            valueCommitmentRandomness: valueCommitmentRandomness2
        });
        // Filter out overflows
        vm.assume(
            deltaInputs1.consumed != deltaInputs2.consumed
                || deltaInputs2.quantity <= type(uint128).max - deltaInputs1.quantity
        );
        vm.assume(
            0 < deltaInputs2.valueCommitmentRandomness
                && deltaInputs2.valueCommitmentRandomness <= type(uint256).max - deltaInputs1.valueCommitmentRandomness
        );

        // Add the deltas
        SignMagnitude.Number memory sum = SignMagnitude.Number(deltaInputs1.consumed, deltaInputs1.quantity).add(
            SignMagnitude.Number(deltaInputs2.consumed, deltaInputs2.quantity)
        );

        // Compute the inputs corresponding to the sum of deltas
        DeltaGen.InstanceInputs memory deltaInputs3 = DeltaGen.InstanceInputs({
            kind: deltaInputs1.kind,
            quantity: sum.magnitude,
            consumed: sum.isNegative,
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
    function test_verify_inconsistent_delta_fails1(
        uint256 kind,
        uint256 valueCommitmentRandomness,
        uint128 quantity,
        bool consumed,
        bytes32 verifyingKey
    ) public {
        // Construct delta instance inputs from the above parameters
        DeltaGen.InstanceInputs memory deltaInstanceInputs = DeltaGen.InstanceInputs({
            kind: kind,
            quantity: quantity,
            consumed: consumed,
            valueCommitmentRandomness: valueCommitmentRandomness
        });
        // Construct delta proof inputs from the above parameters
        DeltaGen.ProofInputs memory deltaProofInputs =
            DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness, verifyingKey: verifyingKey});
        // Filter out inadmissible private keys or equal keys
        deltaProofInputs.valueCommitmentRandomness = deltaInstanceInputs.valueCommitmentRandomness;
        vm.assume(deltaInstanceInputs.kind.modOrder() != 0);
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
    function test_verify_inconsistent_delta_fails2(
        uint256 kind,
        bool consumed,
        bytes32 verifyingKey,
        uint256 valueCommitmentRandomness1,
        uint256 valueCommitmentRandomness2
    ) public {
        // Construct delta proof inputs from the above parameters
        DeltaGen.ProofInputs memory deltaInputs1 =
            DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness1, verifyingKey: verifyingKey});
        // Construct delta instance inputs from the above parameters
        DeltaGen.InstanceInputs memory deltaInputs2 = DeltaGen.InstanceInputs({
            kind: kind,
            quantity: 0,
            consumed: consumed,
            valueCommitmentRandomness: valueCommitmentRandomness2
        });
        // Filter out inadmissible private keys or equal keys
        vm.assume(
            deltaInputs1.valueCommitmentRandomness.modOrder() != deltaInputs2.valueCommitmentRandomness.modOrder()
        );
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
    function test_verify_inconsistent_delta_fails3(
        uint256 kind,
        uint256 valueCommitmentRandomness,
        bool consumed,
        bytes32 verifyingKey1,
        bytes32 verifyingKey2
    ) public {
        // Construct delta proof inputs from the above parameters
        DeltaGen.ProofInputs memory deltaInputs1 =
            DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness, verifyingKey: verifyingKey1});
        // Construct delta instance inputs from the above parameters
        DeltaGen.InstanceInputs memory deltaInputs2 = DeltaGen.InstanceInputs({
            kind: kind,
            quantity: 0,
            consumed: consumed,
            valueCommitmentRandomness: valueCommitmentRandomness
        });
        // Filter out inadmissible private keys or equal keys
        vm.assume(deltaInputs1.verifyingKey != verifyingKey2);
        _assumeDeltaInstance(deltaInputs2);
        _assumeDeltaProof(deltaInputs1);
        // Generate a delta proof and instance from the above tags and preimage
        bytes memory proof1 = DeltaGen.generateProof(vm, deltaInputs1);
        uint256[2] memory instance2 = DeltaGen.generateInstance(vm, deltaInputs2);
        // Verify that the mixing deltas is invalid
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        Delta.verify({proof: proof1, instance: instance2, verifyingKey: verifyingKey2});
    }

    /// @notice Check that a balanced transaction does pass verification
    function test_verify_balanced_delta_succeeds(
        uint256 kind,
        FuzzerInstanceInputsExceptKind[] memory fuzzerInputs,
        bytes32 verifyingKey
    ) public {
        DeltaGen.InstanceInputs[] memory deltaInputs = _getBoundedDeltaInstances(kind, fuzzerInputs);

        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];

        // Make sure that the delta quantities balance out
        (
            DeltaGen.InstanceInputs[] memory wrappedDeltaInputs,
            bool consumed,
            uint128 quantity,
            uint256 valueCommitmentRandomness
        ) = deltaInputs.createBalancedDeltaInputArray();
        // Adjust the last delta so that the full sum is zero

        if (quantity != 0) {
            SignMagnitude.Number memory diff = SignMagnitude.Number(
                wrappedDeltaInputs[wrappedDeltaInputs.length - 1].consumed,
                wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity
            ).sub(SignMagnitude.Number(consumed, quantity));

            wrappedDeltaInputs[wrappedDeltaInputs.length - 1].consumed = diff.isNegative;
            wrappedDeltaInputs[wrappedDeltaInputs.length - 1].quantity = diff.magnitude;
        }

        for (uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            _assumeDeltaInstance(wrappedDeltaInputs[i]);
            uint256[2] memory instance = DeltaGen.generateInstance(vm, wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }

        // Compute the proof for the balanced transaction
        DeltaGen.ProofInputs memory sumDeltaInputs =
            DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness, verifyingKey: verifyingKey});
        _assumeDeltaProof(sumDeltaInputs);
        bytes memory proof = DeltaGen.generateProof(vm, sumDeltaInputs);
        // Verify that the balanced transaction proof succeeds
        Delta.verify({proof: proof, instance: deltaAcc, verifyingKey: verifyingKey});
    }

    /// @notice Check that an imbalanced transaction fails verification
    function test_verify_imbalanced_delta_fails(
        uint256 kind,
        FuzzerInstanceInputsExceptKind[] memory fuzzerInputs,
        bytes32 verifyingKey
    ) public {
        DeltaGen.InstanceInputs[] memory deltaInputs = _getBoundedDeltaInstances(kind, fuzzerInputs);

        uint256[2] memory deltaAcc = [uint256(0), uint256(0)];

        // Accumulate the total quantity and randomness commitment
        (
            DeltaGen.InstanceInputs[] memory wrappedDeltaInputs,
            bool consumed,
            uint128 quantity,
            uint256 valueCommitmentRandomness
        ) = deltaInputs.createBalancedDeltaInputArray();
        // Assume that the deltas are imbalanced
        vm.assume(DeltaGen.canonicalizeQuantity(consumed, quantity) != 0);
        for (uint256 i = 0; i < wrappedDeltaInputs.length; i++) {
            // Compute the delta instance and accumulate it
            _assumeDeltaInstance(wrappedDeltaInputs[i]);
            uint256[2] memory instance = DeltaGen.generateInstance(vm, wrappedDeltaInputs[i]);
            deltaAcc = Delta.add(deltaAcc, instance);
        }
        // Compute the proof for the balanced transaction
        DeltaGen.ProofInputs memory sumDeltaInputs =
            DeltaGen.ProofInputs({valueCommitmentRandomness: valueCommitmentRandomness, verifyingKey: verifyingKey});
        _assumeDeltaProof(sumDeltaInputs);
        bytes memory proof = DeltaGen.generateProof(vm, sumDeltaInputs);
        // Verify that the imbalanced transaction proof fails
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
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

    /// @notice Assume that the delta instance inputs are well-formed. I.e. the
    /// value commitment randomness and resource kind are both non-zero.
    function _assumeDeltaInstance(DeltaGen.InstanceInputs memory deltaInputs) internal pure {
        // The value commitment randomness must be non-zero modulo the base
        // point order
        deltaInputs.valueCommitmentRandomness = deltaInputs.valueCommitmentRandomness.modOrder();
        vm.assume(deltaInputs.valueCommitmentRandomness != 0);
        // The kind must be non-zero modulo the base point order
        deltaInputs.kind = deltaInputs.kind.modOrder();
        vm.assume(deltaInputs.kind != 0);
        // The exponent must be non-zero modulo the base point order
        uint256 quantity = DeltaGen.canonicalizeQuantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, EllipticCurveK256.ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.valueCommitmentRandomness, EllipticCurveK256.ORDER);
        vm.assume(preDelta != 0);
    }

    /// @notice Assume that the delta proof inputs are well-formed. I.e. the
    /// value commitment randomness is non-zero.
    function _assumeDeltaProof(DeltaGen.ProofInputs memory deltaInputs) internal pure {
        deltaInputs.valueCommitmentRandomness = deltaInputs.valueCommitmentRandomness.modOrder();
        vm.assume(deltaInputs.valueCommitmentRandomness != 0);
    }

    function _getBoundedDeltaInstances(uint256 kind, FuzzerInstanceInputsExceptKind[] memory fuzzerInputs)
        internal
        pure
        returns (DeltaGen.InstanceInputs[] memory deltaInputs)
    {
        // Kind
        vm.assume(kind.modOrder() != 0);

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
}
