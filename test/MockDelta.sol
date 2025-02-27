// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {Universal} from "../src/libs/Identities.sol";
import {Delta} from "../src/proving/Delta.sol";

library MockDelta {
    using Delta for uint256[2];
    // Message
    /* The empty array "[]"
    abi.encode(
        0x0000000000000000000000000000000000000000000000000000000000000020,
        0x0000000000000000000000000000000000000000000000000000000000000000
    );*/
    // abi.encode(new bytes32[](0));

    bytes internal constant MESSAGE =
        hex"00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000";

    bytes32 internal constant MESSAGE_HASH = keccak256(MESSAGE);

    // Signer
    address internal constant SIGNER_ACCOUNT = Universal.ACCOUNT;
    uint256 internal constant SIGNER_PRIVATE_KEY = Universal.SEED;

    // Signature
    // obtained from `(uint8 v, bytes32 r, bytes32 s) = vm.sign(SIGNER_PRIVATE_KEY, MESSAGE_HASH);`
    bytes32 internal constant R = 0x281904b46380592ae0d9c3de363c450ea37ba9b7fcfdac5f568d878b43464bb9;
    bytes32 internal constant S = 0x167d04ade99ca40b42df474db6e51b45495a8bfe48248dc5952948354a0f9017;
    uint8 internal constant V = 0x1c; // 28
    bytes internal constant PROOF = abi.encodePacked(R, S, V);

    function transactionDelta() internal pure returns (uint256[2] memory txDelta) {
        txDelta[0] = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
        txDelta[1] = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;
    }

    function verify(bytes memory deltaProof) internal pure {
        require(keccak256(deltaProof) == keccak256(PROOF));

        Delta.verify({transactionHash: MESSAGE_HASH, transactionDelta: transactionDelta(), deltaProof: deltaProof});
    }
}
