// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, Vm} from "forge-std/Test.sol";

import {ICommitmentAccumulator} from "../src/interfaces/ICommitmentAccumulator.sol";
import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {Transaction, Action} from "../src/Types.sol";
import {TransactionExample} from "./examples/transactions/Transaction.e.sol";

import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract ProtocolAdapterTest is Test {
    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;

    function setUp() public {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run();

        _pa = new ProtocolAdapter(_router);
    }

    function test_constructor_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(ProtocolAdapter.RiscZeroVerifierStopped.selector);
        new ProtocolAdapter(_router);
    }

    function test_execute_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(_emergencyStop));
        _pa.execute(TransactionExample.transaction());
    }

    function test_execute() public {
        _pa.execute(TransactionExample.transaction());
    }

    function test_execute_executes_the_empty_transaction() public {
        Transaction memory emptyTx = Transaction({actions: new Action[](0), deltaProof: ""});

        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.TransactionExecuted({tags: new bytes32[](0), logicRefs: new bytes32[](0)});
        _pa.execute(emptyTx);
    }

    function test_execute_does_not_emit_the_CommitmentTreeRootStored_event_for_the_empty_transaction() public {
        Transaction memory emptyTx = Transaction({actions: new Action[](0), deltaProof: ""});

        vm.recordLogs();

        _pa.execute(emptyTx);

        Vm.Log[] memory entries = vm.getRecordedLogs();

        for (uint256 i = 0; i < entries.length; i++) {
            assert(entries[i].topics[0] != ICommitmentAccumulator.CommitmentTreeRootStored.selector);
        }
    }
}
