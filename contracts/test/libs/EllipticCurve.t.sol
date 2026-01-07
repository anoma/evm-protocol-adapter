// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EllipticCurve} from "elliptic-curve-solidity/contracts/EllipticCurve.sol";
import {Test} from "forge-std/Test.sol";

import {Delta} from "../../src/libs/proving/Delta.sol";

/**
 * @title EllipticCurvePropertiesTest
 * @author Informal Systems
 * @dev Property-based tests for EllipticCurve.ecAdd using Foundry fuzzing.
 *
 * These tests verify GROUP PROPERTIES with points VERIFIED to be on the curve.
 * Points are generated via scalar multiplication: P = k × G
 * This guarantees all test points satisfy the curve equation y² = x³ + ax + b
 *
 * Run with: forge test -vv
 * Run with more fuzz runs: forge test --fuzz-runs 10000 -vv
 */
contract EllipticCurvePropertiesTest is Test {
    using EllipticCurve for *;

    /* GROUP PROPERTY TESTS (Points Verified On Curve) */

    /// @notice GROUP PROPERTY: Commutativity - P + Q = Q + P
    /// @dev Uses secp256k1 with points VERIFIED to be on the curve
    function testFuzz_group_property_commutativity_secp256k1(uint256 scalar1, uint256 scalar2) public pure {
        // Generate two points on secp256k1 by scalar multiplication of G
        scalar1 = bound(scalar1, 1, 20); // Keep small for performance
        scalar2 = bound(scalar2, 1, 20);

        // P1 = scalar1 * G
        (uint256 x1, uint256 y1) =
            EllipticCurve.ecMul({_k: scalar1, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});

        // P2 = scalar2 * G
        (uint256 x2, uint256 y2) =
            EllipticCurve.ecMul({_k: scalar2, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});

        // Verify both points are on curve
        assertTrue(
            EllipticCurve.isOnCurve({_x: x1, _y: y1, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "P1 must be on curve"
        );
        assertTrue(
            EllipticCurve.isOnCurve({_x: x2, _y: y2, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "P2 must be on curve"
        );

        // Test commutativity: P1 + P2 = P2 + P1
        (uint256 resultX1, uint256 resultY1) =
            EllipticCurve.ecAdd({_x1: x1, _y1: y1, _x2: x2, _y2: y2, _aa: Delta._AA, _pp: Delta._PP});
        (uint256 resultX2, uint256 resultY2) =
            EllipticCurve.ecAdd({_x1: x2, _y1: y2, _x2: x1, _y2: y1, _aa: Delta._AA, _pp: Delta._PP});

        assertEq(resultX1, resultX2, "GROUP PROPERTY: P + Q must equal Q + P");
        assertEq(resultY1, resultY2, "GROUP PROPERTY: P + Q must equal Q + P");
    }

    /// @notice GROUP PROPERTY: Identity - P + O = P
    function testFuzz_group_property_identity_secp256k1(uint256 scalar) public pure {
        scalar = bound(scalar, 1, 20);

        // P = scalar * G (guaranteed on curve)
        (uint256 x, uint256 y) =
            EllipticCurve.ecMul({_k: scalar, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});

        // Verify P is on curve
        assertTrue(
            EllipticCurve.isOnCurve({_x: x, _y: y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "P must be on curve"
        );

        // P + O should equal P
        (uint256 resultX, uint256 resultY) =
            EllipticCurve.ecAdd({_x1: x, _y1: y, _x2: 0, _y2: 0, _aa: Delta._AA, _pp: Delta._PP});

        assertEq(resultX, x, "GROUP PROPERTY: P + O must equal P");
        assertEq(resultY, y, "GROUP PROPERTY: P + O must equal P");
    }

    /// @notice GROUP PROPERTY: Inverse - P + (-P) = O
    function testFuzz_group_property_inverse_secp256k1(uint256 scalar) public pure {
        scalar = bound(scalar, 1, 20);

        // P = scalar * G (guaranteed on curve)
        (uint256 x, uint256 y) =
            EllipticCurve.ecMul({_k: scalar, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});

        // Verify P is on curve
        assertTrue(
            EllipticCurve.isOnCurve({_x: x, _y: y, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "P must be on curve"
        );

        // Get -P
        (uint256 invX, uint256 invY) = EllipticCurve.ecInv({_x: x, _y: y, _pp: Delta._PP});

        // Verify -P is on curve
        assertTrue(
            EllipticCurve.isOnCurve({_x: invX, _y: invY, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}),
            "-P must be on curve"
        );

        // P + (-P) should equal O
        (uint256 resultX, uint256 resultY) =
            EllipticCurve.ecAdd({_x1: x, _y1: y, _x2: invX, _y2: invY, _aa: Delta._AA, _pp: Delta._PP});

        assertTrue(
            _isPointAtInfinity(Delta.Point(resultX, resultY)), "GROUP PROPERTY: P + (-P) must equal point at infinity"
        );
    }

    /// @notice GROUP PROPERTY: Associativity - (P + Q) + R = P + (Q + R)
    function testFuzz_group_property_associativity_secp256k1(uint256 scalar1, uint256 scalar2, uint256 scalar3)
        public
        pure
    {
        scalar1 = bound(scalar1, 1, 10); // Keep small for performance
        scalar2 = bound(scalar2, 1, 10);
        scalar3 = bound(scalar3, 1, 10);

        // Generate three points on curve
        (uint256 x1, uint256 y1) =
            EllipticCurve.ecMul({_k: scalar1, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});
        (uint256 x2, uint256 y2) =
            EllipticCurve.ecMul({_k: scalar2, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});
        (uint256 x3, uint256 y3) =
            EllipticCurve.ecMul({_k: scalar3, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});

        // Verify all points are on curve
        assertTrue(EllipticCurve.isOnCurve({_x: x1, _y: y1, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}));
        assertTrue(EllipticCurve.isOnCurve({_x: x2, _y: y2, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}));
        assertTrue(EllipticCurve.isOnCurve({_x: x3, _y: y3, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}));

        // Compute (P + Q) + R
        (uint256 pqX, uint256 pqY) =
            EllipticCurve.ecAdd({_x1: x1, _y1: y1, _x2: x2, _y2: y2, _aa: Delta._AA, _pp: Delta._PP});
        (uint256 resultX1, uint256 resultY1) =
            EllipticCurve.ecAdd({_x1: pqX, _y1: pqY, _x2: x3, _y2: y3, _aa: Delta._AA, _pp: Delta._PP});

        // Compute P + (Q + R)
        (uint256 qrX, uint256 qrY) =
            EllipticCurve.ecAdd({_x1: x2, _y1: y2, _x2: x3, _y2: y3, _aa: Delta._AA, _pp: Delta._PP});

        (uint256 resultX2, uint256 resultY2) =
            EllipticCurve.ecAdd({_x1: x1, _y1: y1, _x2: qrX, _y2: qrY, _aa: Delta._AA, _pp: Delta._PP});

        assertEq(resultX1, resultX2, "GROUP PROPERTY: Associativity must hold");
        assertEq(resultY1, resultY2, "GROUP PROPERTY: Associativity must hold");
    }

    /// @notice GROUP PROPERTY: Closure - If P, Q on curve, then P+Q on curve or at infinity
    function testFuzz_group_property_Closure_secp256k1(uint256 scalar1, uint256 scalar2) public pure {
        scalar1 = bound(scalar1, 1, 20);
        scalar2 = bound(scalar2, 1, 20);

        // Generate two points on curve
        (uint256 x1, uint256 y1) =
            EllipticCurve.ecMul({_k: scalar1, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});
        (uint256 x2, uint256 y2) =
            EllipticCurve.ecMul({_k: scalar2, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});

        // Verify inputs are on curve
        assertTrue(EllipticCurve.isOnCurve({_x: x1, _y: y1, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}));
        assertTrue(EllipticCurve.isOnCurve({_x: x2, _y: y2, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}));

        // Add points
        (uint256 resultX, uint256 resultY) =
            EllipticCurve.ecAdd({_x1: x1, _y1: y1, _x2: x2, _y2: y2, _aa: Delta._AA, _pp: Delta._PP});

        // Result must be on curve or at infinity
        bool atInfinity = _isPointAtInfinity(Delta.Point(resultX, resultY));
        bool onCurve =
            EllipticCurve.isOnCurve({_x: resultX, _y: resultY, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP});

        assertTrue(atInfinity || onCurve, "GROUP PROPERTY: Closure - result must be on curve or at infinity");
    }

    /* PRECONDITION TESTS (UNREDUCED COORDINATES) */

    /// @notice PRECONDITION TEST: Demonstrates correct behavior with reduced coordinates
    function test_precondition_reduced_coordinates() public pure {
        // Use a small prime: p = 7, curve parameter a = 2
        uint256 pp = 7;
        uint256 aa = 2;

        // Point P: (3, 5), Point Q: (3, 2) where Q is inverse of P since 2 + 5 = 7 ≡ 0 (mod 7)
        (uint256 rx, uint256 ry) = EllipticCurve.ecAdd({_x1: 3, _y1: 5, _x2: 3, _y2: 2, _aa: aa, _pp: pp});

        // P + (-P) should equal point at infinity
        assertTrue(
            _isPointAtInfinity(Delta.Point(rx, ry)),
            "With REDUCED coordinates: (3,5) + (3,2) correctly gives point at infinity"
        );
    }

    /* CONCRETE TESTS (SECP256K1) */

    /// @notice Concrete: G + G = 2G
    function test_doubling_secp256k1() public pure {
        (uint256 rx, uint256 ry) = EllipticCurve.ecAdd({
            _x1: Delta._GX, _y1: Delta._GY, _x2: Delta._GX, _y2: Delta._GY, _aa: Delta._AA, _pp: Delta._PP
        });

        // Expected 2G
        assertEq(rx, 0xc6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5);
        assertEq(ry, 0x1ae168fea63dc339a3c58419466ceaeef7f632653266d0e1236431a950cfe52a);

        // Verify result is on curve
        assertTrue(EllipticCurve.isOnCurve({_x: rx, _y: ry, _aa: Delta._AA, _bb: Delta._BB, _pp: Delta._PP}));
    }

    /// @notice Concrete: G + O = G
    function test_group_property_identity_secp256k1() public pure {
        (uint256 rx, uint256 ry) =
            EllipticCurve.ecAdd({_x1: Delta._GX, _y1: Delta._GY, _x2: 0, _y2: 0, _aa: Delta._AA, _pp: Delta._PP});

        assertEq(rx, Delta._GX);
        assertEq(ry, Delta._GY);
    }

    /// @notice Concrete: G + (-G) = O
    function test_inverse_secp256k1() public pure {
        (uint256 invX, uint256 invY) = EllipticCurve.ecInv({_x: Delta._GX, _y: Delta._GY, _pp: Delta._PP});

        (uint256 rx, uint256 ry) =
            EllipticCurve.ecAdd({_x1: Delta._GX, _y1: Delta._GY, _x2: invX, _y2: invY, _aa: Delta._AA, _pp: Delta._PP});

        assertTrue(_isPointAtInfinity(Delta.Point(rx, ry)), "G + (-G) should be point at infinity");
    }

    /// @notice Concrete: (G + 2G) + 3G = G + (2G + 3G) = 6G
    function test_associativity_secp256k1() public pure {
        // Compute 2G, 3G

        (uint256 p2gX, uint256 p2gY) =
            EllipticCurve.ecMul({_k: 2, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});
        (uint256 p3gX, uint256 p3gY) =
            EllipticCurve.ecMul({_k: 3, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});

        // Compute (G + 2G) + 3G
        (uint256 pg2gX, uint256 pg2gY) =
            EllipticCurve.ecAdd({_x1: Delta._GX, _y1: Delta._GY, _x2: p2gX, _y2: p2gY, _aa: Delta._AA, _pp: Delta._PP});
        (uint256 result1X, uint256 result1Y) =
            EllipticCurve.ecAdd({_x1: pg2gX, _y1: pg2gY, _x2: p3gX, _y2: p3gY, _aa: Delta._AA, _pp: Delta._PP});

        // Compute G + (2G + 3G)
        (uint256 p2g3gX, uint256 p2g3gY) =
            EllipticCurve.ecAdd({_x1: p2gX, _y1: p2gY, _x2: p3gX, _y2: p3gY, _aa: Delta._AA, _pp: Delta._PP});
        (uint256 result2X, uint256 result2Y) = EllipticCurve.ecAdd({
            _x1: Delta._GX, _y1: Delta._GY, _x2: p2g3gX, _y2: p2g3gY, _aa: Delta._AA, _pp: Delta._PP
        });

        // Both should equal 6G
        (uint256 p6gx, uint256 p6gy) =
            EllipticCurve.ecMul({_k: 6, _x: Delta._GX, _y: Delta._GY, _aa: Delta._AA, _pp: Delta._PP});

        assertEq(result1X, result2X, "Associativity: (G+2G)+3G = G+(2G+3G)");

        assertEq(result1Y, result2Y, "Associativity: (G+2G)+3G = G+(2G+3G)");
        assertEq(result1X, p6gx, "Result should be 6G");
        assertEq(result1Y, p6gy, "Result should be 6G");
    }

    /// @notice Returns whether a point is at infinity or not..
    /// @param p The point to check.
    /// @return isAtInfinity Whether the point is at infinity or not.
    function _isPointAtInfinity(Delta.Point memory p) internal pure returns (bool isAtInfinity) {
        isAtInfinity = p.x == 0 && p.y == 0;
    }
}
