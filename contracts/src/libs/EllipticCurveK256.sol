// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EllipticCurve} from "@elliptic-curve-solidity/contracts/EllipticCurve.sol";

/// @title EllipticCurveK256
/// @author Anoma Foundation, 2025
/// @notice The secp256k1 (K-256) elliptic curve taken from
/// https://github.com/witnet/elliptic-curve-solidity/blob/0.2.1/examples/Secp256k1.sol
/// @custom:security-contact security@anoma.foundation
library EllipticCurveK256 {
    /// @notice Constant of curve.
    uint256 internal constant AA = 0;

    /// @notice The modulus.
    uint256 internal constant PP = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

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
}
