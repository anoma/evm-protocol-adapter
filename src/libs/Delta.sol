// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

library Delta {
    function add(bytes32 a, bytes32 b) internal pure returns (bytes32) {
        // TODO implement. Ask Yulia first how this works.

        // Shielded case: Pedersen Commitments, operation over elliptic curves
        // Ethereum uses ECDSA

        // Yulia: types need to support addition

        // Keys are not generated "naturally".

        // ecrecover();
        // TODO: Use
        // import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
        // import { P256 } from "@openzeppelin/contracts/utils/cryptography/P256.sol";

        // OR
        // https://eips.ethereum.org/EIPS/eip-196
        // assembly ECADD

        b;

        return a;
    }

    // TODO revisit
    function ecAdd(uint256[2] memory point1, uint256[2] memory point2) public view returns (uint256[2] memory result) {
        uint256[4] memory input;
        input[0] = point1[0]; // x1
        input[1] = point1[1]; // y1
        input[2] = point2[0]; // x2
        input[3] = point2[1]; // y2

        assembly {
            // Call the ECADD precompiled contract
            // input: [x1, y1, x2, y2]
            // output: [x3, y3]
            if iszero(staticcall(not(0), 0x06, input, 0x80, result, 0x40)) { revert(0, 0) }
        }
    }
}
