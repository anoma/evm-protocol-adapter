// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";

import {Bytes} from "openzeppelin-contracts/utils/Bytes.sol";

import {IRiscZeroVerifier, Receipt as RiscZeroReceipt, VerificationFailed} from "risc0-ethereum/IRiscZeroVerifier.sol";
import {RiscZeroMockVerifier, SelectorMismatch} from "risc0-ethereum/test/RiscZeroMockVerifier.sol";
import {MockRiscZeroProof} from "./MockRiscZeroProof.sol";

contract MockRiscZeroProofTest is Test {
    using Bytes for bytes;

    RiscZeroMockVerifier internal immutable mockVerifier;
    RiscZeroReceipt internal proof;

    constructor() {
        mockVerifier = new RiscZeroMockVerifier(MockRiscZeroProof.VERIFIER_SELECTOR);

        proof = mockVerifier.mockProve({
            imageId: MockRiscZeroProof.IMAGE_ID_1,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    /// @notice should have the expected bytes4 verifier selector prepended.
    function test_proof_has_selector() public view {
        bytes4 selector = bytes4(proof.seal.slice(0, 4));

        assertEq(selector, MockRiscZeroProof.VERIFIER_SELECTOR);
    }

    /// @notice It should verify correct proofs.
    function test_correct_proof() public view {
        mockVerifier.verify({
            seal: proof.seal,
            imageId: MockRiscZeroProof.IMAGE_ID_1,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    /// @notice Verification
    function test_wrong_image_id() public {
        vm.expectRevert(VerificationFailed.selector);
        mockVerifier.verify({
            seal: proof.seal,
            imageId: MockRiscZeroProof.IMAGE_ID_2,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    function test_wrong_seal() public {
        bytes memory wrongSeal = abi.encode(MockRiscZeroProof.VERIFIER_SELECTOR, "WRONG_DATA");

        vm.expectRevert(VerificationFailed.selector);
        mockVerifier.verify({
            seal: wrongSeal,
            imageId: MockRiscZeroProof.IMAGE_ID_1,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    function test_wrong_selector() public {
        bytes4 wrongSelector = bytes4(0);

        vm.expectRevert(
            abi.encodeWithSelector(SelectorMismatch.selector, wrongSelector, MockRiscZeroProof.VERIFIER_SELECTOR)
        );
        mockVerifier.verify({
            seal: abi.encode(wrongSelector),
            imageId: MockRiscZeroProof.IMAGE_ID_1,
            journalDigest: MockRiscZeroProof.JOURNAL_DIGEST
        });
    }

    function test_wrong_journal_digest() public {
        bytes32 wrongDigest = bytes32(0);

        vm.expectRevert(VerificationFailed.selector);
        mockVerifier.verify({seal: proof.seal, imageId: MockRiscZeroProof.IMAGE_ID_1, journalDigest: wrongDigest});
    }
}
