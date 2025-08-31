// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, console} from "forge-std/Test.sol";

import {Parameters} from "../../src/libs/Parameters.sol";
import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";
import {Transaction} from "../../src/Types.sol";

import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

contract BenchmarkData is Test {
    function _parse(string memory path) internal view returns (Transaction memory txn) {
        string memory fullPath = string.concat(vm.projectRoot(), path);
        bytes memory data = vm.readFileBinary(fullPath);

        txn = abi.decode(data, (Transaction));
    }
}

contract Benchmark is BenchmarkData {
    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;
    Transaction[4] internal _txns;

    function setUp() public {
        string[4] memory paths = ["test_tx01.bin", "test_tx05.bin", "test_tx10.bin", "test_tx15.bin"];

        for (uint256 i = 0; i < paths.length; ++i) {
            _txns[i] = _parse(string.concat("/test/benchmark/", paths[i]));
        }
        {
            (_router, _emergencyStop,) = new DeployRiscZeroContracts().run();

            _pa = new ProtocolAdapter({
                riscZeroVerifierRouter: _router,
                commitmentTreeDepth: Parameters.COMMITMENT_TREE_DEPTH,
                actionTagTreeDepth: Parameters.ACTION_TAG_TREE_DEPTH
            });
        }
    }

    function test_execute_01() public {
        _pa.execute(_txns[0]);
    }

    function test_execute_05() public {
        _pa.execute(_txns[1]);
    }

    function test_execute_10() public {
        _pa.execute(_txns[2]);
    }

    function test_execute_15() public {
        _pa.execute(_txns[3]);
    }

    function test_print_calldata() public view {
        for (uint256 i = 0; i < _txns.length; ++i) {
            uint256 nCUs = 0;

            uint256 nActions = _txns[i].actions.length;

            for (uint256 j = 0; j < nActions; ++j) {
                nCUs += _txns[i].actions[j].complianceVerifierInputs.length;
            }

            string memory output = string(
                abi.encodePacked(
                    "Actions: ",
                    Strings.toString(nActions),
                    ", ",
                    "CUs: ",
                    Strings.toString(nCUs),
                    ", ",
                    "Calldata (bytes): ",
                    Strings.toString(abi.encodeCall(ProtocolAdapter.execute, _txns[i]).length)
                )
            );

            console.log(output);
        }
    }
}
