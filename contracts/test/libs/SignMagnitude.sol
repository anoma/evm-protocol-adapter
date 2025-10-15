// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

library SignMagnitude {
    /// Positive  numbers are represented with a false sign and negative numbers with a true sign.
    /// @param isNegative Whether the number is negative or not.
    /// @param magnitude The magnitude of the number.
    struct Number {
        bool isNegative;
        uint128 magnitude;
    }

    /// @notice Adds two numbers in sign magnitude representation.
    /// @param lhs The left-hand side number.
    /// @param lhs The right-hand side number to add.
    /// @return sum The resulting sum.
    function add(Number memory lhs, Number memory rhs) internal pure returns (Number memory sum) {
        if (lhs.isNegative == rhs.isNegative) {
            sum = Number({isNegative: lhs.isNegative, magnitude: lhs.magnitude + rhs.magnitude});
        } else if (lhs.magnitude >= rhs.magnitude) {
            sum = Number({isNegative: lhs.isNegative, magnitude: lhs.magnitude - rhs.magnitude});
        } else if (lhs.magnitude < rhs.magnitude) {
            sum = Number({isNegative: rhs.isNegative, magnitude: rhs.magnitude - lhs.magnitude});
        }
    }

    /// @notice Subtracts two numbers in sign magnitude representation.
    /// @param lhs The left-hand side number.
    /// @param lhs The right-hand side number to subtract.
    /// @return difference The difference.
    function sub(Number memory lhs, Number memory rhs) internal pure returns (Number memory difference) {
        difference = add(lhs, negate(rhs));
    }

    /// @notice Negate a number in sign magnitude representation.
    /// @param number The number to negate.
    /// @return negated The negated number.
    function negate(Number memory number) internal pure returns (Number memory negated) {
        negated = Number({isNegative: !number.isNegative, magnitude: number.magnitude});
    }

    /// @notice Convert the signed quantity whose magnitude fits into a uint128
    /// into a sign-magnitude representation. Positive numbers are represented
    /// with a false sign and negative numbers with a true sign.
    function fromInt256(int256 quantity) internal pure returns (bool sign, uint128 magnitude) {
        if (quantity >= 0) {
            // forge-lint: disable-next-line(unsafe-typecast)
            magnitude = uint128(uint256(quantity));
            sign = false;
        } else {
            // forge-lint: disable-next-line(unsafe-typecast)
            magnitude = uint128(uint256(-quantity));
            sign = true;
        }
    }
}
