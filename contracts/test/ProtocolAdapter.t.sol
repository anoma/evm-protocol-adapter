// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

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
import {Transaction, Action} from "../src/Types.sol";
import {Compliance} from "../src/proving/Compliance.sol";
import {Logic} from "../src/proving/Logic.sol";
import {TxGen} from "./libs/TxGen.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";
import {DeployRiscZeroContractsMock} from "./script/DeployRiscZeroContractsMock.s.sol";

struct ProtocolAdapterTestArgs {
    RiscZeroVerifierRouter router;
    RiscZeroVerifierEmergencyStop emergencyStop;
    RiscZeroMockVerifier verifier;
}

contract ProtocolAdapterTestBase is Test, ProtocolAdapter {
    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;
    RiscZeroMockVerifier internal _mockVerifier;
    bytes4 internal _verifierSelector;
    using TxGen for Vm;

    constructor(ProtocolAdapterTestArgs memory args) ProtocolAdapter(args.router, args.verifier.SELECTOR()) {
        _router = args.router;
        _emergencyStop = args.emergencyStop;
        _mockVerifier = args.verifier;
        _verifierSelector = args.verifier.SELECTOR();
    }

    function setUp() public {
        _pa = new ProtocolAdapter({
            riscZeroVerifierRouter: _router,
            riscZeroVerifierSelector: _verifierSelector
        });
    }

    function test_constructor_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(ProtocolAdapter.RiscZeroVerifierStopped.selector);
        new ProtocolAdapter(_router, _verifierSelector);
    }

    function test_execute_reverts_on_vulnerable_risc_zero_verifier(uint8 nActions, uint8 nCUs, UnknownTagFailsParams memory params) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(_emergencyStop));
        _pa.execute(txn);
    }

    function test_execute(uint8 nActions, uint8 nCUs) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        _pa.execute(txn);
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
    
    // solhint-disable-next-line no-empty-blocks
    function test_tx_with_cu_mismatch_fails() public view {
        // TODO: create a transaction with no compliance units and two trivial resources
        //       in the action
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct NonExistingRootFailsParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the compliance verifier input of the action to mutate
        uint256 inputIdx;
        // The value to mutate the action tree root to
        bytes32 commitmentTreeRoot;
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by giving one of its compliance verifier inputs an incorrect
    /// commitment tree root.
    function mutation_test_execute_non_existing_root_fails(Transaction memory transaction, NonExistingRootFailsParams memory params) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs = transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Assume the proposed commitment tree root is not already contained
        vm.assume(!_containsRoot(params.commitmentTreeRoot));
        // Cannot do do mutation if transaction has no compliance verifier inputs
        vm.assume(complianceVerifierInputs.length > 0);
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally assign the proposed commitment tree root into the transaction
        complianceVerifierInputs[params.inputIdx].instance.consumed.commitmentTreeRoot = params.commitmentTreeRoot;
        // With an incorrect commitment tree root, we expect failure
        vm.expectPartialRevert(NonExistingRoot.selector);
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with nonexistent rotts fail
    function test_execute_non_existing_root_fails(uint8 nActions, uint8 nCUs, NonExistingRootFailsParams memory params) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_non_existing_root_fails(TransactionExample.transaction(), params);
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct ShortProofFailsParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the compliance verifier input of the action to mutate
        uint256 inputIdx;
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by giving one of its compliance verifier inputs a proof that's too
    /// short.
    function mutation_test_execute_short_proof_fails(Transaction memory transaction, ShortProofFailsParams memory params) public {
        uint256 MIN_PROOF_LEN = 4;
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs = transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Cannot do do mutation if transaction has no compliance verifier inputs
        vm.assume(complianceVerifierInputs.length > 0);
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally truncate the compliance proof to below the minimum
        bytes memory proof = complianceVerifierInputs[params.inputIdx].proof;
        bytes memory truncatedProof = new bytes(proof.length % MIN_PROOF_LEN);
        for (uint256 k = 0; k < truncatedProof.length; k++) {
            truncatedProof[k] = proof[k];
        }
        complianceVerifierInputs[params.inputIdx].proof = truncatedProof;
        // With a short proof, we expect failure
        vm.expectRevert(address(_router));
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with short proofs fail
    function test_execute_short_proof_fails(uint8 nActions, uint8 nCUs, ShortProofFailsParams memory params) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_short_proof_fails(TransactionExample.transaction(), params);
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct UnknownSelectorFailsParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the compliance verifier input of the action to mutate
        uint256 inputIdx;
        // The proof to overwrite with
        bytes proof;
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by giving one of its compliance verifier inputs a proof with an
    /// unknown selector.
    function mutation_test_execute_unknown_selector_fails(Transaction memory transaction, UnknownSelectorFailsParams memory params) public {
        // Make sure that the chosen verifier selector does not exist
        uint256 MIN_PROOF_LEN = 4;
        vm.assume(params.proof.length >= MIN_PROOF_LEN);
        vm.assume(address(_router.verifiers(bytes4(params.proof))) == address(0));
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs = transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Cannot do do mutation if transaction has no compliance verifier inputs
        vm.assume(complianceVerifierInputs.length > 0);
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally, corrupt the verifier selector
        complianceVerifierInputs[params.inputIdx].proof = params.proof;
        // With an unknown selector, we expect failure
        vm.expectPartialRevert(RiscZeroVerifierRouter.SelectorUnknown.selector, address(_router));
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with unknown selectors fail
    function test_execute_unknown_selector_fails(uint8 nActions, uint8 nCUs, UnknownSelectorFailsParams memory params) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_unknown_selector_fails(TransactionExample.transaction(), params);
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct UnknownTagFailsParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the compliance verifier input of the action to mutate
        uint256 inputIdx;
        // The tag to overwrite with
        bytes32 tag;
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that the nullifier of one of its compliance verifier
    /// inputs is not found in the logic verifier inputs.
    function mutation_test_execute_unknown_nullifier_tag_fails(Transaction memory transaction, UnknownTagFailsParams memory params) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs = transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Cannot do do mutation if transaction has no compliance verifier inputs
        vm.assume(complianceVerifierInputs.length > 0);
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally, corrupt the corresponding logic verifier input tag
        Logic.VerifierInput[] memory logicVerifierInputs = transaction.actions[params.actionIdx].logicVerifierInputs;
        // Do a linear search to identify the corresponding logic verifier input
        for (uint256 i = 0; i < logicVerifierInputs.length; i++) {
            // Select the logic verifier input with a tag matching the nullifier
            if (logicVerifierInputs[i].tag == complianceVerifierInputs[params.inputIdx].instance.consumed.nullifier) {
                // Finally, corrupt the logic verifier input tag so it can no longer be found
                logicVerifierInputs[i].tag = params.tag;
            }
        }
        // With an unknown tag, we expect failure
        vm.expectPartialRevert(Logic.TagNotFound.selector);
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with unknown nullifier tags fail
    function test_execute_unknown_nullifier_tag_fails(uint8 nActions, uint8 nCUs, UnknownTagFailsParams memory params) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_unknown_nullifier_tag_fails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that the commitment of one of its compliance verifier
    /// inputs is not found in the logic verifier inputs.
    function mutation_test_execute_unknown_commitment_tag_fails(Transaction memory transaction, UnknownTagFailsParams memory params) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs = transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Cannot do do mutation if transaction has no compliance verifier inputs
        vm.assume(complianceVerifierInputs.length > 0);
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally, corrupt the corresponding logic verifier input tag
        Logic.VerifierInput[] memory logicVerifierInputs = transaction.actions[params.actionIdx].logicVerifierInputs;
        // Do a linear search to identify the corresponding logic verifier input
        for (uint256 i = 0; i < logicVerifierInputs.length; i++) {
            // Select the logic verifier input with a tag matching the commitment
            if (logicVerifierInputs[i].tag == complianceVerifierInputs[params.inputIdx].instance.created.commitment) {
                // Finally, corrupt the logic verifier input tag so it can no longer be found
                logicVerifierInputs[i].tag = params.tag;
            }
        }
        // With an unknown tag, we expect failure
        vm.expectPartialRevert(Logic.TagNotFound.selector);
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with unknown commitment tags fail
    function test_execute_unknown_commitment_tag_fails(uint8 nActions, uint8 nCUs, UnknownTagFailsParams memory params) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_unknown_commitment_tag_fails(txn, params);
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct MismatchingResourcesFailParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the compliance verifier input of the action to mutate
        uint256 inputIdx;
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that it has less compliance verifier inputs than half
    /// the logic verifier inputs.
    function mutate_test_execute_missing_compliance_verifier_input_fail(Transaction memory transaction, MismatchingResourcesFailParams memory params) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs = transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Cannot do do mutation if transaction has no compliance verifier inputs
        vm.assume(complianceVerifierInputs.length > 0);
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Now delete the array entry
        // Replace the target position with the last element
        complianceVerifierInputs[params.inputIdx] = complianceVerifierInputs[complianceVerifierInputs.length - 1];
        // Then make a shorter array of compliance verifier inputs
        Compliance.VerifierInput[] memory shorter = new Compliance.VerifierInput[](complianceVerifierInputs.length - 1);
        for (uint256 i = 0; i < shorter.length; i++) {
            shorter[i] = complianceVerifierInputs[i];
        }
        // Finally, replace the compliance verifier inputs with the shorter array
        transaction.actions[params.actionIdx].complianceVerifierInputs = shorter;
        // With mismatching resource counts, we expect failure
        vm.expectPartialRevert(ResourceCountMismatch.selector);
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with a missing compliance verifier input fail
    function test_execute_missing_compliance_verifier_input_fail(uint8 nActions, uint8 nCUs, MismatchingResourcesFailParams memory params) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = _mockVerifier.transaction({nonce: 0, configs: configs});
        mutate_test_execute_missing_compliance_verifier_input_fail(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that it has less logic verifier inputs double half the
    /// compliance verifier inputs.
    function mutate_test_execute_missing_logic_verifier_input_fail(Transaction memory transaction, MismatchingResourcesFailParams memory params) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Logic.VerifierInput[] memory logicVerifierInputs = transaction.actions[params.actionIdx].logicVerifierInputs;
        // Cannot do do mutation if transaction has no logic verifier inputs
        vm.assume(logicVerifierInputs.length > 0);
        // Wrap the logic verifier input index into range
        params.inputIdx = params.inputIdx % logicVerifierInputs.length;
        // Now delete the array entry
        // Replace the target position with the last element
        logicVerifierInputs[params.inputIdx] = logicVerifierInputs[logicVerifierInputs.length - 1];
        // Then make a shorter array of logic verifier inputs
        Logic.VerifierInput[] memory shorter = new Logic.VerifierInput[](logicVerifierInputs.length - 1);
        for (uint256 i = 0; i < shorter.length; i++) {
            shorter[i] = logicVerifierInputs[i];
        }
        // Finally, replace the logic verifier inputs with the shorter array
        transaction.actions[params.actionIdx].logicVerifierInputs = shorter;
        // With mismatching resource counts, we expect failure
        vm.expectPartialRevert(ResourceCountMismatch.selector);
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with a missing logic verifier input fail
    function test_execute_missing_logic_verifier_input_fail(uint8 nActions, uint8 nCUs, MismatchingResourcesFailParams memory params) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = _mockVerifier.transaction({nonce: 0, configs: configs});
        mutate_test_execute_missing_logic_verifier_input_fail(txn, params);
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct MismatchingLogicRefsFailParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the logic verifier input of the action to mutate
        uint256 inputIdx;
        // The logic reference to overwrite with
        bytes32 logicRef;
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that it has less compliance verifier inputs than half
    /// the logic verifier inputs.
    function mutate_test_execute_mismatching_logic_refs_fail(Transaction memory transaction, MismatchingLogicRefsFailParams memory params) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Logic.VerifierInput[] memory logicVerifierInputs = transaction.actions[params.actionIdx].logicVerifierInputs;
        // Cannot do do mutation if transaction has no logic verifier inputs
        vm.assume(logicVerifierInputs.length > 0);
        // Wrap the logic verifier input index into range
        params.inputIdx = params.inputIdx % logicVerifierInputs.length;
        // Now corrupt the logic reference
        vm.assume(logicVerifierInputs[params.inputIdx].verifyingKey != params.logicRef);
        logicVerifierInputs[params.inputIdx].verifyingKey = params.logicRef;
        // With mismatching logic references, we expect failure
        vm.expectPartialRevert(LogicRefMismatch.selector);
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with mismatching logic references fail
    function test_execute_mismatching_logic_refs_fail(uint8 nActions, uint8 nCUs, MismatchingLogicRefsFailParams memory params) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) = _mockVerifier.transaction({nonce: 0, configs: configs});
        mutate_test_execute_mismatching_logic_refs_fail(txn, params);
    }
}

contract ProtocolAdapterTest is ProtocolAdapterTestBase {
    constructor() ProtocolAdapterTestBase(baseArgs()) {}

    function baseArgs() public returns (ProtocolAdapterTestArgs memory args) {
        RiscZeroVerifierRouter router;
        RiscZeroVerifierEmergencyStop emergencyStop;
        RiscZeroMockVerifier verifier;
        (router, emergencyStop, verifier) = new DeployRiscZeroContractsMock().run();
        return ProtocolAdapterTestArgs({ router: router, emergencyStop: emergencyStop, verifier: verifier });
    }
}
