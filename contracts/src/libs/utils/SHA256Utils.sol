// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title SHA256
/// @author Anoma Foundation, 2025
/// @notice A library for computing SHA256 hashes.
/// @custom:security-contact security@anoma.foundation
library SHA256Utils {
    /// @notice The hash of the string "EMPTY".
    /// @dev Obtained from `sha256("EMPTY")` (`0xcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06`).
    bytes32 public constant EMPTY_HASH = 0xcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06;

    /// @notice Hashes a single `bytes32` value.
    /// @param a The value to hash.
    /// @return ha The resulting hash.
    function hash(bytes32 a) internal pure returns (bytes32 ha) {
        ha = sha256(abi.encode(a));
    }

    /// @notice Hashes two `bytes32` values.
    /// @param a The first value to hash.
    /// @param b The second value to hash.
    /// @return hab The resulting hash.
    function hash(bytes32 a, bytes32 b) internal pure returns (bytes32 hab) {
        hab = sha256(abi.encode(a, b));
    }
}
