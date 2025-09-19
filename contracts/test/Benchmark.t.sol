// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {RiscZeroGroth16Verifier} from "@risc0-ethereum/groth16/RiscZeroGroth16Verifier.sol";
import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, Vm, console} from "forge-std/Test.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Transaction} from "../src/Types.sol";
import {Parsing} from "./libs/Parsing.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract Benchmark is Test {
    using Parsing for Vm;

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;
    Transaction[5] internal _txns;

    function setUp() public {
        string[5] memory paths = [
            "../examples/transactions/test_tx01.bin",
            "../examples/transactions/test_tx05.bin",
            "../examples/transactions/test_tx10.bin",
            "../examples/transactions/test_tx15.bin",
            "../examples/transactions/test_tx20.bin"
        ];

        for (uint256 i = 0; i < paths.length; ++i) {
            _txns[i] = vm.parseTransaction(string.concat("/test/benchmark/", paths[i]));
        }
        {
            RiscZeroGroth16Verifier verifier;

            (_router, _emergencyStop, verifier) = new DeployRiscZeroContracts().run();

            _pa = new ProtocolAdapter(_router, verifier.SELECTOR());
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

    function test_execute_20() public {
        _pa.execute(_txns[4]);
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
