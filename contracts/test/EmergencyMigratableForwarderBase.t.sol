// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EmergencyMigratableForwarderBase} from "../src/forwarders/EmergencyMigratableForwarderBase.sol";
import {ForwarderBase} from "../src/forwarders/ForwarderBase.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {EmergencyMigratableForwarderExample} from "./examples/EmergencyMigratableForwarder.e.sol";
import {ForwarderExample} from "./examples/Forwarder.e.sol";
import {
    ForwarderTargetExample, INPUT_VALUE, OUTPUT_VALUE, INPUT, EXPECTED_OUTPUT
} from "./examples/ForwarderTarget.e.sol";

import {ForwarderBaseTest} from "./ForwarderBase.t.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract EmergencyMigratableForwarderBaseTest is ForwarderBaseTest {
    address internal constant _EMERGENCY_COMMITTEE = address(uint160(3));

    EmergencyMigratableForwarderExample internal _emrgFwd;

    function setUp() public override {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run();
        _riscZeroAdmin = _emergencyStop.owner();

        _pa = address(new ProtocolAdapter(_router));

        _emrgFwd = new EmergencyMigratableForwarderExample({
            protocolAdapter: _pa,
            emergencyCommittee: _EMERGENCY_COMMITTEE,
            calldataCarrierLogicRef: _CALLDATA_CARRIER_LOGIC_REF
        });

        _fwd = ForwarderExample(address(_emrgFwd));

        _tgt = ForwarderTargetExample(_fwd.TARGET());
    }

    function test_setEmergencyCaller_reverts_if_the_caller_is_not_the_emergency_committee() public {
        vm.prank(_UNAUTHORIZED_CALLER);
        vm.expectRevert(
            abi.encodeWithSelector(
                ForwarderBase.UnauthorizedCaller.selector, _EMERGENCY_COMMITTEE, _UNAUTHORIZED_CALLER
            ),
            address(_fwd)
        );
        _emrgFwd.setEmergencyCaller(_EMERGENCY_CALLER);
    }

    function test_setEmergencyCaller_reverts_if_the_new_emergency_caller_is_the_zero_address() public {
        vm.prank(_EMERGENCY_COMMITTEE);
        vm.expectRevert(ForwarderBase.ZeroNotAllowed.selector, address(_fwd));

        _emrgFwd.setEmergencyCaller(address(0));
    }

    function test_setEmergencyCaller_reverts_if_the_emergency_caller_has_already_been_set() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        vm.prank(_EMERGENCY_COMMITTEE);
        vm.expectRevert(
            abi.encodeWithSelector(
                EmergencyMigratableForwarderBase.EmergencyCallerAlreadySet.selector, _EMERGENCY_CALLER
            ),
            address(_fwd)
        );
        _emrgFwd.setEmergencyCaller(_UNAUTHORIZED_CALLER);
    }

    function test_setEmergencyCaller_reverts_if_the_pa_is_not_stopped() public {
        vm.prank(_EMERGENCY_COMMITTEE);
        vm.expectRevert(EmergencyMigratableForwarderBase.ProtocolAdapterNotStopped.selector, address(_fwd));
        _emrgFwd.setEmergencyCaller(_EMERGENCY_CALLER);
    }

    function test_setEmergencyCaller_sets_the_emergency_caller() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        assertEq(_emrgFwd.emergencyCaller(), _EMERGENCY_CALLER);
    }

    function test_forwardEmergencyCall_reverts_if_the_pa_is_stopped_but_the_emergency_caller_is_not_set() public {
        _stopProtocolAdapter();

        vm.expectRevert(EmergencyMigratableForwarderBase.EmergencyCallerNotSet.selector);
        _emrgFwd.forwardEmergencyCall({input: INPUT});
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
        _emrgFwd.forwardEmergencyCall({input: INPUT});
    }

    function test_forwardEmergencyCall_forwards_calls_if_the_pa_is_stopped_and_the_caller_is_the_emergency_caller()
        public
    {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        vm.prank(_EMERGENCY_CALLER);
        bytes memory output = _emrgFwd.forwardEmergencyCall({input: INPUT});
        assertEq(keccak256(output), keccak256(EXPECTED_OUTPUT));
    }

    function test_forwardEmergencyCall_emits_the_EmergencyCallForwarded_event() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        vm.prank(_EMERGENCY_CALLER);
        vm.expectEmit(address(_emrgFwd));
        emit ForwarderExample.EmergencyCallForwarded(INPUT, EXPECTED_OUTPUT);
        _emrgFwd.forwardEmergencyCall({input: INPUT});
    }

    function test_forwardEmergencyCall_calls_the_function_in_the_target_contract() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();
        vm.prank(_EMERGENCY_CALLER);

        vm.expectEmit(address(_tgt));
        emit ForwarderTargetExample.CallReceived(INPUT_VALUE, OUTPUT_VALUE);
        _emrgFwd.forwardEmergencyCall({input: INPUT});
    }

    function test_emergencyCaller_returns_the_emergency_caller_after_it_has_been_set() public {
        _stopProtocolAdapter();
        _setEmergencyCaller();

        assertEq(_emrgFwd.emergencyCaller(), _EMERGENCY_CALLER);
    }

    function test_emergencyCaller_returns_zero_if_the_emergency_caller_has_not_been_set() public view {
        assertEq(_emrgFwd.emergencyCaller(), address(0));
    }

    function _setEmergencyCaller() private {
        vm.prank(_EMERGENCY_COMMITTEE);
        _emrgFwd.setEmergencyCaller(_EMERGENCY_CALLER);
    }
}
