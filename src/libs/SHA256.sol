// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

library SHA256 {
    function hash(bytes32 a) internal pure returns (bytes32) {
        return sha256(abi.encode(a));
    }

    function hash(bytes32 a, bytes32 b) internal pure returns (bytes32) {
        return sha256(abi.encode(a, b));
    }

    function commutativeHash(bytes32 a, bytes32 b) internal pure returns (bytes32) {
        return a < b ? hash(a, b) : hash(b, a);
    }
}
