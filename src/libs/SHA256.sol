// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library SHA256 {
    function hash(bytes32 a) internal pure returns (bytes32 ha) {
        ha = sha256(abi.encode(a));
    }

    function hash(bytes32 a, bytes32 b) internal pure returns (bytes32 hab) {
        hab = sha256(abi.encode(a, b));
    }

    function hash3(bytes32 a, bytes32 b, bytes32 c) internal pure returns (bytes32 habc) {
        habc = sha256(abi.encode(a, b, c));
    }

    function commutativeHash(bytes32 a, bytes32 b) internal pure returns (bytes32 habOrBa) {
        habOrBa = a < b ? hash(a, b) : hash(b, a);
    }

    function commutativeHash3(bytes32 a, bytes32 b, bytes32 c) internal pure returns (bytes32 habcOrAcb) {
        habcOrAcb = a < b ? hash3(a, b, c) : hash3(a, c, b);
    }
}
