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

    RiscZeroVerifierRouter internal _router;
    RiscZeroMockVerifier internal _mockVerifier;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapterMock internal _mockPa;

    function setUp() public {
        (_router, _emergencyStop, _mockVerifier) = new DeployRiscZeroContractsMock().run();

        _mockPa = new ProtocolAdapterMock(_router, _TEST_COMMITMENT_TREE_DEPTH, _TEST_ACTION_TAG_TREE_DEPTH);
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
        bytes32 nonce = 0;
        bytes32 logicRef = bytes32(uint256(123));
        ForwarderExample fwd =
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: logicRef});

        bytes32 labelRef = sha256(abi.encode(address(fwd)));

        Transaction memory txn;
        {
            ForwarderCalldata memory call =
                ForwarderCalldata({untrustedForwarder: address(fwd), input: INPUT, output: EXPECTED_OUTPUT});

            Logic.ExpirableBlob[] memory externalBlobs = new Logic.ExpirableBlob[](1);
            externalBlobs[0] =
                Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: abi.encode(call)});

            bytes memory zero = new bytes(32);

            Logic.AppData memory consumedAppData = Logic.AppData({
                discoveryPayload: new Logic.ExpirableBlob[](0),
                resourcePayload: new Logic.ExpirableBlob[](0),
                externalPayload: new Logic.ExpirableBlob[](0),
                applicationPayload: new Logic.ExpirableBlob[](0)
            });

            TxGen.ResourceAndAppData[] memory consumed = new TxGen.ResourceAndAppData[](1);

            consumed[0] = TxGen.ResourceAndAppData({
                resource: TxGen.mockResource({nonce: nonce, logicRef: logicRef, labelRef: labelRef, quantity: 1}),
                appData: consumedAppData
            });

            Logic.AppData memory createdAppData = Logic.AppData({
                discoveryPayload: new Logic.ExpirableBlob[](0),
                resourcePayload: new Logic.ExpirableBlob[](1),
                externalPayload: new Logic.ExpirableBlob[](1),
                applicationPayload: new Logic.ExpirableBlob[](0)
            });

            Logic.ExpirableBlob[] memory resourceBlobs = new Logic.ExpirableBlob[](1);
            resourceBlobs[0] = Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: zero});

            createdAppData.externalPayload = externalBlobs;
            createdAppData.resourcePayload = resourceBlobs;

            TxGen.ResourceAndAppData[] memory created = new TxGen.ResourceAndAppData[](1);
            created[0] = TxGen.ResourceAndAppData({
                resource: TxGen.mockResource({
                    nonce: bytes32(uint256(nonce) + 1),
                    logicRef: logicRef,
                    labelRef: labelRef,
                    quantity: 1
                }),
                appData: createdAppData
            });

            created[0].appData.resourcePayload[0].blob = abi.encode(created[0].resource);

            TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
            resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
            txn = _mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH);
        }

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });
        _mockPa.execute(txn);
    }

    function test_execute_emits_the_ForwarderCallExecuted_event_on_consumed_carrier_resource() public {
        bytes32 nonce = 0;
        bytes32 logicRef = bytes32(uint256(123));
        ForwarderExample fwd =
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: logicRef});

        bytes32 labelRef = sha256(abi.encode(address(fwd)));

        Transaction memory txn;
        {
            ForwarderCalldata memory call =
                ForwarderCalldata({untrustedForwarder: address(fwd), input: INPUT, output: EXPECTED_OUTPUT});

            Logic.ExpirableBlob[] memory externalBlobs = new Logic.ExpirableBlob[](1);
            externalBlobs[0] =
                Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: abi.encode(call)});

            bytes memory zero = new bytes(32);

            Logic.AppData memory consumedAppData = Logic.AppData({
                discoveryPayload: new Logic.ExpirableBlob[](0),
                resourcePayload: new Logic.ExpirableBlob[](2),
                externalPayload: new Logic.ExpirableBlob[](1),
                applicationPayload: new Logic.ExpirableBlob[](0)
            });

            TxGen.ResourceAndAppData[] memory consumed = new TxGen.ResourceAndAppData[](1);

            Logic.ExpirableBlob[] memory resourceBlobs = new Logic.ExpirableBlob[](2);
            resourceBlobs[0] = Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: zero});
            resourceBlobs[1] = Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: zero});

            consumedAppData.externalPayload = externalBlobs;
            consumedAppData.resourcePayload = resourceBlobs;

            consumed[0] = TxGen.ResourceAndAppData({
                resource: TxGen.mockResource({nonce: nonce, logicRef: logicRef, labelRef: labelRef, quantity: 1}),
                appData: consumedAppData
            });
            consumed[0].appData.resourcePayload[0].blob = abi.encode(consumed[0].resource);

            Logic.AppData memory createdAppData = Logic.AppData({
                discoveryPayload: new Logic.ExpirableBlob[](0),
                resourcePayload: new Logic.ExpirableBlob[](0),
                externalPayload: new Logic.ExpirableBlob[](0),
                applicationPayload: new Logic.ExpirableBlob[](0)
            });

            TxGen.ResourceAndAppData[] memory created = new TxGen.ResourceAndAppData[](1);
            created[0] = TxGen.ResourceAndAppData({
                resource: TxGen.mockResource({
                    nonce: bytes32(uint256(nonce) + 1),
                    logicRef: logicRef,
                    labelRef: labelRef,
                    quantity: 1
                }),
                appData: createdAppData
            });

            TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
            resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
            txn = _mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH);
        }

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });
        _mockPa.execute(txn);
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

    function test_execute_reverts_on_incorrect_commitment_computation() public {
        bytes32 nonce = 0;
        bytes32 logicRef = bytes32(uint256(123));
        ForwarderExample fwd =
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: logicRef});

        bytes32 labelRef = sha256(abi.encode(address(fwd)));

        ForwarderCalldata memory call =
            ForwarderCalldata({untrustedForwarder: address(fwd), input: INPUT, output: EXPECTED_OUTPUT});

        Logic.ExpirableBlob[] memory externalBlobs = new Logic.ExpirableBlob[](1);
        externalBlobs[0] =
            Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: abi.encode(call)});

        bytes memory zero = new bytes(32);

        Logic.AppData memory consumedAppData = Logic.AppData({
            discoveryPayload: new Logic.ExpirableBlob[](0),
            resourcePayload: new Logic.ExpirableBlob[](0),
            externalPayload: new Logic.ExpirableBlob[](0),
            applicationPayload: new Logic.ExpirableBlob[](0)
        });

        TxGen.ResourceAndAppData[] memory consumed = new TxGen.ResourceAndAppData[](1);

        consumed[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({nonce: nonce, logicRef: logicRef, labelRef: labelRef, quantity: 1}),
            appData: consumedAppData
        });

        Logic.AppData memory createdAppData = Logic.AppData({
            discoveryPayload: new Logic.ExpirableBlob[](0),
            resourcePayload: new Logic.ExpirableBlob[](1),
            externalPayload: new Logic.ExpirableBlob[](1),
            applicationPayload: new Logic.ExpirableBlob[](0)
        });

        Logic.ExpirableBlob[] memory resourceBlobs = new Logic.ExpirableBlob[](1);
        resourceBlobs[0] = Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: zero});

        createdAppData.externalPayload = externalBlobs;
        createdAppData.resourcePayload = resourceBlobs;

        TxGen.ResourceAndAppData[] memory created = new TxGen.ResourceAndAppData[](1);
        created[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({
                nonce: bytes32(uint256(nonce) + 1),
                logicRef: logicRef,
                labelRef: labelRef,
                quantity: 1
            }),
            appData: createdAppData
        });

        Resource memory fakeCreated =
            TxGen.mockResource({nonce: nonce, logicRef: logicRef, labelRef: labelRef, quantity: 1});
        created[0].appData.resourcePayload[0].blob = abi.encode(fakeCreated);

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = _mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH);

        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.CalldataCarrierCommitmentMismatch.selector,
                fakeCreated.commitment(),
                txn.actions[0].complianceVerifierInputs[0].instance.created.commitment
            )
        );
        _mockPa.execute(txn);
    }

    function test_execute_reverts_on_incorrect_nullifier_computation_resource() public {
        bytes32 nonce = 0;
        bytes32 logicRef = bytes32(uint256(123));
        ForwarderExample fwd =
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: logicRef});

        bytes32 labelRef = sha256(abi.encode(address(fwd)));

        ForwarderCalldata memory call =
            ForwarderCalldata({untrustedForwarder: address(fwd), input: INPUT, output: EXPECTED_OUTPUT});

        Logic.ExpirableBlob[] memory externalBlobs = new Logic.ExpirableBlob[](1);
        externalBlobs[0] =
            Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: abi.encode(call)});

        bytes memory zero = new bytes(32);

        Logic.AppData memory consumedAppData = Logic.AppData({
            discoveryPayload: new Logic.ExpirableBlob[](0),
            resourcePayload: new Logic.ExpirableBlob[](2),
            externalPayload: new Logic.ExpirableBlob[](1),
            applicationPayload: new Logic.ExpirableBlob[](0)
        });

        TxGen.ResourceAndAppData[] memory consumed = new TxGen.ResourceAndAppData[](1);

        Logic.ExpirableBlob[] memory resourceBlobs = new Logic.ExpirableBlob[](2);
        resourceBlobs[0] = Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: zero});
        resourceBlobs[1] = Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: zero});

        consumedAppData.externalPayload = externalBlobs;
        consumedAppData.resourcePayload = resourceBlobs;

        consumed[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({nonce: nonce, logicRef: logicRef, labelRef: labelRef, quantity: 1}),
            appData: consumedAppData
        });
        Resource memory fakeConsumed = TxGen.mockResource({
            nonce: bytes32(uint256(nonce) + 1),
            logicRef: logicRef,
            labelRef: labelRef,
            quantity: 1
        });
        // Encode a wrong resource
        consumed[0].appData.resourcePayload[0].blob = abi.encode(fakeConsumed);

        Logic.AppData memory createdAppData = Logic.AppData({
            discoveryPayload: new Logic.ExpirableBlob[](0),
            resourcePayload: new Logic.ExpirableBlob[](0),
            externalPayload: new Logic.ExpirableBlob[](0),
            applicationPayload: new Logic.ExpirableBlob[](0)
        });

        TxGen.ResourceAndAppData[] memory created = new TxGen.ResourceAndAppData[](1);
        created[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({
                nonce: bytes32(uint256(nonce) + 1),
                logicRef: logicRef,
                labelRef: labelRef,
                quantity: 1
            }),
            appData: createdAppData
        });

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = _mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH);

        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.CalldataCarrierNullifierMismatch.selector,
                fakeConsumed.nullifier(0),
                txn.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier
            )
        );
        _mockPa.execute(txn);
    }

    function test_execute_reverts_on_incorrect_nullifier_computation_nonce() public {
        bytes32 nonce = 0;
        bytes32 logicRef = bytes32(uint256(123));
        ForwarderExample fwd =
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: logicRef});

        bytes32 labelRef = sha256(abi.encode(address(fwd)));

        ForwarderCalldata memory call =
            ForwarderCalldata({untrustedForwarder: address(fwd), input: INPUT, output: EXPECTED_OUTPUT});

        Logic.ExpirableBlob[] memory externalBlobs = new Logic.ExpirableBlob[](1);
        externalBlobs[0] =
            Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: abi.encode(call)});

        bytes memory zero = new bytes(32);

        Logic.AppData memory consumedAppData = Logic.AppData({
            discoveryPayload: new Logic.ExpirableBlob[](0),
            resourcePayload: new Logic.ExpirableBlob[](2),
            externalPayload: new Logic.ExpirableBlob[](1),
            applicationPayload: new Logic.ExpirableBlob[](0)
        });

        TxGen.ResourceAndAppData[] memory consumed = new TxGen.ResourceAndAppData[](1);

        Logic.ExpirableBlob[] memory resourceBlobs = new Logic.ExpirableBlob[](2);
        resourceBlobs[0] = Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: zero});
        resourceBlobs[1] = Logic.ExpirableBlob({deletionCriterion: Logic.DeletionCriterion.Never, blob: zero});

        consumedAppData.externalPayload = externalBlobs;
        consumedAppData.resourcePayload = resourceBlobs;

        consumed[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({nonce: nonce, logicRef: logicRef, labelRef: labelRef, quantity: 1}),
            appData: consumedAppData
        });
        consumed[0].appData.resourcePayload[0].blob = abi.encode(consumed[0].resource);
        // Encode a wrong nullifier key
        bytes memory nkey = hex"3f0000007f000000bf000000ff000000";
        consumed[0].appData.resourcePayload[1].blob = nkey;

        Logic.AppData memory createdAppData = Logic.AppData({
            discoveryPayload: new Logic.ExpirableBlob[](0),
            resourcePayload: new Logic.ExpirableBlob[](0),
            externalPayload: new Logic.ExpirableBlob[](0),
            applicationPayload: new Logic.ExpirableBlob[](0)
        });

        TxGen.ResourceAndAppData[] memory created = new TxGen.ResourceAndAppData[](1);
        created[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({
                nonce: bytes32(uint256(nonce) + 1),
                logicRef: logicRef,
                labelRef: labelRef,
                quantity: 1
            }),
            appData: createdAppData
        });

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = _mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH);

        vm.expectRevert(
            abi.encodeWithSelector(
                ProtocolAdapter.CalldataCarrierNullifierMismatch.selector,
                consumed[0].resource.nullifier(bytes32(nkey)),
                txn.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier
            )
        );
        _mockPa.execute(txn);
    }
}
