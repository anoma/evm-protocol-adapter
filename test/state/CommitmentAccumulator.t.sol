// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {MerkleProof} from "@openzeppelin-contracts/utils/cryptography/MerkleProof.sol";
import {Test} from "forge-std/Test.sol";

import {ICommitmentAccumulator} from "../../src/interfaces/ICommitmentAccumulator.sol";
import {SHA256} from "../../src/libs/SHA256.sol";

import {CommitmentAccumulatorMock} from "../mocks/CommitmentAccumulatorMock.sol";
import {ICommitmentAccumulatorMock} from "../mocks/ICommitmentAccumulatorMock.sol";
import {ImprovedCommitmentAccumulatorMock} from "../mocks/ImprovedCommitmentAccumulatorMock.sol";

contract Base is Test {
    uint8 internal constant _TREE_DEPTH = 2; // NOTE: 2^2 = 4 _nodes

    uint256 internal constant _N_LEAFS = 2 ** _TREE_DEPTH;
    uint256 internal constant _N_NODES = 2 ** (_TREE_DEPTH - 1);
    uint256 internal constant _N_ROOTS = _N_LEAFS + 1;

    bytes32[4][5] internal _leaves;
    bytes32[][4][5] internal _siblings; // 2
    bytes32[2][5] internal _nodes;
    bytes32[5] internal _roots;

    ICommitmentAccumulatorMock internal _cmAcc;

    constructor(ICommitmentAccumulatorMock cmAcc) {
        _cmAcc = cmAcc;
    }

    function setUp() public {
        /*
                R
              /  \
            N0   N1
           / \   / \
          0  1  2  3
        */

        bytes32 emptyLeafHash = _cmAcc.emptyLeafHash();

        for (uint256 i = 0; i < _N_ROOTS; ++i) {
            for (uint256 j = 0; j < i; ++j) {
                _leaves[i][j] = SHA256.hash(bytes32(j));
            }

            for (uint256 j = i; j < _N_ROOTS - 1; ++j) {
                _leaves[i][j] = emptyLeafHash;
            }

            _nodes[i][0] = SHA256.commutativeHash(_leaves[i][0], _leaves[i][1]);
            _nodes[i][1] = SHA256.commutativeHash(_leaves[i][2], _leaves[i][3]);
            _roots[i] = SHA256.commutativeHash(_nodes[i][0], _nodes[i][1]);

            _siblings[i][0] = new bytes32[](2);
            _siblings[i][0][0] = _leaves[i][1];
            _siblings[i][0][1] = _nodes[i][1];

            _siblings[i][1] = new bytes32[](2);
            _siblings[i][1][0] = _leaves[i][0];
            _siblings[i][1][1] = _nodes[i][1];

            _siblings[i][2] = new bytes32[](2);
            _siblings[i][2][0] = _leaves[i][3];
            _siblings[i][2][1] = _nodes[i][0];

            _siblings[i][3] = new bytes32[](2);
            _siblings[i][3][0] = _leaves[i][2];
            _siblings[i][3][1] = _nodes[i][0];
        }
    }

    function test_latestRoot_should_return_correct_roots() public {
        bytes32 initialRoot = _cmAcc.latestRoot();

        assertEq(initialRoot, _roots[0]);
        assertEq(initialRoot, _cmAcc.initialRoot());

        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            assertEq(_cmAcc.addCommitment(_leaves[i + 1][i]), _roots[i + 1]);
        }
    }

    function test_computeMerklePath_reverts_for_empty_hash() public {
        bytes32 emptyLeafHash = _cmAcc.emptyLeafHash();
        vm.expectRevert(ICommitmentAccumulator.EmptyCommitment.selector);
        _cmAcc.computeMerklePath(emptyLeafHash);
    }

    function test_computeMerklePath_should_return_correct_siblings() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            _cmAcc.addCommitment(_leaves[i + 1][i]);

            for (uint256 j = 0; j < i; ++j) {
                assertEq(_cmAcc.computeMerklePath(_leaves[i + 1][j]), _siblings[i + 1][j]);
            }
        }
    }

    function test_findCommitmentIndex_should_return_correct_indices() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            _cmAcc.addCommitment(_leaves[i + 1][i]);

            for (uint256 j = 0; j <= i; ++j) {
                assertEq(j, _cmAcc.findCommitmentIndex(_leaves[i + 1][j]));
            }
        }
    }

    function test_findCommitmentIndex_reverts_on_empty_commitment() public {
        bytes32 emptyLeafHash = _cmAcc.emptyLeafHash();
        vm.expectRevert(ICommitmentAccumulator.EmptyCommitment.selector);
        _cmAcc.findCommitmentIndex(emptyLeafHash);
    }

    function test_addCommitment_should_add_commitments() public {
        uint256 prevCount = 0;
        uint256 newCount = 0;

        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            _cmAcc.addCommitment(_leaves[i + 1][i]);
            newCount = _cmAcc.commitmentCount();

            assertEq(newCount, ++prevCount);
            prevCount = newCount;
        }
    }

    function test_addCommitment_reverts_on_duplicate() public {
        bytes32 cm = sha256("SOME_COMMITMENT");
        _cmAcc.addCommitment(cm);

        vm.expectRevert(abi.encodeWithSelector(ICommitmentAccumulator.PreExistingCommitment.selector, cm));
        _cmAcc.addCommitment(cm);
    }

    function test_findCommitmentIndex_reverts_on_non_existent_commitment() public {
        bytes32 nonExistentCommitment = sha256("NO_N_EXISTENT");
        vm.expectRevert(
            abi.encodeWithSelector(ICommitmentAccumulator.NonExistingCommitment.selector, nonExistentCommitment)
        );
        _cmAcc.findCommitmentIndex(nonExistentCommitment);
    }

    function test_commitmentAtIndex_reverts_on_non_existent_index() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            uint256 commitmentCount = _cmAcc.commitmentCount();

            vm.expectRevert(
                abi.encodeWithSelector(ICommitmentAccumulator.CommitmentIndexOutOfBounds.selector, i, commitmentCount)
            );
            _cmAcc.commitmentAtIndex(i);
        }
    }

    function test_should_produce_an_invalid_root_for_a_non_existent_leaf() public {
        bytes32 nonExistentCommitment = sha256("NO_N_EXISTENT");

        // Test empty tree
        bytes32 root = _cmAcc.initialRoot();
        bytes32 invalidRoot = SHA256.commutativeHash(
            SHA256.commutativeHash(nonExistentCommitment, _siblings[0][0][0]), _siblings[0][0][1]
        );

        bytes32 computedRoot = MerkleProof.processProof({
            proof: _siblings[0][0],
            leaf: nonExistentCommitment,
            hasher: SHA256.commutativeHash
        });
        assertNotEq(computedRoot, root);
        assertEq(computedRoot, invalidRoot);

        // Populated tree
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            root = _cmAcc.addCommitment(_leaves[i + 1][i]);

            for (uint256 j = 0; j <= i; ++j) {
                invalidRoot = SHA256.commutativeHash(
                    SHA256.commutativeHash(nonExistentCommitment, _siblings[i + 1][j][0]), _siblings[i + 1][j][1]
                );

                computedRoot = MerkleProof.processProof({
                    proof: _siblings[i + 1][j],
                    leaf: nonExistentCommitment,
                    hasher: SHA256.commutativeHash
                });

                assertNotEq(computedRoot, root);
                assertEq(computedRoot, invalidRoot);
            }
        }
    }
}

contract ImprovedCommitmentAccumulatorTest is Base {
    constructor() Base(new ImprovedCommitmentAccumulatorMock(_TREE_DEPTH)) {}
}

contract CommitmentAccumulatorTest is Base {
    constructor() Base(new CommitmentAccumulatorMock(_TREE_DEPTH)) {}
}
