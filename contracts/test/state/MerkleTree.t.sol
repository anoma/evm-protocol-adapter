// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {MerkleTreeExample} from "../examples/MerkleTree.e.sol";
import {MerkleTree as ZeppelinMerkleTree} from "@openzeppelin/contracts/utils/structs/MerkleTree.sol";

contract MerkleTreeTest is Test, MerkleTreeExample {
    using MerkleTree for MerkleTree.Tree;
    using MerkleTree for bytes32[];
    using ZeppelinMerkleTree for ZeppelinMerkleTree.Bytes32PushTree;

    MerkleTree.Tree internal _merkleTree;
    MerkleTree.Tree internal _paMerkleTree;
    ZeppelinMerkleTree.Bytes32PushTree internal _zeppelinMerkleTree;

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

    /// @notice Differentially test our Merkle tree implementation against
    /// OpenZeppelin's implementation.
    function testFuzz_push_implementations_yield_same_roots(bytes32[] memory leaves) public {
        // First compute what tree depth is required to store leaves
        uint8 treeDepth = 0;
        // Essentially compute the logarithm of the leaf count base 2
        for (uint256 i = leaves.length; i > 0; i >>= 1) {
            treeDepth++;
        }
        // Set up a protocol adapter Merkle tree and an OpenZeppelin one
        _paMerkleTree.setup();
        // OpenZeppelin implementation is not variable depth, it is easier to
        // just compare the end state once we have reached the final depth
        _zeppelinMerkleTree.setup(treeDepth, SHA256.EMPTY_HASH, SHA256.hash_pair);

        uint256 index1;
        bytes32 newRoot1;
        uint256 index2;
        bytes32 newRoot2;
        // Now add all the leaves to each Merkle tree
        for (uint256 i = 0; i < leaves.length; i++) {
            (index1, newRoot1) = _paMerkleTree.push(leaves[i]);
            (index2, newRoot2) = _zeppelinMerkleTree.push(leaves[i], SHA256.hash_pair);
            // The lead counts must remain matched throughout
            assertEq(index1, index2);
            // Once we have reached the final depth, we might as well start
            // comparing the roots
            if (_paMerkleTree.depth() == _zeppelinMerkleTree.depth()) {
                assertEq(newRoot1, newRoot2);
            }
        }
        // Now confirm that the Merkle trees have the same leaf count
        assertEq(index1, index2);
        // Same roots
        assertEq(newRoot1, newRoot2);
        // Same depths
        assertEq(_paMerkleTree.depth(), _zeppelinMerkleTree.depth());
    }
}
