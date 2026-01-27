// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VmSafe} from "forge-std-1.14.0/src/Vm.sol";

import {Delta} from "../../src/libs/proving/Delta.sol";
import {SignMagnitude} from "./SignMagnitude.sol";

library DeltaGen {
    using SignMagnitude for SignMagnitude.Number;
    using DeltaGen for uint256;

    /// @notice The parameters required to generate a mock delta instance for testing.
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

    /// @notice The parameters required to generate a delta proof.
    /// @param valueCommitmentRandomness Value commitment randomness.
    /// @param verifyingKey The hash being signed over.
    struct ProofInputs {
        uint256 valueCommitmentRandomness;
        bytes32 verifyingKey;
    }

    /// @notice The secp256k1 (K-256) elliptic curve order.
    uint256 internal constant SECP256K1_ORDER = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    // Resource kind must be non-zero
    error KindZero();
    error KindMismatch(uint256 expected, uint256 actual);

    // Value commitment randomness must be non-zero
    error ValueCommitmentRandomnessZero();
    // Private key corresponding to delta instance must be non-zero
    error PreDeltaZero();

    /// @notice Generates a transaction delta instance by computing the public
    /// key corresponding to a(kind)^quantity * b^valueCommitmentRandomness
    /// @param vm VmSafe instance with which to compute public key
    /// @param deltaInputs Parameters required to determine a delta instance
    /// @return instance The delta instance corresponding to the parameters
    function generateInstance(VmSafe vm, InstanceInputs memory deltaInputs)
        internal
        returns (Delta.Point memory instance)
    {
        deltaInputs.valueCommitmentRandomness = validateValueCommitmentRandomness(deltaInputs.valueCommitmentRandomness);
        deltaInputs.kind = validateKind(deltaInputs.kind);
        uint256 quantity = canonicalizeQuantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.valueCommitmentRandomness, SECP256K1_ORDER);
        if (preDelta == 0) {
            revert DeltaGen.PreDeltaZero();
        }
        // Derive address and public key from transaction delta
        VmSafe.Wallet memory valueWallet = vm.createWallet(preDelta);

        // Extract the transaction delta from the wallet
        instance = Delta.Point({x: valueWallet.publicKeyX, y: valueWallet.publicKeyY});
    }

    /// @notice Generates a transaction delta proof by signing verifyingKey with
    /// valueCommitmentRandomness
    /// @param vm VmSafe instance with which to sign verifyingKey
    /// @param deltaInputs Parameters required to construct a delta proof
    /// @return proof The delta proof corresponding to the parameters
    function generateProof(VmSafe vm, ProofInputs memory deltaInputs) internal returns (bytes memory proof) {
        deltaInputs.valueCommitmentRandomness = validateValueCommitmentRandomness(deltaInputs.valueCommitmentRandomness);
        // Compute the components of the transaction delta proof
        VmSafe.Wallet memory randomWallet = vm.createWallet(deltaInputs.valueCommitmentRandomness);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(randomWallet, deltaInputs.verifyingKey);
        // Finally compute the transaction delta proof
        proof = abi.encodePacked(r, s, v);
    }

    /// @notice Computes the modulo of a value and returns the remainder.
    /// @param value The value to compute the modulo for.
    /// @return remainder The remainder.
    function modOrder(uint256 value) internal pure returns (uint256 remainder) {
        remainder = value % SECP256K1_ORDER;
    }

    /// @notice Validates and normalizes the value commitment randomness.
    /// @param value The value commitment randomness to validate.
    /// @return normalized The normalized value (value % SECP256K1_ORDER).
    function validateValueCommitmentRandomness(uint256 value) internal pure returns (uint256 normalized) {
        normalized = value.modOrder();
        if (normalized == 0) {
            revert ValueCommitmentRandomnessZero();
        }
    }

    /// @notice Validates and normalizes the kind.
    /// @param value The kind value to validate.
    /// @return normalized The normalized kind (value % SECP256K1_ORDER).
    function validateKind(uint256 value) internal pure returns (uint256 normalized) {
        normalized = value.modOrder();
        if (normalized == 0) {
            revert KindZero();
        }
    }

    /// @notice Normalizes the kind and valueCommitmentRandomness fields of an InstanceInputs struct.
    /// @dev This function modifies the input in-place and also returns it for convenience.
    /// @param inputs The delta instance inputs to normalize.
    /// @return normalized The same inputs with normalized kind and valueCommitmentRandomness.
    function normalize(InstanceInputs memory inputs) internal pure returns (InstanceInputs memory normalized) {
        inputs.kind = inputs.kind.modOrder();
        inputs.valueCommitmentRandomness = inputs.valueCommitmentRandomness.modOrder();
        normalized = inputs;
    }

    /// @notice Checks if the given InstanceInputs will produce a valid (non-zero) preDelta.
    /// @param inputs The delta instance inputs to check.
    /// @return valid True if the inputs will produce a valid preDelta, false otherwise.
    function isValid(InstanceInputs memory inputs) internal pure returns (bool valid) {
        uint256 kind = inputs.kind.modOrder();
        uint256 vcr = inputs.valueCommitmentRandomness.modOrder();
        if (kind == 0 || vcr == 0) {
            return false;
        }
        uint256 canonicalizedQuantity = canonicalizeQuantity(inputs.consumed, inputs.quantity);
        uint256 prod = mulmod(kind, canonicalizedQuantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, vcr, SECP256K1_ORDER);
        return preDelta != 0;
    }

    /// @notice Convert an exponent represented as a boolean sign and a uint128
    /// magnitude to an equivalent uint256 assuming an order of SECP256K1_ORDER
    /// @param consumed False represents a non-negative quantity, true a non-positive quantity
    /// @param quantity The magnitude of the quantity being canonicalized
    /// @return quantityRepresentative The non-negative number less than SECP256K1_ORDER
    /// that's equivalent to the exponent modulo SECP256K1_ORDER
    function canonicalizeQuantity(bool consumed, uint128 quantity)
        internal
        pure
        returns (uint256 quantityRepresentative)
    {
        // If positive, leave the number unchanged
        quantityRepresentative = consumed ? ((SECP256K1_ORDER - uint256(quantity)).modOrder()) : uint256(quantity);
    }

    /// @notice Computes the pre-delta value from delta inputs.
    /// @dev preDelta = (kind * canonicalizedQuantity + valueCommitmentRandomness) mod SECP256K1_ORDER
    /// @param deltaInputs The delta instance inputs.
    /// @return preDelta The computed pre-delta value.
    function computePreDelta(DeltaGen.InstanceInputs memory deltaInputs) internal pure returns (uint256 preDelta) {
        uint256 canonicalizedQuantity = canonicalizeQuantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, canonicalizedQuantity, SECP256K1_ORDER);
        preDelta = addmod(prod, deltaInputs.valueCommitmentRandomness, SECP256K1_ORDER);
    }

    /// @notice Creates balanced delta pairs from an array of inputs.
    /// @dev Takes n inputs and creates 2n outputs: n positive (created) and n negative (consumed) with matching
    /// quantities. The quantities sum to zero by construction, guaranteeing balance.
    /// @param baseInputs The base delta inputs to create pairs from. All must have the same kind.
    /// @return pairedInputs Array of 2n delta inputs (n positive followed by n negative).
    /// @return valueCommitmentRandomnessAcc The accumulated randomness (sum of all randomnesses mod order).
    function createBalancedPairs(InstanceInputs[] memory baseInputs)
        internal
        pure
        returns (InstanceInputs[] memory pairedInputs, uint256 valueCommitmentRandomnessAcc)
    {
        if (baseInputs.length == 0) {
            return (baseInputs, 0);
        }

        uint256 expectedKind = baseInputs[0].kind;
        validateKind(expectedKind);

        // Create array with double the length for pairs
        pairedInputs = new InstanceInputs[](baseInputs.length * 2);
        valueCommitmentRandomnessAcc = 0;

        for (uint256 i = 0; i < baseInputs.length; i++) {
            if (baseInputs[i].kind != expectedKind) {
                revert KindMismatch({expected: expectedKind, actual: baseInputs[i].kind});
            }

            // Positive (created) version
            pairedInputs[i] = InstanceInputs({
                kind: expectedKind,
                valueCommitmentRandomness: baseInputs[i].valueCommitmentRandomness,
                quantity: baseInputs[i].quantity,
                consumed: false
            });

            // Negative (consumed) version - same quantity, opposite sign
            pairedInputs[baseInputs.length + i] = InstanceInputs({
                kind: expectedKind,
                valueCommitmentRandomness: baseInputs[i].valueCommitmentRandomness,
                quantity: baseInputs[i].quantity,
                consumed: true
            });

            // Accumulate randomness (each input contributes twice)
            valueCommitmentRandomnessAcc = addmod(
                valueCommitmentRandomnessAcc,
                mulmod(2, baseInputs[i].valueCommitmentRandomness, SECP256K1_ORDER),
                SECP256K1_ORDER
            );
        }
    }

    /// @notice Balances an array of delta inputs by adjusting the inputs so that the sum is within the range
    /// [halfMin, halfMax]. Moreover, it returns the accumulated quantity and value commitment randomness.
    /// @dev DEPRECATED: Use createBalancedPairs() instead for simpler and more predictable behavior.
    function createBalancedDeltaInputArray(DeltaGen.InstanceInputs[] memory deltaInputs)
        internal
        pure
        returns (
            DeltaGen.InstanceInputs[] memory wrappedDeltaInputs,
            bool consumedAcc,
            uint128 quantityMagAcc,
            uint256 valueCommitmentRandomnessAcc
        )
    {
        quantityMagAcc = 0;
        consumedAcc = false;
        valueCommitmentRandomnessAcc = 0;

        if (deltaInputs.length == 0) {
            return (deltaInputs, consumedAcc, quantityMagAcc, valueCommitmentRandomnessAcc);
        }

        // Compute the window into which the deltas should sum
        int256 halfMax = int256(uint256(type(uint128).max >> 1));
        int256 halfMin = -halfMax;

        uint256 expectedKind = deltaInputs[0].kind;
        for (uint256 i = 0; i < deltaInputs.length; i++) {
            if (deltaInputs[i].kind != expectedKind) {
                revert KindMismatch({expected: expectedKind, actual: deltaInputs[i].kind});
            }
        }

        validateKind(deltaInputs[0].kind);

        int256 quantityAcc = 0;
        for (uint256 i = 0; i < deltaInputs.length; i++) {
            // Accumulate the randomness commitments modulo SECP256K1_ORDER
            valueCommitmentRandomnessAcc =
                addmod(valueCommitmentRandomnessAcc, deltaInputs[i].valueCommitmentRandomness, SECP256K1_ORDER);
            int256 currentQuantityMag = int256(uint256(deltaInputs[i].quantity));

            int256 currentQuantity = deltaInputs[i].consumed ? -currentQuantityMag : currentQuantityMag;

            // Adjust the delta inputs so that the sum remains in a specific range
            if (currentQuantity >= 0 && quantityAcc > halfMax - currentQuantity) {
                int256 overflow = quantityAcc - (halfMax - currentQuantity);
                currentQuantity = halfMin + overflow - 1 - quantityAcc;
            } else if (currentQuantity < 0 && quantityAcc < halfMin - currentQuantity) {
                int256 underflow = (halfMin - currentQuantity) - quantityAcc;
                currentQuantity = halfMax + 1 - underflow - quantityAcc;
            }

            // Finally, accumulate the adjusted quantity
            quantityAcc += currentQuantity;
            (deltaInputs[i].consumed, deltaInputs[i].quantity) = SignMagnitude.fromInt256(currentQuantity);
        }
        // Finally, return the balanced deltas
        wrappedDeltaInputs = deltaInputs;
        (consumedAcc, quantityMagAcc) = SignMagnitude.fromInt256(quantityAcc);
    }
}
