// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {MerkleProof} from "@openzeppelin-contracts/utils/cryptography/MerkleProof.sol";
import {Test} from "forge-std/Test.sol";

import {SHA256} from "../../src/libs/SHA256.sol";

import {CommitmentAccumulator} from "../../src/state/CommitmentAccumulator.sol";
import {ICommitmentAccumulator} from "../../src/interfaces/ICommitmentAccumulator.sol";
import {ImprovedCommitmentAccumulator} from "../../src/state/ImprovedCommitmentAccumulator.sol";
import {ImprovedMerkleTree} from "../../src/state/ImprovedMerkleTree.sol";

import {CommitmentAccumulatorMock} from "../mocks/CommitmentAccumulatorMock.sol";
import {ImprovedCommitmentAccumulatorMock} from "../mocks/ImprovedCommitmentAccumulatorMock.sol";
import {ICommitmentAccumulatorMock} from "../mocks/ICommitmentAccumulatorMock.sol";

import {console} from "forge-std/console.sol";

contract Base is Test {
    uint8 internal constant _TREE_DEPTH = 2; // NOTE: 2^2 = 4 _nodes

    /// @dev sha256("NON_EXISTENT");
    bytes32 internal constant _NON_EXISTENT_LEAF = 0x876515d057234b0fd4991e64ba758c5971d578d2385f182a5a264f6019761dd6;

    uint256 internal constant N_LEAFS = 2 ** _TREE_DEPTH;
    uint256 internal constant N_NODES = 2 ** (_TREE_DEPTH - 1);

    bytes32[4][4] internal _leaves;
    bytes32[][4][4] internal _siblings; // 2
    bytes32[2][4] internal _nodes;
    bytes32[4] internal _roots;

    ICommitmentAccumulatorMock _cmAcc;

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

        bytes32 emptyLeafHash = ImprovedMerkleTree._EMPTY_LEAF_HASH;

        for (uint256 i = 0; i < N_LEAFS; ++i) {
            for (uint256 j = 0; j <= i; ++j) {
                _leaves[i][j] = SHA256.hash(bytes32(j));
                //console.log(i, j, vm.toString(_leaves[i][j]));
            }
            for (uint256 j = i + 1; j < N_LEAFS; ++j) {
                _leaves[i][j] = emptyLeafHash;
                //console.log(i, j, "'", vm.toString(_leaves[i][j]));
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
        for (uint256 i = 0; i < N_LEAFS; ++i) {
            _cmAcc.addCommitment(_leaves[i][i]);
            assertEq(_cmAcc.latestRoot(), _roots[i]);
        }
    }

    function test_computeMerklePath_should_return_correct_siblings() public {
        for (uint256 i = 0; i < N_LEAFS; ++i) {
            _cmAcc.addCommitment(_leaves[i][i]);

            for (uint256 j = 0; j <= i; ++j) {
                assertEq(_cmAcc.computeMerklePath(_leaves[i][j]), _siblings[i][j]);
            }
        }
    }

    function test_findCommitmentIndex_should_return_correct_indices() public {
        for (uint256 i = 0; i < N_LEAFS; ++i) {
            _cmAcc.addCommitment(_leaves[i][i]);

            for (uint256 j = 0; j <= i; ++j) {
                assertEq(j, _cmAcc.findCommitmentIndex(_leaves[i][j]));
            }
        }
    }

    function test_findCommitmentIndex_should_revert_on_empty_commitment() public {
        bytes32 emptyLeafHash = _cmAcc.emptyLeafHash();
        vm.expectRevert(ICommitmentAccumulator.EmptyCommitment.selector);
        _cmAcc.findCommitmentIndex(emptyLeafHash);
    }

    // function test_findCommitmentIndex_should_panic() public {
    //     uint256 cmCount = _cmAcc.commitmentCount();
    //     uint256 index = 0;
    //
    //     //vm.expectRevert(
    //     //    abi.encodeWithSelector(ICommitmentAccumulator.CommitmentIndexOutOfBounds.selector, index, cmCount)
    //     //);
    //
    //     vm.expectRevert(abi.encodeWithSelector(ICommitmentAccumulator.NonExistingCommitment.selector, cm));
    //
    //     _cmAcc.findCommitmentIndex(_NON_EXISTENT_LEAF);
    // }

    function test_addCommitment_should_add_commitments() public {
        uint256 prevCount = 0;
        uint256 newCount = 0;

        for (uint256 i = 0; i < N_LEAFS; ++i) {
            _cmAcc.addCommitment(_leaves[i][i]);
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

    function test_findCommitmentIndex_should_revert_on_non_existent_commitment() public {
        vm.expectRevert(
            abi.encodeWithSelector(ICommitmentAccumulator.NonExistingCommitment.selector, _NON_EXISTENT_LEAF)
        );
        _cmAcc.findCommitmentIndex(_NON_EXISTENT_LEAF);
    }

    function test_commitmentAtIndex_should_revert_on_non_existent_index() public {
        for (uint256 i = 0; i < N_LEAFS; ++i) {
            uint256 commitmentCount = _cmAcc.commitmentCount();

            vm.expectRevert(
                abi.encodeWithSelector(ICommitmentAccumulator.CommitmentIndexOutOfBounds.selector, i, commitmentCount)
            );
            _cmAcc.commitmentAtIndex(i);
        }
    }

    /*
    function test_findCommitmentIndex_reverts_on_non_existent_leaf() public {
        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.NonExistingCommitment.selector, _NON_EXISTENT_LEAF)
        );
        _cmAcc.findCommitmentIndex(_NON_EXISTENT_LEAF);
    }
    */
    function test_should_produce_an_invalid_root_for_a_non_existent_leaf() public {
        for (uint256 i = 0; i < N_LEAFS; ++i) {
            _cmAcc.addCommitment(_leaves[i][i]);
            bytes32 root = _cmAcc.latestRoot();

            for (uint256 j = 0; j <= i; ++j) {
                bytes32 invalidRoot = SHA256.commutativeHash(
                    SHA256.commutativeHash(_NON_EXISTENT_LEAF, _siblings[i][j][0]), _siblings[i][j][1]
                );

                bytes32 computedRoot = MerkleProof.processProof({
                    proof: _siblings[i][j],
                    leaf: _NON_EXISTENT_LEAF,
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
