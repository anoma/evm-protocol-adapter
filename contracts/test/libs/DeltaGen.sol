// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VmSafe} from "forge-std/Vm.sol";

import {EllipticCurveK256} from "../../src/libs/EllipticCurveK256.sol";

import {SignMagnitude} from "./SignMagnitude.sol";

library DeltaGen {
    using EllipticCurveK256 for uint256;
    using SignMagnitude for SignMagnitude.Number;

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
        public
        returns (uint256[2] memory instance)
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
        uint256 prod = mulmod(deltaInputs.kind, quantity, EllipticCurveK256.ORDER);
        uint256 preDelta = addmod(prod, deltaInputs.valueCommitmentRandomness, EllipticCurveK256.ORDER);
        if (preDelta == 0) {
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

    /// @notice Convert an exponent represented as a boolean sign and a uint128
    /// magnitude to an equivalent uint256 assuming an order of SECP256K1_ORDER
    /// @param consumed False represents a non-negative quantity, true a non-positive quantity
    /// @param quantity The magnitude of the quantity being caanonicalized
    /// @return quantityRepresentative The non-negative number less than SECP256K1_ORDER
    /// that's equivalent to the exponent modulo SECP256K1_ORDER
    function canonicalizeQuantity(bool consumed, uint128 quantity)
        public
        pure
        returns (uint256 quantityRepresentative)
    {
        // If positive, leave the number unchanged
        quantityRepresentative =
            consumed ? ((EllipticCurveK256.ORDER - uint256(quantity)).modOrder()) : uint256(quantity);
    }

    /// @notice Wrap the delta inputs in such a way that they can be balanced
    /// and also return the total quantity and value commitment randomness
    /// * Adjusts the delta inputs so that the sum is within the range [halfMin, halfMax].
    function createBalancedDeltaInputArray(DeltaGen.InstanceInputs[] memory deltaInputs)
        public
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

        // Track the current quantity and value commitment randomness
        int256 quantityAcc = 0;

        // TODO! check that all kinds in deltaInputs are the same
        uint256 expectedKind = deltaInputs[0].kind;
        for (uint256 i = 0; i < deltaInputs.length; i++) {
            if (deltaInputs[i].kind != expectedKind) {
                revert KindMismatch({expected: expectedKind, actual: deltaInputs[i].kind});
            }
        }

        if (deltaInputs[0].kind.modOrder() == 0) {
            revert KindZero();
        }

        // Wrap the deltas
        for (uint256 i = 0; i < deltaInputs.length; i++) {
            // TODO! MOVE THIS // Ensure that all the deltas have the same kind
            // TODO! MOVE THIS deltaInputs[i].kind = kind;
            // Accumulate the randomness commitments modulo SECP256K1_ORDER
            valueCommitmentRandomnessAcc =
                addmod(valueCommitmentRandomnessAcc, deltaInputs[i].valueCommitmentRandomness, EllipticCurveK256.ORDER);
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
        // Finally, return tbe wrapped deltas
        wrappedDeltaInputs = deltaInputs;
        (consumedAcc, quantityMagAcc) = SignMagnitude.fromInt256(quantityAcc);
    }
}
