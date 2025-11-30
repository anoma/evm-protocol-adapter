// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test, Vm} from "forge-std/Test.sol";

import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {MerkleTree} from "../src/libs/MerkleTree.sol";
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
import {CommitmentTreeMock} from "./mocks/CommitmentTree.m.sol";
import {DeployRiscZeroContractsMock} from "./script/DeployRiscZeroContractsMock.s.sol";

contract ProtocolAdapterMockVerifierTest is Test {
    using MerkleTree for bytes32[];
    using TxGen for Action[];
    using TxGen for Action;
    using TxGen for Vm;

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
            tags: txn.actions.collectTags(), logicRefs: txn.actions.collectLogicRefs()
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
                actionTagCount: complianceUnitCount * Compliance._RESOURCES_PER_COMPLIANCE_UNIT
            });
        }
        _mockPa.execute(txn);
    }

    function testFuzz_execute_emits_the_ForwarderCallExecuted_event_on_created_carrier_resource(bool aggregated)
        public
    {
        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: _fwdList});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists, aggregated);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd), input: INPUT, output: EXPECTED_OUTPUT
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
            untrustedForwarder: address(_fwd), input: INPUT, output: EXPECTED_OUTPUT
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
            untrustedForwarder: address(_fwd), input: INPUT, output: EXPECTED_OUTPUT
        });

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(fwd2), input: INPUT, output: EXPECTED_OUTPUT
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
            actionCount: uint8(bound(actionCount, 0, 5)), complianceUnitCount: uint8(bound(complianceUnitCount, 0, 5))
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
            actionCount: uint8(bound(actionCount, 0, 5)), complianceUnitCount: uint8(bound(complianceUnitCount, 0, 5))
        });

        (Transaction memory txn, bytes32 updatedNonce) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs, isProofAggregated: aggregated});
        _mockPa.execute(txn);

        (txn,) = vm.transaction({
            mockVerifier: _mockVerifier, nonce: updatedNonce, configs: configs, isProofAggregated: aggregated
        });
        _mockPa.execute(txn);
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
        uint256 expectedResourceCount =
            txn.actions[0].complianceVerifierInputs.length * Compliance._RESOURCES_PER_COMPLIANCE_UNIT;

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
        bytes4 selector,
        bytes calldata randomBytes,
        bool aggregated
    ) public {
        // Ensure that the first 4 bytes of the proof are invalid.
        // The mock router only accepts one selector we deploy with.
        vm.assume(selector != _mockVerifier.SELECTOR());
        bytes memory fakeProof = abi.encodePacked(selector, randomBytes);

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
            abi.encodeWithSelector(RiscZeroVerifierRouter.SelectorUnknown.selector, selector), address(_router)
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
        (
            actionCount,
            complianceUnitCount,
            actionIndex, /* complianceIndex */
        ) = _bindParameters(actionCount, complianceUnitCount, actionIndex, 0);

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
                uint256(fakeComplianceCount) * Compliance._RESOURCES_PER_COMPLIANCE_UNIT
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
        (
            actionCount,
            complianceUnitCount,
            actionIndex, /* complianceIndex */
        ) = _bindParameters(actionCount, complianceUnitCount, actionIndex, 0);

        // Take a fake action unit count.
        vm.assume(fakeLogicVerifierCount != (uint256(complianceUnitCount) * Compliance._RESOURCES_PER_COMPLIANCE_UNIT));

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
                txn.actions[actionIndex].complianceVerifierInputs.length * Compliance._RESOURCES_PER_COMPLIANCE_UNIT
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
        (
            actionCount,
            complianceUnitCount,/* actionIndex */, /* complianceIndex */
        ) = _bindParameters(actionCount, complianceUnitCount, 0, 0);
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

    function testFuzz_execute_updates_commitment_root_exactly_with_desired_commitments(
        uint8 actionCount,
        uint8 complianceUnitCount,
        bool aggregated
    ) public {
        (
            actionCount,
            complianceUnitCount,/* actionIndex */, /* complianceIndex */
        ) = _bindParameters(actionCount, complianceUnitCount, 0, 0);
        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        _mockPa.execute(txn);

        CommitmentTreeMock newCmTree = new CommitmentTreeMock();

        bytes32[] memory cms = TxGen.collectCommitments(txn);
        bytes32 newRoot = newCmTree.initialRoot();

        for (uint256 i = 0; i < cms.length; ++i) {
            newRoot = newCmTree.addCommitment(cms[i]);
        }

        newCmTree.addCommitmentTreeRoot(newRoot);

        assert(_mockPa.latestCommitmentTreeRoot() == newCmTree.latestCommitmentTreeRoot());
    }

    function testFuzz_execute_updates_nullifier_set_exactly_with_desired_nullifiers(
        uint8 actionCount,
        uint8 complianceUnitCount,
        bool aggregated
    ) public {
        (
            actionCount,
            complianceUnitCount,/* actionIndex */, /* complianceIndex */
        ) = _bindParameters(actionCount, complianceUnitCount, 0, 0);
        assertEq(_mockPa.nullifierCount(), 0);
        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount}),
            isProofAggregated: aggregated
        });

        _mockPa.execute(txn);

        bytes32[] memory nlfs = TxGen.collectNullifiers(txn);

        assertEq(_mockPa.nullifierCount(), nlfs.length);

        for (uint256 i = 0; i < nlfs.length; ++i) {
            assert(_mockPa.isNullifierContained(nlfs[i]));
        }
    }

    function test_execute_skips_risc_zero_proofs_if_aggregation_proof_is_present() public {
        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({actionCount: 1, complianceUnitCount: 1}),
            isProofAggregated: true
        });

        vm.expectCall({callee: address(_router), data: bytes(""), count: 1});
        _mockPa.execute(txn);
    }

    function _exampleResourceAndEmptyAppData(uint256 nonce)
        private
        view
        returns (TxGen.ResourceAndAppData[] memory data)
    {
        data = new TxGen.ResourceAndAppData[](1);

        data[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({
                nonce: bytes32(nonce), logicRef: _CARRIER_LOGIC_REF, labelRef: _carrierLabelRef, quantity: 1
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
                nonce: bytes32(nonce), logicRef: _CARRIER_LOGIC_REF, labelRef: _carrierLabelRef, quantity: 1
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
