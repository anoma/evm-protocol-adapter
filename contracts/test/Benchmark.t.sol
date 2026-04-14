// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Strings} from "@openzeppelin-contracts-5.5.0/utils/Strings.sol";
import {Test, Vm, console} from "forge-std-1.14.0/src/Test.sol";
import {RiscZeroGroth16Verifier} from "risc0-risc0-ethereum-3.0.1/contracts/src/groth16/RiscZeroGroth16Verifier.sol";
import {
    RiscZeroVerifierEmergencyStop
} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierRouter.sol";

import {Compliance} from "../src/libs/proving/Compliance.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Transaction} from "../src/Types.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";
import {Parsing} from "./libs/Parsing.sol";

uint256 constant UPPER_EMPTY_TX_GAS_COST_BOUND = 7256;
uint256 constant UPPER_RISC_ZERO_PROOF_GAS_COST_BOUND = 239000;
uint256 constant EXPECTED_AGGREGATION_PROOF_GAS_COST = 238285;

// Calldata gas benchmark: gas limits to evaluate (add or modify entries here)
uint256 constant BLOCK_GAS_LIMIT_CURRENT = 36_000_000;
uint256 constant BLOCK_GAS_LIMIT_FUSAKA = 60_000_000;
uint256 constant TX_GAS_CAP_EIP7825 = 16_777_216; // 2^24

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

        assertEq(gasWithProofs, gasWithoutProofs, "empty tx gas cost should be the same with and without proofs");
        assertLe(gasWithoutProofs, UPPER_EMPTY_TX_GAS_COST_BOUND, "empty tx gas cost should be within upper bound");
    }

    function test_aggregated_proof_gas_cost_is_fixed() public {
        for (uint256 i = 0; i < _txnsAgg.length; ++i) {
            Transaction memory txn = _txnsAgg[i];
            uint256 gasWithoutProofs = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: true});
            uint256 gasWithProofs = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: false});

            uint256 aggregationProofCost = gasWithProofs - gasWithoutProofs;

            assertEq(
                aggregationProofCost,
                EXPECTED_AGGREGATION_PROOF_GAS_COST,
                "aggregation proof gas cost should match expected"
            );
        }
    }

    function test_regular_proof_gas_cost_is_bound() public {
        for (uint256 i = 0; i < _txnsReg.length; ++i) {
            Transaction memory txn = _txnsReg[i];
            uint256 gasWithoutProofs = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: true});
            uint256 gasWithProofs = _executionGasCost({transaction: txn, skipRiscZeroProofVerification: false});

            uint256 averageRegularProofCost = (gasWithProofs - gasWithoutProofs) / (_countComplianceUnits(txn) * 3);

            assertLt(
                averageRegularProofCost,
                UPPER_RISC_ZERO_PROOF_GAS_COST_BOUND,
                "average regular proof gas cost should be within upper bound"
            );
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

        uint256[] memory gasLimits = new uint256[](3);
        gasLimits[0] = TX_GAS_CAP_EIP7825;
        gasLimits[1] = BLOCK_GAS_LIMIT_CURRENT;
        gasLimits[2] = BLOCK_GAS_LIMIT_FUSAKA;

        _logMaxCUsTable(zeroArr, nzArr, egArr, gasLimits);
        _logCalldataGasTable(zeroArr, nzArr);
        _logEip7623FloorCheck(zeroArr, nzArr, egArr);
        _logTotalGasTable(zeroArr, nzArr, egArr);
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

        assertEq(selector, ProtocolAdapter.Simulated.selector, "selector should match Simulated");
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

    /// @dev Calldata gas pricing schemes:
    ///   0 = Current (EIP-2028): 4 gas/zero-byte + 16 gas/nonzero-byte -active today
    ///   1 = Pectra floor (EIP-7623): 10/zero + 40/nonzero -floor only, never binds for ARM txns
    ///   2 = Glamsterdam proposal (EIP-7976 Opt 1): 15/zero + 60/nonzero -~3.75x current
    ///   3 = Glamsterdam flat rate (EIP-7976 Opt 2): 64/byte regardless of content -~4x current
    function _calldataGas(uint256 zero, uint256 nonZero, uint256 scheme) internal pure returns (uint256) {
        if (scheme == 0) return zero * 4 + nonZero * 16;
        if (scheme == 1) return zero * 10 + nonZero * 40;
        if (scheme == 2) return zero * 15 + nonZero * 60;
        return (zero + nonZero) * 64;
    }

    function _logCalldataGasTable(uint256[10] memory zeroArr, uint256[10] memory nzArr) internal pure {
        uint256[5] memory cuCounts = [uint256(1), 5, 10, 15, 20];
        string[2] memory modeNames = ["agg", "reg"];

        console.log("");
        console.log("=== Table 1: Calldata Gas per Transaction ===");
        console.log("How much gas does the transaction data alone cost under each pricing scheme?");
        console.log(
            "Mode, CUs, Bytes, Zero, NonZero, Current(EIP-2028), PectraFloor(EIP-7623), Glamsterdam(EIP-7976), FlatRate(EIP-7976-alt)"
        );

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
                    Strings.toString(z + nz),
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
            "(*) Pectra floor (EIP-7623) uses 10/40 rates but only kicks in when calldata cost > execution cost."
        );
        console.log("    For ARM txns, execution gas always dominates, so the current 4/16 rate applies under Pectra.");
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
        console.log("Total = 21000 (intrinsic) + calldata gas + execution gas");
        console.log(
            "Mode, CUs, ExecGas, CD:Current, Tot:Current, CD:PectraFloor, Tot:PectraFloor, CD:Glamsterdam, Tot:Glamsterdam, CD:FlatRate, Tot:FlatRate"
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

    function _logMaxCUsTable(
        uint256[10] memory zeroArr,
        uint256[10] memory nzArr,
        uint256[10] memory egArr,
        uint256[] memory gasLimits
    ) internal pure {
        string[2] memory modeNames = ["agg", "reg"];
        string[4] memory schemeNames =
            ["Current(EIP-2028)", "PectraFloor(EIP-7623)", "Glamsterdam(EIP-7976)", "FlatRate(EIP-7976-alt)"];
        uint256 intrinsicGas = 21_000;
        uint256 resourcesPerCu = Compliance._RESOURCES_PER_COMPLIANCE_UNIT;

        // Linear extrapolation: marginalCost = (total@20CU - total@1CU) / 19
        // baseCost = total@1CU - marginalCost
        // maxCUs = (gasLimit - baseCost) / marginalCost
        console.log("");
        console.log("=== Table 3: Max Compliance Units (CUs) and Resources per Block ===");
        console.log("How many CUs/resources fit in a single block under each gas pricing scheme?");

        // Build header dynamically
        string memory header = "Mode, Scheme, GasCost/CU";

        for (uint256 g = 0; g < gasLimits.length; ++g) {
            string memory label = Strings.toString(gasLimits[g] / 1_000_000);
            // solhint-disable-next-line func-named-parameters
            header = string.concat(header, ", CUs@", label, "M, Resources@", label, "M");
        }

        console.log(header);
        console.log("  agg = aggregated proof mode (one proof per tx, cheaper)");
        console.log("  reg = regular proof mode (one proof per CU, more expensive)");
        console.log("  1 CU = 1 consumed + 1 created resource = 2 resources");
        console.log("  Estimates are conservative: ~5% marginal cost overestimate in agg mode");

        for (uint256 m = 0; m < 2; ++m) {
            for (uint256 s = 0; s < 4; ++s) {
                uint256 total1 = intrinsicGas + _calldataGas(zeroArr[m * 5], nzArr[m * 5], s) + egArr[m * 5];
                uint256 total20 =
                    intrinsicGas + _calldataGas(zeroArr[m * 5 + 4], nzArr[m * 5 + 4], s) + egArr[m * 5 + 4];

                uint256 marginalCost = (total20 - total1) / 19;
                uint256 baseCost = total1 - marginalCost;

                // solhint-disable func-named-parameters
                string memory row =
                    string.concat(modeNames[m], ", ", schemeNames[s], ", ", Strings.toString(marginalCost));
                // solhint-enable func-named-parameters

                for (uint256 g = 0; g < gasLimits.length; ++g) {
                    uint256 maxCUs = 0;

                    if (marginalCost > 0 && gasLimits[g] > baseCost) {
                        maxCUs = (gasLimits[g] - baseCost) / marginalCost;
                    }

                    // solhint-disable-next-line func-named-parameters
                    row = string.concat(
                        row, ", ", Strings.toString(maxCUs), ", ", Strings.toString(maxCUs * resourcesPerCu)
                    );
                }

                console.log(row);
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
        console.log("=== EIP-7623 (Pectra) Floor Check ===");
        console.log("Pectra introduced a calldata gas floor: 6*zero + 24*nonzero bytes.");
        console.log("If this floor exceeds the execution gas, the tx pays the higher floor rate (10/40).");
        console.log("For ARM txns, execution gas always dominates, so the floor never activates.");
        console.log("Ratio(%) shows floor/exec: values below 100% mean the floor does NOT bind.");
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
        console.log("Checks whether gas cost grows linearly with CU count (it should).");
        console.log("R-squared measures fit quality: 10000 = perfect, lower = worse fit.");
        console.log("");
        console.log("R-squared (using current EIP-2028 pricing as representative):");

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
        console.log("Out-of-sample validation: 4 CUs split across 2 actions (02_02 config)");
        console.log("vs prediction from single-action data. Tests whether the model holds for multi-action txns.");
        console.log(
            "Error shown in permille (1000 = 100%). Structural differences (multi-action overhead) are expected."
        );

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
        console.log("=== Pricing Scheme Reference ===");
        console.log("Current (EIP-2028):          4 gas/zero-byte + 16 gas/nonzero-byte -active today");
        console.log("Pectra floor (EIP-7623):     10 gas/zero + 40 gas/nonzero -floor only, never binds for ARM");
        console.log("Glamsterdam (EIP-7976):      15 gas/zero + 60 gas/nonzero -proposed ~3.75x increase");
        console.log("Flat rate (EIP-7976-alt):    64 gas/byte for all bytes -proposed ~4x increase");
        console.log("");
        console.log("=== Additional Context ===");
        console.log("- Fusaka (EIP-7935): block gas limit raised to 60M (reflected in table above).");
        console.log("- Fusaka (EIP-7825): per-transaction gas cap of 2^24 (~16.78M). A single ARM tx");
        console.log("  cannot exceed this, so filling a 60M block requires multiple transactions.");
        console.log("- EIP-7706: if calldata gets its own gas dimension with independent basefee,");
        console.log("  actual costs could be lower when blocks are not calldata-heavy.");
        console.log("- Blob alternative (EIP-4844): posting proof data as blobs (~1 gas/byte) could");
        console.log("  bypass calldata repricing entirely, but requires architectural changes.");
    }
}

