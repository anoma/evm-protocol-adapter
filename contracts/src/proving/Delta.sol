// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ECDSA} from "@openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import {EllipticCurveK256} from "../libs/EllipticCurveK256.sol";

/// @notice A library for addition and verification of delta values.
/// @dev This uses the Pedersen commitment scheme
/// (https://link.springer.com/content/pdf/10.1007/3-540-46766-1_9.pdf#page=3).
library Delta {
    error DeltaMismatch(address expected, address actual);

    function add(uint256[2] memory p1, uint256[2] memory p2) internal pure returns (uint256[2] memory p3) {
        (p3[0], p3[1]) = EllipticCurveK256.ecAdd(p1[0], p1[1], p2[0], p2[1]);
    }

    function toAccount(uint256[2] memory delta) internal pure returns (address account) {
        // Hash the public key with Keccak-256
        bytes32 hashedKey = keccak256(abi.encode(delta[0], delta[1]));

        // Take the last 20 bytes to obtain an Ethereum address.
        account = address(uint160(uint256(hashedKey)));
    }

    /// @notice Computes the delta verifying key as the Keccak-256 hash of all nullifiers and commitments
    /// as ordered in the compliance units.
    /// @dev The tags are encoded in packed form to remove the array header.
    /// Since all the tags are 32 bytes in size, tight variable packing will not occur.
    function computeVerifyingKey(bytes32[] memory tags) internal pure returns (bytes32 hash) {
        hash = keccak256(abi.encodePacked(tags));
    }

    /// @param proof The delta proof.
    /// @param instance The transaction delta.
    /// @param verifyingKey The Keccak-256 hash of all nullifiers and commitments as ordered in the compliance units.
    function verify(bytes memory proof, uint256[2] memory instance, bytes32 verifyingKey) internal pure {
        // Verify the delta proof using the ECDSA.recover API to obtain the address
        address recovered = ECDSA.recover({hash: verifyingKey, signature: proof});

        // Convert the public key to an address
        address expected = toAccount(instance);

        // Compare it with the recovered address
        if (recovered != expected) {
            revert DeltaMismatch({expected: expected, actual: recovered});
        }
    }
}
