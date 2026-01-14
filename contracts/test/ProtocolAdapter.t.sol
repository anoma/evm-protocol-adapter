// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Ownable} from "@openzeppelin-contracts-5.5.0/access/Ownable.sol";
import {Pausable} from "@openzeppelin-contracts-5.5.0/utils/Pausable.sol";
import {Test, Vm} from "forge-std-1.14.0/src/Test.sol";
import {RiscZeroGroth16Verifier} from "risc0-risc0-ethereum-3.0.1/contracts/src/groth16/RiscZeroGroth16Verifier.sol";
import {
    RiscZeroVerifierEmergencyStop
} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierRouter.sol";
import {SemVerLib} from "solady-0.1.26/src/utils/SemVerLib.sol";

import {ICommitmentTree} from "../src/interfaces/ICommitmentTree.sol";
import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {Transaction, Action} from "../src/Types.sol";
import {Parsing} from "./libs/Parsing.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract ProtocolAdapterTest is Test {
    using Parsing for Vm;
    using SemVerLib for bytes32;

    address internal constant _EMERGENCY_COMMITTEE = address(uint160(1));
    address internal constant _UNAUTHORIZED_CALLER = address(uint160(2));

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;
    bytes4 internal _verifierSelector;

    Transaction internal _exampleTx;

    function setUp() public {
        RiscZeroGroth16Verifier verifier;
        (_router, _emergencyStop, verifier) =
            new DeployRiscZeroContracts().run({admin: msg.sender, guardian: msg.sender});

        _verifierSelector = verifier.SELECTOR();

        _pa = new ProtocolAdapter(_router, _verifierSelector, _EMERGENCY_COMMITTEE);

        _exampleTx = vm.parseTransaction("test/examples/transactions/test_tx_reg_01_01.bin");
    }

    function test_constructor_reverts_on_address_zero_router() public {
        vm.expectRevert(ProtocolAdapter.ZeroNotAllowed.selector);
        new ProtocolAdapter(RiscZeroVerifierRouter(address(0)), _verifierSelector, _EMERGENCY_COMMITTEE);
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
        _pa.execute(_exampleTx);
    }

    function test_execute_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(_emergencyStop));
        _pa.execute(_exampleTx);
    }

    function test_execute() public {
        _pa.execute(_exampleTx);
    }

    function test_execute_executes_the_empty_transaction() public {
        Transaction memory emptyTx = Transaction({actions: new Action[](0), deltaProof: "", aggregationProof: ""});

        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.TransactionExecuted({tags: new bytes32[](0), logicRefs: new bytes32[](0)});
        _pa.execute(emptyTx);
    }

    function test_execute_does_not_emit_the_CommitmentTreeRootAdded_event_for_the_empty_transaction() public {
        Transaction memory emptyTx = Transaction({actions: new Action[](0), deltaProof: "", aggregationProof: ""});

        vm.recordLogs();

        _pa.execute(emptyTx);

        Vm.Log[] memory entries = vm.getRecordedLogs();

        for (uint256 i = 0; i < entries.length; i++) {
            assert(entries[i].topics[0] != ICommitmentTree.CommitmentTreeRootAdded.selector);
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

    function test_getRiscZeroVerifierRouter_returns_the_router_address() public view {
        assertEq(_pa.getRiscZeroVerifierRouter(), address(_router));
    }

    function test_getRiscZeroVerifierSelector_returns_the_selector() public view {
        assertEq(_pa.getRiscZeroVerifierSelector(), _verifierSelector);
    }

    function test_getVersion_returns_a_semantic_version() public view {
        bytes32 version = _pa.getVersion();

        assertEq(
            version.cmp("0.0.0"),
            1 /* GT */
        );
        assertEq(
            version.cmp("999.999.999"),
            -1 /* LT */
        );
    }
}
