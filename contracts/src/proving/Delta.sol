// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EllipticCurve} from "@elliptic-curve-solidity/contracts/EllipticCurve.sol";
import {ECDSA} from "@openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import {EfficientHashLib} from "@solady/utils/EfficientHashLib.sol";

/// @title Delta
/// @author Anoma Foundation, 2025
/// @notice A library containing methods of the delta proving system.
/// @custom:security-contact security@anoma.foundation
library Delta {
    using Delta for CurvePoint;

    /// @notice An elliptic curve point representing a delta value.
    /// @param x The x component of the point.
    /// @param y The y component of the point.
    struct CurvePoint {
        uint256 x;
        uint256 y;
    }

    /// @notice The constant of the secp256k1 (K-256) elliptic curve.
    uint256 internal constant _AA = 0;

    /// @notice The modulus of the secp256k1 (K-256) elliptic curve.
    uint256 internal constant _PP = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

    /// @notice Thrown if the recovered delta public key doesn't match the delta instance.
    error DeltaMismatch(address expected, address actual);

    /// @notice Returns the elliptic curve point representing the zero delta.
    /// @return zeroDelta The zero delta.
    function zero() internal pure returns (CurvePoint memory zeroDelta) {
        zeroDelta = CurvePoint({x: 0, y: 0});
    }

    /// @notice Adds two elliptic curve points and returns the resulting value.
    /// @param p1 The first curve point.
    /// @param p2 The second curve point.
    /// @return sum The resulting curve point.
    function add(CurvePoint memory p1, CurvePoint memory p2) internal pure returns (CurvePoint memory sum) {
        (sum.x, sum.y) = EllipticCurve.ecAdd({_x1: p1.x, _y1: p1.y, _x2: p2.x, _y2: p2.y, _aa: _AA, _pp: _PP});
    }

    /// @notice Converts an elliptic curve point to an Ethereum account address.
    /// @param delta The elliptic curve point.
    /// @return account The associated account.
    function toAccount(CurvePoint memory delta) internal pure returns (address account) {
        // Hash the public key with Keccak-256
        bytes32 hashedKey = EfficientHashLib.hash(delta.x, delta.y);

        // Take the last 20 bytes to obtain an Ethereum address.
        account = address(uint160(uint256(hashedKey)));
    }

    /// @notice Computes the delta verifying key as the Keccak-256 hash of all nullifiers and commitments
    /// as ordered in the compliance units.
    /// @param tags The list of nullifiers and commitments to compute the verifying key from.
    /// @return verifyingKey The verifying key obtained from hashing the nullifiers and commitments.
    /// @dev The tags are encoded in packed form to remove the array header.
    /// Since all the tags are 32 bytes in size, tight variable packing will not occur.
    function computeVerifyingKey(bytes32[] memory tags) internal pure returns (bytes32 verifyingKey) {
        verifyingKey = EfficientHashLib.hash(tags);
    }

    /// @notice Verifies a delta proof.
    /// @param proof The delta proof.
    /// @param instance The transaction delta.
    /// @param verifyingKey The Keccak-256 hash of all nullifiers and commitments as ordered in the compliance units.
    function verify(bytes memory proof, CurvePoint memory instance, bytes32 verifyingKey) internal pure {
        // Verify the delta proof using the ECDSA.recover API to obtain the address
        address recovered = ECDSA.recover({hash: verifyingKey, signature: proof});

        // Convert the public key to an address
        address expected = toAccount(instance);

        // Compare it with the recovered address
        if (recovered != expected) {
            revert DeltaMismatch({expected: expected, actual: recovered});
        }
    }
}
