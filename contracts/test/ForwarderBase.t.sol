// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {ForwarderBase} from "../src/forwarders/ForwarderBase.sol";
import {ComputableComponents} from "../src/libs/ComputableComponents.sol";
import {Parameters} from "../src/libs/Parameters.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {ForwarderMock} from "./mocks/Forwarder.m.sol";
import {ForwarderTarget} from "./mocks/ForwarderTarget.m.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract ForwarderBaseTest is Test {
    address internal constant _EMERGENCY_COMMITTEE = address(uint160(2));
    address internal constant _EMERGENCY_CALLER = address(uint160(3));
    address internal constant _UNAUTHORIZED_CALLER = address(uint160(4));

    bytes32 internal constant _CALLDATA_CARRIER_LOGIC_REF = bytes32(type(uint256).max);

    uint256 internal constant _INPUT_VALUE = 123;
    uint256 internal constant _OUTPUT_VALUE = _INPUT_VALUE + 1;
    bytes internal constant _INPUT = abi.encodeCall(ForwarderTarget.increment, _INPUT_VALUE);
    bytes internal constant _EXPECTED_OUTPUT = abi.encode(_OUTPUT_VALUE);

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    address internal _riscZeroAdmin;
    address internal _pa;

    ForwarderMock internal _fwd;
    ForwarderTarget internal _tgt;

    function setUp() public {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run();
        _riscZeroAdmin = _emergencyStop.owner();

        _pa = address(
            new ProtocolAdapter({
                riscZeroVerifierRouter: _router,
                commitmentTreeDepth: Parameters.COMMITMENT_TREE_DEPTH,
                actionTagTreeDepth: Parameters.ACTION_TAG_TREE_DEPTH
            })
        );

        _fwd = new ForwarderMock({
            protocolAdapter: _pa,
            emergencyCommittee: _EMERGENCY_COMMITTEE,
            calldataCarrierLogicRef: _CALLDATA_CARRIER_LOGIC_REF
        });
        _tgt = ForwarderTarget(_fwd.TARGET());
    }

    function test_forwardCall_reverts_if_the_pa_is_not_the_caller() public {
        vm.prank(_UNAUTHORIZED_CALLER);
        vm.expectRevert(abi.encodeWithSelector(ForwarderBase.UnauthorizedCaller.selector, _pa, _UNAUTHORIZED_CALLER));
        _fwd.forwardCall({input: _INPUT});
    }

    function test_forwardCall_forwards_calls_if_the_pa_is_the_caller() public {
        vm.prank(_pa);
        bytes memory output = _fwd.forwardCall({input: _INPUT});
        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT));
    }

    function test_forwardCall_emits_the_CallForwarded_event() public {
        vm.prank(_pa);

        vm.expectEmit(address(_fwd));
        emit ForwarderMock.CallForwarded(_INPUT, _EXPECTED_OUTPUT);
        _fwd.forwardCall({input: _INPUT});
    }

    function test_forwardCall_calls_the_function_in_the_target_contract() public {
        vm.prank(_pa);

        vm.expectEmit(address(_tgt));
        emit ForwarderTarget.CallReceived(_INPUT_VALUE, _OUTPUT_VALUE);
        _fwd.forwardCall({input: _INPUT});
    }

    function test_setEmergencyCaller_reverts_if_the_caller_is_not_the_emergency_committee() public {
        vm.prank(_UNAUTHORIZED_CALLER);
        vm.expectRevert(
            abi.encodeWithSelector(
                ForwarderBase.UnauthorizedCaller.selector, _EMERGENCY_COMMITTEE, _UNAUTHORIZED_CALLER
            ),
            address(_fwd)
        );
        _fwd.setEmergencyCaller(_EMERGENCY_CALLER);
    }

    function test_setEmergencyCaller_reverts_if_the_new_emergency_caller_is_the_zero_address() public {
        vm.prank(_EMERGENCY_COMMITTEE);
        vm.expectRevert(ForwarderBase.ZeroNotAllowed.selector, address(_fwd));

        _fwd.setEmergencyCaller(address(0));
    }

    function test_setEmergencyCaller_reverts_if_the_emergency_caller_has_already_been_set() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        vm.prank(_EMERGENCY_COMMITTEE);
        vm.expectRevert(
            abi.encodeWithSelector(ForwarderBase.EmergencyCallerAlreadySet.selector, _EMERGENCY_CALLER), address(_fwd)
        );
        _fwd.setEmergencyCaller(_UNAUTHORIZED_CALLER);
    }

    function test_setEmergencyCaller_reverts_if_the_pa_is_not_stopped() public {
        vm.prank(_EMERGENCY_COMMITTEE);
        vm.expectRevert(ForwarderBase.ProtocolAdapterNotStopped.selector, address(_fwd));
        _fwd.setEmergencyCaller(_EMERGENCY_CALLER);
    }

    function test_setEmergencyCaller_sets_the_emergency_caller() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        assertEq(_fwd.emergencyCaller(), _EMERGENCY_CALLER);
    }

    function test_forwardEmergencyCall_reverts_if_the_pa_is_stopped_but_the_emergency_caller_is_not_set() public {
        _stopProtocolAdapter();

        vm.expectRevert(ForwarderBase.EmergencyCallerNotSet.selector);
        _fwd.forwardEmergencyCall({input: _INPUT});
    }

    function test_forwardEmergencyCall_reverts_if_the_pa_is_stopped_but_the_caller_is_not_the_emergency_caller()
        public
    {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        vm.prank(_UNAUTHORIZED_CALLER);
        vm.expectRevert(
            abi.encodeWithSelector(ForwarderBase.UnauthorizedCaller.selector, _EMERGENCY_CALLER, _UNAUTHORIZED_CALLER)
        );
        _fwd.forwardEmergencyCall({input: _INPUT});
    }

    function test_forwardEmergencyCall_forwards_calls_if_the_pa_is_stopped_and_the_caller_is_the_emergency_caller()
        public
    {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        vm.prank(_EMERGENCY_CALLER);
        bytes memory output = _fwd.forwardEmergencyCall({input: _INPUT});
        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT));
    }

    function test_forwardEmergencyCall_emits_the_EmergencyCallForwarded_event() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        vm.prank(_EMERGENCY_CALLER);
        vm.expectEmit(address(_fwd));
        emit ForwarderMock.EmergencyCallForwarded(_INPUT, _EXPECTED_OUTPUT);
        _fwd.forwardEmergencyCall({input: _INPUT});
    }

    function test_forwardEmergencyCall_calls_the_function_in_the_target_contract() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();
        vm.prank(_EMERGENCY_CALLER);

        vm.expectEmit(address(_tgt));
        emit ForwarderTarget.CallReceived(_INPUT_VALUE, _OUTPUT_VALUE);
        _fwd.forwardEmergencyCall({input: _INPUT});
    }

    function test_emergencyCaller_returns_the_emergency_caller_after_it_has_been_set() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        assertEq(_fwd.emergencyCaller(), _EMERGENCY_CALLER);
    }

    function test_emergencyCaller_returns_zero_if_the_emergency_caller_has_not_been_set() public view {
        assertEq(_fwd.emergencyCaller(), address(0));
    }

    function test_calldataCarrierResourceKind_returns_the_expected_kind() public view {
        bytes32 expectedKind = ComputableComponents.kind({
            logicRef: _CALLDATA_CARRIER_LOGIC_REF,
            labelRef: sha256(abi.encode(address(_fwd)))
        });
        assertEq(_fwd.calldataCarrierResourceKind(), expectedKind);
    }

    function _stopProtocolAdapter() private {
        vm.prank(_riscZeroAdmin);
        _emergencyStop.estop();
    }

    function _setEmergencyCaller() private {
        vm.prank(_EMERGENCY_COMMITTEE);
        _fwd.setEmergencyCaller(_EMERGENCY_CALLER);
    }
}
