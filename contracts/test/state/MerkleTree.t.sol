// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree as OzMerkleTree} from "@openzeppelin-contracts-5.5.0/utils/structs/MerkleTree.sol";
import {Test} from "forge-std-1.14.0/src/Test.sol";
import {MerkleTree} from "./../../src/libs/MerkleTree.sol";
import {SHA256} from "./../../src/libs/SHA256.sol";
import {MerkleTreeExample} from "./../examples/MerkleTree.e.sol";

contract MerkleTreeTest is Test, MerkleTreeExample {
    using MerkleTree for MerkleTree.Tree;
    using MerkleTree for bytes32[];
    using OzMerkleTree for OzMerkleTree.Bytes32PushTree;

    MerkleTree.Tree internal _merkleTree;
    MerkleTree.Tree internal _paMerkleTree;
    OzMerkleTree.Bytes32PushTree internal _ozMerkleTree;

    constructor() {
        _setupMockTree();
    }

    function test_push_expands_the_tree_depth_if_the_capacity_is_reached() public {
        assertEq(_merkleTree.setup(), _roots[0], "initial root should match expected");
        assertEq(_merkleTree.leafCount(), 0, "initial leaf count should be 0");
        assertEq(_merkleTree.depth(), 0, "initial depth should be 0");

        _merkleTree.push(_leaves[7][0]);
        assertEq(_merkleTree.leafCount(), 1, "leaf count should be 1 after first push");
        assertEq(_merkleTree.depth(), 1, "depth should be 1 after first push");

        _merkleTree.push(_leaves[7][1]);
        assertEq(_merkleTree.leafCount(), 2, "leaf count should be 2 after second push");
        assertEq(_merkleTree.depth(), 2, "depth should expand to 2 after second push");

        _merkleTree.push(_leaves[7][2]);
        assertEq(_merkleTree.leafCount(), 3, "leaf count should be 3 after third push");
        assertEq(_merkleTree.depth(), 2, "depth should remain 2 after third push");

        _merkleTree.push(_leaves[7][3]);
        assertEq(_merkleTree.leafCount(), 4, "leaf count should be 4 after fourth push");
        assertEq(_merkleTree.depth(), 3, "depth should expand to 3 after fourth push");

        _merkleTree.push(_leaves[7][4]);
        assertEq(_merkleTree.leafCount(), 5, "leaf count should be 5 after fifth push");
        assertEq(_merkleTree.depth(), 3, "depth should remain 3 after fifth push");

        _merkleTree.push(_leaves[7][5]);
        assertEq(_merkleTree.leafCount(), 6, "leaf count should be 6 after sixth push");
        assertEq(_merkleTree.depth(), 3, "depth should remain 3 after sixth push");

        _merkleTree.push(_leaves[7][6]);
        assertEq(_merkleTree.leafCount(), 7, "leaf count should be 7 after seventh push");
        assertEq(_merkleTree.depth(), 3, "depth should remain 3 after seventh push");
    }

    function test_setup_returns_the_expected_initial_root() public {
        assertEq(_merkleTree.setup(), SHA256.EMPTY_HASH, "initial root should be the empty hash");
    }

    function testFuzz_push_returns_the_same_roots(bytes32[] memory leaves) public {
        // First compute what tree depth is required to store leaves
        uint8 treeDepth = 0;
        // Essentially compute the logarithm of the leaf count base 2
        for (uint256 i = leaves.length; i > 0; i >>= 1) {
            treeDepth++;
        }
        // Set up a protocol adapter Merkle tree and an OpenZeppelin one
        bytes32 paRoot = _paMerkleTree.setup();
        // OpenZeppelin implementation is not variable depth, it is easier to
        // just compare the end state once we have reached the final depth
        bytes32 ozRoot = _ozMerkleTree.setup(treeDepth, SHA256.EMPTY_HASH, _hashPair);

        uint256 paIndex = 0;
        uint256 ozIndex = 0;
        // Now add all the leaves to each Merkle tree
        for (uint256 i = 0; i < leaves.length; i++) {
            (paIndex, paRoot) = _paMerkleTree.push(leaves[i]);
            (ozIndex, ozRoot) = _ozMerkleTree.push(leaves[i], _hashPair);
            // The lead counts must remain matched throughout
            assertEq(paIndex, ozIndex, "leaf indices should match during push");
            // Once we have reached the final depth, we might as well start
            // comparing the roots
            if (_paMerkleTree.depth() == _ozMerkleTree.depth()) {
                assertEq(paRoot, ozRoot, "roots should match at same depth");
            }
        }
        // Now confirm that the Merkle trees have the same leaf count
        assertEq(paIndex, ozIndex, "final leaf indices should match");
        // Same roots
        assertEq(paRoot, ozRoot, "final roots should match");
        // Same depths
        assertEq(_paMerkleTree.depth(), _ozMerkleTree.depth(), "final depths should match");
    }

    function testFuzz_push_returns_the_same_roots() public {
        bytes32[] memory dynamicLeaves = new bytes32[](0);
        testFuzz_push_returns_the_same_roots(dynamicLeaves);
    }

    function testFuzz_push_returns_the_same_roots(bytes32[1] memory leaves) public {
        bytes32[] memory dynamicLeaves = new bytes32[](1);
        dynamicLeaves[0] = leaves[0];
        testFuzz_push_returns_the_same_roots(dynamicLeaves);
    }

    function testFuzz_push_returns_the_same_roots(bytes32[2] memory leaves) public {
        bytes32[] memory dynamicLeaves = new bytes32[](2);
        dynamicLeaves[0] = leaves[0];
        dynamicLeaves[1] = leaves[1];
        testFuzz_push_returns_the_same_roots(dynamicLeaves);
    }

    function test_compare_le() public pure {
        assertEq(
            _computeMinimalTreeDepthNaive(0),
            MerkleTree.computeMinimalTreeDepth(0),
            "naive and optimized should match for 0 leaves"
        );
        assertEq(MerkleTree.computeMinimalTreeDepth(0), 0, "minimal tree depth for 0 leaves should be 0");
    }

    function test_computeMinimalTreeDepth_computes_the_right_tree_depths() public pure {
        uint8[34] memory depths =
            [0, 0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6];

        for (uint256 i = 0; i < depths.length; ++i) {
            assertEq(
                MerkleTree.computeMinimalTreeDepth({leavesCount: i}), depths[i], "tree depth should match expected"
            );
        }
    }

    function test_computeMinimalTreeDepth_reproduces_tree_depths_of_the_naive_implementation() public pure {
        uint256 maxLeafCount = 16;

        for (uint256 i = 0; i < maxLeafCount; ++i) {
            assertEq(
                _computeMinimalTreeDepthNaive({leavesCount: i}),
                MerkleTree.computeMinimalTreeDepth({leavesCount: i}),
                "naive and optimized implementations should match"
            );
        }
    }

    function test_compare_power_of_two_boundaries() public pure {
        // Test powers of 2 and their neighbors
        uint256[10] memory testCases = [uint256(1), 2, 4, 8, 16, 32, 64, 128, 256, 512];

        for (uint256 i = 0; i < testCases.length; i++) {
            uint256 powerOfTwo = testCases[i];

            assertEq(
                _computeMinimalTreeDepthNaive(powerOfTwo - 1),
                MerkleTree.computeMinimalTreeDepth(powerOfTwo - 1),
                "should match for power of 2 minus 1"
            );

            // Test power of 2
            assertEq(
                _computeMinimalTreeDepthNaive(powerOfTwo),
                MerkleTree.computeMinimalTreeDepth(powerOfTwo),
                "should match for power of 2"
            );

            // Test power of 2 + 1
            assertEq(
                _computeMinimalTreeDepthNaive(powerOfTwo + 1),
                MerkleTree.computeMinimalTreeDepth(powerOfTwo + 1),
                "should match for power of 2 plus 1"
            );
        }
    }

    function test_compare_large_values() public pure {
        // Test some large but realistic values
        uint256[5] memory testCases = [uint256(1000), 10000, 100000, 1000000, 10000000];

        for (uint256 i = 0; i < testCases.length; i++) {
            assertEq(
                _computeMinimalTreeDepthNaive(testCases[i]),
                MerkleTree.computeMinimalTreeDepth(testCases[i]),
                "should match for large values"
            );
        }
    }

    /// @notice Fuzz test with unbounded uint256
    function testFuzz_compare_implementations_unbounded(uint256 leavesCount) public pure {
        leavesCount = bound(leavesCount, 0, type(uint128).max);

        uint8 original = _computeMinimalTreeDepthNaive(leavesCount);
        uint8 optimized = MerkleTree.computeMinimalTreeDepth(leavesCount);

        assertEq(original, optimized, "Implementations must match");
    }

    /// @notice Fuzz test with small values (0-1000)
    function testFuzz_compare_implementations_small(uint256 leavesCount) public pure {
        leavesCount = bound(leavesCount, 0, 1000);

        uint8 original = _computeMinimalTreeDepthNaive(leavesCount);
        uint8 optimized = MerkleTree.computeMinimalTreeDepth(leavesCount);

        assertEq(original, optimized, "Implementations must match");
    }

    /// @notice Fuzz test with medium values (1000-1000000)
    function testFuzz_compare_implementations_medium(uint256 leavesCount) public pure {
        leavesCount = bound(leavesCount, 1000, 1000000);

        uint8 original = _computeMinimalTreeDepthNaive(leavesCount);
        uint8 optimized = MerkleTree.computeMinimalTreeDepth(leavesCount);

        assertEq(original, optimized, "Implementations must match");
    }

    function testFuzz_gas_naive(uint256 leavesCount) public pure {
        leavesCount = bound(leavesCount, 0, 1000000);
        _computeMinimalTreeDepthNaive(leavesCount);
    }

    /// @notice Fuzz test - Optimized implementation only (to measure gas)
    function testFuzz_gas_optimized(uint256 leavesCount) public pure {
        leavesCount = bound(leavesCount, 0, 1000000);
        MerkleTree.computeMinimalTreeDepth(leavesCount);
    }

    /// @notice Hashes two `bytes32` values.
    /// @param a The first value to hash.
    /// @param b The second value to hash.
    /// @return hab The resulting hash.
    function _hashPair(bytes32 a, bytes32 b) internal pure returns (bytes32 hab) {
        hab = SHA256.hash(a, b);
    }

    /// @notice The naive implementation using a loop.
    function _computeMinimalTreeDepthNaive(uint256 leavesCount) internal pure returns (uint8 treeDepth) {
        uint256 treeCapacity = 1;
        treeDepth = 0;

        while (treeCapacity < leavesCount) {
            treeCapacity *= 2;
            ++treeDepth;
        }

        return treeDepth;
    }
}
