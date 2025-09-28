// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

import {IProtocolAdapter} from "./../src/interfaces/IProtocolAdapter.sol";
import {MerkleTree} from "./../src/libs/MerkleTree.sol";
import {SHA256} from "./../src/libs/SHA256.sol";

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

    /// @notice Test that transactions with nonexistent roots fail.
    function testFuzz_execute_reverts_on_non_existing_root(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes32 fakeRoot
    ) public {
        // Assume the proposed commitment tree root is not already contained.
        vm.assume(!_mockPa.containsRoot(fakeRoot));

        // Choose random compliance unit among the actions.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        // Assign the proposed commitment tree root into the transaction.
        txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.consumed.commitmentTreeRoot =
            fakeRoot;

        vm.expectRevert(abi.encodeWithSelector(CommitmentAccumulator.NonExistingRoot.selector, fakeRoot));
        _mockPa.execute(txn);
    }

    /// @notice Test that transactions with unknown selectors fail.
    function testFuzz_execute_reverts_if_proofs_start_with_an_unknown_verifier_selector(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes memory fakeProof
    ) public {
        // Ensure that the first 4 bytes of the proof are invalid.
        // The mock router only accepts one selector we deploy with.
        vm.assume(bytes4(fakeProof) != _mockVerifier.SELECTOR());
        vm.assume(fakeProof.length >= 4);

        // Choose random compliance unit among the actions.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        // Replace the selected compliance unit's proof with a fake one.
        txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].proof = fakeProof;

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
        bytes32 nonce
    ) public {
        // Choose random compliance unit among the actions.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        // Generate a different tag with the nonce.
        // We assume that the tags are generated using sha256. Hence the tag is different modulo hash-breaking.
        bytes32 fakeTag = SHA256.hash(
            txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.consumed.nullifier, nonce
        );

        // Replace the nullifier corresponding to the selected compliance unit with a fake one.
        txn.actions[actionIndex].logicVerifierInputs[complianceIndex * 2].tag = fakeTag;

        // Execution reverts as the original nullifier isn't found in logic inputs.
        vm.expectRevert(
            abi.encodeWithSelector(
                Logic.TagNotFound.selector,
                txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.consumed.nullifier
            )
        );

        _mockPa.execute(txn);
    }

    function testFuzz_execute_reverts_if_commitment_from_compliance_inputs_cannot_be_found_in_logic_inputs(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes32 nonce
    ) public {
        // Choose random compliance unit among the actions.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        // Generate a different tag with the nonce.
        // We assume that the tags are generated using sha256. Hence the tag is different modulo hash-breaking.
        bytes32 fakeTag = SHA256.hash(
            txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.created.commitment, nonce
        );

        // Replace the commitment corresponding to the selected compliance unit with a fake one
        txn.actions[actionIndex].logicVerifierInputs[(complianceIndex * 2) + 1].tag = fakeTag;

        // Execution reverts as the original commitment isn't found in logic inputs.
        vm.expectRevert(
            abi.encodeWithSelector(
                Logic.TagNotFound.selector,
                txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.created.commitment
            )
        );

        _mockPa.execute(txn);
    }

    /// @notice Test that transactions with a missing compliance verifier input fail.
    function testFuzz_execute_reverts_on_compliance_and_logic_verifier_tag_count_mismatch(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 fakeComplianceCount
    ) public {
        // Choose a random action whose resource count we will mutate.
        (actionCount, complianceUnitCount, actionIndex, /* complianceIndex */ ) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, 0);

        // Take a fake compliance unit count.
        vm.assume(fakeComplianceCount != complianceUnitCount);

        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        // Set the compliance unit count to the fake number.
        // We assume these can be kept empty as the compliance partition is checked prior to other checks.
        txn.actions[actionIndex].complianceVerifierInputs = new Compliance.VerifierInput[](fakeComplianceCount);

        // Expect revert based on wrong resource computation.
        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.TagCountMismatch.selector,
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
        uint8 fakeLogicVerifierCount
    ) public {
        // Choose a random action whose resource count we will mutate.
        (actionCount, complianceUnitCount, actionIndex, /* complianceIndex */ ) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, 0);

        // Take a fake action unit count.
        vm.assume(fakeLogicVerifierCount != (uint256(complianceUnitCount) * 2));

        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        // Set the logic verifier inputs length based on wrong count.
        txn.actions[actionIndex].logicVerifierInputs = new Logic.VerifierInput[](fakeLogicVerifierCount);

        // Expect revert based on wrong resource computation.
        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.TagCountMismatch.selector,
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
        bytes32 nonce
    ) public {
        // Choose a random compliance unit whose commitment logicRef we will mutate.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        Compliance.ConsumedRefs memory consumed =
            txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.consumed;

        // Generate a fake logic using a nonce.
        bytes32 fakeLogic = SHA256.hash(consumed.logicRef, nonce);
        // Replace the original logic.
        txn.actions[actionIndex].logicVerifierInputs[(complianceIndex * 2) + 1].verifyingKey = fakeLogic;

        // Expect a logic mismatch.
        vm.expectRevert(abi.encodeWithSelector(ProtocolAdapter.LogicRefMismatch.selector, fakeLogic, consumed.logicRef));
        _mockPa.execute(txn);
    }

    function testFuzz_execute_reverts_on_compliance_and_logic_verifier_logic_reference_mismatch_for_created_resource(
        uint8 actionCount,
        uint8 complianceUnitCount,
        uint8 actionIndex,
        uint8 complianceIndex,
        bytes32 nonce
    ) public {
        // Choose a random compliance whose commitment logicRef we will mutate.
        (actionCount, complianceUnitCount, actionIndex, complianceIndex) =
            _bindParameters(actionCount, complianceUnitCount, actionIndex, complianceIndex);

        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({actionCount: actionCount, complianceUnitCount: complianceUnitCount});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        Compliance.CreatedRefs memory created =
            txn.actions[actionIndex].complianceVerifierInputs[complianceIndex].instance.created;

        // Generate a fake logic using a nonce.
        bytes32 fakeLogic = SHA256.hash(created.logicRef, nonce);
        // Replace the original logic.
        txn.actions[actionIndex].logicVerifierInputs[(complianceIndex * 2) + 1].verifyingKey = fakeLogic;

        // Expect a logic mismatch.
        vm.expectRevert(abi.encodeWithSelector(ProtocolAdapter.LogicRefMismatch.selector, fakeLogic, created.logicRef));
        _mockPa.execute(txn);
    }

    function testFuzz_execute_reverts_on_unexpected_forwarder_call_output(bytes memory fakeOutput) public {
        vm.assume(keccak256(fakeOutput) != keccak256(EXPECTED_OUTPUT));

        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: _fwdList});

        created[0].appData.externalPayload[0].blob = abi.encode(_fwd, INPUT, fakeOutput);

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});

        // Create a transaction with two resources, the created calling the forwarder.
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);

        // Expect output mismatch.
        vm.expectRevert(
            abi.encodeWithSelector(ProtocolAdapter.ForwarderCallOutputMismatch.selector, fakeOutput, EXPECTED_OUTPUT)
        );
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
