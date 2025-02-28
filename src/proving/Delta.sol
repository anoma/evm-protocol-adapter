// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ECDSA } from "@openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import { EllipticCurveK256 } from "../libs/EllipticCurveK256.sol";

/// @notice A library for addition and verification of delta values.
/// @dev This uses the Pedersen commitment scheme
/// (https://link.springer.com/content/pdf/10.1007/3-540-46766-1_9.pdf#page=3).
library Delta {
    error InvalidPublicKeyLength(uint256 expected, uint256 actual);
    error DeltaMismatch(address expected, address actual);

    function zero() internal pure returns (uint256[2] memory p) {
        (p[0], p[1]) = EllipticCurveK256.derivePubKey({ privateKey: 0 });
    }

    function toBytes(uint256[2] memory delta) internal pure returns (bytes memory bytesDelta) {
        bytesDelta = abi.encode(delta[0], delta[1]);
    }

    function toAccount(uint256[2] memory delta) internal pure returns (address account) {
        // Hash the public key with Keccak-256
        bytes32 hashedKey = keccak256(toBytes(delta));

        // Extract the last 20 bytes (Ethereum address)
        account = address(uint160(uint256(hashedKey)));
    }

    function add(uint256[2] memory p1, uint256[2] memory p2) internal pure returns (uint256[2] memory p3) {
        (p3[0], p3[1]) = EllipticCurveK256.ecAdd(p1[0], p1[1], p2[0], p2[1]);
    }

    function verify(
        bytes32 transactionHash,
        uint256[2] memory transactionDelta,
        bytes memory deltaProof
    )
        internal
        pure
    {
        // Verify the delta proof using the ECDSA.recover API to obtain the address
        address recovered = ECDSA.recover({ hash: transactionHash, signature: deltaProof });

        // Convert the public key to an address
        address expected = toAccount(transactionDelta);

        // Compare it with the recovered address
        if (recovered != expected) {
            revert DeltaMismatch({ expected: expected, actual: recovered });
        }
    }
}
