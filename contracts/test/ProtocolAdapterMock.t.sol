// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test} from "forge-std/Test.sol";

import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {MerkleTree} from "../src/libs/MerkleTree.sol";
import {TagLookup} from "../src/libs/TagLookup.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Logic} from "../src/proving/Logic.sol";
import {CommitmentAccumulator} from "../src/state/CommitmentAccumulator.sol";
import {NullifierSet} from "../src/state/NullifierSet.sol";
import {Transaction, ResourceForwarderCalldataPair, ForwarderCalldata} from "../src/Types.sol";

import {ExampleGen} from "./mocks/ExampleGen.sol";
import {ForwarderMock} from "./mocks/Forwarder.m.sol";
import {INPUT, EXPECTED_OUTPUT} from "./mocks/ForwarderTarget.m.sol";
import {ProtocolAdapterMock} from "./mocks/ProtocolAdapter.m.sol";
import {DeployRiscZeroContractsMock} from "./script/DeployRiscZeroContractsMock.s.sol";

contract ProtocolAdapterMockTest is Test {
    using MerkleTree for bytes32[];
    using ExampleGen for RiscZeroMockVerifier;
    using ExampleGen for Transaction;

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
            configs: ExampleGen.generateActionConfigs({nActions: 1, nCUs: 1}),
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });

        bytes32[] memory cms = new bytes32[](1);
        cms[0] = txn.actions[0].complianceVerifierInputs[0].instance.created.commitment;

        bytes32 expectedRoot = cms.computeRoot(_TEST_COMMITMENT_TREE_DEPTH);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.TransactionExecuted({id: 0, transaction: txn, newRoot: expectedRoot});
        _mockPa.execute(txn);
    }

    function test_execute_emits_the_ForwarderCallExecuted_event() public {
        uint256 nonce = 0;

        bytes32 logicRef = bytes32(uint256(123));
        ForwarderMock fwd = new ForwarderMock({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: logicRef});

        bytes32 labelRef = sha256(abi.encode(address(fwd)));

        Transaction memory txn;
        {
            ForwarderCalldata memory call =
                ForwarderCalldata({untrustedForwarder: address(fwd), input: INPUT, output: EXPECTED_OUTPUT});

            Logic.ExpirableBlob[] memory blobs = new Logic.ExpirableBlob[](1);
            blobs[0] = Logic.ExpirableBlob({
                deletionCriterion: Logic.DeletionCriterion.Never,
                blob: abi.encode(call.untrustedForwarder, call.input, call.output)
            });

            ExampleGen.ResourceAndAppData[] memory consumed = new ExampleGen.ResourceAndAppData[](1);
            ExampleGen.ResourceAndAppData[] memory created = new ExampleGen.ResourceAndAppData[](1);
            consumed[0] = ExampleGen.ResourceAndAppData({
                resource: ExampleGen.mockResource({nonce: nonce++, logicRef: logicRef, labelRef: labelRef, quantity: 1}),
                appData: blobs
            });
            created[0] = ExampleGen.ResourceAndAppData({
                resource: ExampleGen.mockResource({nonce: nonce++, logicRef: logicRef, labelRef: labelRef, quantity: 1}),
                appData: blobs
            });

            ExampleGen.ActionResources[] memory resourceLists = new ExampleGen.ActionResources[](1);
            resourceLists[0] = ExampleGen.ActionResources({consumed: consumed, created: created});
            txn = _mockVerifier.transaction(resourceLists, _TEST_COMMITMENT_TREE_DEPTH);

            ResourceForwarderCalldataPair[] memory pairs = new ResourceForwarderCalldataPair[](1);
            pairs[0] = ResourceForwarderCalldataPair({
                carrier: created[0].resource,
                call: ForwarderCalldata({untrustedForwarder: address(fwd), input: INPUT, output: EXPECTED_OUTPUT})
            });

            txn.actions[0].resourceCalldataPairs = pairs;
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
            configs: ExampleGen.generateActionConfigs({nActions: 1, nCUs: 0}),
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });
        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_2_action_with_1_and_0_cus() public {
        ExampleGen.ActionConfig[] memory configs = new ExampleGen.ActionConfig[](2);
        configs[0] = ExampleGen.ActionConfig({nCUs: 1});
        configs[1] = ExampleGen.ActionConfig({nCUs: 0});

        (Transaction memory txn,) = _mockVerifier.transaction({
            nonce: 0,
            configs: ExampleGen.generateActionConfigs({nActions: 1, nCUs: 1}),
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });
        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({
            nActions: uint8(bound(nActions, 0, 5)),
            nCUs: uint8(bound(nCUs, 0, 2 ** (_mockPa.actionTreeDepth() - 1)))
        });

        (Transaction memory txn,) =
            _mockVerifier.transaction({nonce: 0, configs: configs, commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH});
        _mockPa.execute(txn);
    }

    function test_execute_2_txns_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({
            nActions: uint8(bound(nActions, 0, 5)),
            nCUs: uint8(bound(nCUs, 0, 2 ** (_mockPa.actionTreeDepth() - 1)))
        });

        (Transaction memory txn, uint256 updatedNonce) =
            _mockVerifier.transaction({nonce: 0, configs: configs, commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH});
        _mockPa.execute(txn);

        (txn,) = _mockVerifier.transaction({
            nonce: updatedNonce,
            configs: configs,
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });
        _mockPa.execute(txn);
    }

    function test_verify_reverts_on_pre_existing_nullifier() public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({nActions: 1, nCUs: 1});

        (Transaction memory tx1, uint256 updatedNonce) =
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
        _mockPa.verify(tx2);
    }

    function test_verify_reverts_on_pre_existing_commitment() public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({nActions: 1, nCUs: 1});

        (Transaction memory tx1, uint256 updatedNonce) =
            _mockVerifier.transaction({nonce: 0, configs: configs, commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH});
        bytes32 preExistingCm = tx1.actions[0].complianceVerifierInputs[0].instance.created.commitment;
        _mockPa.execute(tx1);

        (Transaction memory tx2,) = _mockVerifier.transaction({
            nonce: updatedNonce,
            configs: configs,
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });
        tx2.actions[0].complianceVerifierInputs[0].instance.created.commitment = preExistingCm;
        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.PreExistingCommitment.selector, preExistingCm),
            address(_mockPa)
        );
        _mockPa.verify(tx2);
    }

    function test_verify_reverts_on_duplicated_nullifier() public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({nActions: 1, nCUs: 2});

        (Transaction memory txn,) =
            _mockVerifier.transaction({nonce: 0, configs: configs, commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH});
        bytes32 duplicatedNf = txn.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;
        txn.actions[0].complianceVerifierInputs[1].instance.consumed.nullifier = duplicatedNf;

        vm.expectRevert(abi.encodeWithSelector(TagLookup.NullifierDuplicated.selector, duplicatedNf), address(_mockPa));
        _mockPa.verify(txn);
    }

    function test_verify_reverts_on_duplicated_commitment() public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({nActions: 1, nCUs: 2});

        (Transaction memory txn,) =
            _mockVerifier.transaction({nonce: 0, configs: configs, commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH});
        bytes32 duplicatedCm = txn.actions[0].complianceVerifierInputs[0].instance.created.commitment;
        txn.actions[0].complianceVerifierInputs[1].instance.created.commitment = duplicatedCm;

        vm.expectRevert(abi.encodeWithSelector(TagLookup.CommitmentDuplicated.selector, duplicatedCm), address(_mockPa));
        _mockPa.verify(txn);
    }

    function test_verify_reverts_on_wrong_isConsumed_value_in_consumed_resource_logic_proof() public {
        (Transaction memory txn,) = _mockVerifier.transaction({
            nonce: 0,
            configs: ExampleGen.generateActionConfigs({nActions: 2, nCUs: 2}),
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });

        bool expected = true;
        txn.actions[1].logicVerifierInputs[0].instance.isConsumed = !expected;

        vm.expectRevert(
            abi.encodeWithSelector(ProtocolAdapter.ResourceLifecycleMismatch.selector, expected), (address(_mockPa))
        );
        _mockPa.verify(txn);
    }

    function test_verify_reverts_on_wrong_isConsumed_value_in_created_resource_logic_proof() public {
        (Transaction memory txn,) = _mockVerifier.transaction({
            nonce: 0,
            configs: ExampleGen.generateActionConfigs({nActions: 2, nCUs: 2}),
            commitmentTreeDepth: _TEST_COMMITMENT_TREE_DEPTH
        });

        bool expected = false;
        txn.actions[1].logicVerifierInputs[1].instance.isConsumed = !expected;

        vm.expectRevert(
            abi.encodeWithSelector(ProtocolAdapter.ResourceLifecycleMismatch.selector, expected), (address(_mockPa))
        );
        _mockPa.verify(txn);
    }
}
*/
