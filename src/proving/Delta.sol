// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { EllipticCurveK256 } from "../libs/EllipticCurveK256.sol";

import { console } from "forge-std/console.sol";
// TODO Remove?

struct DeltaInstance {
    uint256 expectedBalance; // Balance // pre-image
}

// slither-disable-next-line max-line-length
/// @notice Uses the Pedersen commitment scheme (https://link.springer.com/content/pdf/10.1007/3-540-46766-1_9.pdf#page=3)
library Delta {
    uint8 internal constant RECOVERY_IDENTIFIER = 27;

    error DeltaMismatch(address expected, address actual);

    function zero() internal pure returns (uint256[2] memory p) {
        (p[0], p[1]) = EllipticCurveK256.derivePubKey({ privKey: 0 });
    }

    function toBytes(uint256[2] memory delta) internal pure returns (bytes memory) {
        return abi.encode(delta[0], delta[1]);
    }

    function toSignature(uint256[2] memory delta) internal pure returns (bytes memory) {
        bytes memory sig = abi.encodePacked(delta[0], delta[1], RECOVERY_IDENTIFIER);

        return sig;
    }

    function add(uint256[2] memory p1, uint256[2] memory p2) internal pure returns (uint256[2] memory p3) {
        (p3[0], p3[1]) = EllipticCurveK256.ecAdd(p1[0], p1[1], p2[0], p2[1]);
    }

    function verify(
        bytes32 transactionHash,
        uint256[2] memory transactionDelta,
        bytes calldata deltaProof
    )
        internal
        pure
    {
        // Verify the delta proof using the ECDSA.recover API to obtain the address
        address recovered = ECDSA.recover({ hash: transactionHash, signature: deltaProof });

        // Sum the deltahashes to obtain the real public key
        bytes memory pubKey = toSignature(transactionDelta);
        address expected = address(uint160(uint256(keccak256(pubKey))));

        if (recovered != expected) {
            revert DeltaMismatch({ expected: expected, actual: recovered });
        }
    }

    function publicKeyToAddress(bytes memory publicKey) public pure returns (address) {
        require(publicKey.length == 64, "Invalid public key length");

        // Hash the public key with Keccak-256
        bytes32 hashedKey = keccak256(publicKey);

        // Extract the last 20 bytes (Ethereum address)
        return address(uint160(uint256(hashedKey)));
    }
}
