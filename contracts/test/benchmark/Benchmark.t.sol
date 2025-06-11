// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IRiscZeroVerifier} from "@risc0-ethereum/IRiscZeroVerifier.sol";

import {Test} from "forge-std/Test.sol";

import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";
import {Transaction} from "../../src/Types.sol";

contract BenchmarkData is Test {
    function _parse(string memory path) internal view returns (Transaction memory txn) {
        string memory fullPath = string.concat(vm.projectRoot(), path);
        string memory json = vm.readFile(fullPath);
        bytes memory data = vm.parseJson(json);

        txn = abi.decode(data, (Transaction));
    }
}

contract Benchmark is BenchmarkData {
    Transaction[10] internal _txns;
    ProtocolAdapter internal _pa;

    function setUp() public {
        string[9] memory paths = [
            "test_tx1.json",
            "test_tx5.json",
            "test_tx10.json",
            "test_tx15.json",
            "test_tx20.json",
            "test_tx25.json",
            "test_tx30.json",
            "test_tx35.json",
            "test_tx40.json"
        ];

        for (uint256 i = 0; i < paths.length; ++i) {
            _txns[i + 1] = _parse(string.concat("/test/benchmark/", paths[i]));
        }

        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";

        _pa = new ProtocolAdapter({
            riscZeroVerifier: IRiscZeroVerifier(vm.parseAddress(vm.readLine(path))), // Sepolia verifier
            commitmentTreeDepth: uint8(vm.parseUint(vm.readLine(path))),
            actionTagTreeDepth: uint8(vm.parseUint(vm.readLine(path)))
        });
    }

    function test_execute_00() public {
        _pa.execute(_txns[0]);
    }

    function test_execute_01() public {
        _pa.execute(_txns[1]);
    }

    function test_execute_05() public {
        _pa.execute(_txns[2]);
    }

    function test_execute_10() public {
        _pa.execute(_txns[3]);
    }

    function test_execute_15() public {
        _pa.execute(_txns[4]);
    }

    function test_execute_20() public {
        _pa.execute(_txns[5]);
    }

    function test_execute_25() public {
        _pa.execute(_txns[6]);
    }

    function test_execute_30() public {
        _pa.execute(_txns[7]);
    }

    function test_execute_35() public {
        _pa.execute(_txns[8]);
    }

    function test_execute_40() public {
        _pa.execute(_txns[9]);
    }

    function test_verify_00() public view {
        _pa.verify(_txns[0]);
    }

    function test_verify_01() public view {
        _pa.verify(_txns[1]);
    }

    function test_verify_05() public view {
        _pa.verify(_txns[2]);
    }

    function test_verify_10() public view {
        _pa.verify(_txns[3]);
    }

    function test_verify_15() public view {
        _pa.verify(_txns[4]);
    }

    function test_verify_20() public view {
        _pa.verify(_txns[5]);
    }

    function test_verify_25() public view {
        _pa.verify(_txns[6]);
    }

    function test_verify_30() public view {
        _pa.verify(_txns[7]);
    }

    function test_verify_35() public view {
        _pa.verify(_txns[8]);
    }

    function test_verify_40() public view {
        _pa.verify(_txns[9]);
    }
}
