// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VmSafe} from "forge-std-1.15.0/src/Vm.sol";

import {Delta} from "../../src/libs/proving/Delta.sol";

/// @title DeltaGen
/// @author Anoma Foundation, 2026
/// @notice A test-only library that mocks delta instances and delta proofs so tests can construct synthetic
/// transactions for the Anoma protocol adapter without invoking the real proving system. The mock follows the same
/// algebraic structure as the real scheme: a delta instance is the secp256k1 public key derived from a per-resource
/// secret scalar (the pre-delta), and a delta proof is an ECDSA signature whose private key is the sum of all per-
/// resource value commitment randomnesses.
/// @custom:security-contact security@anoma.foundation
library DeltaGen {
    using DeltaGen for uint256;

    /// @notice The inputs needed to mock a delta instance for a single resource.
    /// @param kind The resource kind. Treated as a scalar reduced modulo `SECP256K1_ORDER` and required to be
    /// non-zero.
    /// @param valueCommitmentRandomness The blinding scalar associated with the resource. Reduced modulo
    /// `SECP256K1_ORDER` and required to be non-zero.
    /// @param quantity The magnitude of the resource quantity.
    /// @param consumed Wheter the resource is consumed or created and contributes negatively or positively to the delta
    /// sum, respectively.
    struct InstanceInputs {
        uint256 kind;
        uint256 valueCommitmentRandomness;
        uint128 quantity;
        bool consumed;
    }

    /// @notice The inputs needed to mock a delta proof.
    /// @param valueCommitmentRandomness The signing scalar. For the proof to verify against a delta instance summed
    /// from multiple resources, this must equal the sum of the per-resource randomnesses (modulo `SECP256K1_ORDER`).
    /// @param verifyingKey The Keccak-256 hash of the action tags being committed to. This is the message that the
    /// ECDSA signature signs over.
    struct ProofInputs {
        uint256 valueCommitmentRandomness;
        bytes32 verifyingKey;
    }

    /// @notice The order of the secp256k1 (K-256) elliptic curve group. All scalar arithmetic in the delta scheme is
    /// performed modulo this constant.
    uint256 internal constant SECP256K1_ORDER = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    /// @notice Thrown when the resource kind reduces to zero modulo `SECP256K1_ORDER`. A zero kind would erase the
    /// quantity contribution from the pre-delta and is rejected as a degenerate input.
    error ZeroKind();

    /// @notice Thrown when `createBalancedPairs` is given inputs whose kinds differ. Pairing only makes sense for a
    /// single shared kind, since instances of different kinds cannot cancel each other.
    /// @param expected The kind taken from the first input, against which all other inputs are compared.
    /// @param actual The first kind that did not match.
    error KindMismatch(uint256 expected, uint256 actual);

    /// @notice Thrown when the value commitment randomness reduces to zero modulo `SECP256K1_ORDER`. A zero blinding
    /// scalar cannot be used as an ECDSA private key.
    error ValueCommitmentRandomnessZero();

    /// @notice Thrown when the pre-delta scalar (the secret key from which the delta point is derived) is zero, in
    /// which case `vm.createWallet` would not produce a usable curve point.
    error PreDeltaZero();

    /// @notice Mocks a delta instance by deriving the curve point `preDelta * G` on secp256k1, where `G` is the curve
    /// generator and `preDelta = kind * signedQuantity + valueCommitmentRandomness` (mod `SECP256K1_ORDER`).
    /// @dev Forge's `vm.createWallet` performs the scalar multiplication implicitly: it treats the pre-delta as a
    /// private key and exposes the corresponding public key, which is exactly the curve point we want to mock.
    /// @param vm The Forge cheatcode interface used to derive the public key from the pre-delta scalar.
    /// @param inputs The delta instance inputs.
    /// @return instance The curve point that mocks the delta instance.
    function generateInstance(VmSafe vm, InstanceInputs memory inputs) internal returns (Delta.Point memory instance) {
        // Reduce and reject zero scalars before they can be combined into the pre-delta.
        inputs.valueCommitmentRandomness = checkedValueCommitmentRandomness(inputs.valueCommitmentRandomness);
        inputs.kind = checkedKind(inputs.kind);

        // Compute the pre-delta scalar: kind * signedQuantity + valueCommitmentRandomness, all modulo SECP256K1_ORDER.
        uint256 signedQuantity = signedQuantityModOrder(inputs.consumed, inputs.quantity);
        uint256 kindTimesQuantity = mulmod(inputs.kind, signedQuantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(kindTimesQuantity, inputs.valueCommitmentRandomness, SECP256K1_ORDER);

        // A zero pre-delta is not a valid ECDSA private key, so reject it explicitly rather than letting the cheatcode
        // fail with a less informative error.
        require(preDelta != 0, PreDeltaZero());

        // Use the pre-delta as a private key; the resulting public key coordinates are the delta point.
        VmSafe.Wallet memory wallet = vm.createWallet(preDelta);
        instance = Delta.Point({x: wallet.publicKeyX, y: wallet.publicKeyY});
    }

    /// @notice Mocks a delta proof by signing the verifying key under the value commitment randomness using ECDSA on
    /// secp256k1.
    /// @dev The signature is the proof: a verifier recovers a public key from `(verifyingKey, signature)` and checks
    /// that it matches the address derived from the corresponding delta instance.
    /// @param vm The Forge cheatcode interface used to perform the ECDSA signing operation.
    /// @param inputs The delta proof inputs.
    /// @return proof The ECDSA signature laid out as `r || s || v`, matching what `ECDSA.recover` expects.
    function generateProof(VmSafe vm, ProofInputs memory inputs) internal returns (bytes memory proof) {
        // Reduce and reject zero so the cheatcode is given a valid private key.
        inputs.valueCommitmentRandomness = checkedValueCommitmentRandomness(inputs.valueCommitmentRandomness);

        // The wallet's private key is the value commitment randomness; signing the verifying key produces the proof.
        VmSafe.Wallet memory wallet = vm.createWallet(inputs.valueCommitmentRandomness);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(wallet, inputs.verifyingKey);

        proof = abi.encodePacked(r, s, v);
    }

    /// @notice Reduces a scalar to its canonical representative in `[0, SECP256K1_ORDER)`.
    /// @param value The scalar to reduce.
    /// @return reduced The canonical representative of `value` modulo `SECP256K1_ORDER`.
    function modOrder(uint256 value) internal pure returns (uint256 reduced) {
        reduced = value % SECP256K1_ORDER;
    }

    /// @notice Returns the value commitment randomness reduced modulo `SECP256K1_ORDER`, requiring the result to be
    /// non-zero.
    /// @param value The value commitment randomness to validate.
    /// @return checked The reduced, non-zero value commitment randomness.
    function checkedValueCommitmentRandomness(uint256 value) internal pure returns (uint256 checked) {
        checked = value.modOrder();
        require(checked != 0, ValueCommitmentRandomnessZero());
    }

    /// @notice Returns the resource kind reduced modulo `SECP256K1_ORDER`, requiring the result to be non-zero.
    /// @param value The kind to validate.
    /// @return checked The reduced, non-zero kind.
    function checkedKind(uint256 value) internal pure returns (uint256 checked) {
        checked = value.modOrder();
        require(checked != 0, ZeroKind());
    }

    /// @notice Reports whether the given inputs would produce a non-zero pre-delta and therefore a usable delta
    /// instance.
    /// @dev Mirrors the validation performed by `generateInstance` but as a pure predicate, so fuzz tests can use it
    /// in `vm.assume` to discard degenerate inputs without triggering a revert.
    /// @param inputs The delta instance inputs to check.
    /// @return ok True if `generateInstance(vm, inputs)` would succeed, false otherwise.
    function producesNonPreDeltaZero(InstanceInputs memory inputs) internal pure returns (bool ok) {
        uint256 reducedKind = inputs.kind.modOrder();
        uint256 reducedRandomness = inputs.valueCommitmentRandomness.modOrder();

        // A zero kind or zero randomness is rejected by `generateInstance`, so it cannot produce a usable instance.
        if (reducedKind == 0 || reducedRandomness == 0) {
            return false;
        }

        uint256 signedQuantity = signedQuantityModOrder(inputs.consumed, inputs.quantity);
        uint256 kindTimesQuantity = mulmod(reducedKind, signedQuantity, SECP256K1_ORDER);
        uint256 preDelta = addmod(kindTimesQuantity, reducedRandomness, SECP256K1_ORDER);

        ok = preDelta != 0;
    }

    /// @notice Converts a signed quantity, given as a (sign, magnitude) pair, into its scalar representative in
    /// `[0, SECP256K1_ORDER)`.
    /// @param isNegative True for a non-positive quantity (consumed resource), false for a non-negative quantity
    /// (created resource).
    /// @param magnitude The absolute value of the quantity.
    /// @return scalar The non-negative integer less than `SECP256K1_ORDER` that represents the signed quantity modulo
    /// the curve order.
    /// @dev Negative quantities are mapped to `SECP256K1_ORDER - magnitude` so that addition modulo the curve order
    /// matches signed addition. This mirrors the value commitment scheme's convention: consumed resources contribute
    /// negative scalars, created resources contribute positive ones.
    function signedQuantityModOrder(bool isNegative, uint128 magnitude) internal pure returns (uint256 scalar) {
        scalar = isNegative ? (SECP256K1_ORDER - uint256(magnitude)).modOrder() : uint256(magnitude);
    }

    /// @notice Computes the pre-delta scalar
    /// (`kind * signedQuantity + valueCommitmentRandomness` mod `SECP256K1_ORDER`) for the given inputs without
    /// invoking the cheatcode VM.
    /// @dev Exposed so fuzz tests can pre-check that the pre-delta is non-zero before calling `generateInstance`,
    /// which would otherwise revert.
    /// @param inputs The delta instance inputs.
    /// @return preDelta The pre-delta scalar.
    function computePreDelta(InstanceInputs memory inputs) internal pure returns (uint256 preDelta) {
        uint256 signedQuantity = signedQuantityModOrder(inputs.consumed, inputs.quantity);
        uint256 kindTimesQuantity = mulmod(inputs.kind, signedQuantity, SECP256K1_ORDER);
        preDelta = addmod(kindTimesQuantity, inputs.valueCommitmentRandomness, SECP256K1_ORDER);
    }

    /// @notice Expands `n` instance inputs into `2n` inputs whose quantities sum to zero by construction, yielding a
    /// balanced delta when summed.
    /// @param baseInputs The `n` base delta inputs to expand. An empty array is allowed and produces an empty result.
    /// @return pairedInputs The `2n` resulting inputs: the `n` created copies first, followed by the `n` consumed
    /// copies in the same order.
    /// @return summedRandomness The sum of all value commitment randomnesses across `pairedInputs`, reduced modulo
    /// `SECP256K1_ORDER`. Tests can pass this as the proof's value commitment randomness so the proof matches the
    /// summed delta instance.
    /// @dev For each base input, emits one created (positive) copy and one consumed (negative) copy with the same
    /// kind, quantity, and randomness. Because each resource is paired with its exact counterpart, the summed
    /// signed quantity is zero regardless of the underlying magnitudes.
    /// All base inputs must share the same kind: instances of different kinds cannot cancel and would not produce a
    /// balanced delta.
    function createBalancedPairs(InstanceInputs[] memory baseInputs)
        internal
        pure
        returns (InstanceInputs[] memory pairedInputs, uint256 summedRandomness)
    {
        // No inputs means no work and a trivially balanced (empty) result.
        if (baseInputs.length == 0) {
            return (baseInputs, 0);
        }

        // All inputs must share the kind of the first input. Validate that kind once up front.
        uint256 commonKind = baseInputs[0].kind;
        checkedKind(commonKind);

        // Each base input expands into two paired inputs, so the result has twice the length.
        pairedInputs = new InstanceInputs[](baseInputs.length * 2);

        for (uint256 i = 0; i < baseInputs.length; ++i) {
            // Reject any input whose kind does not match the common kind: mismatched kinds cannot be balanced.
            require(baseInputs[i].kind == commonKind, KindMismatch({expected: commonKind, actual: baseInputs[i].kind}));

            // Created copy: positive (created) contribution to the delta sum.
            pairedInputs[i] = InstanceInputs({
                kind: commonKind,
                valueCommitmentRandomness: baseInputs[i].valueCommitmentRandomness,
                quantity: baseInputs[i].quantity,
                consumed: false
            });

            // Consumed copy: same kind, randomness, and magnitude, but opposite sign — cancels the created copy above.
            pairedInputs[baseInputs.length + i] = InstanceInputs({
                kind: commonKind,
                valueCommitmentRandomness: baseInputs[i].valueCommitmentRandomness,
                quantity: baseInputs[i].quantity,
                consumed: true
            });

            // Each base randomness is included twice (once per copy), so it contributes `2 * randomness` to the sum.
            summedRandomness = addmod(
                summedRandomness, mulmod(2, baseInputs[i].valueCommitmentRandomness, SECP256K1_ORDER), SECP256K1_ORDER
            );
        }
    }
}
