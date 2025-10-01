// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";
import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {IProtocolAdapter} from "./../src/interfaces/IProtocolAdapter.sol";
import {MerkleTree} from "./../src/libs/MerkleTree.sol";
import {RiscZeroUtils} from "./../src/libs/RiscZeroUtils.sol";
import {ProtocolAdapter} from "./../src/ProtocolAdapter.sol";
import {Compliance} from "./../src/proving/Compliance.sol";
import {Logic} from "./../src/proving/Logic.sol";
import {CommitmentAccumulator} from "./../src/state/CommitmentAccumulator.sol";
import {NullifierSet} from "./../src/state/NullifierSet.sol";
import {Transaction, Action} from "./../src/Types.sol";
import {ForwarderExample} from "./examples/Forwarder.e.sol";
import {INPUT, EXPECTED_OUTPUT} from "./examples/ForwarderTarget.e.sol";
import {TxGen} from "./libs/TxGen.sol";
import {DeployRiscZeroContractsMock} from "./script/DeployRiscZeroContractsMock.s.sol";

contract ProtocolAdapterMockVerifierTest is Test {
    using MerkleTree for bytes32[];
    using TxGen for Action[];
    using TxGen for Action;
    using TxGen for Vm;
    using RiscZeroUtils for Logic.VerifierInput;
    using Logic for Logic.VerifierInput[];
    using Compliance for Compliance.VerifierInput[];

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct NonExistingRootFailsParams {
        uint256 actionIdx;
        uint256 inputIdx;
        bytes32 commitmentTreeRoot;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct UnknownSelectorFailsParams {
        uint256 actionIdx;
        uint256 inputIdx;
        bytes proof;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct UnknownTagFailsParams {
        uint256 actionIdx;
        uint256 inputIdx;
        bytes32 tag;
        bool consumed;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct GenericFailParams {
        uint256 actionIdx;
        uint256 inputIdx;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct MismatchingLogicRefsFailParams {
        uint256 actionIdx;
        uint256 inputIdx;
        bytes32 logicRef;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    struct MismatchingForwarderCallOutputsFailParams {
        uint256 actionIdx;
        uint256 inputIdx;
        uint256 payloadIdx;
        bytes output;
        bool consumed;
    }

    address internal constant _EMERGENCY_COMMITTEE = address(uint160(1));
    bytes32 internal constant _CARRIER_LOGIC_REF = bytes32(uint256(123));

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _mockPa;
    bytes4 internal _verifierSelector;
    RiscZeroMockVerifier internal _mockVerifier;
    address internal _fwd;
    address[] internal _fwdList;

    bytes32 internal _carrierLabelRef;

    function setUp() public {
        (_router, _emergencyStop, _mockVerifier) = new DeployRiscZeroContractsMock().run();
        _verifierSelector = _mockVerifier.SELECTOR();
        _mockPa = new ProtocolAdapter(_router, _verifierSelector, _EMERGENCY_COMMITTEE);

        _fwd = address(
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: _CARRIER_LOGIC_REF})
        );

        _fwdList = new address[](1);
        _fwdList[0] = _fwd;

        _carrierLabelRef = sha256(abi.encode(_fwd));
    }

    function testFuzz_execute_emits_the_TransactionExecuted_event(uint8 actionCount, uint8 complianceUnitCount)
        public
    {
        actionCount = uint8(bound(actionCount, 0, 10));
        complianceUnitCount = uint8(bound(complianceUnitCount, 0, 10));

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount})
        });

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.TransactionExecuted({
            tags: txn.actions.collectTags(),
            logicRefs: txn.actions.collectLogicRefs()
        });
        _mockPa.execute(txn);
    }

    function testFuzz_execute_emits_ActionExecuted_events_for_each_action(uint8 actionCount, uint8 complianceUnitCount)
        public
    {
        actionCount = uint8(bound(actionCount, 0, 10));
        complianceUnitCount = uint8(bound(complianceUnitCount, 0, 10));

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount})
        });

        for (uint256 i = 0; i < actionCount; ++i) {
            vm.expectEmit(address(_mockPa));
            emit IProtocolAdapter.ActionExecuted({
                actionTreeRoot: txn.actions[i].collectTags().computeRoot(),
                actionTagCount: complianceUnitCount * 2
            });
        }
        _mockPa.execute(txn);
    }

    function test_execute_emits_the_ForwarderCallExecuted_event_on_created_carrier_resource() public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: _fwdList});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });
        _mockPa.execute(txn);
    }

    function test_execute_emits_the_ForwarderCallExecuted_event_on_consumed_carrier_resource() public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleCarrierResourceAndAppData({nonce: 0, fwdList: _fwdList});
        TxGen.ResourceAndAppData[] memory created = _exampleResourceAndEmptyAppData({nonce: 1});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });

        _mockPa.execute(txn);
    }

    function test_execute_emits_all_ForwarderCallExecuted_events() public {
        address fwd2 = address(
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: _CARRIER_LOGIC_REF})
        );
        assertNotEq(_fwd, fwd2);

        address[] memory fwdList = new address[](2);
        fwdList[0] = _fwd;
        fwdList[1] = fwd2;

        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: fwdList});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(fwd2),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });

        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_2_action_with_1_and_0_cus() public {
        TxGen.ActionConfig[] memory configs = new TxGen.ActionConfig[](2);
        configs[0] = TxGen.ActionConfig({complianceUnitCount: 1});
        configs[1] = TxGen.ActionConfig({complianceUnitCount: 0});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_n_actions_and_n_cus(uint8 actionCount, uint8 complianceUnitCount) public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({
            actionCount: uint8(bound(actionCount, 0, 5)),
            complianceUnitCount: uint8(bound(complianceUnitCount, 0, 5))
        });

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        _mockPa.execute(txn);
    }

    function test_execute_2_txns_with_n_actions_and_n_cus(uint8 actionCount, uint8 complianceUnitCount) public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({
            actionCount: uint8(bound(actionCount, 0, 5)),
            complianceUnitCount: uint8(bound(complianceUnitCount, 0, 5))
        });

        (Transaction memory txn, bytes32 updatedNonce) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        _mockPa.execute(txn);

        (txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: updatedNonce, configs: configs});
        _mockPa.execute(txn);
    }

    function test_random_transactions_execute(TxGen.TransactionParams memory params) public {
        _mockPa.execute(vm.transaction(_mockVerifier, params));
    }

    function test_execute_reverts_on_pre_existing_nullifier() public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({actionCount: 1, complianceUnitCount: 1});

        (Transaction memory tx1, bytes32 updatedNonce) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        bytes32 preExistingNf = tx1.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;
        _mockPa.execute(tx1);

        (Transaction memory tx2,) = vm.transaction({mockVerifier: _mockVerifier, nonce: updatedNonce, configs: configs});
        tx2.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier = preExistingNf;
        vm.expectRevert(
            abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, preExistingNf), address(_mockPa)
        );
        _mockPa.execute(tx2);
    }

    function test_execute_reverts_on_resource_count_mismatch(uint8 complianceUnitCount) public {
        complianceUnitCount = uint8(bound(complianceUnitCount, 1, 5));
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: 1, complianceUnitCount: uint8(bound(complianceUnitCount, 1, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        txn.actions[0].logicVerifierInputs = new Logic.VerifierInput[](0);

        // Make sure that all the CUs are in the first action to expect the correct revert.
        assertEq(txn.actions[0].complianceVerifierInputs.length, complianceUnitCount);

        // You expect the twice number of compliance units to be the expected resource count.
        uint256 expectedResourceCount = txn.actions[0].complianceVerifierInputs.length * 2;

        vm.expectRevert(
            abi.encodeWithSelector(ProtocolAdapter.TagCountMismatch.selector, 0, expectedResourceCount),
            address(_mockPa)
        );

        _mockPa.execute(txn);
    }

    /// @notice Make transaction fail by giving it an incorrect commitment tree root.
    function mutationTestExecuteNonExistingRootFails(
        Transaction memory transaction,
        NonExistingRootFailsParams memory params
    ) public {
        // Wrap the action index into range
        vm.assume(transaction.actions.length > 0);
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Assume the proposed commitment tree root is not already contained
        vm.assume(!_mockPa.containsRoot(params.commitmentTreeRoot));
        // Wrap the compliance verifier input index into range
        vm.assume(complianceVerifierInputs.length > 0);
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally assign the proposed commitment tree root into the transaction
        complianceVerifierInputs[params.inputIdx].instance.consumed.commitmentTreeRoot = params.commitmentTreeRoot;
        // With an incorrect commitment tree root, we expect failure
        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.NonExistingRoot.selector, params.commitmentTreeRoot)
        );
        // Finally, execute the transaction to make sure that it fails
        _mockPa.execute(transaction);
    }

    /// @notice Test that transactions with nonexistent rotts fail
    function testFuzz_execute_non_existing_root_fails(
        TxGen.TransactionParams memory txParams,
        NonExistingRootFailsParams memory mutParams
    ) public {
        mutationTestExecuteNonExistingRootFails(vm.transaction(_mockVerifier, txParams), mutParams);
    }

    /// @notice Make transaction fail by giving it a proof that's too short
    function mutationTestExecuteShortProofFails(
        Transaction calldata transactionCalldata,
        GenericFailParams memory params
    ) public {
        Transaction memory transaction = transactionCalldata;
        uint256 minProofLen = 4;
        // Wrap the action index into range
        vm.assume(transaction.actions.length > 0);
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        vm.assume(complianceVerifierInputs.length > 0);
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally truncate the compliance proof to below the minimum
        bytes calldata proof =
            transactionCalldata.actions[params.actionIdx].complianceVerifierInputs[params.inputIdx].proof;
        complianceVerifierInputs[params.inputIdx].proof = proof[0:(proof.length % minProofLen)];
        // With a short proof, we expect an EVM error (which is message-less)
        vm.expectRevert(bytes(""), address(_router));
        // Finally, execute the transaction to make sure that it fails
        _mockPa.execute(transaction);
    }

    /// @notice Test that transactions with short proofs fail
    function testFuzz_execute_short_proof_fails(
        TxGen.TransactionParams memory txParams,
        GenericFailParams memory mutParams
    ) public {
        this.mutationTestExecuteShortProofFails(vm.transaction(_mockVerifier, txParams), mutParams);
    }

    /// @notice Make transaction fail by giving it an unknown selector.
    function mutationTestExecuteUnknownSelectorFails(
        Transaction memory transaction,
        UnknownSelectorFailsParams memory params
    ) public {
        // Make sure that the chosen verifier selector does not exist
        uint256 minProofLen = 4;
        vm.assume(params.proof.length >= minProofLen);
        vm.assume(address(_router.verifiers(bytes4(params.proof))) == address(0));
        // Wrap the action index into range
        vm.assume(transaction.actions.length > 0);
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        vm.assume(complianceVerifierInputs.length > 0);
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally, corrupt the verifier selector
        complianceVerifierInputs[params.inputIdx].proof = params.proof;
        // With an unknown selector, we expect failure
        vm.expectRevert(
            abi.encodeWithSelector(RiscZeroVerifierRouter.SelectorUnknown.selector, bytes4(params.proof)),
            address(_router)
        );
        // Finally, execute the transaction to make sure that it fails
        _mockPa.execute(transaction);
    }

    /// @notice Test that transactions with unknown selectors fail
    function testFuzz_execute_unknown_selector_fails(
        TxGen.TransactionParams memory txParams,
        UnknownSelectorFailsParams memory mutParams
    ) public {
        mutationTestExecuteUnknownSelectorFails(vm.transaction(_mockVerifier, txParams), mutParams);
    }

    /// @notice Make transaction fail by ensuring unknown tag
    function mutationTestExecuteUnknownTagFails(
        Transaction calldata transactionCalldata,
        UnknownTagFailsParams memory params
    ) public {
        Transaction memory transaction = transactionCalldata;
        // Wrap the action index into range
        vm.assume(transaction.actions.length > 0);
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Action calldata actionCalldata = transactionCalldata.actions[params.actionIdx];
        Action memory action = transaction.actions[params.actionIdx];
        Compliance.VerifierInput[] memory complianceVerifierInputs = action.complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        vm.assume(complianceVerifierInputs.length > 0);
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        Compliance.VerifierInput memory complianceVerifierInput = complianceVerifierInputs[params.inputIdx];
        // Make sure that the planned corruption will change something
        bytes32 tag = params.consumed
            ? complianceVerifierInput.instance.consumed.nullifier
            : complianceVerifierInput.instance.created.commitment;
        vm.assume(tag != params.tag);
        // Finally, corrupt the corresponding logic verifier input tag
        uint256 logicVerifierInputIdx = actionCalldata.logicVerifierInputs.lookup(tag);
        action.logicVerifierInputs[logicVerifierInputIdx].tag = params.tag;
        // With an unknown tag, we expect failure
        vm.expectRevert(abi.encodeWithSelector(Logic.TagNotFound.selector, tag));
        // Finally, execute the transaction to make sure that it fails
        _mockPa.execute(transaction);
    }

    /// @notice Test that transactions with unknown tags fail
    function testFuzz_execute_unknown_tag_fails(
        TxGen.TransactionParams memory txParams,
        UnknownTagFailsParams memory mutParams
    ) public {
        this.mutationTestExecuteUnknownTagFails(vm.transaction(_mockVerifier, txParams), mutParams);
    }

    /// @notice Make transaction fail by ensuring that it has less compliance verifier inputs
    function mutationTestExecuteMissingComplianceVerifierInputFail(
        Transaction memory transaction,
        GenericFailParams memory params
    ) public {
        // Wrap the action index into range
        vm.assume(transaction.actions.length > 0);
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Action memory action = transaction.actions[params.actionIdx];
        Compliance.VerifierInput[] memory complianceVerifierInputs = action.complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        vm.assume(complianceVerifierInputs.length > 0);
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
        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.TagCountMismatch.selector, action.logicVerifierInputs.length, shorter.length * 2
            )
        );
        // Finally, execute the transaction to make sure that it fails
        _mockPa.execute(transaction);
    }

    /// @notice Test that transactions with a missing compliance verifier input fail
    function testFuzz_execute_missing_compliance_verifier_input_fail(
        TxGen.TransactionParams memory txParams,
        GenericFailParams memory mutParams
    ) public {
        mutationTestExecuteMissingComplianceVerifierInputFail(vm.transaction(_mockVerifier, txParams), mutParams);
    }

    /// @notice Make transaction fail by ensuring that it has less logic verifier inputs
    function mutationTestExecuteMissingLogicVerifierInputFail(
        Transaction memory transaction,
        GenericFailParams memory params
    ) public {
        // Wrap the action index into range
        vm.assume(transaction.actions.length > 0);
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Action memory action = transaction.actions[params.actionIdx];
        Logic.VerifierInput[] memory logicVerifierInputs = action.logicVerifierInputs;
        // Wrap the logic verifier input index into range
        vm.assume(logicVerifierInputs.length > 0);
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
        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.TagCountMismatch.selector, shorter.length, action.complianceVerifierInputs.length * 2
            )
        );
        // Finally, execute the transaction to make sure that it fails
        _mockPa.execute(transaction);
    }

    /// @notice Test that transactions with a missing logic verifier input fail
    function testFuzz_execute_missing_logic_verifier_input_fail(
        TxGen.TransactionParams memory txParams,
        GenericFailParams memory mutParams
    ) public {
        mutationTestExecuteMissingLogicVerifierInputFail(vm.transaction(_mockVerifier, txParams), mutParams);
    }

    /// @notice Make transaction fail by making logic reference mismatch
    function mutationTestExecuteMismatchingLogicRefsFail(
        Transaction memory transaction,
        MismatchingLogicRefsFailParams memory params
    ) public {
        // Wrap the action index into range
        vm.assume(transaction.actions.length > 0);
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Logic.VerifierInput[] memory logicVerifierInputs = transaction.actions[params.actionIdx].logicVerifierInputs;
        // Wrap the logic verifier input index into range
        vm.assume(logicVerifierInputs.length > 0);
        params.inputIdx = params.inputIdx % logicVerifierInputs.length;
        // Now corrupt the logic reference
        vm.assume(logicVerifierInputs[params.inputIdx].verifyingKey != params.logicRef);
        logicVerifierInputs[params.inputIdx].verifyingKey = params.logicRef;
        // With mismatching logic references, we expect failure
        vm.expectPartialRevert(ProtocolAdapter.LogicRefMismatch.selector);
        // Finally, execute the transaction to make sure that it fails
        _mockPa.execute(transaction);
    }

    /// @notice Test that transactions with mismatching logic references fail
    function testFuzz_execute_mismatching_logic_refs_fail(
        TxGen.TransactionParams memory txParams,
        MismatchingLogicRefsFailParams memory mutParams
    ) public {
        mutationTestExecuteMismatchingLogicRefsFail(vm.transaction(_mockVerifier, txParams), mutParams);
    }

    /// @notice Make transaction fail by ensuring that one of its forwarder call outputs mismatch.
    function mutationTestExecuteMismatchingForwarderCallOutputsFail(
        Transaction calldata transactionCalldata,
        MismatchingForwarderCallOutputsFailParams memory params
    ) public {
        Transaction memory transaction = transactionCalldata;
        // Wrap the action index into range
        vm.assume(transaction.actions.length > 0);
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Action calldata actionCalldata = transactionCalldata.actions[params.actionIdx];
        Action memory action = transaction.actions[params.actionIdx];
        Compliance.VerifierInput[] memory complianceVerifierInputs = action.complianceVerifierInputs;
        // Wrap the logic verifier input index into range
        vm.assume(complianceVerifierInputs.length > 0);
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        Compliance.VerifierInput memory complianceVerifierInput = complianceVerifierInputs[params.inputIdx];
        bytes32 tag = params.consumed
            ? complianceVerifierInput.instance.consumed.nullifier
            : complianceVerifierInput.instance.created.commitment;
        uint256 logicVerifierInputIdx = actionCalldata.logicVerifierInputs.lookup(tag);
        Logic.VerifierInput memory logicVerifierInput = action.logicVerifierInputs[logicVerifierInputIdx];
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
        // Re-encode the calldata and replace the value in the external payloads
        externalPayloads[params.payloadIdx].blob = abi.encode(untrustedForwarder, input, params.output);
        // Compute the action tree root
        bytes32[] memory actionTreeTags =
            actionCalldata.complianceVerifierInputs.computeActionTreeTags(action.complianceVerifierInputs.length);
        // Recompute the logic verifier input proof
        logicVerifierInput.proof = _mockVerifier.mockProve({
            imageId: logicVerifierInput.verifyingKey,
            journalDigest: logicVerifierInput.toJournalDigest(actionTreeTags.computeRoot(), params.consumed)
        }).seal;
        // With mismatching forwarder call outputs, we expect failure
        vm.expectRevert(
            abi.encodeWithSelector(ProtocolAdapter.ForwarderCallOutputMismatch.selector, params.output, expectedOutput)
        );
        // Finally, execute the transaction to make sure that it fails
        _mockPa.execute(transaction);
    }

    /// @notice Test that transactions with mismatching forwarder call outputs fails
    function testFuzz_execute_mismatching_forwarder_call_outputs_fail(
        MismatchingForwarderCallOutputsFailParams memory params
    ) public {
        bytes32 carrierLogicRef = bytes32(uint256(123));
        address fwd2 =
            address(new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: carrierLogicRef}));
        assertNotEq(_fwd, fwd2);

        address[] memory fwdList = new address[](2);
        fwdList[0] = _fwd;
        fwdList[1] = fwd2;

        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: fwdList});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);
        this.mutationTestExecuteMismatchingForwarderCallOutputsFail(txn, params);
    }

    function _exampleResourceAndEmptyAppData(uint256 nonce)
        private
        view
        returns (TxGen.ResourceAndAppData[] memory data)
    {
        data = new TxGen.ResourceAndAppData[](1);

        data[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({
                nonce: bytes32(nonce),
                logicRef: _CARRIER_LOGIC_REF,
                labelRef: _carrierLabelRef,
                quantity: 1
            }),
            appData: Logic.AppData({
                discoveryPayload: new Logic.ExpirableBlob[](0),
                resourcePayload: new Logic.ExpirableBlob[](0),
                externalPayload: new Logic.ExpirableBlob[](0),
                applicationPayload: new Logic.ExpirableBlob[](0)
            })
        });
    }

    function _exampleCarrierResourceAndAppData(uint256 nonce, address[] memory fwdList)
        private
        view
        returns (TxGen.ResourceAndAppData[] memory data)
    {
        data = new TxGen.ResourceAndAppData[](1);
        uint256 nCalls = fwdList.length;

        data[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({
                nonce: bytes32(nonce),
                logicRef: _CARRIER_LOGIC_REF,
                labelRef: _carrierLabelRef,
                quantity: 1
            }),
            appData: Logic.AppData({
                discoveryPayload: new Logic.ExpirableBlob[](0),
                resourcePayload: new Logic.ExpirableBlob[](0),
                externalPayload: new Logic.ExpirableBlob[](nCalls),
                applicationPayload: new Logic.ExpirableBlob[](0)
            })
        });

        Logic.ExpirableBlob[] memory externalBlobs = new Logic.ExpirableBlob[](nCalls);
        for (uint256 i = 0; i < nCalls; ++i) {
            externalBlobs[i] = Logic.ExpirableBlob({
                deletionCriterion: Logic.DeletionCriterion.Never,
                blob: abi.encode(address(fwdList[i]), INPUT, EXPECTED_OUTPUT)
            });
        }
        data[0].appData.externalPayload = externalBlobs;
    }
}
