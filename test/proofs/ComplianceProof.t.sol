// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {ComplianceUnit, ComplianceInstance} from "../../src/Types.sol";
import {Example} from "../mocks/Example.sol";

contract ComplianceProofTest is Test {
    using RiscZeroUtils for ComplianceInstance;

    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;
    bytes32 internal _complianceCircuitID;

    function setUp() public {
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";
        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));
        _complianceCircuitID = vm.parseBytes32(vm.readLine(path));
    }

    function test_compliance_circuit_id_integrity() public view {
        assertEq(_complianceCircuitID, 0x2a0bd332079f7420f6f564bb96ad132937224d70d4d93155bf9507e49d05ad65);
    }

    function test_example_compliance_proof() public view {
        ComplianceUnit memory cu = Example.complianceUnit();

        _sepoliaVerifierRouter.verify({
            seal: cu.proof,
            imageId: _complianceCircuitID,
            journalDigest: cu.instance.toJournalDigest()
        });
    }
}
