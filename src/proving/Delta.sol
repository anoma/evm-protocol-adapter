// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { EllipticCurveK256 } from "../libs/EllipticCurveK256.sol";

// TODO Remove?
struct DeltaInstance {
    uint256 expectedBalance; // Balance // pre-image
}

// slither-disable-next-line max-line-length
/// @notice Uses the Pedersen commitment scheme (https://link.springer.com/content/pdf/10.1007/3-540-46766-1_9.pdf#page=3)
library Delta {
    error DeltaMismatch(address expected, address actual);

    function zero() internal pure returns (uint256[2] memory p) {
        (p[0], p[1]) = EllipticCurveK256.derivePubKey({ privKey: 0 });
    }

    function add(uint256[2] memory p1, uint256[2] memory p2) internal pure returns (uint256[2] memory p3) {
        (p3[0], p3[1]) = EllipticCurveK256.ecAdd(p1[0], p1[1], p2[0], p2[1]);
    }

    function hash(uint256[2] memory delta) internal pure returns (bytes32) {
        return sha256(abi.encode(delta[0], delta[1]));
    }

    function verify(bytes32 transactionHash, uint256[2] memory delta, bytes calldata deltaProof) internal pure {
        bytes32 r = bytes32(delta[0]);
        // slither-disable-next-line max-line-length
        uint8 v = 27; // boolean to indicate which of the two y-values is used. Traditionally, 27 and 28 were used in Bitcoin.
        bytes32 s = bytes32(0);

        // slither-disable-next-line max-line-length
        // https://dev.to/truongpx396/understanding-ethereum-ecdsa-eip-712-and-its-role-in-permit-functionality-26ll
        // https://eips.ethereum.org/EIPS/eip-2098

        address expected = abi.decode(deltaProof, (address));

        address recovered = ECDSA.recover({ hash: transactionHash, r: r, v: v, s: s });

        if (recovered != expected) {
            revert DeltaMismatch({ expected: expected, actual: recovered });
        }
    }
}
