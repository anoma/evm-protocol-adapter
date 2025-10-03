// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test, Vm} from "forge-std/Test.sol";

import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {MerkleTree} from "../src/libs/MerkleTree.sol";
import {RiscZeroUtils} from "./../src/libs/RiscZeroUtils.sol";
import {Compliance} from "../src/libs/proving/Compliance.sol";
import {Delta} from "../src/libs/proving/Delta.sol";
import {Logic} from "../src/libs/proving/Logic.sol";
import {SHA256} from "../src/libs/SHA256.sol";
import {TagUtils} from "../src/libs/TagUtils.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {CommitmentTree} from "../src/state/CommitmentTree.sol";
import {NullifierSet} from "../src/state/NullifierSet.sol";
import {Transaction, Action} from "../src/Types.sol";

import {ForwarderExample} from "./examples/Forwarder.e.sol";
import {INPUT, EXPECTED_OUTPUT} from "./examples/ForwarderTarget.e.sol";
import {TxGen} from "./libs/TxGen.sol";
import {DeployRiscZeroContractsMock} from "./script/DeployRiscZeroContractsMock.s.sol";

contract ProtocolAdapterMockVerifierTest is Test {
    using MerkleTree for bytes32[];
    using TxGen for Action[];
    using TxGen for Action;
    using TxGen for Vm;
    using RiscZeroUtils for Logic.Instance;
    using Logic for Logic.VerifierInput[];
    using Logic for Logic.VerifierInput;

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
    RiscZeroMockVerifier internal _mockVerifier;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _mockPa;
    address internal _fwd;
    address[] internal _fwdList;

    bytes32 internal _carrierLabelRef;

    function setUp() public {
        (_router, _emergencyStop, _mockVerifier) = new DeployRiscZeroContractsMock().run();

        _mockPa = new ProtocolAdapter(_router, _mockVerifier.SELECTOR(), _EMERGENCY_COMMITTEE);

        _fwd = address(
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: _CARRIER_LOGIC_REF})
        );

        _fwdList = new address[](1);
        _fwdList[0] = _fwd;

        _carrierLabelRef = sha256(abi.encode(_fwd));
    }

    function testFuzz_execute_emits_the_TransactionExecuted_event(
        uint8 actionCount,
        uint8 complianceUnitCount,
        bool aggregated
    ) public {
        actionCount = uint8(bound(actionCount, 0, 10));
        complianceUnitCount = uint8(bound(complianceUnitCount, 0, 10));

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.TransactionExecuted({
            tags: txn.actions.collectTags(),
            logicRefs: txn.actions.collectLogicRefs()
        });
        _mockPa.execute(txn);
    }

    function testFuzz_execute_emits_ActionExecuted_events_for_each_action(
        uint8 actionCount,
        uint8 complianceUnitCount,
        bool aggregated
    ) public {
        actionCount = uint8(bound(actionCount, 0, 10));
        complianceUnitCount = uint8(bound(complianceUnitCount, 0, 10));

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
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

    function test_execute_emits_the_ForwarderCallExecuted_event_on_created_carrier_resource(bool aggregated) public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: _fwdList});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists, aggregated);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });
        _mockPa.execute(txn);
    }

    function testFuzz_execute_emits_the_ForwarderCallExecuted_event_on_consumed_carrier_resource(bool aggregated)
        public
    {
        TxGen.ResourceAndAppData[] memory consumed = _exampleCarrierResourceAndAppData({nonce: 0, fwdList: _fwdList});
        TxGen.ResourceAndAppData[] memory created = _exampleResourceAndEmptyAppData({nonce: 1});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists, aggregated);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });

        _mockPa.execute(txn);
    }

    function testFuzz_execute_emits_all_ForwarderCallExecuted_events(bool aggregated) public {
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
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists, aggregated);

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

    function testFuzz_execute_1_txn_with_2_action_with_1_and_0_cus(bool aggregated) public {
        TxGen.ActionConfig[] memory configs = new TxGen.ActionConfig[](2);
        configs[0] = TxGen.ActionConfig({complianceUnitCount: 1});
        configs[1] = TxGen.ActionConfig({complianceUnitCount: 0});

        (Transaction memory txn,) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs, isProofAggregated: aggregated});

        _mockPa.execute(txn);
    }

    function testFuzz_execute_1_txn_with_up_to_3_empty_actions(bool[3] memory isEmpty, bool aggregated) public {
        TxGen.ActionConfig[] memory configs = new TxGen.ActionConfig[](3);

        for (uint256 i = 0; i < isEmpty.length; ++i) {
            configs[i] = TxGen.ActionConfig({complianceUnitCount: isEmpty[i] ? 0 : 1});
        }

        (Transaction memory txn,) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs, isProofAggregated: aggregated});

        _mockPa.execute(txn);
    }

    function testFuzz_execute_1_txn_with_n_actions_and_n_cus(
        uint8 actionCount,
        uint8 complianceUnitCount,
        bool aggregated
    ) public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({
            actionCount: uint8(bound(actionCount, 0, 5)),
            complianceUnitCount: uint8(bound(complianceUnitCount, 0, 5))
        });

        (Transaction memory txn,) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs, isProofAggregated: aggregated});
        _mockPa.execute(txn);
    }

    function testFuzz_execute_2_txns_with_n_actions_and_n_cus(
        uint8 actionCount,
        uint8 complianceUnitCount,
        bool aggregated
    ) public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({
            actionCount: uint8(bound(actionCount, 0, 5)),
            complianceUnitCount: uint8(bound(complianceUnitCount, 0, 5))
        });

        (Transaction memory txn, bytes32 updatedNonce) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs, isProofAggregated: aggregated});
        _mockPa.execute(txn);

        (txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: updatedNonce,
            configs: configs,
            isProofAggregated: aggregated
        });
        _mockPa.execute(txn);
    }

    function test_random_transactions_execute(TxGen.TransactionParams memory params) public {
        _mockPa.execute(vm.transaction(_mockVerifier, params));
    }

    function testFuzz_execute_reverts_on_pre_existing_nullifier(bool aggregated) public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({actionCount: 1, complianceUnitCount: 1});

        (Transaction memory tx1,) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs, isProofAggregated: aggregated});
        bytes32 preExistingNf = tx1.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;
        _mockPa.execute(tx1);

        vm.expectRevert(
            abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, preExistingNf), address(_mockPa)
        );
        _mockPa.execute(tx1);
    }

    function testFuzz_execute_reverts_on_resource_count_mismatch(uint8 complianceUnitCount, bool aggregated) public {
        complianceUnitCount = uint8(bound(complianceUnitCount, 1, 5));
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: 1, complianceUnitCount: uint8(bound(complianceUnitCount, 1, 5))});

        (Transaction memory txn,) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs, isProofAggregated: aggregated});

        txn.actions[0].logicVerifierInputs = new Logic.VerifierInput[](0);

        // Make sure that all the CUs are in the first action to expect the correct revert.
        assertEq(txn.actions[0].complianceVerifierInputs.length, complianceUnitCount);

        // You expect the twice number of compliance units to be the expected resource count.
        uint256 expectedResourceCount = txn.actions[0].complianceVerifierInputs.length * 2;

        vm.expectRevert(
            abi.encodeWithSelector(TagUtils.TagCountMismatch.selector, 0, expectedResourceCount), address(_mockPa)
        );

        _mockPa.execute(txn);
    }

    /// @notice Test that transactions with nonexistent roots fail.
    function testFuzz_execute_reverts_on_non_existing_root(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes32 fakeRoot,
        bool aggregated
    ) public {
        // Assume the proposed commitment tree root is not already contained.
        vm.assume(!_mockPa.isCommitmentTreeRootContained(fakeRoot));

        // Choose random compliance unit among the actions.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        // Assign the proposed commitment tree root into the transaction.
        txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.consumed.commitmentTreeRoot =
            fakeRoot;

        vm.expectRevert(abi.encodeWithSelector(CommitmentTree.NonExistingRoot.selector, fakeRoot));
        _mockPa.execute(txn);
    }

    /// @notice Test that transactions with unknown selectors fail.
    function testFuzz_execute_reverts_if_proofs_start_with_an_unknown_verifier_selector(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes memory fakeProof,
        bool aggregated
    ) public {
        // Ensure that the first 4 bytes of the proof are invalid.
        // The mock router only accepts one selector we deploy with.
        vm.assume(bytes4(fakeProof) != _mockVerifier.SELECTOR());
        vm.assume(fakeProof.length >= 4);

        // Choose random compliance unit among the actions.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        if (aggregated) {
            // If aggregated, replace the aggregation proof.
            txn.aggregationProof = fakeProof;
        } else {
            // Otherwise, replace the selected compliance unit's proof with a fake one.
            txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].proof = fakeProof;
        }

        // With an unknown selector, we expect failure.
        vm.expectRevert(
            abi.encodeWithSelector(RiscZeroVerifierRouter.SelectorUnknown.selector, bytes4(fakeProof)), address(_router)
        );
        _mockPa.execute(txn);
    }

    function testFuzz_execute_reverts_if_nullifier_from_compliance_inputs_cannot_be_found_in_logic_inputs(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes32 nonce,
        bool aggregated
    ) public {
        // Choose random compliance unit among the actions.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        bytes32 tag = txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.consumed.nullifier;
        uint256 tagIndex = TxGen.getTagIndex(txn.actions[actionIndex], tag);

        // Generate a different tag with the nonce.
        // We assume that the tags are generated using sha256. Hence the tag is different modulo hash-breaking.
        bytes32 fakeTag = SHA256.hash(tag, nonce);

        // Replace the nullifier corresponding to the selected compliance unit with a fake one.
        txn.actions[actionIndex].logicVerifierInputs[tagIndex].tag = fakeTag;

        // Execution reverts as the original nullifier isn't found in logic inputs.
        vm.expectRevert(abi.encodeWithSelector(Logic.TagNotFound.selector, tag));

        _mockPa.execute(txn);
    }

    function testFuzz_execute_reverts_if_commitment_from_compliance_inputs_cannot_be_found_in_logic_inputs(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes32 nonce,
        bool aggregated
    ) public {
        // Choose random compliance unit among the actions.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        // Generate a different tag with the nonce.
        // We assume that the tags are generated using sha256. Hence the tag is different modulo hash-breaking.
        bytes32 fakeTag = SHA256.hash(
            txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.created.commitment, nonce
        );

        bytes32 tag = txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.created.commitment;
        uint256 tagIndex = TxGen.getTagIndex(txn.actions[actionIndex], tag);

        // Replace the commitment corresponding to the selected compliance unit with a fake one
        txn.actions[actionIndex].logicVerifierInputs[tagIndex].tag = fakeTag;

        // Execution reverts as the original commitment isn't found in logic inputs.
        vm.expectRevert(abi.encodeWithSelector(Logic.TagNotFound.selector, tag));

        _mockPa.execute(txn);
    }

    /// @notice Test that transactions with a missing compliance verifier input fail.
    function testFuzz_execute_reverts_on_compliance_and_logic_verifier_tag_count_mismatch(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 fakeComplianceCount,
        bool aggregated
    ) public {
        // Choose a random action whose resource count we will mutate.
        (actionCount, complianceUnitCount, actionIndex, /* complianceIndex */ ) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, 0);

        // Take a fake compliance unit count.
        vm.assume(fakeComplianceCount != complianceUnitCount);

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        // Set the compliance unit count to the fake number.
        // We assume these can be kept empty as the compliance partition is checked prior to other checks.
        txn.actions[actionIndex].complianceVerifierInputs = new Compliance.VerifierInput[](fakeComplianceCount);

        // Expect revert based on wrong resource computation.
        vm.expectRevert(
            abi.encodeWithSelector(
                TagUtils.TagCountMismatch.selector,
                txn.actions[actionIndex].logicVerifierInputs.length,
                uint256(fakeComplianceCount) * 2
            )
        );

        _mockPa.execute(txn);
    }

    /// @notice Test that transactions with a missing logic verifier input fail.
    function testFuzz_execute_reverts_on_logic_and_compliance_verifier_tag_count_mismatch(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 fakeLogicVerifierCount,
        bool aggregated
    ) public {
        // Choose a random action whose resource count we will mutate.
        (actionCount, complianceUnitCount, actionIndex, /* complianceIndex */ ) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, 0);

        // Take a fake action unit count.
        vm.assume(fakeLogicVerifierCount != (uint256(complianceUnitCount) * 2));

        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount});

        (Transaction memory txn,) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs, isProofAggregated: aggregated});

        // Set the logic verifier inputs length based on wrong count.
        txn.actions[actionIndex].logicVerifierInputs = new Logic.VerifierInput[](fakeLogicVerifierCount);

        // Expect revert based on wrong resource computation.
        vm.expectRevert(
            abi.encodeWithSelector(
                TagUtils.TagCountMismatch.selector,
                fakeLogicVerifierCount,
                txn.actions[actionIndex].complianceVerifierInputs.length * 2
            )
        );

        _mockPa.execute(txn);
    }

    function testFuzz_execute_reverts_on_compliance_and_logic_verifier_logic_reference_mismatch_for_consumed_resource(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes32 nonce,
        bool aggregated
    ) public {
        // Choose a random compliance unit whose commitment logicRef we will mutate.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        Compliance.ConsumedRefs memory consumed =
            txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.consumed;
        uint256 tagIndex = TxGen.getTagIndex(txn.actions[actionIndex], consumed.nullifier);

        // Generate a fake logic using a nonce.
        bytes32 fakeLogic = SHA256.hash(consumed.logicRef, nonce);
        // Replace the original logic.
        txn.actions[actionIndex].logicVerifierInputs[tagIndex].verifyingKey = fakeLogic;

        // Expect a logic mismatch.
        vm.expectRevert(abi.encodeWithSelector(ProtocolAdapter.LogicRefMismatch.selector, consumed.logicRef, fakeLogic));
        _mockPa.execute(txn);
    }

    function testFuzz_execute_reverts_on_compliance_and_logic_verifier_logic_reference_mismatch_for_created_resource(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes32 nonce,
        bool aggregated
    ) public {
        // Choose a random compliance whose commitment logicRef we will mutate.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        Compliance.CreatedRefs memory created =
            txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.created;
        uint256 tagIndex = TxGen.getTagIndex(txn.actions[actionIndex], created.commitment);

        // Generate a fake logic using a nonce.
        bytes32 fakeLogic = SHA256.hash(created.logicRef, nonce);
        // Replace the original logic.
        txn.actions[actionIndex].logicVerifierInputs[tagIndex].verifyingKey = fakeLogic;

        // Expect a logic mismatch.
        vm.expectRevert(abi.encodeWithSelector(ProtocolAdapter.LogicRefMismatch.selector, created.logicRef, fakeLogic));
        _mockPa.execute(txn);
    }

    function testFuzz_execute_reverts_on_unexpected_forwarder_call_output(bytes memory fakeOutput, bool aggregated)
        public
    {
        vm.assume(keccak256(fakeOutput) != keccak256(EXPECTED_OUTPUT));

        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: _fwdList});

        created[0].appData.externalPayload[0].blob = abi.encode(_fwd, INPUT, fakeOutput);

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});

        // Create a transaction with two resources, the created calling the forwarder.
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists, aggregated);

        // Expect output mismatch.
        vm.expectRevert(
            abi.encodeWithSelector(ProtocolAdapter.ForwarderCallOutputMismatch.selector, fakeOutput, EXPECTED_OUTPUT)
        );
        _mockPa.execute(txn);
    }

    function testFuzz_execute_reverts_on_ubalanced_delta(
        uint128 createdQuantity,
        uint128 consumedQuantity,
        bool aggregated
    ) public {
        vm.assume(createdQuantity != consumedQuantity);
        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleResourceAndEmptyAppData({nonce: 0});

        // Make transaction unbalanced by offsettig the deltas.
        created[0].resource.quantity = createdQuantity;
        consumed[0].resource.quantity = consumedQuantity;

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});

        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists, aggregated);
        vm.expectPartialRevert(Delta.DeltaMismatch.selector);
        _mockPa.execute(txn);
    }

    function testFuzz_execute_updates_root(uint8 actionCount, uint8 complianceUnitCount, bool aggregated) public {
        (actionCount, complianceUnitCount, /* actionIndex */, /* complianceIndex */ ) =
            _bindParameters(actionCount, complianceUnitCount, 0, 0);
        bytes32 oldRoot = _mockPa.latestCommitmentTreeRoot();
        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        _mockPa.execute(txn);

        bytes32 newRoot = _mockPa.latestCommitmentTreeRoot();

        assert(oldRoot != newRoot);
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
        vm.assume(!_mockPa.isCommitmentTreeRootContained(params.commitmentTreeRoot));
        // Wrap the compliance verifier input index into range
        vm.assume(complianceVerifierInputs.length > 0);
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally assign the proposed commitment tree root into the transaction
        complianceVerifierInputs[params.inputIdx].instance.consumed.commitmentTreeRoot = params.commitmentTreeRoot;
        // With an incorrect commitment tree root, we expect failure
        vm.expectRevert(
            abi.encodeWithSelector(CommitmentTree.NonExistingRoot.selector, params.commitmentTreeRoot)
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
        uint256 minProofLen = 4;
        // Wrap the action index into range
        vm.assume(transactionCalldata.actions.length > 0);
        params.actionIdx = params.actionIdx % transactionCalldata.actions.length;
        Transaction memory transaction = transactionCalldata;
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
        GenericFailParams calldata mutParams
    ) public {
        txParams.isProofAggregated = false;
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
        UnknownSelectorFailsParams calldata mutParams
    ) public {
        txParams.isProofAggregated = false;
        mutationTestExecuteUnknownSelectorFails(vm.transaction(_mockVerifier, txParams), mutParams);
    }

    /// @notice Make transaction fail by ensuring unknown tag
    function mutationTestExecuteUnknownTagFails(
        Transaction calldata transactionCalldata,
        UnknownTagFailsParams memory params
    ) public {
        // Wrap the action index into range
        vm.assume(transactionCalldata.actions.length > 0);
        params.actionIdx = params.actionIdx % transactionCalldata.actions.length;
        Action calldata actionCalldata = transactionCalldata.actions[params.actionIdx];
        Compliance.VerifierInput[] calldata complianceVerifierInputs = actionCalldata.complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        vm.assume(complianceVerifierInputs.length > 0);
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        Compliance.VerifierInput calldata complianceVerifierInput = complianceVerifierInputs[params.inputIdx];
        // Make sure that the planned corruption will change something
        bytes32 tag = params.consumed
            ? complianceVerifierInput.instance.consumed.nullifier
            : complianceVerifierInput.instance.created.commitment;
        vm.assume(tag != params.tag);
        // Finally, corrupt the corresponding logic verifier input tag
        uint256 logicVerifierInputIdx = actionCalldata.logicVerifierInputs.lookup(tag);
        Transaction memory transaction = transactionCalldata;
        transaction.actions[params.actionIdx].logicVerifierInputs[logicVerifierInputIdx].tag = params.tag;
        // With an unknown tag, we expect failure
        vm.expectRevert(abi.encodeWithSelector(Logic.TagNotFound.selector, tag));
        // Finally, execute the transaction to make sure that it fails
        _mockPa.execute(transaction);
    }

    /// @notice Test that transactions with unknown tags fail
    function testFuzz_execute_unknown_tag_fails(
        TxGen.TransactionParams calldata txParams,
        UnknownTagFailsParams calldata mutParams
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
                TagUtils.TagCountMismatch.selector, action.logicVerifierInputs.length, shorter.length * 2
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
                TagUtils.TagCountMismatch.selector, shorter.length, action.complianceVerifierInputs.length * 2
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
        // Recompute the logic verifier input proof
        logicVerifierInput.proof = _mockVerifier.mockProve({
            imageId: logicVerifierInput.verifyingKey,
            journalDigest: sha256(logicVerifierInput.toInstance(action.collectTags().computeRoot(), params.consumed).toJournal())
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
        bool aggregated,
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
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists, aggregated);
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

    function _bindParameters(uint8 actionCount, uint8 complianceUnitCount, uint8 actionIndex, uint8 complianceIndex)
        private
        pure
        returns (
            uint8 boundActionCount,
            uint8 boundComplianceUnitCount,
            uint8 boundActionIndex,
            uint8 boundComplianceIndex
        )
    {
        boundActionCount = uint8(bound(actionCount, 1, 5));
        boundComplianceUnitCount = uint8(bound(complianceUnitCount, 1, 5));
        boundActionIndex = uint8(bound(actionIndex, 0, boundActionCount - 1));
        boundComplianceIndex = uint8(bound(complianceIndex, 0, boundComplianceUnitCount - 1));
    }
}
