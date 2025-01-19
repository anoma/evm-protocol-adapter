// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { IRiscZeroVerifier } from "@risc0-ethereum/contracts/src/IRiscZeroVerifier.sol";

contract RiscZeroVerifier {
    IRiscZeroVerifier private immutable RISC_ZERO_VERIFIER;

    constructor(address riscZeroVerifier) {
        RISC_ZERO_VERIFIER = IRiscZeroVerifier(riscZeroVerifier);
    }

    function _verifyProof(bytes memory seal, bytes32 imageId, bytes32 journalDigest) internal view {
        RISC_ZERO_VERIFIER.verify({ seal: seal, imageId: imageId, journalDigest: journalDigest });
    }

    function _verifyProofCalldata(bytes calldata seal, bytes32 imageId, bytes32 journalDigest) internal view {
        RISC_ZERO_VERIFIER.verify({ seal: seal, imageId: imageId, journalDigest: journalDigest });
    }

    // TODO verifyIntegrity?
}
