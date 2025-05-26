// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {ComplianceUnit, ComplianceInstance} from "../../src/Types.sol";
import {Compliance} from "../../src/proving/Compliance.sol";
import {Example} from "../mocks/Example.sol";

contract ComplianceProofTest is Test {
    using RiscZeroUtils for ComplianceInstance;

    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;
    bytes32 internal _complianceCircuitID;

    function setUp() public {
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";
        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));
    }

    function test_compliance_instance_encoding() public pure {
        ComplianceInstance memory instance = Example.complianceInstance();

        assertEq(
            abi.encode(instance),
            abi.encodePacked(
                instance.consumed.nullifier,
                instance.consumed.logicRef,
                instance.consumed.commitmentTreeRoot,
                instance.created.commitment,
                instance.created.logicRef,
                instance.unitDeltaX,
                instance.unitDeltaY
            )
        );
    }

    function test_compliance_circuit_id_integrity() public pure {
        // aarm-risc0/target/release/build/compliance-methods-ec7fa279091777e1/out/methods.rs
        // pub const COMPLIANCE_GUEST_ID: [u32; 8] = [3090118071, 2046858913, 4187123841, 1403752873, 1328899817, 1064955823, 809758477, 955615332];
        bytes32 id = bytes32(
            abi.encodePacked(
                uint32(3090118071),
                uint32(2046858913),
                uint32(4187123841),
                uint32(1403752873),
                uint32(1328899817),
                uint32(1064955823),
                uint32(809758477),
                uint32(955615332)
            )
        ); // 0xb82f75b77a0096a1f992708153ab91a94f3566e93f79efaf3043ef0d38f58864

        assertEq(id, Compliance._CIRCUIT_ID);
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
