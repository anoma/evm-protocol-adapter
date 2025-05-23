// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {IRiscZeroVerifier} from "@risc0-ethereum/IRiscZeroVerifier.sol";

import {Test} from "forge-std/Test.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Transaction, Action} from "../src/Types.sol";
import {Example} from "./mocks/Example.sol";

contract ProtocolAdapterTest is Test {
    ProtocolAdapter internal _pa;

    function setUp() public {
        // Fork Sepolia
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";

        _pa = new ProtocolAdapter({
            riscZeroVerifier: IRiscZeroVerifier(vm.parseAddress(vm.readLine(path))), // Sepolia verifier
            complianceCircuitID: vm.parseBytes32(vm.readLine(path)),
            commitmentTreeDepth: uint8(vm.parseUint(vm.readLine(path))),
            actionTreeDepth: uint8(vm.parseUint(vm.readLine(path)))
        });
    }

    function test_execute() public {
        _pa.execute(Example.transaction());
    }

    function test_execute_empty_tx() public {
        Transaction memory txn = Transaction({actions: new Action[](0), deltaProof: ""});
        _pa.execute(txn);
    }

    function test_verify() public view {
        _pa.verify(Example.transaction());
    }

    function test_verify_empty_tx() public view {
        Transaction memory txn = Transaction({actions: new Action[](0), deltaProof: ""});
        _pa.verify(txn);
    }
}
