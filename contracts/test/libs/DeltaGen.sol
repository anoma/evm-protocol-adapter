// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VmSafe} from "forge-std/Vm.sol";

import {Delta} from "../../src/proving/Delta.sol";
import {SignMagnitude} from "./SignMagnitude.sol";

library DeltaGen {
    using SignMagnitude for SignMagnitude.Number;
    using DeltaGen for uint256;

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
        returns (Delta.CurvePoint memory instance)
    {
        deltaInputs.valueCommitmentRandomness = deltaInputs.valueCommitmentRandomness.modOrder();
        if (deltaInputs.valueCommitmentRandomness == 0) {
            revert DeltaGen.ValueCommitmentRandomnessZero();
        }
        deltaInputs.kind = deltaInputs.kind.modOrder();
        if (deltaInputs.kind == 0) {
            revert DeltaGen.KindZero();
        }
        uint256 quantity = canonicalizeQuantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, quantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.valueCommitmentRandomness, SECP256K1_ORDER);
        if (preDelta == 0) {
            revert DeltaGen.PreDeltaZero();
        }
        // Derive address and public key from transaction delta
        VmSafe.Wallet memory valueWallet = vm.createWallet(preDelta);

        // Extract the transaction delta from the wallet
        instance = Delta.CurvePoint({x: valueWallet.publicKeyX, y: valueWallet.publicKeyY});
    }

    /// @notice Generates a transaction delta proof by signing verifyingKey with
    /// valueCommitmentRandomness
    /// @param vm VmSafe instance with which to sign verifyingKey
    /// @param deltaInputs Parameters required to construct a delta proof
    /// @return proof The delta proof corresponding to the parameters
    function generateProof(VmSafe vm, ProofInputs memory deltaInputs) internal returns (bytes memory proof) {
        deltaInputs.valueCommitmentRandomness = deltaInputs.valueCommitmentRandomness.modOrder();
        if (deltaInputs.valueCommitmentRandomness == 0) {
            revert DeltaGen.ValueCommitmentRandomnessZero();
        }
        // Compute the components of the transaction delta proof
        VmSafe.Wallet memory randomWallet = vm.createWallet(deltaInputs.valueCommitmentRandomness);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(randomWallet, deltaInputs.verifyingKey);
        // Finally compute the transaction delta proof
        proof = abi.encodePacked(r, s, v);
    }

    /// @notice Computes the modulo of a value and returns the remainder.
    /// @param value The value to compute the module for.
    /// @return remainder The remainder.
    function modOrder(uint256 value) internal pure returns (uint256 remainder) {
        remainder = value % SECP256K1_ORDER;
    }

    /// @notice Convert an exponent represented as a boolean sign and a uint128
    /// magnitude to an equivalent uint256 assuming an order of SECP256K1_SECP256K1_ORDER
    /// @param consumed False represents a non-negative quantity, true a non-positive quantity
    /// @param quantity The magnitude of the quantity being caanonicalized
    /// @return quantityRepresentative The non-negative number less than SECP256K1_SECP256K1_ORDER
    /// that's equivalent to the exponent modulo SECP256K1_SECP256K1_ORDER
    function canonicalizeQuantity(bool consumed, uint128 quantity)
        internal
        pure
        returns (uint256 quantityRepresentative)
    {
        // If positive, leave the number unchanged
        quantityRepresentative = consumed ? ((SECP256K1_ORDER - uint256(quantity)).modOrder()) : uint256(quantity);
    }

    function computePreDelta(DeltaGen.InstanceInputs memory deltaInputs) internal pure returns (uint256 preDelta) {
        uint256 canonicalizedQuantity = canonicalizeQuantity(deltaInputs.consumed, deltaInputs.quantity);
        uint256 prod = mulmod(deltaInputs.kind, canonicalizedQuantity, SECP256K1_ORDER);
        preDelta = addmod(prod, deltaInputs.valueCommitmentRandomness, SECP256K1_ORDER);
    }

    /// @notice Balances an array of delta inputs by adjusting the inputs so that the sum is within the range
    /// [halfMin, halfMax]. Moreover, it returns the accumulated quantity and value commitment randomness.
    /// TODO This code and its usage must be refactored. Instead of balancing a set of `n` random values, we should take
    /// TODO `n/2` random values and negate them. This will reduce the code complexity in this function and tests.
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

        if (deltaInputs[0].kind.modOrder() == 0) {
            revert KindZero();
        }

        int256 quantityAcc = 0;
        for (uint256 i = 0; i < deltaInputs.length; i++) {
            // Accumulate the randomness commitments modulo SECP256K1_SECP256K1_ORDER
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
        // Finally, return tbe balanced deltas
        wrappedDeltaInputs = deltaInputs;
        (consumedAcc, quantityMagAcc) = SignMagnitude.fromInt256(quantityAcc);
    }
}
