// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";
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

    function test_verify_example_logic_proof_consumed() public {
        Logic.Instance memory instance = Example.logicInstance({isConsumed: true});

        bytes32 journalDigest = instance.toJournalDigest();

        Logic.VerifierInput memory input = Example.logicVerifierInput({isConsumed: true});

        // TODO! Update example to a non-vulnerable version.
        address riscZeroEmergencyStop = address(_sepoliaVerifierRouter.getVerifier(bytes4(input.proof)));
        vm.expectRevert(Pausable.EnforcedPause.selector, riscZeroEmergencyStop);

        _sepoliaVerifierRouter.verify({seal: input.proof, imageId: input.verifyingKey, journalDigest: journalDigest});
    }

    function test_verify_example_logic_proof_created() public {
         Logic.Instance memory instance = Example.logicInstance({isConsumed: false});

        bytes32 journalDigest = instance.toJournalDigest();

        Logic.VerifierInput memory input = Example.logicVerifierInput({isConsumed: false});

        // TODO! Update example to a non-vulnerable version.
        address riscZeroEmergencyStop = address(_sepoliaVerifierRouter.getVerifier(bytes4(input.proof)));
        vm.expectRevert(Pausable.EnforcedPause.selector, riscZeroEmergencyStop);

        _sepoliaVerifierRouter.verify({seal: input.proof, imageId: input.verifyingKey, journalDigest: journalDigest});
    }
}
