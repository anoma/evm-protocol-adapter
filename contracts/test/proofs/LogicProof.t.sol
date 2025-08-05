// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {TransactionExample} from "../examples/Transaction.e.sol";

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
        Logic.VerifierInput memory input = TransactionExample.logicVerifierInput({isConsumed: true});

        bytes32 journalDigest = input.instance.toJournalDigest();

        // TODO! Update example to a non-vulnerable version.
        address riscZeroEmergencyStop = address(_sepoliaVerifierRouter.getVerifier(bytes4(input.proof)));
        vm.expectRevert(Pausable.EnforcedPause.selector, riscZeroEmergencyStop);

        _sepoliaVerifierRouter.verify({seal: input.proof, imageId: input.verifyingKey, journalDigest: journalDigest});
    }

    function test_verify_example_logic_proof_created() public {
        Logic.VerifierInput memory input = TransactionExample.logicVerifierInput({isConsumed: false});

        bytes32 journalDigest = input.instance.toJournalDigest();

        // TODO! Update example to a non-vulnerable version.
        address riscZeroEmergencyStop = address(_sepoliaVerifierRouter.getVerifier(bytes4(input.proof)));
        vm.expectRevert(Pausable.EnforcedPause.selector, riscZeroEmergencyStop);

        _sepoliaVerifierRouter.verify({seal: input.proof, imageId: input.verifyingKey, journalDigest: journalDigest});
    }
}
