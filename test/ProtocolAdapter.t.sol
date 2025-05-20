// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {Test} from "forge-std/Test.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Example} from "./mocks/Example.sol";

contract ProtocolAdapterTest is Test {
    uint8 internal constant _COMMITMENT_TREE_DEPTH = 32;

    uint8 internal constant _ACTION_TREE_DEPTH = 4;

    RiscZeroVerifierRouter internal constant _SEPOLIA_VERIFIER =
        RiscZeroVerifierRouter(address(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187));

    bytes32 internal constant _COMPLIANCE_CIRCUIT_ID =
        0xbf165219f3e8390e1fca936de31db398b66efaef8af1b836f23c271b7ef66103;

    ProtocolAdapter internal _pa;

    function setUp() public {
        // Fork Sepolia
        vm.selectFork(vm.createFork("sepolia"));

        _pa = new ProtocolAdapter({
            riscZeroVerifier: _SEPOLIA_VERIFIER,
            complianceCircuitID: _COMPLIANCE_CIRCUIT_ID,
            commitmentTreeDepth: _COMMITMENT_TREE_DEPTH,
            actionTreeDepth: _ACTION_TREE_DEPTH
        });
    }

    function test_sel() public {
        _pa.execute(Example.transaction());
    }

    function test_execute() public {
        _pa.execute(Example.transaction());
    }

    /*function test_verifyEmptyTx() public view {
        Transaction memory txn = MockTypes.mockTransaction({
            mockVerifier: _mockVerifier,
            root: _pa.latestRoot(),
            consumed: new Resource[](0),
            created: new Resource[](0)
        });

        _pa.verify(txn);
    }*/

    function test_verify_tx() public view {
        _pa.verify(Example.transaction());
    }

    /*
    function test_benchmark() public {
        uint16[3] memory n = [uint16(5), uint16(50), uint16(500)];

        for (uint256 i = 0; i < n.length; ++i) {
            (Resource[] memory consumed, Resource[] memory created) = MockTypes.mockResources({
                nConsumed: n[i],
                ephConsumed: true,
                nCreated: n[i],
                ephCreated: false,
                seed: i
            });

            Transaction memory txn = MockTypes.mockTransaction({
                mockVerifier: _mockVerifier,
                root: _pa.latestRoot(),
                consumed: consumed,
                created: created
            });

            _pa.verify(txn);
            _pa.execute(txn);
        }
    }*/
}
