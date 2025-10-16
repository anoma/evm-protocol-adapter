// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Strings} from "@openzeppelin-contracts/utils/Strings.sol";
import {RiscZeroGroth16Verifier} from "@risc0-ethereum/groth16/RiscZeroGroth16Verifier.sol";
import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, Vm, console} from "forge-std/Test.sol";

import {Compliance} from "../src/libs/proving/Compliance.sol";
import {Logic} from "../src/libs/proving/Logic.sol";
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
    Transaction[6] internal _txnsReg;
    Transaction[6] internal _txnsAgg;

    function setUp() public {
        string[6] memory suffixes = ["01_01", "05_01", "10_01", "15_01", "20_01", "02_02"];

        for (uint256 i = 0; i < suffixes.length; ++i) {
            Transaction memory parsed =
                vm.parseTransaction(string.concat("/test/examples/transactions/test_tx_reg_", suffixes[i], ".bin"));

            _toStorage(_txnsReg[i], parsed);
        }

        for (uint256 i = 0; i < suffixes.length; ++i) {
            Transaction memory parsed =
                vm.parseTransaction(string.concat("/test/examples/transactions/test_tx_agg_", suffixes[i], ".bin"));

            _toStorage(_txnsAgg[i], parsed);
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

    function _toStorage(Transaction storage stored, Transaction memory parsed) internal {
        stored.deltaProof = parsed.deltaProof;
        stored.aggregationProof = parsed.aggregationProof;

        uint256 actionCount = parsed.actions.length;

        for (uint256 i = 0; i < actionCount; ++i) {
            stored.actions.push();
            Action storage storedAction = stored.actions[i];
            Action memory parsedAction = parsed.actions[i];

            uint256 logicProofCount = parsedAction.logicVerifierInputs.length;
            for (uint256 j = 0; j < logicProofCount; ++j) {
                storedAction.logicVerifierInputs.push();
                Logic.VerifierInput storage storedLp = storedAction.logicVerifierInputs[j];
                Logic.VerifierInput memory parsedLp = parsedAction.logicVerifierInputs[j];

                storedLp.tag = parsedLp.tag;
                storedLp.verifyingKey = parsedLp.verifyingKey;
                storedLp.proof = parsedLp.proof;

                uint256 payloadLength = parsedLp.appData.resourcePayload.length;
                for (uint256 k = 0; k < payloadLength; ++k) {
                    storedLp.appData.resourcePayload.push();
                    storedLp.appData.resourcePayload[k] = parsedLp.appData.resourcePayload[k];
                }

                payloadLength = parsedLp.appData.discoveryPayload.length;
                for (uint256 k = 0; k < payloadLength; ++k) {
                    storedLp.appData.discoveryPayload.push();
                    storedLp.appData.discoveryPayload[k] = parsedLp.appData.discoveryPayload[k];
                }

                payloadLength = parsedLp.appData.externalPayload.length;
                for (uint256 k = 0; k < payloadLength; ++k) {
                    storedLp.appData.externalPayload.push();
                    storedLp.appData.externalPayload[k] = parsedLp.appData.externalPayload[k];
                }

                payloadLength = parsedLp.appData.applicationPayload.length;
                for (uint256 k = 0; k < payloadLength; ++k) {
                    storedLp.appData.applicationPayload.push();
                    storedLp.appData.applicationPayload[k] = parsedLp.appData.applicationPayload[k];
                }
            }

            uint256 complianceUnitCount = parsedAction.complianceVerifierInputs.length;
            for (uint256 j = 0; j < complianceUnitCount; ++j) {
                storedAction.complianceVerifierInputs.push();
                Compliance.VerifierInput storage storedCu = storedAction.complianceVerifierInputs[j];
                Compliance.VerifierInput memory parsedCu = parsedAction.complianceVerifierInputs[j];

                storedCu.proof = parsedCu.proof;

                storedCu.instance.consumed.nullifier = parsedCu.instance.consumed.nullifier;
                storedCu.instance.consumed.logicRef = parsedCu.instance.consumed.logicRef;
                storedCu.instance.consumed.commitmentTreeRoot = parsedCu.instance.consumed.commitmentTreeRoot;

                storedCu.instance.created.commitment = parsedCu.instance.created.commitment;
                storedCu.instance.created.logicRef = parsedCu.instance.created.logicRef;

                storedCu.instance.unitDeltaX = parsedCu.instance.unitDeltaX;
                storedCu.instance.unitDeltaY = parsedCu.instance.unitDeltaY;
            }
        }
    }
}
