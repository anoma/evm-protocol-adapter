// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IPermit2} from "@permit2/src/interfaces/IPermit2.sol";

import {Vm} from "forge-std/Test.sol";

import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";
import {Transaction} from "../../src/Types.sol";
import {Parsing} from "../libs/Parsing.sol";
import {ERC20ForwarderTest} from "./ERC20Forwarder.t.sol";

contract ERC20ForwarderE2ETest is ERC20ForwarderTest {
    using Parsing for Vm;

    function setUp() public override {
        vm.selectFork(vm.createFork("sepolia"));
        super.setUp();
    }

    function test_execute_mint_transfer_burn() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        uint256 aliceBalanceBefore = _erc20.balanceOf(_alice);
        uint256 fwdBalanceBefore = _erc20.balanceOf(address(_fwd));

        // Mint
        {
            Transaction memory mintTx = vm.parseTransaction("/test/examples/transactions/mint.bin");
            ProtocolAdapter(_pa).execute(mintTx);

            assertEq(_erc20.balanceOf(_alice), aliceBalanceBefore - _TRANSFER_AMOUNT);
            assertEq(_erc20.balanceOf(address(_fwd)), fwdBalanceBefore + _TRANSFER_AMOUNT);
        }

        // Transfer
        {
            Transaction memory transferTx = vm.parseTransaction("/test/examples/transactions/transfer.bin");
            ProtocolAdapter(_pa).execute(transferTx);

            assertEq(_erc20.balanceOf(_alice), aliceBalanceBefore - _TRANSFER_AMOUNT);
            assertEq(_erc20.balanceOf(address(_fwd)), fwdBalanceBefore + _TRANSFER_AMOUNT);
        }

        // Burn
        {
            Transaction memory burnTx = vm.parseTransaction("/test/examples/transactions/burn.bin");
            ProtocolAdapter(_pa).execute(burnTx);

            assertEq(_erc20.balanceOf(_alice), aliceBalanceBefore);
            assertEq(_erc20.balanceOf(address(_fwd)), fwdBalanceBefore);
        }
    }

    function _permit2Contract() internal pure override returns (IPermit2 permit2) {
        permit2 = IPermit2(address(0x000000000022D473030F116dDEE9F6B43aC78BA3));
    }
}
