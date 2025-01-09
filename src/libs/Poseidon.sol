// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { PoseidonT2 } from "poseidon-solidity/contracts/PoseidonT2.sol";
import { PoseidonT3 } from "poseidon-solidity/contracts/PoseidonT3.sol";

library Poseidon {
    function hash1(bytes32 a) internal pure returns (bytes32) {
        return bytes32(PoseidonT2.hash([uint256(a)]));
    }

    function hash2(bytes32 a, bytes32 b) internal pure returns (bytes32) {
        return bytes32(PoseidonT3.hash([uint256(a), uint256(b)]));
    }

    function commutativeHash2(bytes32 a, bytes32 b) internal pure returns (bytes32) {
        return a < b ? hash2(a, b) : hash2(b, a);
    }
}
