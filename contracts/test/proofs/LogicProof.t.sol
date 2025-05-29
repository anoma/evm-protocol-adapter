// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {Example} from "../mocks/Example.sol";

contract LogicProofTest is Test {
    using RiscZeroUtils for Logic.Instance;
    using RiscZeroUtils for uint32;

    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;
    bytes32 internal _complianceCircuitID;

    function setUp() public {
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";
        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));
    }

    function test_verify_example_logic_proof_consumed() public view {
        Logic.VerifierInput memory input = Example.logicVerifierInput({isConsumed: true});

        _sepoliaVerifierRouter.verify({
            seal: input.proof,
            imageId: input.verifyingKey,
            journalDigest: input.instance.toJournalDigest()
        });
    }

    function test_verify_example_logic_proof_created() public view {
        Logic.VerifierInput memory lp = Example.logicVerifierInput({isConsumed: false});

        _sepoliaVerifierRouter.verify({
            seal: lp.proof,
            imageId: lp.verifyingKey,
            journalDigest: lp.instance.toJournalDigest()
        });
    }
}
