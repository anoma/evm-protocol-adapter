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

uint256 constant UPPER_EMPTY_TX_GAS_COST_BOUND = 7256;
uint256 constant UPPER_RISC_ZERO_PROOF_GAS_COST_BOUND = 239000;
uint256 constant EXPECTED_AGGREGATION_PROOF_GAS_COST = 238285;

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

    function test_empty_transaction_gas_cost_is_fixed() public {
        uint256 gasWithoutProofs = _executionGasCost({transaction: _txnEmpty, skipRiscZeroProofVerification: true});
        uint256 gasWithProofs = _executionGasCost({transaction: _txnEmpty, skipRiscZeroProofVerification: false});

        assertEq(gasWithProofs, gasWithoutProofs);
        assertLe(gasWithoutProofs, UPPER_EMPTY_TX_GAS_COST_BOUND);
    }

    function test_aggregated_proof_gas_cost_is_fixed() public {
        for (uint256 i = 0; i < _txnsAgg.length; ++i) {
            Transaction memory txn = _txnsAgg[i];
            uint256 gasWithoutProofs = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: true});
            uint256 gasWithProofs = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: false});

            uint256 aggregationProofCost = gasWithProofs - gasWithoutProofs;

            assertEq(aggregationProofCost, EXPECTED_AGGREGATION_PROOF_GAS_COST);
        }
    }

    function test_regular_proof_gas_cost_is_bound() public {
        for (uint256 i = 0; i < _txnsReg.length; ++i) {
            Transaction memory txn = _txnsReg[i];
            uint256 gasWithoutProofs = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: true});
            uint256 gasWithProofs = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: false});

            uint256 averageRegularProofCost = (gasWithProofs - gasWithoutProofs) / (_countComplianceUnits(txn) * 3);

            assertLt(averageRegularProofCost, UPPER_RISC_ZERO_PROOF_GAS_COST_BOUND);
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

    function test_print_calldata_gas_analysis() public {
        // Flat arrays: index = m * 5 + i, where m: 0=agg 1=reg, i: 0-4 for CU 1,5,10,15,20
        uint256[10] memory bytesArr;
        uint256[10] memory zeroArr;
        uint256[10] memory nzArr;
        uint256[10] memory egArr;

        for (uint256 m = 0; m < 2; ++m) {
            for (uint256 i = 0; i < 5; ++i) {
                Transaction memory txn;

                if (m == 0) {
                    txn = _txnsAgg[i];
                } else {
                    txn = _txnsReg[i];
                }

                uint256 idx = m * 5 + i;
                bytes memory cd = abi.encodeCall(ProtocolAdapter.execute, (txn));
                bytesArr[idx] = cd.length;
                (zeroArr[idx], nzArr[idx]) = _countCalldataBytes(cd);
                egArr[idx] = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: false});
            }
        }

        // Collect 02_02 (4 CUs in 2 actions) for out-of-sample validation
        uint256[2] memory valZero;
        uint256[2] memory valNz;
        uint256[2] memory valEg;

        for (uint256 m = 0; m < 2; ++m) {
            Transaction memory txn;

            if (m == 0) {
                txn = _txnsAgg[5];
            } else {
                txn = _txnsReg[5];
            }

            bytes memory cd = abi.encodeCall(ProtocolAdapter.execute, (txn));
            (valZero[m], valNz[m]) = _countCalldataBytes(cd);
            valEg[m] = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: false});
        }

        _logCalldataGasTable(bytesArr, zeroArr, nzArr);
        _logEip7623FloorCheck(zeroArr, nzArr, egArr);
        _logTotalGasTable(zeroArr, nzArr, egArr);
        _logMaxCUsTable(zeroArr, nzArr, egArr);
        _logModelValidation({
            zeroArr: zeroArr, nzArr: nzArr, egArr: egArr, valZero: valZero, valNz: valNz, valEg: valEg
        });
        _logNotes();
    }

    function _executionGasCost(Transaction memory transaction, bool skipRiscZeroProofVerification)
        internal
        returns (uint256 gasUsed)
    {
        (bool success, bytes memory data) =
            address(_pa).call(abi.encodeCall(_pa.simulateExecute, (transaction, skipRiscZeroProofVerification))); // solhint-disable-line avoid-low-level-calls
        assertFalse(success, "call should revert");

        bytes4 selector;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            // Load first 32 bytes
            let word := mload(add(data, 32))
            // Selector is high-order 4 bytes
            selector := shl(224, shr(224, word))
            // Gas used is next 32 bytes (starting at offset 4)
            gasUsed := mload(add(data, 36))
        }

        assertEq(selector, ProtocolAdapter.Simulated.selector);
    }

    function _countComplianceUnits(Transaction memory transaction) internal pure returns (uint256 complianceUnits) {
        uint256 actionCount = transaction.actions.length;

        for (uint256 i = 0; i < actionCount; ++i) {
            complianceUnits += transaction.actions[i].complianceVerifierInputs.length;
        }
    }

    function _countCalldataBytes(bytes memory data) internal pure returns (uint256 zero, uint256 nonZero) {
        for (uint256 i = 0; i < data.length; ++i) {
            if (data[i] == 0) {
                ++zero;
            } else {
                ++nonZero;
            }
        }
    }

    /// @dev Scheme mapping:
    ///   0 = EIP-2028 (4/16) — current base rate, still applies under Pectra for execution-heavy txns
    ///   1 = EIP-7623 (10/40) — floor rate only; shown as hypothetical base rate for comparison
    ///   2 = EIP-7976 Opt 1 (15/60) — Glamsterdam proposal
    ///   3 = EIP-7976 Opt 2 (64/64) — Glamsterdam flat rate alternative
    function _calldataGas(uint256 zero, uint256 nonZero, uint256 scheme) internal pure returns (uint256) {
        if (scheme == 0) return zero * 4 + nonZero * 16;
        if (scheme == 1) return zero * 10 + nonZero * 40;
        if (scheme == 2) return zero * 15 + nonZero * 60;
        return (zero + nonZero) * 64;
    }

    function _logCalldataGasTable(uint256[10] memory bytesArr, uint256[10] memory zeroArr, uint256[10] memory nzArr)
        internal
        pure
    {
        uint256[5] memory cuCounts = [uint256(1), 5, 10, 15, 20];
        string[2] memory modeNames = ["agg", "reg"];

        console.log("");
        console.log("=== Table 1: Calldata Gas per Transaction ===");
        console.log("Mode, CUs, Bytes, Zero, NonZero, Gas(4/16), Gas(10/40*), Gas(15/60), Gas(64/64)");

        for (uint256 m = 0; m < 2; ++m) {
            for (uint256 i = 0; i < 5; ++i) {
                uint256 idx = m * 5 + i;
                uint256 z = zeroArr[idx];
                uint256 nz = nzArr[idx];

                // solhint-disable-next-line func-named-parameters
                string memory row = string.concat(
                    modeNames[m],
                    ", ",
                    Strings.toString(cuCounts[i]),
                    ", ",
                    Strings.toString(bytesArr[idx]),
                    ", ",
                    Strings.toString(z),
                    ", ",
                    Strings.toString(nz)
                );
                // solhint-disable-next-line func-named-parameters
                row = string.concat(
                    row,
                    ", ",
                    Strings.toString(z * 4 + nz * 16),
                    ", ",
                    Strings.toString(z * 10 + nz * 40),
                    ", ",
                    Strings.toString(z * 15 + nz * 60),
                    ", ",
                    Strings.toString((z + nz) * 64)
                );
                console.log(row);
            }
        }

        console.log(
            "(*) 10/40 is the EIP-7623 floor rate. For ARM txns, execution gas dominates so standard 4/16 applies under Pectra."
        );
    }

    function _logTotalGasTable(uint256[10] memory zeroArr, uint256[10] memory nzArr, uint256[10] memory egArr)
        internal
        pure
    {
        uint256[5] memory cuCounts = [uint256(1), 5, 10, 15, 20];
        string[2] memory modeNames = ["agg", "reg"];
        uint256 intrinsicGas = 21_000;

        console.log("");
        console.log("=== Table 2: Total On-Chain Gas per Transaction ===");
        console.log(
            "Mode, CUs, ExecGas, CD(4/16), Tot(4/16), CD(10/40), Tot(10/40), CD(15/60), Tot(15/60), CD(64/64), Tot(64/64)"
        );

        for (uint256 m = 0; m < 2; ++m) {
            for (uint256 i = 0; i < 5; ++i) {
                uint256 idx = m * 5 + i;
                uint256 z = zeroArr[idx];
                uint256 nz = nzArr[idx];
                uint256 eg = egArr[idx];

                // solhint-disable-next-line func-named-parameters
                string memory row = string.concat(
                    modeNames[m],
                    ", ",
                    Strings.toString(cuCounts[i]),
                    ", ",
                    Strings.toString(eg),
                    ", ",
                    Strings.toString(z * 4 + nz * 16),
                    ", ",
                    Strings.toString(intrinsicGas + z * 4 + nz * 16 + eg)
                );
                // solhint-disable-next-line func-named-parameters
                row = string.concat(
                    row,
                    ", ",
                    Strings.toString(z * 10 + nz * 40),
                    ", ",
                    Strings.toString(intrinsicGas + z * 10 + nz * 40 + eg),
                    ", ",
                    Strings.toString(z * 15 + nz * 60),
                    ", ",
                    Strings.toString(intrinsicGas + z * 15 + nz * 60 + eg)
                );
                // solhint-disable-next-line func-named-parameters
                row = string.concat(
                    row,
                    ", ",
                    Strings.toString((z + nz) * 64),
                    ", ",
                    Strings.toString(intrinsicGas + (z + nz) * 64 + eg)
                );
                console.log(row);
            }
        }
    }

    function _logMaxCUsTable(uint256[10] memory zeroArr, uint256[10] memory nzArr, uint256[10] memory egArr)
        internal
        pure
    {
        string[2] memory modeNames = ["agg", "reg"];
        string[4] memory schemeNames = ["4/16", "10/40*", "15/60", "64/64"];
        uint256 intrinsicGas = 21_000;

        // Linear extrapolation: marginalCost = (total@20CU - total@1CU) / 19
        // baseCost = total@1CU - marginalCost
        // maxCUs = (gasLimit - baseCost) / marginalCost
        console.log("");
        console.log("=== Table 3: Max CUs per Block ===");
        console.log("Mode, Scheme, MarginalCost/CU, MaxCUs@36M, MaxCUs@60M");
        console.log("NOTE: 2-point model (1,20 CU) is conservative for agg mode (~5% marginal cost overestimate)");

        for (uint256 m = 0; m < 2; ++m) {
            for (uint256 s = 0; s < 4; ++s) {
                uint256 total1 = intrinsicGas + _calldataGas(zeroArr[m * 5], nzArr[m * 5], s) + egArr[m * 5];
                uint256 total20 =
                    intrinsicGas + _calldataGas(zeroArr[m * 5 + 4], nzArr[m * 5 + 4], s) + egArr[m * 5 + 4];

                uint256 marginalCost = (total20 - total1) / 19;
                uint256 baseCost = total1 - marginalCost;

                uint256 maxCUs36 = 0;
                uint256 maxCUs60 = 0;

                if (marginalCost > 0) {
                    if (36_000_000 > baseCost) maxCUs36 = (36_000_000 - baseCost) / marginalCost;
                    if (60_000_000 > baseCost) maxCUs60 = (60_000_000 - baseCost) / marginalCost;
                }

                // solhint-disable func-named-parameters
                console.log(
                    string.concat(
                        modeNames[m],
                        ", ",
                        schemeNames[s],
                        ", ",
                        Strings.toString(marginalCost),
                        ", ",
                        Strings.toString(maxCUs36),
                        ", ",
                        Strings.toString(maxCUs60)
                    )
                );
                // solhint-enable func-named-parameters
            }
        }
    }

    function _logEip7623FloorCheck(uint256[10] memory zeroArr, uint256[10] memory nzArr, uint256[10] memory egArr)
        internal
        pure
    {
        uint256[5] memory cuCounts = [uint256(1), 5, 10, 15, 20];
        string[2] memory modeNames = ["agg", "reg"];

        console.log("");
        console.log("=== EIP-7623 Floor Check ===");
        console.log("Floor activates when 6*zero + 24*nonzero > exec_gas (never for ARM txns)");
        console.log("Mode, CUs, FloorThreshold, ExecGas, Ratio(%)");

        for (uint256 m = 0; m < 2; ++m) {
            for (uint256 i = 0; i < 5; ++i) {
                uint256 idx = m * 5 + i;
                uint256 floorThreshold = 6 * zeroArr[idx] + 24 * nzArr[idx];
                uint256 ratioPct = (floorThreshold * 100) / egArr[idx];

                // solhint-disable func-named-parameters
                console.log(
                    string.concat(
                        modeNames[m],
                        ", ",
                        Strings.toString(cuCounts[i]),
                        ", ",
                        Strings.toString(floorThreshold),
                        ", ",
                        Strings.toString(egArr[idx]),
                        ", ",
                        Strings.toString(ratioPct)
                    )
                );
                // solhint-enable func-named-parameters
            }
        }
    }

    function _logModelValidation(
        uint256[10] memory zeroArr,
        uint256[10] memory nzArr,
        uint256[10] memory egArr,
        uint256[2] memory valZero,
        uint256[2] memory valNz,
        uint256[2] memory valEg
    ) internal pure {
        uint256[5] memory cuCounts = [uint256(1), 5, 10, 15, 20];
        string[2] memory modeNames = ["agg", "reg"];
        uint256 intrinsicGas = 21_000;

        console.log("");
        console.log("=== Table 4: Linear Model Validation ===");

        // R-squared for scheme 0 (4/16) as representative
        console.log("R-squared (4/16 scheme, basis points where 10000 = perfect fit):");

        for (uint256 m = 0; m < 2; ++m) {
            uint256 total1 = intrinsicGas + _calldataGas(zeroArr[m * 5], nzArr[m * 5], 0) + egArr[m * 5];
            uint256 total20 = intrinsicGas + _calldataGas(zeroArr[m * 5 + 4], nzArr[m * 5 + 4], 0) + egArr[m * 5 + 4];

            uint256 marginalCost = (total20 - total1) / 19;
            uint256 baseCost = total1 - marginalCost;

            uint256 sumTotal = 0;
            uint256[5] memory totals;

            for (uint256 i = 0; i < 5; ++i) {
                uint256 idx = m * 5 + i;
                totals[i] = intrinsicGas + _calldataGas(zeroArr[idx], nzArr[idx], 0) + egArr[idx];
                sumTotal += totals[i];
            }

            uint256 mean = sumTotal / 5;

            uint256 ssTot = 0;
            uint256 ssRes = 0;

            for (uint256 i = 0; i < 5; ++i) {
                uint256 predicted = baseCost + marginalCost * cuCounts[i];

                uint256 resDiff = totals[i] > predicted ? totals[i] - predicted : predicted - totals[i];
                ssRes += resDiff * resDiff;

                uint256 totDiff = totals[i] > mean ? totals[i] - mean : mean - totals[i];
                ssTot += totDiff * totDiff;
            }

            uint256 r2Bps = ssTot > 0 ? 10_000 - (10_000 * ssRes) / ssTot : 10_000;

            // solhint-disable-next-line func-named-parameters
            console.log(string.concat("  ", modeNames[m], ": ", Strings.toString(r2Bps), " / 10000"));
        }

        // Out-of-sample: 02_02 (4 CUs, 2 actions) vs linear prediction from single-action data
        console.log("");
        console.log("Out-of-sample: 02_02 (4 CUs in 2 actions) vs single-action model (4/16):");
        console.log("NOTE: structural difference (multi-action) means deviation includes action-structure effect");

        for (uint256 m = 0; m < 2; ++m) {
            uint256 total1 = intrinsicGas + _calldataGas(zeroArr[m * 5], nzArr[m * 5], 0) + egArr[m * 5];
            uint256 total20 = intrinsicGas + _calldataGas(zeroArr[m * 5 + 4], nzArr[m * 5 + 4], 0) + egArr[m * 5 + 4];

            uint256 marginalCost = (total20 - total1) / 19;
            uint256 baseCost = total1 - marginalCost;

            uint256 predicted4 = baseCost + marginalCost * 4;
            uint256 actual4 = intrinsicGas + _calldataGas(valZero[m], valNz[m], 0) + valEg[m];

            uint256 diff = predicted4 > actual4 ? predicted4 - actual4 : actual4 - predicted4;
            string memory sign = predicted4 > actual4 ? "+" : "-";
            uint256 errPermille = (diff * 1000) / actual4;

            // solhint-disable func-named-parameters
            console.log(
                string.concat(
                    "  ",
                    modeNames[m],
                    ": predicted=",
                    Strings.toString(predicted4),
                    " actual=",
                    Strings.toString(actual4),
                    " error=",
                    sign,
                    Strings.toString(errPermille),
                    " permille"
                )
            );
            // solhint-enable func-named-parameters
        }
    }

    function _logNotes() internal pure {
        console.log("");
        console.log("=== Notes ===");
        console.log("- EIP-7706: If calldata gets its own gas dimension with independent basefee,");
        console.log("  actual costs could be lower when blocks are not calldata-heavy.");
        console.log("- 10/40 column (*): hypothetical base rate for comparison. Under Pectra (EIP-7623),");
        console.log("  ARM txns pay standard 4/16 because the 10/40 floor never binds (see floor check).");
        console.log("- Blob alternative (EIP-4844): posting proof data as blobs (~1 gas/byte) could");
        console.log("  bypass calldata repricing entirely, but requires architectural changes.");
    }
}

