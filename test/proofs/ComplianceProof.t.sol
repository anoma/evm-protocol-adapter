// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Receipt as RiscZeroReceipt} from "@risc0-ethereum/IRiscZeroVerifier.sol";
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
        console.logBytes32(_complianceCircuitID);

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
                cu.instance.unitDelta[0],
                cu.instance.unitDelta[1]
            )
        );
    }

    function testFork_example_compliance_proof_from_converted_transaction() public {
        // Fork Sepolia
        vm.selectFork(vm.createFork("sepolia"));

        ComplianceUnit memory cu = Example.complianceUnit();

        bytes memory encodedInstance = abi.encode(
            cu.instance.consumed.nullifier,
            cu.instance.consumed.logicRef,
            cu.instance.consumed.commitmentTreeRoot,
            cu.instance.created.commitment,
            cu.instance.created.logicRef,
            cu.instance.unitDelta[0],
            cu.instance.unitDelta[1]
        );

        // console.logBytes(encodedInstance);
        // console.logBytes(abi.encode(cu.instance));

        _sepoliaVerifierRouter.verify({
            seal: cu.proof,
            imageId: _complianceCircuitID, //0x1acbb40c5b4daed29a7a61c44baf919f97e6ca3b6893164c1b9cdb481e08e284,
            journalDigest: sha256(abi.encode(cu.instance))
        });
    }
}
