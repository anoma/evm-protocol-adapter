// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";

import {ERC20ForwarderV2} from "../../src/forwarders/drafts/ERC20ForwarderV2.sol";
import {ERC20Forwarder} from "../../src/forwarders/ERC20Forwarder.sol";
import {NullifierSet} from "../../src/state/NullifierSet.sol";
import {Transaction} from "../../src/Types.sol";

import {TransactionExample} from "../examples/transactions/Transaction.e.sol";

import {ERC20ForwarderTest} from "./ERC20Forwarder.t.sol";

contract ERC20ForwarderV2Test is ERC20ForwarderTest {
    address internal constant _PA_V2 = address(uint160(2));

    ERC20Forwarder internal _fwdV1;
    ERC20ForwarderV2 internal _fwdV2;

    function setUp() public override {
        super.setUp();

        _fwdV1 = _fwd;

        _fwdV2 = new ERC20ForwarderV2({
            protocolAdapter: _PA_V2,
            calldataCarrierLogicRef: _CALLDATA_CARRIER_LOGIC_REF,
            emergencyCommittee: _EMERGENCY_COMMITTEE,
            protocolAdapterV1: address(_pa),
            erc20ForwarderV1: address(_fwdV1)
        });
    }

    function test_migrate_reverts_if_the_resource_to_migrate_has_already_been_consumed() public {
        Transaction memory txn = TransactionExample.transaction();
        bytes32 nullifier = txn.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;

        assertEq(_pa.contains(nullifier), false);
        _pa.execute(txn);
        assertEq(_pa.contains(nullifier), true);

        // Stop the PA
        vm.prank(address(_pa.owner()));
        _pa.emergencyStop();

        // Set the ERC20ForwarderV2 as the emergency caller of ERC20ForwarderV1.
        vm.prank(_EMERGENCY_COMMITTEE);
        _fwdV1.setEmergencyCaller(address(_fwdV2));

        bytes memory input = abi.encode(ERC20ForwarderV2.CallTypeV2.Migrate, address(0), uint128(0), nullifier);

        vm.prank(_PA_V2);
        vm.expectRevert(
            abi.encodeWithSelector(ERC20ForwarderV2.NullifierAlreadyMigrated.selector, nullifier), address(_fwdV2)
        );
        _fwdV2.forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_migrate_reverts_if_the_resource_has_already_been_migrated() public {
        // Fund the forwarder v1
        _erc20.mint({to: address(_fwdV1), value: _TRANSFER_AMOUNT});

        // Stop the PA
        vm.prank(address(_pa.owner()));
        _pa.emergencyStop();

        // Set the ERC20ForwarderV2 as the emergency caller of ERC20ForwarderV1.
        vm.prank(_EMERGENCY_COMMITTEE);
        _fwdV1.setEmergencyCaller(address(_fwdV2));

        address token = address(_erc20);
        uint128 amount = _TRANSFER_AMOUNT;
        bytes32 nullifier = bytes32(type(uint256).max);

        bytes memory input = abi.encode(ERC20ForwarderV2.CallTypeV2.Migrate, token, amount, nullifier);

        vm.startPrank(_PA_V2);
        _fwdV2.forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});

        vm.expectRevert(abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, nullifier), address(_fwdV2));
        _fwdV2.forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_migrate_transfers_funds_from_V1_to_V2_forwarder() public {
        // Fund the forwarder v1
        _erc20.mint({to: address(_fwdV1), value: _TRANSFER_AMOUNT});

        assertEq(_erc20.balanceOf(address(_fwdV1)), _TRANSFER_AMOUNT);
        assertEq(_erc20.balanceOf(address(_fwdV2)), 0);

        // Stop the PA
        vm.prank(address(_pa.owner()));
        _pa.emergencyStop();

        // Set the ERC20ForwarderV2 as the emergency caller of ERC20ForwarderV1.
        vm.prank(_EMERGENCY_COMMITTEE);
        _fwdV1.setEmergencyCaller(address(_fwdV2));

        address token = address(_erc20);
        uint128 amount = _TRANSFER_AMOUNT;
        bytes32 nullifier = bytes32(type(uint256).max);

        bytes memory input = abi.encode(ERC20ForwarderV2.CallTypeV2.Migrate, token, amount, nullifier);

        vm.prank(_PA_V2);

        vm.expectEmit(address(_fwdV1));
        emit ERC20Forwarder.Unwrapped({token: address(_erc20), to: address(_fwdV2), amount: _TRANSFER_AMOUNT});

        vm.expectEmit(address(_erc20));
        emit IERC20.Transfer({from: address(_fwdV1), to: address(_fwdV2), value: _TRANSFER_AMOUNT});

        vm.expectEmit(address(_fwdV2));
        emit ERC20Forwarder.Wrapped({token: address(_erc20), from: address(_fwdV1), amount: _TRANSFER_AMOUNT});

        _fwdV2.forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});

        assertEq(_erc20.balanceOf(address(_fwdV1)), 0);
        assertEq(_erc20.balanceOf(address(_fwdV2)), _TRANSFER_AMOUNT);
    }
}
