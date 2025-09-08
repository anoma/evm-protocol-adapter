// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {TransactionExample} from "./examples/Transaction.e.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract ProtocolAdapterTest is Test {
    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;

    function setUp() public {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run();

        _pa = new ProtocolAdapter(_router);
    }

    function test_constructor_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(ProtocolAdapter.RiscZeroVerifierStopped.selector);
        new ProtocolAdapter(_router);
    }

    function test_execute_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(_emergencyStop));
        _pa.execute(TransactionExample.transaction());
    }

    function test_execute() public {
        _pa.execute(TransactionExample.transaction());
    }
}
