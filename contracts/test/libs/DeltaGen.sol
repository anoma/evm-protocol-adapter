// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VmSafe} from "forge-std-1.15.0/src/Vm.sol";

import {Delta} from "../../src/libs/proving/Delta.sol";

library DeltaGen {
    using DeltaGen for uint256;

    /// @notice The inputs needed to mock a delta instance for a single resource.
    /// @param kind The resource kind, reduced modulo `SECP256K1_ORDER` and required to be non-zero.
    /// @param valueCommitmentRandomness The blinding scalar, reduced modulo `SECP256K1_ORDER` and required to be
    /// non-zero.
    /// @param quantity The magnitude of the resource quantity.
    /// @param consumed Whether the resource is consumed (negative contribution to the delta) or created (positive).
    struct InstanceInputs {
        uint256 kind;
        uint256 valueCommitmentRandomness;
        uint128 quantity;
        bool consumed;
    }

    /// @notice The inputs needed to mock a delta proof.
    /// @param summedValueCommitmentRandomness The sum of per-resource value commitment randomnesses modulo
    /// `SECP256K1_ORDER`, used as the ECDSA signing scalar and required to match the summed delta instance.
    /// @param verifyingKey The Keccak-256 hash of the action tags being committed to; the ECDSA signing message.
    struct ProofInputs {
        uint256 summedValueCommitmentRandomness;
        bytes32 verifyingKey;
    }

    /// @notice The order of the secp256k1 group, used as the modulus for all scalar arithmetic in the delta scheme.
    uint256 internal constant SECP256K1_ORDER = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    /// @notice Thrown when the value commitment randomness reduces to zero modulo `SECP256K1_ORDER` (not a valid
    /// ECDSA private key).
    error ValueCommitmentRandomnessZero();

    /// @notice Thrown when the pre-delta scalar is zero (not a valid private key for `vm.createWallet`).
    error PreDeltaZero();

    /// @notice Mocks a delta instance as `preDelta * G` on secp256k1, where `G` is the generator and
    /// `preDelta = kind * signedQuantity + valueCommitmentRandomness` (mod `SECP256K1_ORDER`).
    /// @param vm The Forge VM interface.
    /// @param inputs The delta instance inputs.
    /// @return instance The mocked curve point.
    /// @dev `vm.createWallet` performs the scalar multiplication: it treats the pre-delta as a private key and
    /// exposes the corresponding public key — the curve point we want.
    function generateInstance(VmSafe vm, InstanceInputs memory inputs) internal returns (Delta.Point memory instance) {
        // computePreDelta tolerates unreduced inputs (mulmod/addmod handle reduction), and the only failure mode
        // for `vm.createWallet` is a zero pre-delta, which `generateInstanceFromPreDelta` rejects with a named error.
        instance = generateInstanceFromPreDelta(vm, computePreDelta(inputs));
    }

    /// @notice Mocks a delta instance directly from a pre-delta scalar.
    /// @param vm The Forge VM interface.
    /// @param preDelta The pre-delta scalar, reduced modulo `SECP256K1_ORDER` and required to be non-zero.
    /// @return instance The mocked curve point.
    function generateInstanceFromPreDelta(VmSafe vm, uint256 preDelta) internal returns (Delta.Point memory instance) {
        // A zero pre-delta is not a valid ECDSA private key, so reject it explicitly rather than letting the cheatcode
        // fail with a less informative error.
        require(preDelta != 0, PreDeltaZero());

        // Use the pre-delta as a private key; the resulting public key coordinates are the delta point.
        VmSafe.Wallet memory wallet = vm.createWallet(preDelta);
        instance = Delta.Point({x: wallet.publicKeyX, y: wallet.publicKeyY});
    }

    /// @notice Mocks a delta proof by signing the verifying key with the value commitment randomness via ECDSA on
    /// secp256k1.
    /// @param vm The Forge VM interface.
    /// @param inputs The delta proof inputs.
    /// @return proof The ECDSA signature `r || s || v`, as expected by `ECDSA.recover`.
    /// @dev The signature is the proof: a verifier recovers a public key from `(verifyingKey, signature)` and checks
    /// it matches the address derived from the delta instance.
    function generateProof(VmSafe vm, ProofInputs memory inputs) internal returns (bytes memory proof) {
        // Reduce and reject zero so the cheatcode is given a valid private key.
        inputs.summedValueCommitmentRandomness =
            checkedValueCommitmentRandomness(inputs.summedValueCommitmentRandomness);

        // The wallet's private key is the summed randomness; signing the verifying key produces the proof.
        VmSafe.Wallet memory wallet = vm.createWallet(inputs.summedValueCommitmentRandomness);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(wallet, inputs.verifyingKey);

        proof = abi.encodePacked(r, s, v);
    }

    /// @notice Expands `n` instance inputs into `2n` inputs whose quantities sum to zero, yielding a balanced delta.
    /// @param baseInputs The `n` base inputs to expand (an empty array is allowed).
    /// @return pairedInputs The `2n` paired inputs: `n` created copies followed by `n` consumed copies, in input order.
    /// @return summedValueCommitmentRandomness The sum of all randomnesses in `pairedInputs` (mod `SECP256K1_ORDER`),
    /// suitable as the proof's randomness for the summed delta.
    /// @dev Each base input becomes a created (positive) and a consumed (negative) copy with the same kind,
    /// quantity, and randomness.
    function createBalancedPairs(InstanceInputs[] memory baseInputs)
        internal
        pure
        returns (InstanceInputs[] memory pairedInputs, uint256 summedValueCommitmentRandomness)
    {
        // Each base input expands into two paired inputs, so the result has twice the length.
        pairedInputs = new InstanceInputs[](baseInputs.length * 2);

        for (uint256 i = 0; i < baseInputs.length; ++i) {
            // Created copy: positive (created) contribution to the delta sum.
            pairedInputs[i] = InstanceInputs({
                kind: baseInputs[i].kind,
                valueCommitmentRandomness: baseInputs[i].valueCommitmentRandomness,
                quantity: baseInputs[i].quantity,
                consumed: false
            });

            // Consumed copy: same kind, randomness, and magnitude, but opposite sign — cancels the created copy above.
            pairedInputs[baseInputs.length + i] = InstanceInputs({
                kind: baseInputs[i].kind,
                valueCommitmentRandomness: baseInputs[i].valueCommitmentRandomness,
                quantity: baseInputs[i].quantity,
                consumed: true
            });

            // Each base randomness is included twice (once per copy), so it contributes `2 * randomness` to the sum.
            summedValueCommitmentRandomness = addmod(
                summedValueCommitmentRandomness,
                mulmod(2, baseInputs[i].valueCommitmentRandomness, SECP256K1_ORDER),
                SECP256K1_ORDER
            );
        }
    }

    /// @notice Computes the pre-delta `kind * signedQuantity + valueCommitmentRandomness` (mod `SECP256K1_ORDER`).
    /// @param inputs The delta instance inputs.
    /// @return preDelta The pre-delta scalar.
    /// @dev Exposed so fuzz tests can pre-check that the pre-delta is non-zero before calling `generateInstance`.
    function computePreDelta(InstanceInputs memory inputs) internal pure returns (uint256 preDelta) {
        uint256 signedQuantity = signedQuantityModOrder({isNegative: inputs.consumed, quantity: inputs.quantity});
        uint256 kindTimesQuantity = mulmod(inputs.kind, signedQuantity, SECP256K1_ORDER);
        preDelta = addmod(kindTimesQuantity, inputs.valueCommitmentRandomness, SECP256K1_ORDER);
    }

    /// @notice Converts a signed resource quantity to its canonical representative in `[0, SECP256K1_ORDER)`.
    /// @param isNegative True for consumed resources (negative contribution), false for created (positive).
    /// @param quantity The unsigned magnitude of the resource quantity.
    /// @return scalar The canonical representative of the signed quantity.
    /// @dev Negative inputs are mapped to `SECP256K1_ORDER - quantity` so addition mod the order matches signed addition.
    function signedQuantityModOrder(bool isNegative, uint128 quantity) internal pure returns (uint256 scalar) {
        scalar = isNegative ? (SECP256K1_ORDER - uint256(quantity)).modOrder() : uint256(quantity);
    }

    /// @notice Reduces a value commitment randomness modulo `SECP256K1_ORDER`, reverting if the result is zero.
    /// @param value The value commitment randomness to validate.
    /// @return checked The reduced, non-zero value commitment randomness.
    function checkedValueCommitmentRandomness(uint256 value) internal pure returns (uint256 checked) {
        checked = value.modOrder();
        require(checked != 0, ValueCommitmentRandomnessZero());
    }

    /// @notice Reduces a value to its canonical representative in `[0, SECP256K1_ORDER)`.
    /// @param value The value to reduce.
    /// @return reduced The canonical representative of the value.
    function modOrder(uint256 value) internal pure returns (uint256 reduced) {
        reduced = value % SECP256K1_ORDER;
    }
}
