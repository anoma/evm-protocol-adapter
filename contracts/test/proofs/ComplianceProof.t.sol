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
        // /Users/michaelheuer/Projects/Anoma/aarm-risc0/target/debug/build/compliance-methods-5cb536499c35ce55/out/methods.rs
        // [3090118071, 2046858913, 4187123841, 1403752873, 1328899817, 1064955823, 809758477, 955615332];
        //    B82F75B7, 7A0096A1, F9927081, 53AB91A9, 4F3566E9, 3F79EFAF, 3043EF0D , 38F58864

        //assertEq(_complianceCircuitID, 0x2a0bd332079f7420f6f564bb96ad132937224d70d4d93155bf9507e49d05ad65);

        assertEq(_complianceCircuitID, RiscZeroUtils.complianceCircuitID());
        //assertEq(_complianceCircuitID, 0x2a0bd332079f7420f6f564bb96ad132937224d70d4d93155bf9507e49d05ad65);
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
