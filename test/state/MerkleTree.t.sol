// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {MockTree} from "../mocks/MockTree.sol";

contract MerkleTreeTest is Test, MockTree {
    using MerkleTree for MerkleTree.Tree;
    using MerkleTree for bytes32[];

    MerkleTree.Tree internal _merkleTree;

    constructor() {
        _setupMockTree();
    }

    function setUp() public {
        _merkleTree.setup(_TREE_DEPTH);
    }

    function test_push_reverts_on_exceeded_tree_capacity() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            _merkleTree.push(_leaves[4][i]);
        }
        assertEq(_merkleTree.leafCount(), _TREE_DEPTH ** 2);

        bytes32 newLeaf = sha256("NEW LEAF");

        vm.expectRevert(MerkleTree.TreeCapacityExceeded.selector);
        _merkleTree.push(newLeaf);
    }

    function test_setup_returns_the_expected_initial_root() public {
        assertEq(_merkleTree.setup(_TREE_DEPTH), _roots[0]);
    }
}
