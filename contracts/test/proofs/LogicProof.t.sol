// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {Logic} from "../../src/proving/Logic.sol";

import {TransactionExample} from "../examples/Transaction.e.sol";
import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

contract LogicProofTest is Test {
    using RiscZeroUtils for Logic.Instance;
    using RiscZeroUtils for uint32;

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;

    bytes32 internal _complianceCircuitID;

    function setUp() public {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run();
    }

    function test_verify_example_logic_proof_consumed() public view {
        Logic.VerifierInput memory input = TransactionExample.logicVerifierInput({isConsumed: true});
        _router.verify({seal: input.proof, imageId: input.verifyingKey, journalDigest: input.instance.toJournalDigest()});
    }

    function test_verify_example_logic_proof_created() public view {
        Logic.VerifierInput memory input = TransactionExample.logicVerifierInput({isConsumed: false});
        _router.verify({seal: input.proof, imageId: input.verifyingKey, journalDigest: input.instance.toJournalDigest()});
    }
}
