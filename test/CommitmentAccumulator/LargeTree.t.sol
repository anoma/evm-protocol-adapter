// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";

import {SHA256} from "../../src/libs/SHA256.sol";

import {CommitmentAccumulatorMock} from "./CommitmentAccumulatorMock.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract LargeTreeTest is Test, CommitmentAccumulatorMock {
    uint8 internal constant TREE_DEPTH = 10; // Use 20
    bytes32 internal constant NON_EXISTENT_LEAF = sha256("NON_EXISTENT");

    bytes32[] internal leaves;
    bytes32 internal root;

    constructor() CommitmentAccumulatorMock(TREE_DEPTH) {}

    function setUp() public {
        /*
                R
              /  \
            N0   N1
           / \   / \
          0  1  2  3
        */
        leaves = new bytes32[](2 ** TREE_DEPTH);
        for (uint256 i = 0; i < 2 ** TREE_DEPTH; ++i) {
            leaves[i] = SHA256.hash(bytes32(i));
            _addCommitment(leaves[i]);
        }
    }

    function test_check_path() public view {
        bytes32 cm = SHA256.hash(bytes32(0));
        bytes32 rt = _latestRoot();
        bytes32[] memory path = _computeMerklePath(cm);

        _checkMerklePath(rt, cm, path);
    }
}
