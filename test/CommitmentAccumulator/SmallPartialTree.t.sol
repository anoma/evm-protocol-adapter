// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { MerkleProof } from "@openzeppelin-contracts/utils/cryptography/MerkleProof.sol";
import { Test } from "forge-std/Test.sol";

import { SHA256 } from "../../src/libs/SHA256.sol";
import { CommitmentAccumulatorMock } from "./CommitmentAccumulatorMock.sol";

contract PartiallyFullTreeTest is Test {
    uint8 internal constant _TREE_DEPTH = 2; // NOTE: 2^2 = 4 _nodes
    bytes32 internal constant _NON_EXISTENT_LEAF = sha256("NON_EXISTENT");

    bytes32[4] internal _leaves;
    bytes32[][4] internal _siblings;
    bytes32[2] internal _nodes;
    bytes32 internal _root;

    CommitmentAccumulatorMock _cmAcc;

    constructor() {
        _cmAcc = new CommitmentAccumulatorMock(_TREE_DEPTH);
    }

    function setUp() public {
        /*
                R
              /  \
            N0   N1
           / \   / \
          0  [] [] []
        */

        bytes32 emptyLeafHash = _cmAcc.emptyLeafHash();

        _leaves[0] = SHA256.hash(bytes32(0));
        _cmAcc.addCommitment(_leaves[0]);
        _leaves[1] = emptyLeafHash;
        _leaves[2] = emptyLeafHash;
        _leaves[3] = emptyLeafHash;

        _nodes[0] = SHA256.commutativeHash(_leaves[0], _leaves[1]);
        _nodes[1] = SHA256.commutativeHash(_leaves[2], _leaves[3]);

        _root = SHA256.commutativeHash(_nodes[0], _nodes[1]);

        _siblings[0] = new bytes32[](2);
        _siblings[0][0] = _leaves[1];
        _siblings[0][1] = _nodes[1];

        _siblings[1] = new bytes32[](2);
        _siblings[1][0] = _leaves[0];
        _siblings[1][1] = _nodes[1];

        _siblings[2] = new bytes32[](2);
        _siblings[2][0] = _leaves[3];
        _siblings[2][1] = _nodes[0];

        _siblings[3] = new bytes32[](2);
        _siblings[3][0] = _leaves[2];
        _siblings[3][1] = _nodes[0];
    }

    function test_find_commitment_index_reverts_for_empty_commitment() public {
        bytes32 emptyLeafHash = _cmAcc.emptyLeafHash();

        vm.expectRevert(CommitmentAccumulatorMock.EmptyCommitment.selector);
        _cmAcc.findCommitmentIndex(emptyLeafHash);
    }

    function test_should_have_expected__nodes() public view {
        assertEq(_nodes[0], SHA256.commutativeHash(_leaves[0], _cmAcc.emptyLeafHash()));
        assertEq(_nodes[1], _cmAcc.merkleTreeZero({ level: 1 }));
    }

    function test_should_have_the_expected__root() public view {
        assertEq(_root, _cmAcc.latestRoot());
    }

    function test_should_check_merkle_paths() public view {
        _cmAcc.checkMerklePath(_root, _leaves[0], _siblings[0]);
        _cmAcc.checkMerklePath(_root, _leaves[1], _siblings[1]);
        _cmAcc.checkMerklePath(_root, _leaves[2], _siblings[2]);
        _cmAcc.checkMerklePath(_root, _leaves[3], _siblings[3]);
    }

    function test_find_commitment_index() public view {
        assertEq(0, _cmAcc.findCommitmentIndex(_leaves[0]));
    }

    function test_should_compute_merkle_path() public view {
        assertEq(_cmAcc.computeMerklePath(_leaves[0]), _siblings[0]);
    }

    function test_should_produce_an_invalid__root_for_a_non_existent_leaf() public view {
        bytes32 invalidRoot = SHA256.commutativeHash(SHA256.commutativeHash(_NON_EXISTENT_LEAF, _leaves[1]), _nodes[1]);

        bytes32 computedRoot =
            MerkleProof.processProof({ proof: _siblings[0], leaf: _NON_EXISTENT_LEAF, hasher: SHA256.commutativeHash });

        assertNotEq(computedRoot, _root);
        assertEq(computedRoot, invalidRoot);
    }
}
