// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25 <0.9.0;

import {Test} from "forge-std/Test.sol";

import {MerkleProof} from "openzeppelin-contracts/utils/cryptography/MerkleProof.sol";

import {SHA256} from "../../src/libs/SHA256.sol";

import {CommitmentAccumulatorMock} from "./CommitmentAccumulatorMock.sol";

contract FullTreeTest is Test, CommitmentAccumulatorMock {
    uint8 internal constant TREE_DEPTH = 2; // NOTE: 2^2 = 4 nodes
    bytes32 internal constant NON_EXISTENT_LEAF = sha256("NON_EXISTENT");

    bytes32[4] internal leaves;
    bytes32[][4] internal siblings;
    bytes32[2] internal nodes;
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

        for (uint256 i = 0; i < 2 ** TREE_DEPTH; ++i) {
            leaves[i] = SHA256.hash(bytes32(i));
            _addCommitment(leaves[i]);
        }

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

    function test_should_have_the_expected_root() public view {
        assertEq(root, _latestRoot());
    }

    // /// forge-config: default.allow_internal_expect_revert = true
    function testFail_should_revert_if_max_nodes_are_reached_after() public {
        vm.expectRevert();
        // TODO find out how to expect this error with foundry.
        //vm.expectRevert("panic: memory allocation error (0x41)");
        _addCommitment(bytes32(uint256(4)));
    }

    function test_should_check_merkle_paths() public view {
        _checkMerklePath(root, leaves[0], siblings[0]);
        _checkMerklePath(root, leaves[1], siblings[1]);
        _checkMerklePath(root, leaves[2], siblings[2]);
        _checkMerklePath(root, leaves[3], siblings[3]);
    }

    function test_should_find_commitment_index() public view {
        for (uint256 i = 0; i < leaves.length; ++i) {
            assertEq(i, _findCommitmentIndex(leaves[i]));
        }
    }

    function test_compute_merkle_path() public view {
        for (uint256 i = 0; i < leaves.length; ++i) {
            assertEq(_computeMerklePath(leaves[i]), siblings[i]);
        }
    }

    function test_should_produce_an_invalid_root_for_a_non_existent_leaf() public view {
        bytes32 invalidRoot = SHA256.commutativeHash(SHA256.commutativeHash(NON_EXISTENT_LEAF, leaves[1]), nodes[1]);

        bytes32 computedRoot =
            MerkleProof.processProof({proof: siblings[0], leaf: NON_EXISTENT_LEAF, hasher: SHA256.commutativeHash});

        assertNotEq(computedRoot, root);
        assertEq(computedRoot, invalidRoot);
    }
}
