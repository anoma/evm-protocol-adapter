// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test} from "forge-std/Test.sol";

import {DeployRiscZeroVerifierRouterMock} from "../script/DeployRiscZeroVerifierRouterMock.s.sol";

import {TagLookup} from "../src/libs/TagLookup.sol";
import {CommitmentAccumulator} from "../src/state/CommitmentAccumulator.sol";
import {NullifierSet} from "../src/state/NullifierSet.sol";
import {Transaction} from "../src/Types.sol";

import {ExampleGen} from "./mocks/ExampleGen.sol";
import {ProtocolAdapterMock} from "./mocks/ProtocolAdapter.m.sol";

contract ProtocolAdapterMockTest is Test {
    using ExampleGen for RiscZeroMockVerifier;
    using ExampleGen for Transaction;

    RiscZeroVerifierRouter internal _mockRouter;
    RiscZeroMockVerifier internal _mockVerifier;
    ProtocolAdapterMock internal _mockPa;

    function setUp() public {
        (_mockRouter, _mockVerifier) = (new DeployRiscZeroVerifierRouterMock()).run();

        _mockPa = new ProtocolAdapterMock(_mockRouter, 32, 4);
    }

    function test_execute_1_txn_with_1_action_and_0_cus() public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({nActions: 1, nCUs: 0});

        (Transaction memory txn,) = _mockVerifier.transaction(0, configs);
        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_2_action_with_1_and_0_cus() public {
        ExampleGen.ActionConfig[] memory configs = new ExampleGen.ActionConfig[](2);
        configs[0] = ExampleGen.ActionConfig({nCUs: 1});
        configs[1] = ExampleGen.ActionConfig({nCUs: 0});

        (Transaction memory txn,) = _mockVerifier.transaction(0, configs);
        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({
            nActions: uint8(bound(nActions, 0, 5)),
            nCUs: uint8(bound(nCUs, 0, 2 ** (_mockPa.actionTreeDepth() - 1)))
        });

        (Transaction memory txn,) = _mockVerifier.transaction(0, configs);
        _mockPa.execute(txn);
    }

    function test_execute_2_txns_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({
            nActions: uint8(bound(nActions, 0, 5)),
            nCUs: uint8(bound(nCUs, 0, 2 ** (_mockPa.actionTreeDepth() - 1)))
        });

        (Transaction memory txn, uint256 updatedNonce) = _mockVerifier.transaction({nonce: 0, configs: configs});
        _mockPa.execute(txn);

        (txn,) = _mockVerifier.transaction(updatedNonce, configs);
        _mockPa.execute(txn);
    }

    function test_verify_reverts_on_pre_existing_nullifier() public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({nActions: 1, nCUs: 1});

        (Transaction memory tx1, uint256 updatedNonce) = _mockVerifier.transaction({nonce: 0, configs: configs});
        bytes32 preExistingNf = tx1.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;
        _mockPa.execute(tx1);

        (Transaction memory tx2,) = _mockVerifier.transaction({nonce: updatedNonce, configs: configs});
        tx2.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier = preExistingNf;
        vm.expectRevert(
            abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, preExistingNf), address(_mockPa)
        );
        _mockPa.verify(tx2);
    }

    function test_verify_reverts_on_pre_existing_commitment() public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({nActions: 1, nCUs: 1});

        (Transaction memory tx1, uint256 updatedNonce) = _mockVerifier.transaction({nonce: 0, configs: configs});
        bytes32 preExistingCm = tx1.actions[0].complianceVerifierInputs[0].instance.created.commitment;
        _mockPa.execute(tx1);

        (Transaction memory tx2,) = _mockVerifier.transaction({nonce: updatedNonce, configs: configs});
        tx2.actions[0].complianceVerifierInputs[0].instance.created.commitment = preExistingCm;
        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.PreExistingCommitment.selector, preExistingCm),
            address(_mockPa)
        );
        _mockPa.verify(tx2);
    }

    function test_verify_reverts_on_duplicated_nullifier() public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({nActions: 1, nCUs: 2});

        (Transaction memory txn,) = _mockVerifier.transaction({nonce: 0, configs: configs});
        bytes32 duplicatedNf = txn.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;
        txn.actions[0].complianceVerifierInputs[1].instance.consumed.nullifier = duplicatedNf;

        vm.expectRevert(abi.encodeWithSelector(TagLookup.NullifierDuplicated.selector, duplicatedNf), address(_mockPa));
        _mockPa.verify(txn);
    }

    function test_verify_reverts_on_duplicated_commitment() public {
        ExampleGen.ActionConfig[] memory configs = ExampleGen.generateActionConfigs({nActions: 1, nCUs: 2});

        (Transaction memory txn,) = _mockVerifier.transaction({nonce: 0, configs: configs});
        bytes32 duplicatedCm = txn.actions[0].complianceVerifierInputs[0].instance.created.commitment;
        txn.actions[0].complianceVerifierInputs[1].instance.created.commitment = duplicatedCm;

        vm.expectRevert(abi.encodeWithSelector(TagLookup.CommitmentDuplicated.selector, duplicatedCm), address(_mockPa));
        _mockPa.verify(txn);
    }
}
