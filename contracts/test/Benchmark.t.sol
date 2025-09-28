// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {RiscZeroGroth16Verifier} from "@risc0-ethereum/groth16/RiscZeroGroth16Verifier.sol";
import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, Vm, console} from "forge-std/Test.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Transaction, Action} from "../src/Types.sol";
import {Parsing} from "./libs/Parsing.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract Benchmark is Test {
    using Parsing for Vm;

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;
    Transaction[6] internal _txns;

    function setUp() public {
        string[5] memory paths = [
            "../examples/transactions/test_tx01.bin",
            "../examples/transactions/test_tx05.bin",
            "../examples/transactions/test_tx10.bin",
            "../examples/transactions/test_tx15.bin",
            "../examples/transactions/test_tx20.bin"
        ];

        _txns[0] = Transaction({actions: new Action[](0), deltaProof: ""});

        for (uint256 i = 0; i < paths.length; ++i) {
            _txns[i + 1] = vm.parseTransaction(string.concat("/test/benchmark/", paths[i]));
        }
        {
            RiscZeroGroth16Verifier verifier;

            (_router, _emergencyStop, verifier) = new DeployRiscZeroContracts().run();

            _pa = new ProtocolAdapter(_router, verifier.SELECTOR(), msg.sender);
        }
    }

    /// forge-config: default.isolate = true
    function test_execute_00() public {
        _pa.execute(_txns[0]);
    }

    /// forge-config: default.isolate = true
    function test_execute_01() public {
        _pa.execute(_txns[1]);
    }

    /// forge-config: default.isolate = true
    function test_execute_05() public {
        _pa.execute(_txns[2]);
    }

    /// forge-config: default.isolate = true
    function test_execute_10() public {
        _pa.execute(_txns[3]);
    }

    /// forge-config: default.isolate = true
    function test_execute_15() public {
        _pa.execute(_txns[4]);
    }

    /// forge-config: default.isolate = true
    function test_execute_20() public {
        _pa.execute(_txns[5]);
    }

    function test_print_calldata() public view {
        for (uint256 i = 0; i < _txns.length; ++i) {
            uint256 complianceUnitCount = 0;

            uint256 actionCount = _txns[i].actions.length;

            for (uint256 j = 0; j < actionCount; ++j) {
                complianceUnitCount += _txns[i].actions[j].complianceVerifierInputs.length;
            }

            string memory output = string(
                abi.encodePacked(
                    "Actions: ",
                    Strings.toString(actionCount),
                    ", ",
                    "CUs: ",
                    Strings.toString(complianceUnitCount),
                    ", ",
                    "Calldata (bytes): ",
                    Strings.toString(abi.encodeCall(ProtocolAdapter.execute, _txns[i]).length)
                )
            );

            console.log(output);
        }
    }
}
