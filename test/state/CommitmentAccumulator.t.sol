// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Test } from "forge-std/Test.sol";

import { SHA256 } from "../../src/libs/SHA256.sol";
import { CommitmentAccumulator } from "../../src/state/CommitmentAccumulator.sol";
import { MerkleTree } from "../../src/state/MerkleTree.sol";

import { CommitmentAccumulatorMock } from "../mocks/CommitmentAccumulatorMock.sol";
import { MockTree } from "../mocks/MockTree.sol";

contract CommitmentAccumulatorTest is Test, MockTree {
    using MerkleTree for bytes32[];

    CommitmentAccumulatorMock internal _cmAcc;

    constructor() {
        _setupMockTree();
        _cmAcc = new CommitmentAccumulatorMock(_TREE_DEPTH);
    }

    function test_latestRoot_should_return_correct_roots() public {
        bytes32 initialRoot = _cmAcc.latestRoot();

        assertEq(initialRoot, _roots[0]);
        assertEq(initialRoot, _cmAcc.initialRoot());

        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            assertEq(_cmAcc.addCommitment(_leaves[i + 1][i]), _roots[i + 1]);
        }
    }

    function test_merkleProof_reverts_for_empty_hash() public {
        bytes32 emptyLeafHash = _cmAcc.emptyLeafHash();
        vm.expectRevert(CommitmentAccumulator.EmptyCommitment.selector);
        _cmAcc.merkleProof(emptyLeafHash);
    }

    function test_merkleProof_should_return_correct_siblings_and_direction_bits() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            _cmAcc.addCommitment(_leaves[i + 1][i]);

            for (uint256 j = 0; j < i + 1; ++j) {
                (bytes32[] memory path, uint256 directionBits,) = _cmAcc.merkleProof(_leaves[i + 1][j]);

                assertEq(path, _siblings[i + 1][j]);
                assertEq(directionBits, _directionBits[j]);
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
        vm.expectRevert(CommitmentAccumulator.EmptyCommitment.selector);
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
        bytes32 cm = sha256("SOMETHING");
        _cmAcc.addCommitment(cm);

        vm.expectRevert(abi.encodeWithSelector(CommitmentAccumulator.PreExistingCommitment.selector, cm));
        _cmAcc.addCommitment(cm);
    }

    function test_findCommitmentIndex_reverts_on_non_existent_commitment() public {
        bytes32 nonExistentCommitment = sha256("NON_EXISTENT");
        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.NonExistingCommitment.selector, nonExistentCommitment)
        );
        _cmAcc.findCommitmentIndex(nonExistentCommitment);
    }

    function test_commitmentAtIndex_reverts_on_non_existent_index() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            uint256 commitmentCount = _cmAcc.commitmentCount();

            vm.expectRevert(
                abi.encodeWithSelector(CommitmentAccumulator.CommitmentIndexOutOfBounds.selector, i, commitmentCount)
            );
            _cmAcc.commitmentAtIndex(i);
        }
    }

    function test_should_produce_an_invalid_root_for_a_non_existent_leaf() public {
        bytes32 nonExistentCommitment = sha256("NON_EXISTENT");

        // Test empty tree
        bytes32 root = _cmAcc.initialRoot();
        bytes32 invalidRoot = SHA256.hash(SHA256.hash(nonExistentCommitment, _siblings[0][0][0]), _siblings[0][0][1]);

        bytes32 computedRoot = MerkleTree.processProof({
            siblings: _siblings[0][0],
            directionBits: _directionBits[0],
            leaf: nonExistentCommitment
        });
        assertNotEq(computedRoot, root);
        assertEq(computedRoot, invalidRoot);

        // Populated tree
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            root = _cmAcc.addCommitment(_leaves[i + 1][i]);

            for (uint256 j = 0; j <= i; ++j) {
                // Depth 0
                invalidRoot = MerkleTree.isLeftSibling(_directionBits[j], 0)
                    ? SHA256.hash(_siblings[i + 1][j][0], nonExistentCommitment)
                    : SHA256.hash(nonExistentCommitment, _siblings[i + 1][j][0]);

                // Depth 1
                invalidRoot = MerkleTree.isLeftSibling(_directionBits[j], 1)
                    ? SHA256.hash(_siblings[i + 1][j][1], invalidRoot)
                    : SHA256.hash(invalidRoot, _siblings[i + 1][j][1]);

                computedRoot = MerkleTree.processProof({
                    siblings: _siblings[i + 1][j],
                    directionBits: _directionBits[j],
                    leaf: nonExistentCommitment
                });

                assertNotEq(computedRoot, root);
                assertEq(computedRoot, invalidRoot);
            }
        }
    }

    function test_checkPath_should_pass_on_valid_inputs() public {
        bytes32 cm = sha256("SOMETHING");
        _cmAcc.storeRoot(_cmAcc.addCommitment(cm));

        (bytes32[] memory path, uint256 directionBits, bytes32 latestRoot) = _cmAcc.merkleProof(cm);

        _cmAcc.verifyMerkleProof({ root: latestRoot, commitment: cm, path: path, directionBits: directionBits });
    }

    function test_checkPath_reverts_on_non_existent_root() public {
        bytes32 nonExistingRoot = sha256("NON_EXISTENT_ROOT");

        vm.expectRevert(abi.encodeWithSelector(CommitmentAccumulator.NonExistingRoot.selector, nonExistingRoot));
        _cmAcc.verifyMerkleProof({
            root: nonExistingRoot,
            commitment: 0,
            path: new bytes32[](_TREE_DEPTH),
            directionBits: 0
        });
    }

    function test_checkPath_reverts_on_non_existent_commitment() public {
        bytes32 latestRoot = _cmAcc.latestRoot();
        assertEq(latestRoot, _roots[0]);

        bytes32 nonExistingCommitment = _leaves[1][0];
        bytes32 nonExistingRoot = _roots[1];
        bytes32[] memory siblingsCorrespondingToNonExistingRoot = _siblings[1][0];
        uint256 directionBitsCorrespondingToNonExistingRoot = _directionBits[0];

        vm.expectRevert(abi.encodeWithSelector(CommitmentAccumulator.InvalidRoot.selector, latestRoot, nonExistingRoot));
        _cmAcc.verifyMerkleProof({
            root: latestRoot,
            commitment: nonExistingCommitment,
            path: siblingsCorrespondingToNonExistingRoot,
            directionBits: directionBitsCorrespondingToNonExistingRoot
        });
    }

    function test_checkPath_reverts_on_wrong_path_length() public {
        _cmAcc.storeRoot(_cmAcc.addCommitment(0));
        bytes32[] memory wrongPath = new bytes32[](3);

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.InvalidPathLength.selector, _TREE_DEPTH, wrongPath.length)
        );
        _cmAcc.verifyMerkleProof({ root: 0, commitment: 0, path: wrongPath, directionBits: 0 });
    }

    function test_checkPath_reverts_on_wrong_path() public {
        bytes32 commitment = sha256("SOMETHING");
        bytes32 newRoot = _cmAcc.addCommitment(commitment);
        _cmAcc.storeRoot(newRoot);

        bytes32[] memory wrongPath = new bytes32[](_TREE_DEPTH);

        // Compute the expected, invalid root.
        bytes32 invalidRoot = wrongPath.processProof({ directionBits: 0, leaf: commitment });

        vm.expectRevert(abi.encodeWithSelector(CommitmentAccumulator.InvalidRoot.selector, newRoot, invalidRoot));
        _cmAcc.verifyMerkleProof({ root: newRoot, commitment: commitment, path: wrongPath, directionBits: 0 });
    }
}
