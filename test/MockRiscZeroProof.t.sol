// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Bytes } from "@openzeppelin-contracts/utils/Bytes.sol";
import { Receipt as RiscZeroReceipt, VerificationFailed } from "@risc0-ethereum/IRiscZeroVerifier.sol";
import { RiscZeroMockVerifier, SelectorMismatch } from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import { Test } from "forge-std/Test.sol";

import { MockRiscZeroProof } from "./MockRiscZeroProof.sol";

contract MockRiscZeroProofTest is Test {
    using Bytes for bytes;

    RiscZeroMockVerifier internal immutable _mockVerifier;
    RiscZeroReceipt internal _proof;

    constructor() {
        _mockVerifier = new RiscZeroMockVerifier(MockRiscZeroProof.VERIFIER_SELECTOR);

        _proof = _mockVerifier.mockProve({
            imageId: MockRiscZeroProof.IMAGE_ID_1,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    /// @notice Verification
    function test_wrongImageId() public {
        vm.expectRevert(VerificationFailed.selector);
        _mockVerifier.verify({
            seal: _proof.seal,
            imageId: MockRiscZeroProof.IMAGE_ID_2,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    function test_wrongSeal() public {
        bytes memory wrongSeal = abi.encode(MockRiscZeroProof.VERIFIER_SELECTOR, "WRONG_DATA");

        vm.expectRevert(VerificationFailed.selector);
        _mockVerifier.verify({
            seal: wrongSeal,
            imageId: MockRiscZeroProof.IMAGE_ID_1,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    function test_wrongSelector() public {
        bytes4 wrongSelector = bytes4(0);

        vm.expectRevert(
            abi.encodeWithSelector(SelectorMismatch.selector, wrongSelector, MockRiscZeroProof.VERIFIER_SELECTOR)
        );
        _mockVerifier.verify({
            seal: abi.encode(wrongSelector),
            imageId: MockRiscZeroProof.IMAGE_ID_1,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    function test_wrongJournalDigest() public {
        bytes32 wrongDigest = bytes32(0);

        vm.expectRevert(VerificationFailed.selector);
        _mockVerifier.verify({ seal: _proof.seal, imageId: MockRiscZeroProof.IMAGE_ID_1, journalDigest: wrongDigest });
    }
    /// @notice It should verify correct _proofs.

    function test_correctProof() public view {
        _mockVerifier.verify({
            seal: _proof.seal,
            imageId: MockRiscZeroProof.IMAGE_ID_1,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    /// @notice should have the expected bytes4 verifier selector prepended.
    function test_proofHasSelector() public view {
        bytes4 selector = bytes4(_proof.seal.slice(0, 4));

        assertEq(selector, MockRiscZeroProof.VERIFIER_SELECTOR);
    }
}
