// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {MerkleTree} from "../src/libs/MerkleTree.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Logic} from "../src/proving/Logic.sol";
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

        _mockPa = new ProtocolAdapter(_router, _mockVerifier.SELECTOR());

        _fwd = address(
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: _CARRIER_LOGIC_REF})
        );

        _fwdList = new address[](1);
        _fwdList[0] = _fwd;

        _carrierLabelRef = sha256(abi.encode(_fwd));
    }

    function testFuzz_execute_emits_the_TransactionExecuted_event(uint8 nActions, uint8 nCUs) public {
        nActions = uint8(bound(nActions, 0, 10));
        nCUs = uint8(bound(nCUs, 0, 10));

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({nActions: nActions, nCUs: nCUs})
        });

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.TransactionExecuted({
            tags: txn.actions.collectTags(),
            logicRefs: txn.actions.collectLogicRefs()
        });
        _mockPa.execute(txn);
    }

    function testFuzz_execute_emits_ActionExecuted_events_for_each_action(uint8 nActions, uint8 nCUs) public {
        nActions = uint8(bound(nActions, 0, 10));
        nCUs = uint8(bound(nCUs, 0, 10));

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({nActions: nActions, nCUs: nCUs})
        });

        for (uint256 i = 0; i < nActions; ++i) {
            vm.expectEmit(address(_mockPa));
            emit IProtocolAdapter.ActionExecuted({
                actionTreeRoot: txn.actions[i].collectTags().computeRoot(),
                tagsCount: nCUs * 2
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
        configs[0] = TxGen.ActionConfig({nCUs: 1});
        configs[1] = TxGen.ActionConfig({nCUs: 0});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        _mockPa.execute(txn);
    }

    function test_execute_2_txns_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        _mockPa.execute(txn);

        (txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: updatedNonce, configs: configs});
        _mockPa.execute(txn);
    }

    function test_execute_reverts_on_pre_existing_nullifier() public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({nActions: 1, nCUs: 1});

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
