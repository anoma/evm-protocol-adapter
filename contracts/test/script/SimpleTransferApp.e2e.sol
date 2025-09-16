// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {Permit2Lib} from "@permit2/src/libraries/Permit2Lib.sol";
import {PermitHash} from "@permit2/src/libraries/PermitHash.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Script} from "forge-std/Script.sol";
import {Vm} from "forge-std/Vm.sol";

import {ERC20Forwarder} from "../../src/forwarders/ERC20Forwarder.sol";
import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";
import {Transaction} from "../../src/Types.sol";
import {ERC20Example} from "../../test/examples/ERC20.e.sol";
import {Parsing} from "../libs/Parsing.sol";
import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

contract MintTransferBurnTransaction is Script {
    using Parsing for Vm;

    // Get funds on https://faucet.circle.com/
    address internal constant _SEPOLIA_EURC = address(0x08210F9170F89Ab7658F0B5E3fF39b0E03C594D4);
    address internal constant _SEPOLIA_USDC = address(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238);

    address internal constant _EXPECTED_DEPLOYER = address(0x990c1773C28B985c2cf32C0a920192bD8717C871);

    error WrongDeployer(address expected, address actual);

    /// @notice Run this with
    /// `export SENDER_ADDRESS=$(cast wallet address --account deployment-wallet)`
    /// `forge script test/script/SimpleTransferApp.e2e.sol:MintTransferBurnTransaction --sig "run(address)" $TOKEN_ADDRESS  --rpc-url sepolia --account dev-wallet --sender $SENDER_ADDRESS`
    function run(ProtocolAdapter pa) public {
        if (msg.sender != _EXPECTED_DEPLOYER) {
            revert WrongDeployer({expected: _EXPECTED_DEPLOYER, actual: msg.sender});
        }

        IERC20 erc20 = IERC20(_SEPOLIA_USDC);
        address permit2 = address(Permit2Lib.PERMIT2);

        vm.startBroadcast();
        {
            // Approve permit2
            erc20.approve(permit2, type(uint256).max);

            // Mint
            {
                Transaction memory mintTx = vm.parseTransaction("/test/examples/transactions/mint.bin");
                ProtocolAdapter(pa).execute(mintTx);
            }
            // Transfer
            {
                Transaction memory transferTx = vm.parseTransaction("/test/examples/transactions/transfer.bin");
                ProtocolAdapter(pa).execute(transferTx);
            }
            // Burn
            {
                Transaction memory burnTx = vm.parseTransaction("/test/examples/transactions/burn.bin");
                ProtocolAdapter(pa).execute(burnTx);
            }
        }
        vm.stopBroadcast();
    }
}
