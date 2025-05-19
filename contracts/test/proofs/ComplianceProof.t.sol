// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Receipt as RiscZeroReceipt} from "@risc0-ethereum/IRiscZeroVerifier.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test} from "forge-std/Test.sol";

import {ExampleComplianceProof} from "../mocks/ExampleComplianceProof.sol";

contract ComplianceProofTest is Test {
    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;
    RiscZeroMockVerifier internal _mockVerifier;

    RiscZeroReceipt internal _mockReceipt;
    bytes internal _mockSeal;

    function setUp() public {
        _sepoliaVerifierRouter = RiscZeroVerifierRouter(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187);
        _mockVerifier = new RiscZeroMockVerifier({selector: bytes4(ExampleComplianceProof.SEAL)});

        _mockReceipt = _mockVerifier.mockProve({
            imageId: ExampleComplianceProof.COMPLIANCE_CIRCUIT_ID,
            journalDigest: ExampleComplianceProof.JOURNAL_DIGEST
        });
        _mockSeal = _mockReceipt.seal;
    }

    function test_real_complianceProof() public {
        // Fork Sepolia
        vm.selectFork(vm.createFork("sepolia"));

        _sepoliaVerifierRouter.verify({
            seal: ExampleComplianceProof.SEAL,
            imageId: ExampleComplianceProof.COMPLIANCE_CIRCUIT_ID,
            journalDigest: ExampleComplianceProof.JOURNAL_DIGEST
        });
    }

    function test_mock_complianceProof() public view {
        _mockVerifier.verify({
            seal: _mockSeal,
            imageId: ExampleComplianceProof.COMPLIANCE_CIRCUIT_ID,
            journalDigest: ExampleComplianceProof.JOURNAL_DIGEST
        });
    }
}
