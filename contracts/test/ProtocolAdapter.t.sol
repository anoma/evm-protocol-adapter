// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";
import {Test} from "forge-std/Test.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
// import {Resource, Transaction} from "../src/Types.sol";

import {MockRiscZeroProof} from "./mocks/MockRiscZeroProof.sol";

//import {MockTypes} from "./mocks/MockTypes.sol";

contract ProtocolAdapterTest is Test {
    uint8 internal constant _COMMITMENT_TREE_DEPTH = 32;

    uint8 internal constant _ACTION_TREE_DEPTH = 4;

    // IRiscZeroVerifier internal constant _SEPOLIA_VERIFIER =
    //     IRiscZeroVerifier(address(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187));

    RiscZeroMockVerifier internal _mockVerifier;
    ProtocolAdapter internal _pa;

    function setUp() public {
        _mockVerifier = new RiscZeroMockVerifier(MockRiscZeroProof.VERIFIER_SELECTOR);

        _pa = new ProtocolAdapter({
            riscZeroVerifier: _mockVerifier,
            complianceCircuitID: MockRiscZeroProof.IMAGE_ID,
            commitmentTreeDepth: _COMMITMENT_TREE_DEPTH,
            actionTreeDepth: _ACTION_TREE_DEPTH
        });
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
    }

    function test_execute() public {
        (Resource[] memory consumed, Resource[] memory created) =
            MockTypes.mockResources({nConsumed: 1, ephConsumed: true, nCreated: 1, ephCreated: false, seed: 0});

        Transaction memory txn = MockTypes.mockTransaction({
            mockVerifier: _mockVerifier,
            root: _pa.latestRoot(),
            consumed: consumed,
            created: created
        });

        _pa.execute(txn);
    }

    function test_verifyEmptyTx() public view {
        Transaction memory txn = MockTypes.mockTransaction({
            mockVerifier: _mockVerifier,
            root: _pa.latestRoot(),
            consumed: new Resource[](0),
            created: new Resource[](0)
        });

        _pa.verify(txn);
    }

    function test_verify() public view {
        (Resource[] memory consumed, Resource[] memory created) =
            MockTypes.mockResources({nConsumed: 1, ephConsumed: true, nCreated: 1, ephCreated: false, seed: 0});

        Transaction memory txn = MockTypes.mockTransaction({
            mockVerifier: _mockVerifier,
            root: _pa.latestRoot(),
            consumed: consumed,
            created: created
        });

        _pa.verify(txn);
    }*/
}
