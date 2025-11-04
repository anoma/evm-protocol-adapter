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
    using Delta for Point;

    /// @notice An elliptic curve point representing a delta value.
    /// @param x The x component of the point.
    /// @param y The y component of the point.
    struct Point {
        uint256 x;
        uint256 y;
    }

    /// @notice The x-coordinate of the curve generator point.
    uint256 internal constant _GX = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;

    /// @notice The y-coordinate of the curve generator point.
    uint256 internal constant _GY = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;

    // @notice The coefficient a of th secp256k1 (K-256) elliptic curve (y² = x³ + ax + b).
    uint256 internal constant _AA = 0;

    // @notice The coefficient b of th secp256k1 (K-256) elliptic curve (y² = x³ + ax + b).
    uint256 internal constant _BB = 7;

    /// @notice The field prime modulus (2^256 - 2^32 - 977) of the secp256k1 (K-256) elliptic curve (y² = x³ + ax + b).
    uint256 internal constant _PP = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

    /// @notice Thrown if the recovered delta public key doesn't match the delta instance.
    error DeltaMismatch(address expected, address actual);

    /// @notice Thrown when a provided point is not on the curve.
    error PointNotOnCurve(Point point);

    /// @notice Returns the elliptic curve point representing the zero delta.
    /// @return zeroDelta The zero delta.
    function zero() internal pure returns (Point memory zeroDelta) {
        zeroDelta = Point({x: 0, y: 0});
    }

    /// @notice Adds two elliptic curve points and returns the resulting value.
    /// @param p1 The first curve point.
    /// @param p2 The second curve point.
    /// @return sum The resulting curve point.
    function add(Point memory p1, Point memory p2) internal pure returns (Point memory sum) {
        if (!EllipticCurve.isOnCurve({_x: p2.x, _y: p2.y, _aa: _AA, _bb: _BB, _pp: _PP})) {
            revert PointNotOnCurve(p2);
        }

        (sum.x, sum.y) = EllipticCurve.ecAdd({_x1: p1.x, _y1: p1.y, _x2: p2.x, _y2: p2.y, _aa: _AA, _pp: _PP});
    }

    /// @notice Converts an elliptic curve point to an Ethereum account address.
    /// @param delta The elliptic curve point.
    /// @return account The associated account.
    function toAccount(Point memory delta) internal pure returns (address account) {
        // Hash the public key with Keccak-256.
        bytes32 hashedKey = EfficientHashLib.hash(delta.x, delta.y);

        // Take the last 20 bytes to obtain an Ethereum address.
        account = address(uint160(uint256(hashedKey)));
    }

    /// @notice Computes the delta verifying key as the Keccak-256 hash of all nullifiers and commitments
    /// as ordered in the compliance units.
    /// @param tags The list of nullifiers and commitments to compute the verifying key from.
    /// @return verifyingKey The verifying key obtained from hashing the nullifiers and commitments.
    function computeVerifyingKey(bytes32[] memory tags) internal pure returns (bytes32 verifyingKey) {
        verifyingKey = EfficientHashLib.hash(tags);
    }

    /// @notice Verifies a delta proof.
    /// @param proof The delta proof.
    /// @param instance The transaction delta.
    /// @param verifyingKey The Keccak-256 hash of all nullifiers and commitments as ordered in the compliance units.
    function verify(bytes memory proof, Point memory instance, bytes32 verifyingKey) internal pure {
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
