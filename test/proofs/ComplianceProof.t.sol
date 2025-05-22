// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Receipt as RiscZeroReceipt, VerificationFailed} from "@risc0-ethereum/IRiscZeroVerifier.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test, console} from "forge-std/Test.sol";

import {ComplianceUnit, ComplianceInstance} from "../../src/Types.sol";

import {ExampleComplianceProof} from "../mocks/ExampleComplianceProof.sol";
import {Example} from "../mocks/Example.sol";

contract ComplianceProofTest is Test {
    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;
    bytes32 internal _complianceCircuitID;

    RiscZeroMockVerifier internal _mockVerifier;

    RiscZeroReceipt internal _mockReceipt;
    bytes internal _mockSeal;

    function setUp() public {
        string memory path = "./script/constructor-args.txt";
        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));
        _complianceCircuitID = vm.parseBytes32(vm.readLine(path));

        _mockVerifier = new RiscZeroMockVerifier({selector: bytes4(ExampleComplianceProof.SEAL)});
        _mockReceipt = _mockVerifier.mockProve({
            imageId: ExampleComplianceProof.COMPLIANCE_CIRCUIT_ID,
            journalDigest: ExampleComplianceProof.JOURNAL_DIGEST
        });
        _mockSeal = _mockReceipt.seal;
    }

    function testFork_real_complianceProof() public {
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

    function test_encoding() public pure {
        ComplianceUnit memory cu = Example.complianceUnit();

        assertEq(
            abi.encode(cu.instance),
            abi.encode(
                cu.instance.consumed.nullifier,
                cu.instance.consumed.logicRef,
                cu.instance.consumed.commitmentTreeRoot,
                cu.instance.created.commitment,
                cu.instance.created.logicRef,
                cu.instance.unitDeltaX,
                cu.instance.unitDeltaY
            )
        );
    }

    function test_compliance_circuit_id_integrity() public view {
        assertEq(_complianceCircuitID, 0x2a0bd332079f7420f6f564bb96ad132937224d70d4d93155bf9507e49d05ad65);
    }

    function testFork_example_compliance_proof_from_converted_transaction() public {
        vm.selectFork(vm.createFork("sepolia"));

        ComplianceUnit memory cu = Example.complianceUnit();

        _sepoliaVerifierRouter.verify({
            seal: cu.proof,
            imageId: _complianceCircuitID,
            journalDigest: sha256(abi.encode(cu.instance))
        });
    }
}
