// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Ownable} from "@openzeppelin-contracts-5.5.0/access/Ownable.sol";
import {Pausable} from "@openzeppelin-contracts-5.5.0/utils/Pausable.sol";
import {Test, Vm} from "forge-std-1.14.0/src/Test.sol";
import {RiscZeroGroth16Verifier} from "risc0-risc0-ethereum-3.0.1/contracts/src/groth16/RiscZeroGroth16Verifier.sol";
import {VerificationFailed} from "risc0-risc0-ethereum-3.0.1/contracts/src/IRiscZeroVerifier.sol";
import {
    RiscZeroVerifierEmergencyStop
} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "risc0-risc0-ethereum-3.0.1/contracts/src/test/RiscZeroMockVerifier.sol";
import {SemVerLib} from "solady-0.1.26/src/utils/SemVerLib.sol";

import {ICommitmentTree} from "../src/interfaces/ICommitmentTree.sol";
import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Transaction} from "../src/Types.sol";
import {Parsing} from "./libs/Parsing.sol";
import {TxGen} from "./libs/TxGen.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";
import {DeployRiscZeroContractsMock, MOCK_VERIFIER_SELECTOR} from "./script/DeployRiscZeroContractsMock.s.sol";

contract ProtocolAdapterTest is Test {
    using Parsing for Transaction;
    using Parsing for Vm;
    using SemVerLib for bytes32;
    using TxGen for Vm;

    address internal constant _EMERGENCY_COMMITTEE = address(uint160(1));
    address internal constant _UNAUTHORIZED_CALLER = address(uint160(2));

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    RiscZeroVerifierEmergencyStop internal _mockEmergencyStop;
    RiscZeroGroth16Verifier internal _verifier;
    RiscZeroMockVerifier internal _mockVerifier;

    ProtocolAdapter internal _pa;
    bytes4 internal _verifierSelector;

    Transaction internal _aggTx;
    Transaction internal _regTx;
    Transaction internal _emptyTx;

    function setUp() public {
        (_router, _emergencyStop, _verifier) =
            new DeployRiscZeroContracts().run({admin: msg.sender, guardian: msg.sender});

        (, _mockEmergencyStop, _mockVerifier) = new DeployRiscZeroContractsMock().run();
        _router.addVerifier({selector: _mockVerifier.SELECTOR(), verifier: _mockEmergencyStop});

        _verifierSelector = _verifier.SELECTOR();

        _pa = new ProtocolAdapter(_router, _verifierSelector, _EMERGENCY_COMMITTEE);

        _aggTx.toStorage(vm.parseTransaction("test/examples/transactions/test_tx_agg_01_01.bin"));
        _regTx.toStorage(vm.parseTransaction("test/examples/transactions/test_tx_reg_01_01.bin"));
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
        _pa.execute(_regTx);
    }

    function test_execute_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(_emergencyStop));
        _pa.execute(_regTx);
    }

    function test_execute_reverts_if_regular_proofs_have_been_generated_with_another_unstopped_verifier() public {
        (Transaction memory txnWithMockProof,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: 1, complianceUnitCount: 1}),
            isProofAggregated: false
        });

        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.RiscZeroVerifierSelectorMismatch.selector, _verifierSelector, MOCK_VERIFIER_SELECTOR
            ),
            address(_pa)
        );
        _pa.execute(txnWithMockProof);
    }

    function test_execute_reverts_if_aggregation_proof_has_been_generated_with_another_unstopped_verifier() public {
        (Transaction memory txnWithMockProof,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: 1, complianceUnitCount: 1}),
            isProofAggregated: true
        });

        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.RiscZeroVerifierSelectorMismatch.selector, _verifierSelector, MOCK_VERIFIER_SELECTOR
            ),
            address(_pa)
        );
        _pa.execute(txnWithMockProof);
    }

    function test_execute() public {
        _pa.execute(_regTx);
    }

    function test_execute_executes_the_empty_transaction() public {
        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.TransactionExecuted({tags: new bytes32[](0), logicRefs: new bytes32[](0)});
        _pa.execute(_emptyTx);
    }

    function test_execute_does_not_emit_the_CommitmentTreeRootAdded_event_for_the_empty_transaction() public {
        vm.recordLogs();

        _pa.execute(_emptyTx);

        Vm.Log[] memory entries = vm.getRecordedLogs();

        for (uint256 i = 0; i < entries.length; i++) {
            assertTrue(
                entries[i].topics[0] != ICommitmentTree.CommitmentTreeRootAdded.selector,
                "empty tx should not emit CommitmentTreeRootAdded"
            );
        }
    }

    function test_simulateExecute_reverts_if_proof_verification_is_skipped() public {
        vm.expectPartialRevert(ProtocolAdapter.Simulated.selector, address(_pa));
        _pa.simulateExecute({transaction: _emptyTx, skipRiscZeroProofVerification: true});
    }

    function test_simulateExecute_reverts_if_proof_verification_is_not_skipped() public {
        vm.expectPartialRevert(ProtocolAdapter.Simulated.selector, address(_pa));
        _pa.simulateExecute({transaction: _emptyTx, skipRiscZeroProofVerification: false});
    }

    function test_simulateExecute_reverts_on_invalid_logic_proof_if_proof_verification_is_not_skipped() public {
        Transaction memory modified = _regTx;
        {
            bytes memory proof = modified.actions[0].logicVerifierInputs[0].proof;
            proof[5] >>= 1; // Right shift the first byte after the verifier selector to invalidate the proof.
            modified.actions[0].logicVerifierInputs[0].proof = proof;
        }

        vm.expectRevert(VerificationFailed.selector, address(_verifier));
        _pa.simulateExecute({transaction: modified, skipRiscZeroProofVerification: false});
    }

    function test_simulateExecute_reverts_on_invalid_compliance_proof_if_proof_verification_is_not_skipped() public {
        Transaction memory modified = _regTx;
        {
            bytes memory proof = modified.actions[0].complianceVerifierInputs[0].proof;
            proof[5] >>= 1; // Right shift the first byte after the verifier selector to invalidate the proof.
            modified.actions[0].complianceVerifierInputs[0].proof = proof;
        }

        vm.expectRevert(VerificationFailed.selector, address(_verifier));
        _pa.simulateExecute({transaction: modified, skipRiscZeroProofVerification: false});
    }

    function test_simulateExecute_reverts_on_invalid_aggregation_proof_if_proof_verification_is_not_skipped() public {
        Transaction memory modified = _aggTx;
        {
            bytes memory proof = modified.aggregationProof;
            proof[5] >>= 1; // Right shift the first byte after the verifier selector to invalidate the proof.
            modified.aggregationProof = proof;
        }

        vm.expectRevert(VerificationFailed.selector, address(_verifier));
        _pa.simulateExecute({transaction: modified, skipRiscZeroProofVerification: false});
    }

    function test_emergencyStop_reverts_if_the_caller_is_not_the_owner() public {
        vm.prank(_UNAUTHORIZED_CALLER);
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, _UNAUTHORIZED_CALLER), address(_pa)
        );
        _pa.emergencyStop();
    }

    function test_emergencyStop_pauses_the_protocol_adapter() public {
        assertEq(_pa.paused(), false, "PA should not be paused initially");

        vm.prank(_EMERGENCY_COMMITTEE);
        _pa.emergencyStop();

        assertEq(_pa.paused(), true, "PA should be paused after emergency stop");
    }

    function test_emergencyStop_emits_the_Paused_event() public {
        vm.prank(_EMERGENCY_COMMITTEE);

        vm.expectEmit(address(_pa));
        emit Pausable.Paused(_EMERGENCY_COMMITTEE);
        _pa.emergencyStop();
    }

    function test_getRiscZeroVerifierRouter_returns_the_router_address() public view {
        assertEq(_pa.getRiscZeroVerifierRouter(), address(_router), "router address should match");
    }

    function test_getRiscZeroVerifierSelector_returns_the_selector() public view {
        assertEq(_pa.getRiscZeroVerifierSelector(), _verifierSelector, "verifier selector should match");
    }

    function test_getVersion_returns_a_semantic_version() public view {
        bytes32 version = _pa.getVersion();

        assertEq(
            version.cmp("0.0.0"),
            1, /* GT */
            "version should be greater than 0.0.0"
        );
        assertEq(
            version.cmp("999.999.999"),
            -1, /* LT */
            "version should be less than 999.999.999"
        );
    }
}
