// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test} from "forge-std/Test.sol";

import {DeployRiscZeroVerifierRouterMock} from "../script/DeployRiscZeroVerifierRouterMock.s.sol";
import {Transaction} from "../src/Types.sol";

import {MockExamples} from "./mocks/Examples.sol";
import {ProtocolAdapterMock} from "./mocks/ProtocolAdapter.m.sol";

contract ProtocolAdapterMockTest is Test {
    using MockExamples for RiscZeroMockVerifier;

    uint256 internal _nonce;

    RiscZeroVerifierRouter internal _mockRouter;
    RiscZeroMockVerifier internal _mockVerifier;
    ProtocolAdapterMock internal _mockPa;

    function setUp() public {
        _nonce = 1;
        (_mockRouter, _mockVerifier) = (new DeployRiscZeroVerifierRouterMock()).run();

        _mockPa = new ProtocolAdapterMock(_mockRouter, 32, 4);
    }

    function test_execute_1_txn_with_1_action_and_0_cus() public {
        uint256 nActions = 1;
        uint256 nCUs = 0;

        MockExamples.ActionConfig[] memory actionConfigs = new MockExamples.ActionConfig[](nActions);
        for (uint256 i = 0; i < nActions; ++i) {
            actionConfigs[i] = MockExamples.ActionConfig({nCUs: nCUs});
        }

        (Transaction memory txn,) = _mockVerifier.transaction(_nonce, actionConfigs);
        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        // Fuzzing limits
        nActions = uint8(bound(nActions, 0, 5));
        nCUs = uint8(bound(nCUs, 0, 2 ** (_mockPa.actionTreeDepth() - 1)));

        MockExamples.ActionConfig[] memory actionConfigs = new MockExamples.ActionConfig[](nActions);
        for (uint256 i = 0; i < nActions; ++i) {
            actionConfigs[i] = MockExamples.ActionConfig({nCUs: nCUs});
        }

        (Transaction memory txn,) = _mockVerifier.transaction(_nonce, actionConfigs);
        _mockPa.execute(txn);
    }

    function test_execute_2_txns_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        // Fuzzing limits
        nActions = uint8(bound(nActions, 0, 5));
        nCUs = uint8(bound(nCUs, 0, 2 ** (_mockPa.actionTreeDepth() - 1)));

        MockExamples.ActionConfig[] memory actionConfigs = new MockExamples.ActionConfig[](nActions);
        for (uint256 i = 0; i < nActions; ++i) {
            actionConfigs[i] = MockExamples.ActionConfig({nCUs: nCUs});
        }

        (Transaction memory txn, uint256 updatedNonce) = _mockVerifier.transaction(_nonce, actionConfigs);
        _mockPa.execute(txn);

        (txn,) = _mockVerifier.transaction(updatedNonce, actionConfigs);
        _mockPa.execute(txn);
    }
}
