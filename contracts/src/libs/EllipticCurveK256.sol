// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EllipticCurve} from "@elliptic-curve-solidity/contracts/EllipticCurve.sol";

/// @title EllipticCurveK256
/// @author Anoma Foundation, 2025
/// @notice The secp256k1 (K-256) elliptic curve taken from
/// https://github.com/witnet/elliptic-curve-solidity/blob/0.2.1/examples/Secp256k1.sol
/// @custom:security-contact security@anoma.foundation
library EllipticCurveK256 {
    /// @notice The x-coordinate of the curve generator point.
    uint256 internal constant GX = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;

    /// @notice The y-coordinate of the curve generator point.
    uint256 internal constant GY = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;

    /// @notice Constant of curve.
    uint256 internal constant AA = 0;

    /// @notice Constant of curve.
    uint256 internal constant BB = 7;

    /// @notice The modulus.
    uint256 internal constant PP = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

    /// @notice Derives a public key from a private key as an elliptic curve point.
    /// @param privateKey The private key to derive the public key from.
    /// @return qx The x-coordinate of the public key.
    /// @return qy The y-coordinate of the public key.
    /// @dev Do not use this function on-chain for sensitive data.
    function derivePubKey(uint256 privateKey) internal pure returns (uint256 qx, uint256 qy) {
        (qx, qy) = EllipticCurve.ecMul({_k: privateKey, _x: GX, _y: GY, _aa: AA, _pp: PP});
    }

    /// @notice Adds two elliptic curve points and returns the result.
    /// @param x1 The x-coordinate of the first point.
    /// @param y1 The y-coordinate of the first point.
    /// @param x2 The x-coordinate of the second point.
    /// @param y2 The y-coordinate of the second point.
    /// @return x3 The x-coordinate of the public key.
    /// @return y3 The y-coordinate of the public key.
    function ecAdd(uint256 x1, uint256 y1, uint256 x2, uint256 y2) internal pure returns (uint256 x3, uint256 y3) {
        (x3, y3) = EllipticCurve.ecAdd({_x1: x1, _y1: y1, _x2: x2, _y2: y2, _aa: AA, _pp: PP});
    }

    /// @notice Multiply point (x, y) times k and returns the result.
    /// @param k scalar to multiply
    /// @param x coordinate x of P
    /// @param y coordinate y of P
    /// @return x1 The x-coordinate of k*P
    /// @return y1 The y-coordinate of k*P
    function ecMul(uint256 k, uint256 x, uint256 y) internal pure returns (uint256 x1, uint256 y1) {
        (x1, y1) = EllipticCurve.ecMul({_k: k, _x: x, _y: y, _aa: AA, _pp: PP});
    }
}
