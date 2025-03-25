// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library SHA256 {
    function hash(bytes32 a) internal pure returns (bytes32 ha) {
        ha = sha256(abi.encode(a));
    }

    function hash2(bytes32 a, bytes32 b) internal pure returns (bytes32 hab) {
        hab = sha256(abi.encode(a, b));
    }
}
