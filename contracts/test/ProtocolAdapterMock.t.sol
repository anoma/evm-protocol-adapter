// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test} from "forge-std/Test.sol";

import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {ComputableComponents} from "../src/libs/ComputableComponents.sol";
import {MerkleTree} from "../src/libs/MerkleTree.sol";
import {RiscZeroUtils} from "../src/libs/RiscZeroUtils.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Logic} from "../src/proving/Logic.sol";
import {NullifierSet} from "../src/state/NullifierSet.sol";
import {ForwarderCalldata, Transaction, Resource} from "../src/Types.sol";

import {ForwarderExample} from "./examples/Forwarder.e.sol";
import {INPUT, EXPECTED_OUTPUT} from "./examples/ForwarderTarget.e.sol";
import {TxGen} from "./examples/TxGen.sol";
import {ProtocolAdapterMock} from "./mocks/ProtocolAdapter.m.sol";
import {DeployRiscZeroContractsMock} from "./script/DeployRiscZeroContractsMock.s.sol";

contract ProtocolAdapterMockTest is Test {
    using MerkleTree for bytes32[];
    using ComputableComponents for Resource;
    using RiscZeroUtils for Logic.VerifierInput;
    using TxGen for RiscZeroMockVerifier;
    using TxGen for Transaction;

    uint8 internal constant _TEST_COMMITMENT_TREE_DEPTH = 8;
    uint8 internal constant _TEST_ACTION_TAG_TREE_DEPTH = 4;

    bytes32 internal constant _CARRIER_LOGIC_REF = bytes32(uint256(123));

    RiscZeroVerifierRouter internal _router;
    RiscZeroMockVerifier internal _mockVerifier;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapterMock internal _mockPa;
    address internal _fwd;

    bytes32 internal _carrierLabelRef;

    function setUp() public {
        (_router, _emergencyStop, _mockVerifier) = new DeployRiscZeroContractsMock().run();

        _mockPa = new ProtocolAdapterMock(_router, _TEST_COMMITMENT_TREE_DEPTH, _TEST_ACTION_TAG_TREE_DEPTH);

        _fwd = address(
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: _CARRIER_LOGIC_REF})
        );

        _carrierLabelRef = sha256(abi.encode(_fwd));
    }

    function test_execute_emits_the_TransactionExecuted_event() public {
        (Transaction memory txn,) = _mockVerifier.transaction({
            nonce: 0,
            configs: TxGen.generateActionConfigs({nActions: 1, nCUs: 1}),
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });

        bytes32[] memory cms = new bytes32[](1);
        cms[0] = txn.actions[0].complianceVerifierInputs[0].instance.created.commitment;

        bytes32 expectedRoot = cms.computeRoot(_TEST_COMMITMENT_TREE_DEPTH);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.TransactionExecuted({id: 0, transaction: txn, newRoot: expectedRoot});
        _mockPa.execute(txn);
    }

    function test_execute_emits_the_ForwarderCallExecuted_event_on_created_carrier_resource() public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, isConsumed: false});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });
        _mockPa.execute(_mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH));
    }

    function test_execute_emits_the_ForwarderCallExecuted_event_on_consumed_carrier_resource() public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleCarrierResourceAndAppData({nonce: 0, isConsumed: true});
        TxGen.ResourceAndAppData[] memory created = _exampleResourceAndEmptyAppData({nonce: 1});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });
        _mockPa.execute(_mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH));
    }

    function test_execute_1_txn_with_1_action_and_0_cus() public {
        (Transaction memory txn,) = _mockVerifier.transaction({
            nonce: 0,
            configs: TxGen.generateActionConfigs({nActions: 1, nCUs: 0}),
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });
        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_2_action_with_1_and_0_cus() public {
        TxGen.ActionConfig[] memory configs = new TxGen.ActionConfig[](2);
        configs[0] = TxGen.ActionConfig({nCUs: 1});
        configs[1] = TxGen.ActionConfig({nCUs: 0});

        (Transaction memory txn,) =
            _mockVerifier.transaction({nonce: 0, configs: configs, commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH});
        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({
            nActions: uint8(bound(nActions, 0, 5)),
            nCUs: uint8(bound(nCUs, 0, 2 ** (_mockPa.actionTreeDepth() - 1)))
        });

        (Transaction memory txn,) =
            _mockVerifier.transaction({nonce: 0, configs: configs, commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH});
        _mockPa.execute(txn);
    }

    function test_execute_2_txns_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({
            nActions: uint8(bound(nActions, 0, 5)),
            nCUs: uint8(bound(nCUs, 0, 2 ** (_mockPa.actionTreeDepth() - 1)))
        });

        (Transaction memory txn, bytes32 updatedNonce) =
            _mockVerifier.transaction({nonce: 0, configs: configs, commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH});
        _mockPa.execute(txn);

        (txn,) = _mockVerifier.transaction({
            nonce: updatedNonce,
            configs: configs,
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });
        _mockPa.execute(txn);
    }

    function test_execute_reverts_on_pre_existing_nullifier() public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({nActions: 1, nCUs: 1});

        (Transaction memory tx1, bytes32 updatedNonce) =
            _mockVerifier.transaction({nonce: 0, configs: configs, commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH});
        bytes32 preExistingNf = tx1.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;
        _mockPa.execute(tx1);

        (Transaction memory tx2,) = _mockVerifier.transaction({
            nonce: updatedNonce,
            configs: configs,
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });
        tx2.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier = preExistingNf;
        vm.expectRevert(
            abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, preExistingNf), address(_mockPa)
        );
        _mockPa.execute(tx2);
    }

    function test_execute_reverts_on_incorrect_commitment_computation_because_of_wrong_resource() public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, isConsumed: false});

        // Alter the resource blob so that it results in a different commitment.
        (Resource memory originalResource) = abi.decode(created[0].appData.resourcePayload[0].blob, (Resource));
        Resource memory alteredResource = consumed[0].resource;
        assertNotEq(keccak256(abi.encode(originalResource)), keccak256(abi.encode(alteredResource)));

        // Put the resource in the blob
        created[0].appData.resourcePayload[0].blob = abi.encode(alteredResource);

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = _mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH);

        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.CalldataCarrierCommitmentMismatch.selector,
                txn.actions[0].complianceVerifierInputs[0].instance.created.commitment,
                alteredResource.commitment()
            )
        );
        _mockPa.execute(txn);
    }

    function test_execute_reverts_on_incorrect_nullifier_computation_because_of_wrong_resource() public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleCarrierResourceAndAppData({nonce: 0, isConsumed: true});
        TxGen.ResourceAndAppData[] memory created = _exampleResourceAndEmptyAppData({nonce: 1});

        // Alter the nullifier key blob so that it results in a different commitment.
        (Resource memory originalResource, bytes32 originalNullifierKey) =
            abi.decode(consumed[0].appData.resourcePayload[0].blob, (Resource, bytes32));
        Resource memory alteredResource = created[0].resource;
        assertNotEq(keccak256(abi.encode(originalResource)), keccak256(abi.encode(alteredResource)));

        // Put the resource and the nullifier key in the blob
        consumed[0].appData.resourcePayload[0].blob = abi.encode(alteredResource, originalNullifierKey);

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = _mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH);

        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.CalldataCarrierNullifierMismatch.selector,
                txn.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier,
                alteredResource.nullifier({nullifierKey: originalNullifierKey})
            )
        );
        _mockPa.execute(txn);
    }

    function test_execute_reverts_on_incorrect_nullifier_computation_because_of_wrong_nullifierKey() public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleCarrierResourceAndAppData({nonce: 0, isConsumed: true});
        TxGen.ResourceAndAppData[] memory created = _exampleResourceAndEmptyAppData({nonce: 1});

        // Alter the nullifier key blob so that it results in a different nullifier.
        (Resource memory originalResource, bytes32 originalNullifierKey) =
            abi.decode(consumed[0].appData.resourcePayload[0].blob, (Resource, bytes32));
        bytes32 alteredNullifierKey = keccak256(abi.encode(originalNullifierKey));
        assertNotEq(originalNullifierKey, alteredNullifierKey);

        // Put the resource and the nullifier key in the blob
        consumed[0].appData.resourcePayload[0].blob = abi.encode(originalResource, alteredNullifierKey);

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = _mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH);

        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.CalldataCarrierNullifierMismatch.selector,
                txn.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier,
                consumed[0].resource.nullifier(alteredNullifierKey)
            )
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

    function _exampleCarrierResourceAndAppData(uint256 nonce, bool isConsumed)
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
                resourcePayload: new Logic.ExpirableBlob[](1),
                externalPayload: new Logic.ExpirableBlob[](1),
                applicationPayload: new Logic.ExpirableBlob[](0)
            })
        });

        Logic.ExpirableBlob[] memory resourceBlobs = new Logic.ExpirableBlob[](1);
        if (isConsumed) {
            bytes32 nullifierKey = 0;

            resourceBlobs[0] = Logic.ExpirableBlob({
                deletionCriterion: Logic.DeletionCriterion.Never,
                blob: abi.encode(data[0].resource, nullifierKey)
            });
        } else {
            resourceBlobs[0] = Logic.ExpirableBlob({
                deletionCriterion: Logic.DeletionCriterion.Never,
                blob: abi.encode(data[0].resource)
            });
        }

        data[0].appData.resourcePayload = resourceBlobs;

        Logic.ExpirableBlob[] memory externalBlobs = new Logic.ExpirableBlob[](1);
        externalBlobs[0] = Logic.ExpirableBlob({
            deletionCriterion: Logic.DeletionCriterion.Never,
            blob: abi.encode(ForwarderCalldata({untrustedForwarder: address(_fwd), input: INPUT, output: EXPECTED_OUTPUT}))
        });
        data[0].appData.externalPayload = externalBlobs;
    }
}
