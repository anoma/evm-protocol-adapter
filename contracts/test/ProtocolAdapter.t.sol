// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";
import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";
import {Test, Vm} from "forge-std/Test.sol";
import {ICommitmentAccumulator} from "../src/interfaces/ICommitmentAccumulator.sol";
import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {MerkleTree} from "./../src/libs/MerkleTree.sol";
import {RiscZeroUtils} from "./../src/libs/RiscZeroUtils.sol";
import {ProtocolAdapter} from "./../src/ProtocolAdapter.sol";
import {Compliance} from "./../src/proving/Compliance.sol";
import {Logic} from "./../src/proving/Logic.sol";
import {Transaction, Action} from "./../src/Types.sol";
import {ForwarderExample} from "./examples/Forwarder.e.sol";
import {TxGen} from "./libs/TxGen.sol";
import {ProtocolAdapterMockVerifierTest} from "./ProtocolAdapterMock.t.sol";
import {DeployRiscZeroContractsMock} from "./script/DeployRiscZeroContractsMock.s.sol";

struct ProtocolAdapterTestArgs {
    RiscZeroVerifierRouter router;
    RiscZeroVerifierEmergencyStop emergencyStop;
    RiscZeroMockVerifier verifier;
}

contract ProtocolAdapterTestBase is Test, ProtocolAdapter {
    using TxGen for Vm;
    using RiscZeroUtils for Logic.VerifierInput;
    using MerkleTree for bytes32[];

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct NonExistingRootFailsParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the compliance verifier input of the action to mutate
        uint256 inputIdx;
        // The value to mutate the action tree root to
        bytes32 commitmentTreeRoot;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct ShortProofFailsParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the compliance verifier input of the action to mutate
        uint256 inputIdx;
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

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct UnknownTagFailsParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the compliance verifier input of the action to mutate
        uint256 inputIdx;
        // The tag to overwrite with
        bytes32 tag;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct MismatchingResourcesFailParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the compliance verifier input of the action to mutate
        uint256 inputIdx;
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

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct MismatchingForwarderCallOutputsFailParams {
        // The index of the action to mutate
        uint256 actionIdx;
        // The index of the logic verifier input of the action to mutate
        uint256 inputIdx;
        // The index of the external payload to mutate
        uint256 payloadIdx;
        // The output to overwrite with
        bytes output;
    }

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;
    RiscZeroMockVerifier internal _mockVerifier;
    bytes4 internal _verifierSelector;

    constructor(ProtocolAdapterTestArgs memory args) ProtocolAdapter(args.router, args.verifier.SELECTOR()) {
        _router = args.router;
        _emergencyStop = args.emergencyStop;
        _mockVerifier = args.verifier;
        _verifierSelector = args.verifier.SELECTOR();
    }

    function setUp() public {
        _pa = new ProtocolAdapter({riscZeroVerifierRouter: _router, riscZeroVerifierSelector: _verifierSelector});
    }

    function test_constructor_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(ProtocolAdapter.RiscZeroVerifierStopped.selector);
        new ProtocolAdapter(_router, _verifierSelector);
    }

    function test_execute_reverts_on_vulnerable_risc_zero_verifier(uint8 nActions, uint8 nCUs) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn, ) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(_emergencyStop));
        _pa.execute(txn);
    }

    function test_execute(uint8 nActions, uint8 nCUs) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, ) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
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

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by giving one of its compliance verifier inputs an incorrect
    /// commitment tree root.
    function mutation_test_execute_non_existing_root_fails(
        Transaction memory transaction,
        NonExistingRootFailsParams memory params
    ) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
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
    function test_execute_non_existing_root_fails(uint8 nActions, uint8 nCUs, NonExistingRootFailsParams memory params)
        public
    {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_non_existing_root_fails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by giving one of its compliance verifier inputs a proof that's too
    /// short.
    function mutation_test_execute_short_proof_fails(
        Transaction memory transaction,
        ShortProofFailsParams memory params
    ) public {
        uint256 minProofLen = 4;
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Cannot do do mutation if transaction has no compliance verifier inputs
        vm.assume(complianceVerifierInputs.length > 0);
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally truncate the compliance proof to below the minimum
        bytes memory proof = complianceVerifierInputs[params.inputIdx].proof;
        bytes memory truncatedProof = new bytes(proof.length % minProofLen);
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

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_short_proof_fails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by giving one of its compliance verifier inputs a proof with an
    /// unknown selector.
    function mutation_test_execute_unknown_selector_fails(
        Transaction memory transaction,
        UnknownSelectorFailsParams memory params
    ) public {
        // Make sure that the chosen verifier selector does not exist
        uint256 minProofLen = 4;
        vm.assume(params.proof.length >= minProofLen);
        vm.assume(address(_router.verifiers(bytes4(params.proof))) == address(0));
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
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
    function test_execute_unknown_selector_fails(uint8 nActions, uint8 nCUs, UnknownSelectorFailsParams memory params)
        public
    {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_unknown_selector_fails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that the nullifier of one of its compliance verifier
    /// inputs is not found in the logic verifier inputs.
    function mutation_test_execute_unknown_nullifier_tag_fails(
        Transaction memory transaction,
        UnknownTagFailsParams memory params
    ) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
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
    function test_execute_unknown_nullifier_tag_fails(uint8 nActions, uint8 nCUs, UnknownTagFailsParams memory params)
        public
    {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, ) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_unknown_nullifier_tag_fails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that the commitment of one of its compliance verifier
    /// inputs is not found in the logic verifier inputs.
    function mutation_test_execute_unknown_commitment_tag_fails(
        Transaction memory transaction,
        UnknownTagFailsParams memory params
    ) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
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
    function test_execute_unknown_commitment_tag_fails(uint8 nActions, uint8 nCUs, UnknownTagFailsParams memory params)
        public
    {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, ) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutation_test_execute_unknown_commitment_tag_fails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that it has less compliance verifier inputs than half
    /// the logic verifier inputs.
    function mutate_test_execute_missing_compliance_verifier_input_fail(
        Transaction memory transaction,
        MismatchingResourcesFailParams memory params
    ) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
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
    function test_execute_missing_compliance_verifier_input_fail(
        uint8 nActions,
        uint8 nCUs,
        MismatchingResourcesFailParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, ) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutate_test_execute_missing_compliance_verifier_input_fail(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that it has less logic verifier inputs double half the
    /// compliance verifier inputs.
    function mutate_test_execute_missing_logic_verifier_input_fail(
        Transaction memory transaction,
        MismatchingResourcesFailParams memory params
    ) public {
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
    function test_execute_missing_logic_verifier_input_fail(
        uint8 nActions,
        uint8 nCUs,
        MismatchingResourcesFailParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, ) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutate_test_execute_missing_logic_verifier_input_fail(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that it has less compliance verifier inputs than half
    /// the logic verifier inputs.
    function mutate_test_execute_mismatching_logic_refs_fail(
        Transaction memory transaction,
        MismatchingLogicRefsFailParams memory params
    ) public {
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
    function test_execute_mismatching_logic_refs_fail(
        uint8 nActions,
        uint8 nCUs,
        MismatchingLogicRefsFailParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, ) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutate_test_execute_mismatching_logic_refs_fail(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that one of its forwarder call outputs mismatch.
    function mutate_test_execute_mismatching_forwarder_call_outputs_fail(
        Transaction memory transaction,
        MismatchingForwarderCallOutputsFailParams memory params
    ) public {
        // Cannot do mutation if the transaction has no actions
        vm.assume(transaction.actions.length > 0);
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Action memory action = transaction.actions[params.actionIdx];
        Logic.VerifierInput[] memory logicVerifierInputs = action.logicVerifierInputs;
        // Cannot do mutation if transaction has no logic verifier inputs
        vm.assume(logicVerifierInputs.length > 0);
        // Wrap the logic verifier input index into range
        params.inputIdx = params.inputIdx % logicVerifierInputs.length;
        Logic.VerifierInput memory logicVerifierInput = logicVerifierInputs[params.inputIdx];
        Logic.ExpirableBlob[] memory externalPayloads = logicVerifierInput.appData.externalPayload;
        // Cannot do the mutation if transaction has no external payloads
        vm.assume(externalPayloads.length > 0);
        // Wrap the external payload index into range
        params.payloadIdx = params.payloadIdx % externalPayloads.length;
        // Now corrupt the calldata output
        (address untrustedForwarder, bytes memory input, bytes memory expectedOutput) =
            abi.decode(externalPayloads[params.payloadIdx].blob, (address, bytes, bytes));
        vm.assume(
            expectedOutput.length != params.output.length || keccak256(expectedOutput) != keccak256(params.output)
        );
        expectedOutput = params.output;
        // Re-encode the calldata and replace the value in the external payloads
        externalPayloads[params.payloadIdx].blob = abi.encode(untrustedForwarder, input, expectedOutput);
        // Now determine whether the current resource is being created or consumed
        Compliance.VerifierInput[] memory complianceVerifierInputs = action.complianceVerifierInputs;
        bool isConsumed;
        for (uint256 i = 0; i < complianceVerifierInputs.length; i++) {
            if (complianceVerifierInputs[i].instance.consumed.nullifier == logicVerifierInput.tag) {
                isConsumed = true;
            } else if (
                complianceVerifierInputs[i].instance.created.commitment == logicVerifierInputs[params.inputIdx].tag
            ) {
                isConsumed = false;
            }
        }
        // Compute the action tree root
        bytes32 actionTreeRoot = _computeActionTreeRoot_memory(action, action.complianceVerifierInputs.length);
        // Recompute the logic verifier input proof
        logicVerifierInputs[params.inputIdx].proof = _mockVerifier.mockProve({
            imageId: logicVerifierInputs[params.inputIdx].verifyingKey,
            journalDigest: logicVerifierInputs[params.inputIdx].toJournalDigest(actionTreeRoot, isConsumed)
        }).seal;
        // With mismatching forwarder call outputs, we expect failure
        vm.expectPartialRevert(ForwarderCallOutputMismatch.selector);
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with mismatching forwarder call outputs fails
    function test_execute_mismatching_forwarder_call_outputs_fail(
        MismatchingForwarderCallOutputsFailParams memory params
    ) public {
        bytes32 carrierLogicRef = bytes32(uint256(123));
        address _fwd =
            address(new ForwarderExample({protocolAdapter: address(this), calldataCarrierLogicRef: carrierLogicRef}));
        address fwd2 =
            address(new ForwarderExample({protocolAdapter: address(this), calldataCarrierLogicRef: carrierLogicRef}));
        assertNotEq(_fwd, fwd2);

        address[] memory fwdList = new address[](2);
        fwdList[0] = _fwd;
        fwdList[1] = fwd2;
        ProtocolAdapterMockVerifierTest test = new ProtocolAdapterMockVerifierTest();

        TxGen.ResourceAndAppData[] memory consumed = test.exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = test.exampleCarrierResourceAndAppData({nonce: 1, fwdList: fwdList});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);
        mutate_test_execute_mismatching_forwarder_call_outputs_fail(txn, params);
    }

    // solhint-disable-next-line no-empty-blocks
    function test_tx_with_cu_mismatch_fails() public view {
        // TODO: create a transaction with no compliance units and two trivial resources
        //       in the action
    }

    /// @notice Computes the action tree root of an action constituted by all its nullifiers and commitments.
    /// @param action The action whose root we compute.
    /// @param nCUs The number of compliance units in the action.
    /// @return root The root of the corresponding tree.
    function _computeActionTreeRoot_memory(Action memory action, uint256 nCUs) internal pure returns (bytes32 root) {
        bytes32[] memory actionTreeTags = new bytes32[](nCUs * 2);

        // The order in which the tags are added to the tree are provided by the compliance units
        for (uint256 j = 0; j < nCUs; ++j) {
            Compliance.VerifierInput memory complianceVerifierInput = action.complianceVerifierInputs[j];

            actionTreeTags[2 * j] = complianceVerifierInput.instance.consumed.nullifier;
            actionTreeTags[(2 * j) + 1] = complianceVerifierInput.instance.created.commitment;
        }

        root = actionTreeTags.computeRoot();
    }
}

contract ProtocolAdapterTest is ProtocolAdapterTestBase {
    constructor() ProtocolAdapterTestBase(baseArgs()) {}

    function baseArgs() public returns (ProtocolAdapterTestArgs memory args) {
        RiscZeroVerifierRouter router;
        RiscZeroVerifierEmergencyStop emergencyStop;
        RiscZeroMockVerifier verifier;
        (router, emergencyStop, verifier) = new DeployRiscZeroContractsMock().run();
        return ProtocolAdapterTestArgs({router: router, emergencyStop: emergencyStop, verifier: verifier});
    }
}
