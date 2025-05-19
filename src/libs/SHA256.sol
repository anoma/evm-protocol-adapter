// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library SHA256 {
    /// @notice The hash representing the empty leaf that is not expected to be part of the tree.
    /// @dev Obtained from `sha256("EMPTY")`.
    bytes32 public constant EMPTY_HASH = 0xcc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06;

    function hash(bytes32 a) internal pure returns (bytes32 ha) {
        ha = sha256(abi.encode(a));
    }

    function hash(bytes32 a, bytes32 b) internal pure returns (bytes32 hab) {
        hab = sha256(abi.encode(a, b));
    }
}
