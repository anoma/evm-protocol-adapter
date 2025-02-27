// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/Test.sol";

import { MerkleProof } from "openzeppelin-contracts/utils/cryptography/MerkleProof.sol";

import { SHA256 } from "../../src/libs/SHA256.sol";

import { CommitmentAccumulatorMock, CommitmentAccumulator } from "./CommitmentAccumulatorMock.sol";

contract ExtCallFake {
    function extCall() external pure { }
}

contract PartiallyFullTreeTest is Test, CommitmentAccumulatorMock {
    uint8 internal constant TREE_DEPTH = 2; // NOTE: 2^2 = 4 nodes
    bytes32 internal constant NON_EXISTENT_LEAF = sha256("NON_EXISTENT");

    bytes32[4] internal leaves;
    bytes32[][4] internal siblings;
    bytes32[2] internal nodes;
    bytes32 internal root;

    constructor() CommitmentAccumulatorMock(TREE_DEPTH) { }

    function setUp() public {
        /*
                R
              /  \
            N0   N1
           / \   / \
          0  [] [] []
        */

        leaves[0] = SHA256.hash(bytes32(0));
        _addCommitment(leaves[0]);
        leaves[1] = EMPTY_LEAF_HASH;
        leaves[2] = EMPTY_LEAF_HASH;
        leaves[3] = EMPTY_LEAF_HASH;

        nodes[0] = SHA256.commutativeHash(leaves[0], leaves[1]);
        nodes[1] = SHA256.commutativeHash(leaves[2], leaves[3]);

        root = SHA256.commutativeHash(nodes[0], nodes[1]);

        siblings[0] = new bytes32[](2);
        siblings[0][0] = leaves[1];
        siblings[0][1] = nodes[1];

        siblings[1] = new bytes32[](2);
        siblings[1][0] = leaves[0];
        siblings[1][1] = nodes[1];

        siblings[2] = new bytes32[](2);
        siblings[2][0] = leaves[3];
        siblings[2][1] = nodes[0];

        siblings[3] = new bytes32[](2);
        siblings[3][0] = leaves[2];
        siblings[3][1] = nodes[0];
    }

    function test_should_have_expected_nodes() public view {
        assertEq(nodes[0], SHA256.commutativeHash(leaves[0], EMPTY_LEAF_HASH));
        assertEq(nodes[1], merkleTree._zeros[1]);
    }

    function test_should_have_the_expected_root() public view {
        assertEq(root, _latestRoot());
    }

    function test_should_check_merkle_paths() public view {
        _checkMerklePath(root, leaves[0], siblings[0]);
        _checkMerklePath(root, leaves[1], siblings[1]);
        _checkMerklePath(root, leaves[2], siblings[2]);
        _checkMerklePath(root, leaves[3], siblings[3]);
    }

    function test_find_commitment_index() public view {
        assertEq(0, _findCommitmentIndex(leaves[0]));
    }

    // https://book.getfoundry.sh/cheatcodes/expect-revert?highlight=revert#description
    /// forge-config: default.allow_internal_expect_revert = true
    function test_find_commitment_index_reverts_for_empty_commitment() public {
        vm.expectRevert(CommitmentAccumulatorMock.EmptyCommitment.selector);

        _findCommitmentIndex(EMPTY_LEAF_HASH);
    }

    function test_should_compute_merkle_path() public view {
        assertEq(_computeMerklePath(leaves[0]), siblings[0]);
    }

    function test_should_produce_an_invalid_root_for_a_non_existent_leaf() public view {
        bytes32 invalidRoot = SHA256.commutativeHash(SHA256.commutativeHash(NON_EXISTENT_LEAF, leaves[1]), nodes[1]);

        bytes32 computedRoot =
            MerkleProof.processProof({ proof: siblings[0], leaf: NON_EXISTENT_LEAF, hasher: SHA256.commutativeHash });

        assertNotEq(computedRoot, root);
        assertEq(computedRoot, invalidRoot);
    }
}
