// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroGroth16Verifier} from "@risc0-ethereum/groth16/RiscZeroGroth16Verifier.sol";
import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {ForwarderBase} from "../../../src/forwarders/bases/ForwarderBase.sol";
import {ProtocolAdapter} from "../../../src/ProtocolAdapter.sol";

import {ForwarderExample} from "../../examples/Forwarder.e.sol";
import {
    ForwarderTargetExample,
    INPUT_VALUE,
    OUTPUT_VALUE,
    INPUT,
    EXPECTED_OUTPUT
} from "../../examples/ForwarderTarget.e.sol";
import {DeployRiscZeroContracts} from "../../script/DeployRiscZeroContracts.s.sol";

contract ForwarderBaseTest is Test {
    address internal constant _EMERGENCY_CALLER = address(uint160(1));
    address internal constant _UNAUTHORIZED_CALLER = address(uint160(2));
    address internal constant _PA_OWNER = address(uint160(3));

    bytes32 internal constant _CALLDATA_CARRIER_LOGIC_REF = bytes32(type(uint256).max);

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    address internal _riscZeroAdmin;

    address internal _pa;

    ForwarderExample internal _fwd;
    ForwarderTargetExample internal _tgt;

    function setUp() public virtual {
        RiscZeroGroth16Verifier verifier;
        (_router, _emergencyStop, verifier) = new DeployRiscZeroContracts().run();

        _riscZeroAdmin = _emergencyStop.owner();

        _pa = address(new ProtocolAdapter(_router, verifier.SELECTOR(), _PA_OWNER));

        _fwd = new ForwarderExample({protocolAdapter: _pa, calldataCarrierLogicRef: _CALLDATA_CARRIER_LOGIC_REF});
        _tgt = ForwarderTargetExample(_fwd.TARGET());
    }

    function test_forwardCall_reverts_if_the_pa_is_not_the_caller() public {
        vm.prank(_UNAUTHORIZED_CALLER);
        vm.expectRevert(abi.encodeWithSelector(ForwarderBase.UnauthorizedCaller.selector, _pa, _UNAUTHORIZED_CALLER));
        _fwd.forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: INPUT});
    }

    function test_forwardCall_reverts_if_the_logic_ref_mismatches() public {
        bytes32 wrongLogicRef = bytes32(uint256(123));

        assertNotEq(wrongLogicRef, _CALLDATA_CARRIER_LOGIC_REF);

        vm.prank(_pa);
        vm.expectRevert(
            abi.encodeWithSelector(
                ForwarderBase.UnauthorizedLogicRef.selector, _CALLDATA_CARRIER_LOGIC_REF, wrongLogicRef
            )
        );
        _fwd.forwardCall({logicRef: wrongLogicRef, input: INPUT});
    }

    function test_forwardCall_forwards_calls_if_the_pa_is_the_caller() public {
        vm.prank(_pa);
        bytes memory output = _fwd.forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: INPUT});
        assertEq(keccak256(output), keccak256(EXPECTED_OUTPUT));
    }

    function test_forwardCall_emits_the_CallForwarded_event() public {
        vm.prank(_pa);

        vm.expectEmit(address(_fwd));
        emit ForwarderExample.CallForwarded(INPUT, EXPECTED_OUTPUT);
        _fwd.forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: INPUT});
    }

    function test_forwardCall_calls_the_function_in_the_target_contract() public {
        vm.prank(_pa);

        vm.expectEmit(address(_tgt));
        emit ForwarderTargetExample.CallReceived(INPUT_VALUE, OUTPUT_VALUE);
        _fwd.forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: INPUT});
    }

    function _stopProtocolAdapter() internal {
        vm.prank(_riscZeroAdmin);
        _emergencyStop.estop();
    }
}
