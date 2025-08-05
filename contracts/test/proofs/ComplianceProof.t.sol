// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {Compliance} from "../../src/proving/Compliance.sol";
import {TransactionExample} from "../examples/Transaction.e.sol";

contract ComplianceProofTest is Test {
    using RiscZeroUtils for Compliance.Instance;

    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;

    function setUp() public {
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";
        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));
    }

    function tes_verify_example_compliance_proof() public view {
        Compliance.VerifierInput memory cu = TransactionExample.complianceVerifierInput();

        _sepoliaVerifierRouter.verify({
            seal: cu.proof,
            imageId: Compliance._VERIFYING_KEY,
            journalDigest: cu.instance.toJournalDigest()
        });
    }

    function test_compliance_instance_encoding() public pure {
        Compliance.Instance memory instance = TransactionExample.complianceInstance();

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
}
