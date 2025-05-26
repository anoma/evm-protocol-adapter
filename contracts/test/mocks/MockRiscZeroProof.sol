// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library MockRiscZeroProof {
    bytes4 internal constant VERIFIER_SELECTOR = 0x12345678;

    bytes32 internal constant IMAGE_ID = bytes32(uint256(1));

    /// @notice Generated from `sha256("MOCK_JOURNAL_DIGEST");`.
    bytes32 internal constant JOURNAL_DIGEST = 0x26968006c64cf2912711161619df51842dc3d1b2dd9e58765cf6385c16beee1f;
}
