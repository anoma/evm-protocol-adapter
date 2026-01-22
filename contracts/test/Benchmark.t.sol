// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Strings} from "@openzeppelin-contracts-5.5.0/utils/Strings.sol";
import {Test, Vm, console} from "forge-std-1.14.0/src/Test.sol";
import {RiscZeroGroth16Verifier} from "risc0-risc0-ethereum-3.0.1/contracts/src/groth16/RiscZeroGroth16Verifier.sol";
import {
    RiscZeroVerifierEmergencyStop
} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierRouter.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Transaction} from "../src/Types.sol";
import {Parsing} from "./libs/Parsing.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract Benchmark is Test {
    using Parsing for Transaction;
    using Parsing for Vm;

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;

    Transaction internal _txnEmpty;
    Transaction[6] internal _txnsReg;
    Transaction[6] internal _txnsAgg;

    function setUp() public {
        string[6] memory suffixes = ["01_01", "05_01", "10_01", "15_01", "20_01", "02_02"];

        for (uint256 i = 0; i < suffixes.length; ++i) {
            Transaction memory parsed =
                vm.parseTransaction(string.concat("test/examples/transactions/test_tx_reg_", suffixes[i], ".bin"));

            _txnsReg[i].toStorage(parsed);
        }

        for (uint256 i = 0; i < suffixes.length; ++i) {
            Transaction memory parsed =
                vm.parseTransaction(string.concat("test/examples/transactions/test_tx_agg_", suffixes[i], ".bin"));

            _txnsAgg[i].toStorage(parsed);
        }

        {
            RiscZeroGroth16Verifier verifier;

            (_router, _emergencyStop, verifier) =
                new DeployRiscZeroContracts().run({admin: msg.sender, guardian: msg.sender});

            _pa = new ProtocolAdapter(_router, verifier.SELECTOR(), msg.sender);
        }
    }

    function test_execute_00() public {
        _pa.execute(_txnEmpty);
    }

    function test_execute_01_01_reg() public {
        _pa.execute(_txnsReg[0]);
    }

    function test_execute_05_01_reg() public {
        _pa.execute(_txnsReg[1]);
    }

    function test_execute_10_01_reg() public {
        _pa.execute(_txnsReg[2]);
    }

    function test_execute_15_01_reg() public {
        _pa.execute(_txnsReg[3]);
    }

    function test_execute_20_01_reg() public {
        _pa.execute(_txnsReg[4]);
    }

    function test_execute_02_02_reg() public {
        _pa.execute(_txnsReg[5]);
    }

    function test_execute_01_01_agg() public {
        _pa.execute(_txnsAgg[0]);
    }

    function test_execute_05_01_agg() public {
        _pa.execute(_txnsAgg[1]);
    }

    function test_execute_10_01_agg() public {
        _pa.execute(_txnsAgg[2]);
    }

    function test_execute_15_01_agg() public {
        _pa.execute(_txnsAgg[3]);
    }

    function test_execute_20_01_agg() public {
        _pa.execute(_txnsAgg[4]);
    }

    function test_execute_02_02_agg() public {
        _pa.execute(_txnsAgg[5]);
    }

    function test_print_calldata_reg() public view {
        for (uint256 i = 0; i < _txnsReg.length; ++i) {
            uint256 complianceUnitCount = 0;

            uint256 actionCount = _txnsReg[i].actions.length;

            for (uint256 j = 0; j < actionCount; ++j) {
                complianceUnitCount += _txnsReg[i].actions[j].complianceVerifierInputs.length;
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
                    Strings.toString(abi.encodeCall(ProtocolAdapter.execute, _txnsReg[i]).length)
                )
            );

            console.log(output);
        }
    }

    function test_print_calldata_agg() public view {
        for (uint256 i = 0; i < _txnsAgg.length; ++i) {
            uint256 complianceUnitCount = 0;

            uint256 actionCount = _txnsAgg[i].actions.length;

            for (uint256 j = 0; j < actionCount; ++j) {
                complianceUnitCount += _txnsAgg[i].actions[j].complianceVerifierInputs.length;
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
                    Strings.toString(abi.encodeCall(ProtocolAdapter.execute, _txnsAgg[i]).length)
                )
            );

            console.log(output);
        }
    }
}

