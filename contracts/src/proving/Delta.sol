// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ECDSA} from "@openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import {EfficientHashLib} from "@solady/utils/EfficientHashLib.sol";

import {EllipticCurveK256} from "../libs/EllipticCurveK256.sol";

/// @title Delta
/// @author Anoma Foundation, 2025
/// @notice A library containing methods of the delta proving system.
/// @custom:security-contact security@anoma.foundation
library Delta {
    /// @notice Thrown if the recovered delta public key doesn't match the delta instance.
    error DeltaMismatch(address expected, address actual);

    /// @notice Adds two elliptic curve points and returns the resulting value.
    /// @param p1 The first curve point.
    /// @param p2 The second curve point.
    /// @return p3 The resulting curve point.
    function add(uint256[2] memory p1, uint256[2] memory p2) internal pure returns (uint256[2] memory p3) {
        (p3[0], p3[1]) = EllipticCurveK256.ecAdd(p1[0], p1[1], p2[0], p2[1]);
    }

    /// @notice Converts an elliptic curve point to an Ethereum account address.
    /// @param delta The elliptic curve point.
    /// @return account The associated account.
    function toAccount(uint256[2] memory delta) internal pure returns (address account) {
        // Hash the public key with Keccak-256
        bytes32 hashedKey = EfficientHashLib.hash(delta[0], delta[1]);

        // Take the last 20 bytes to obtain an Ethereum address.
        account = address(uint160(uint256(hashedKey)));
    }

    /// @notice Computes the delta verifying key as the Keccak-256 hash of all nullifiers and commitments
    /// as ordered in the compliance units.
    /// @param tags The list of nullifiers and commitments to compute the verifying key from.
    /// @return verifyingKey The verifying key obtained from hashing the nullifiers and commitments.
    /// @dev The tags are encoded in packed form to remove the array header.
    /// Since all the tags are 32 bytes in size, tight variable packing will not occur.
    function computeVerifyingKey(bytes32[] memory tags) internal pure returns (bytes32 verifyingKey) {
        verifyingKey = EfficientHashLib.hash(tags);
    }

    /// @notice Verifies a delta proof.
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
