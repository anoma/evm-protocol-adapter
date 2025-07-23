// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Transaction, Action} from "../src/Types.sol";
import {Example} from "./mocks/Example.sol";

contract ProtocolAdapterTest is Test {
    ProtocolAdapter internal _pa;

    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;

    function setUp() public {
        // Fork Sepolia
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";

        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));

        _pa = new ProtocolAdapter({
            riscZeroVerifierRouter: RiscZeroVerifierRouter(_sepoliaVerifierRouter), // Sepolia verifier
            commitmentTreeDepth: uint8(vm.parseUint(vm.readLine(path))),
            actionTagTreeDepth: uint8(vm.parseUint(vm.readLine(path)))
        });
    }

    function test_execute() public {
        address riscZeroEmergencyStop =
            address(_sepoliaVerifierRouter.getVerifier(bytes4(Example._CONSUMED_LOGIC_PROOF)));

        vm.expectRevert(Pausable.EnforcedPause.selector, riscZeroEmergencyStop);

        _pa.execute(Example.transaction());
    }

    function test_execute_empty_tx() public {
        Transaction memory txn = Transaction({actions: new Action[](0), deltaProof: ""});
        _pa.execute(txn);
    }

    function test_verify() public {
        address riscZeroEmergencyStop =
            address(_sepoliaVerifierRouter.getVerifier(bytes4(Example._CONSUMED_LOGIC_PROOF)));

        vm.expectRevert(Pausable.EnforcedPause.selector, riscZeroEmergencyStop);
        _pa.verify(Example.transaction());
    }

    function test_execute_emits_the_Blob_event() public {
        /* NOTE:
         * Here we fork sepolia before emergency stop was called on the `RiscZeroVerifierEmergencyStop` contract for v2.0.0
         * See
         * - https://sepolia.etherscan.io/address/0x8A8023bf44CABa343CEef3b06A4639fc8EBeE629
         * - https://github.com/risc0/risc0/security/advisories/GHSA-g3qg-6746-3mg9
         * for the details.
         */
        vm.selectFork(vm.createFork("sepolia", 8577299 - 1));

        string memory path = "./script/constructor-args.txt";

        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));

        _pa = new ProtocolAdapter({
            riscZeroVerifierRouter: RiscZeroVerifierRouter(_sepoliaVerifierRouter), // Sepolia verifier
            commitmentTreeDepth: uint8(vm.parseUint(vm.readLine(path))),
            actionTagTreeDepth: uint8(vm.parseUint(vm.readLine(path)))
        });

        Transaction memory txn = Example.transaction();
        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[0].appData[0]);

        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[0].appData[1]);

        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[1].appData[0]);

        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[1].appData[1]);

        _pa.execute(txn);
    }

    function test_verify_empty_tx() public view {
        Transaction memory txn = Transaction({actions: new Action[](0), deltaProof: ""});
        _pa.verify(txn);
    }

    function test_tx_with_cu_mismatch_fails() public view {
        // TODO: create a transaction with no compliance units and two trivial resources
        //       in the action
        true;
    }

    function test_verify_reverts_on_action_with_repeating_nullifiers() public view {
        // TODO: create a transaction with repeating actions (specifically nullifier)
        //       and expect it to revert on appropriate error
        true;
    }
}
