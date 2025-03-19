// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { RiscZeroMockVerifier } from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";
import { Test } from "forge-std/Test.sol";

import { ProtocolAdapter } from "../src/ProtocolAdapter.sol";
import { Resource, Transaction } from "../src/Types.sol";

import { MockRiscZeroProof } from "./mocks/MockRiscZeroProof.sol";
import { MockTypes } from "./mocks/MockTypes.sol";

contract ProtocolAdapterDemo is Test {
    ProtocolAdapter internal _pa;
    Transaction internal _txn;

    function setUp() public {
        RiscZeroMockVerifier mockVerifier = new RiscZeroMockVerifier(MockRiscZeroProof.VERIFIER_SELECTOR);

        _pa = new ProtocolAdapter({
            riscZeroVerifier: mockVerifier,
            logicCircuitID: MockRiscZeroProof.IMAGE_ID_1,
            complianceCircuitID: MockRiscZeroProof.IMAGE_ID_2,
            treeDepth: 2 ^ 8
        });

        (Resource[] memory consumed, Resource[] memory created) =
            MockTypes.mockResources({ nConsumed: 1, ephConsumed: true, nCreated: 1, ephCreated: false, seed: 0 });

        _txn = MockTypes.mockTransaction({
            mockVerifier: mockVerifier,
            root: _pa.latestRoot(),
            consumed: consumed,
            created: created
        });
    }

    function test_execute() public view {
        _pa.verify(_txn);
    }

    function test_verify() public view {
        _pa.verify(_txn);
    }
}
