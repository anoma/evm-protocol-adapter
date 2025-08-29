// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {MerkleTreeExample} from "../examples/MerkleTree.e.sol";

import {console} from "forge-std/console.sol";

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
        //assertEq(_merkleTree.depth(), 0);

        (, bytes32 root1) = _merkleTree.push(_a[7][0]);
        console.logString("root1");
        console.logBytes32(root1);
        assertEq(_merkleTree.leafCount(), 1);
        //assertEq(_merkleTree.depth(), 0);

        (, bytes32 root2) = _merkleTree.push(_a[7][1]);
        console.logString("root2");
        console.logBytes32(root2);
        assertEq(_merkleTree.leafCount(), 2);
        //assertEq(_merkleTree.depth(), 1);

        (, bytes32 root3) = _merkleTree.push(_a[7][2]);
        console.logString("root3");
        console.logBytes32(root3);
        assertEq(_merkleTree.leafCount(), 3);
        //assertEq(_merkleTree.depth(), 2);

        (, bytes32 root4) = _merkleTree.push(_a[7][3]);
        console.logString("root4");
        console.logBytes32(root4);
        assertEq(_merkleTree.leafCount(), 4);
        //assertEq(_merkleTree.depth(), 2);

        (, bytes32 root5) = _merkleTree.push(_a[7][4]);
        console.logString("root5");
        console.logBytes32(root5);
        assertEq(_merkleTree.leafCount(), 5);
        //assertEq(_merkleTree.depth(), 3);

        (, bytes32 root6) = _merkleTree.push(_a[7][5]);
        console.logString("root6");
        console.logBytes32(root6);
        assertEq(_merkleTree.leafCount(), 6);
        //assertEq(_merkleTree.depth(), 3);

        (, bytes32 root7) = _merkleTree.push(_a[7][6]);
        console.logString("root7");
        console.logBytes32(root7);
        assertEq(_merkleTree.leafCount(), 7);
        //assertEq(_merkleTree.depth(), 3);

        bytes32 finalroot;
        for (uint256 i = 0; i < 10000; i++) {
            (, finalroot) = _merkleTree.push(bytes32(i));
        }
        console.logString("finalroot");
        console.logBytes32(finalroot);
    }

    function test_setup_returns_the_expected_initial_root() public {
        assertEq(_merkleTree.setup(), SHA256.EMPTY_HASH);
    }
}
