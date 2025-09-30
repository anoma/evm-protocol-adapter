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

    Transaction internal _txnEmpty;
    Transaction[5] internal _txnsReg;
    Transaction[5] internal _txnsAgg;

    function setUp() public {
        _txnEmpty = Transaction({actions: new Action[](0), deltaProof: "", aggregationProof: ""});

        string[5] memory suffixes = ["01", "05", "10", "15", "20"];

        for (uint256 i = 0; i < suffixes.length; ++i) {
            _txnsReg[i] =
                vm.parseTransaction(string.concat("/test/examples/transactions/test_tx_reg_", suffixes[i], ".bin"));
        }
        for (uint256 i = 0; i < suffixes.length; ++i) {
            _txnsAgg[i] =
                vm.parseTransaction(string.concat("/test/examples/transactions/test_tx_agg_", suffixes[i], ".bin"));
        }

        {
            RiscZeroGroth16Verifier verifier;

            (_router, _emergencyStop, verifier) = new DeployRiscZeroContracts().run();

            _pa = new ProtocolAdapter(_router, verifier.SELECTOR(), msg.sender);
        }
    }

    function test_execute_00() public {
        _pa.execute(_txnEmpty);
    }

    function test_execute_01_reg() public {
        _pa.execute(_txnsReg[0]);
    }

    function test_execute_05_reg() public {
        _pa.execute(_txnsReg[1]);
    }

    function test_execute_10_reg() public {
        _pa.execute(_txnsReg[2]);
    }

    function test_execute_15_reg() public {
        _pa.execute(_txnsReg[3]);
    }

    function test_execute_20_reg() public {
        _pa.execute(_txnsReg[4]);
    }

    function test_execute_01_agg() public {
        _pa.execute(_txnsAgg[0]);
    }

    function test_execute_05_agg() public {
        _pa.execute(_txnsAgg[1]);
    }

    function test_execute_10_agg() public {
        _pa.execute(_txnsAgg[2]);
    }

    function test_execute_15_agg() public {
        _pa.execute(_txnsAgg[3]);
    }

    function test_execute_20_agg() public {
        _pa.execute(_txnsAgg[4]);
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
}
