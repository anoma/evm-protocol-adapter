// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {MerkleTreeExample} from "../examples/MerkleTree.e.sol";

contract MerkleTreeTest is Test, MerkleTreeExample {
    using MerkleTree for MerkleTree.Tree;
    using MerkleTree for bytes32[];

    MerkleTree.Tree internal _merkleTree;

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
}
