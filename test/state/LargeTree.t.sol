// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Test } from "forge-std/Test.sol";

import { SHA256 } from "../../src/libs/SHA256.sol";

import { CommitmentAccumulatorMock } from "../mocks/CommitmentAccumulatorMock.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract LargeTreeTest is Test {
    uint8 internal constant _TREE_DEPTH = 10; // Use 20

    bytes32[] internal _leaves;
    bytes32 internal _root;
    CommitmentAccumulatorMock internal _cmAcc;

    constructor() {
        _cmAcc = new CommitmentAccumulatorMock(_TREE_DEPTH);
    }

    function setUp() public {
        /*
                R
              /  \
            N0   N1
           / \   / \
          0  1  2  3
        */
        _leaves = new bytes32[](2 ** _TREE_DEPTH);
        for (uint256 i = 0; i < 2 ** _TREE_DEPTH; ++i) {
            _leaves[i] = SHA256.hash(bytes32(i));
            _cmAcc.addCommitment(_leaves[i]);
        }
    }

    function test_checkPath() public view {
        bytes32 cm = SHA256.hash(bytes32(0));
        bytes32 rt = _cmAcc.latestRoot();
        bytes32[] memory path = _cmAcc.computeMerklePath(cm);

        _cmAcc.checkMerklePath(rt, cm, path);
    }
}
