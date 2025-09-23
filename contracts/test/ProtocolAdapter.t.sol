// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Ownable} from "@openzeppelin-contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";

import {RiscZeroGroth16Verifier} from "@risc0-ethereum/groth16/RiscZeroGroth16Verifier.sol";
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
    address internal constant _EMERGENCY_COMMITTEE = address(uint160(1));
    address internal constant _UNAUTHORIZED_CALLER = address(uint160(2));

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;
    bytes4 internal _verifierSelector;

    function setUp() public {
        RiscZeroGroth16Verifier verifier;
        (_router, _emergencyStop, verifier) = new DeployRiscZeroContracts().run();

        _verifierSelector = verifier.SELECTOR();

        _pa = new ProtocolAdapter(_router, _verifierSelector, _EMERGENCY_COMMITTEE);
    }

    function test_constructor_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(ProtocolAdapter.RiscZeroVerifierStopped.selector);
        new ProtocolAdapter(_router, _verifierSelector, _EMERGENCY_COMMITTEE);
    }

    function test_execute_reverts_if_the_pa_has_been_stopped() public {
        vm.prank(_pa.owner());
        _pa.emergencyStop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(_pa));
        _pa.execute(TransactionExample.transaction());
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

    function test_emergencyStop_reverts_if_the_caller_is_not_the_owner() public {
        vm.prank(_UNAUTHORIZED_CALLER);
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, _UNAUTHORIZED_CALLER), address(_pa)
        );
        _pa.emergencyStop();
    }

    function test_emergencyStop_pauses_the_protocol_adapter() public {
        assertEq(_pa.paused(), false);

        vm.prank(_EMERGENCY_COMMITTEE);
        _pa.emergencyStop();

        assertEq(_pa.paused(), true);
    }

    function test_emergencyStop_emits_the_Paused_event() public {
        vm.prank(_EMERGENCY_COMMITTEE);

        vm.expectEmit(address(_pa));
        emit Pausable.Paused(_EMERGENCY_COMMITTEE);
        _pa.emergencyStop();
    }
}
