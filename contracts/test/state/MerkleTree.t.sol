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
        assertEq(_merkleTree.setup(), _roots[0]);
        assertEq(_merkleTree.leafCount(), 0);
        assertEq(_merkleTree.depth(), 0);

        _merkleTree.push(_leaves[7][0]);
        assertEq(_merkleTree.leafCount(), 1);
        assertEq(_merkleTree.depth(), 1);

        _merkleTree.push(_leaves[7][1]);
        assertEq(_merkleTree.leafCount(), 2);
        assertEq(_merkleTree.depth(), 2);

        _merkleTree.push(_leaves[7][2]);
        assertEq(_merkleTree.leafCount(), 3);
        assertEq(_merkleTree.depth(), 2);

        _merkleTree.push(_leaves[7][3]);
        assertEq(_merkleTree.leafCount(), 4);
        assertEq(_merkleTree.depth(), 3);

        _merkleTree.push(_leaves[7][4]);
        assertEq(_merkleTree.leafCount(), 5);
        assertEq(_merkleTree.depth(), 3);

        _merkleTree.push(_leaves[7][5]);
        assertEq(_merkleTree.leafCount(), 6);
        assertEq(_merkleTree.depth(), 3);

        _merkleTree.push(_leaves[7][6]);
        assertEq(_merkleTree.leafCount(), 7);
        assertEq(_merkleTree.depth(), 3);
    }

    function test_setup_returns_the_expected_initial_root() public {
        assertEq(_merkleTree.setup(), SHA256.EMPTY_HASH);
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
            assertEq(paIndex, ozIndex);
            // Once we have reached the final depth, we might as well start
            // comparing the roots
            if (_paMerkleTree.depth() == _ozMerkleTree.depth()) {
                assertEq(paRoot, ozRoot);
            }
        }
        // Now confirm that the Merkle trees have the same leaf count
        assertEq(paIndex, ozIndex);
        // Same roots
        assertEq(paRoot, ozRoot);
        // Same depths
        assertEq(_paMerkleTree.depth(), _ozMerkleTree.depth());
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
        assertEq(_computeMinimalTreeDepthNaive(0), MerkleTree.computeMinimalTreeDepth(0));
        assertEq(MerkleTree.computeMinimalTreeDepth(0), 0);
    }

    function test_computeMinimalTreeDepth_computes_the_right_tree_depths() public pure {
        uint8[34] memory depths =
            [0, 0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6];

        for (uint256 i = 0; i < depths.length; ++i) {
            assertEq(MerkleTree.computeMinimalTreeDepth({leavesCount: i}), depths[i]);
        }
    }

    function test_computeMinimalTreeDepth_reproduces_tree_depths_of_the_naive_implementation() public pure {
        uint256 maxLeafCount = 16;

        for (uint256 i = 0; i < maxLeafCount; ++i) {
            assertEq(
                _computeMinimalTreeDepthNaive({leavesCount: i}), MerkleTree.computeMinimalTreeDepth({leavesCount: i})
            );
        }
    }

    function test_compare_power_of_two_boundaries() public pure {
        // Test powers of 2 and their neighbors
        uint256[10] memory testCases = [uint256(1), 2, 4, 8, 16, 32, 64, 128, 256, 512];

        for (uint256 i = 0; i < testCases.length; i++) {
            uint256 powerOfTwo = testCases[i];

            assertEq(_computeMinimalTreeDepthNaive(powerOfTwo - 1), MerkleTree.computeMinimalTreeDepth(powerOfTwo - 1));

            // Test power of 2
            assertEq(_computeMinimalTreeDepthNaive(powerOfTwo), MerkleTree.computeMinimalTreeDepth(powerOfTwo));

            // Test power of 2 + 1
            assertEq(_computeMinimalTreeDepthNaive(powerOfTwo + 1), MerkleTree.computeMinimalTreeDepth(powerOfTwo + 1));
        }
    }

    function test_compare_large_values() public pure {
        // Test some large but realistic values
        uint256[5] memory testCases = [uint256(1000), 10000, 100000, 1000000, 10000000];

        for (uint256 i = 0; i < testCases.length; i++) {
            assertEq(_computeMinimalTreeDepthNaive(testCases[i]), MerkleTree.computeMinimalTreeDepth(testCases[i]));
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
