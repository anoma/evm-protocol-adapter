// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {ForwarderBase} from "../src/forwarders/ForwarderBase.sol";
import {Parameters} from "../src/libs/Parameters.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {ForwarderExample} from "./examples/Forwarder.e.sol";
import {
    ForwarderTargetExample, INPUT_VALUE, OUTPUT_VALUE, INPUT, EXPECTED_OUTPUT
} from "./examples/ForwarderTarget.e.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract ForwarderBaseTest is Test {
    address internal constant _EMERGENCY_CALLER = address(uint160(1));
    address internal constant _UNAUTHORIZED_CALLER = address(uint160(2));

    bytes32 internal constant _LOGIC_REF = bytes32(uint256(3));
    bytes32 internal constant _LABEL_REF = bytes32(uint256(4));

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    address internal _riscZeroAdmin;
    address internal _pa;
    bytes32 internal _label;
    bytes32 internal _logic;

    ForwarderExample internal _fwd;
    ForwarderTargetExample internal _tgt;

    function setUp() public virtual {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run();
        _riscZeroAdmin = _emergencyStop.owner();

        _pa = address(
            new ProtocolAdapter({
                riscZeroVerifierRouter: _router,
                commitmentTreeDepth: Parameters.COMMITMENT_TREE_DEPTH,
                actionTagTreeDepth: Parameters.ACTION_TAG_TREE_DEPTH
            })
        );
        bytes32[] memory logicRefs = new bytes32[](1);
        bytes32[] memory labelRefs = new bytes32[](1);
        logicRefs[0] = _LOGIC_REF;
        labelRefs[0] = _LABEL_REF;
        _fwd = new ForwarderExample({protocolAdapter: _pa, logicRefs: logicRefs, labelRefs: labelRefs});
        _label = sha256(abi.encode(address(_fwd)));
        _logic = bytes32(uint256(123));
        _tgt = ForwarderTargetExample(_fwd.TARGET());
    }

    function test_forwardCall_reverts_if_the_pa_is_not_the_caller() public {
        vm.prank(_UNAUTHORIZED_CALLER);
        vm.expectRevert(abi.encodeWithSelector(ForwarderBase.UnauthorizedCaller.selector, _pa, _UNAUTHORIZED_CALLER));
        _fwd.forwardCall(INPUT);
    }

    function test_forwardCall_forwards_calls_if_the_pa_is_the_caller() public {
        vm.prank(_pa);
        bytes memory output = _fwd.forwardCall(INPUT);
        assertEq(keccak256(output), keccak256(EXPECTED_OUTPUT));
    }

    function test_forwardCall_emits_the_CallForwarded_event() public {
        vm.prank(_pa);
        vm.expectEmit(address(_fwd));
        emit ForwarderExample.CallForwarded(INPUT, EXPECTED_OUTPUT);
        _fwd.forwardCall(INPUT);
    }

    function test_forwardCall_calls_the_function_in_the_target_contract() public {
        vm.prank(_pa);
        vm.expectEmit(address(_tgt));
        emit ForwarderTargetExample.CallReceived(INPUT_VALUE, OUTPUT_VALUE);
        _fwd.forwardCall(INPUT);
    }

    function test_authorizeCall_reverts_on_wrong_kind_logic() public {
        vm.expectRevert(abi.encodeWithSelector(ForwarderBase.UnauthorizedResourceLogicCaller.selector, 0));
        _fwd.authorizeCall(0, _LABEL_REF);
    }

    function test_authorizeCall_reverts_on_wrong_kind_label() public {
        vm.expectRevert(abi.encodeWithSelector(ForwarderBase.UnauthorizedResourceLabelCaller.selector, 0));
        _fwd.authorizeCall(_LOGIC_REF, 0);
    }

    function test_authorizeCall_succeeds_on_expected_kinds() public view {
        _fwd.authorizeCall(_logic, _label);
        _fwd.authorizeCall(_LOGIC_REF, _label);
        _fwd.authorizeCall(_LOGIC_REF, _LABEL_REF);
        _fwd.authorizeCall(_logic, _LABEL_REF);
    }

    function _stopProtocolAdapter() internal {
        vm.prank(_riscZeroAdmin);
        _emergencyStop.estop();
    }
}
