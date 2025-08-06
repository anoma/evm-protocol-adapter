// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {CommitmentAccumulator} from "../../src/state/CommitmentAccumulator.sol";

import {MerkleTreeExample} from "../examples/MerkleTree.e.sol";
import {CommitmentAccumulatorMock} from "../mocks/CommitmentAccumulator.m.sol";

contract CommitmentAccumulatorTest is Test, MerkleTreeExample {
    using MerkleTree for bytes32[];

    CommitmentAccumulatorMock internal _cmAcc;

    constructor() {
        _setupMockTree();
        _cmAcc = new CommitmentAccumulatorMock();
    }

    function test_the_initial_root_is_the_empty_leaf_hash() public {
        assertEq(new CommitmentAccumulator().latestRoot(), SHA256.EMPTY_HASH);
    }

    function test_latestRoot_returns_correct_roots() public {
        bytes32 initialRoot = _cmAcc.latestRoot();

        assertEq(initialRoot, _roots[0]);
        assertEq(initialRoot, _cmAcc.initialRoot());

        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            assertEq(_cmAcc.addCommitment(_a[i + 1][i]), _roots[i + 1]);
        }
    }

    function test_merkleProof_reverts_for_empty_hash() public {
        bytes32 emptyLeafHash = _cmAcc.emptyLeafHash();
        vm.expectRevert(CommitmentAccumulator.EmptyCommitment.selector, address(_cmAcc));
        _cmAcc.merkleProof(emptyLeafHash);
    }

    function test_merkleProof_should_return_correct_direction_bits() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            _cmAcc.addCommitment(_a[i + 1][i]);

            uint256 cap = _cmAcc.capacity();

            for (uint256 j = 0; j < i + 1; ++j) {
                (, uint256 directionBits) = _cmAcc.merkleProof(_a[i + 1][j]);

                assertEq(directionBits, _directionBits[cap][j]);
            }
        }
    }

    function test_findCommitmentIndex_should_return_correct_indices() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            _cmAcc.addCommitment(_a[i + 1][i]);

            for (uint256 j = 0; j <= i; ++j) {
                assertEq(j, _cmAcc.findCommitmentIndex(_a[i + 1][j]));
            }
        }
    }

    function test_findCommitmentIndex_reverts_on_empty_commitment() public {
        bytes32 emptyLeafHash = _cmAcc.emptyLeafHash();
        vm.expectRevert(CommitmentAccumulator.EmptyCommitment.selector, address(_cmAcc));
        _cmAcc.findCommitmentIndex(emptyLeafHash);
    }

    function test_addCommitment_should_add_commitments() public {
        uint256 prevCount = 0;
        uint256 newCount = 0;

        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            _cmAcc.addCommitment(_a[i + 1][i]);
            newCount = _cmAcc.commitmentCount();

            assertEq(newCount, ++prevCount);
            prevCount = newCount;
        }
    }

    function test_addCommitment_reverts_on_duplicate() public {
        bytes32 cm = sha256("SOMETHING");
        _cmAcc.addCommitment(cm);

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.PreExistingCommitment.selector, cm), address(_cmAcc)
        );
        _cmAcc.addCommitment(cm);
    }

    function test_findCommitmentIndex_reverts_on_non_existent_commitment() public {
        bytes32 nonExistentCommitment = sha256("NON_EXISTENT");
        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.NonExistingCommitment.selector, nonExistentCommitment),
            address(_cmAcc)
        );
        _cmAcc.findCommitmentIndex(nonExistentCommitment);
    }

    function test_commitmentAtIndex_reverts_on_non_existent_index() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            uint256 commitmentCount = _cmAcc.commitmentCount();

            vm.expectRevert(
                abi.encodeWithSelector(CommitmentAccumulator.CommitmentIndexOutOfBounds.selector, i, commitmentCount),
                address(_cmAcc)
            );
            _cmAcc.commitmentAtIndex(i);
        }
    }

    function test_should_produce_an_invalid_root_for_a_non_existent_leaf_in_the_empty_tree() public view {
        bytes32 root = _cmAcc.initialRoot();

        bytes32 nonExistentCommitment = sha256("NON_EXISTENT");
        bytes32 invalidRoot = nonExistentCommitment;

        bytes32 computedRoot =
            MerkleTree.processProof({siblings: new bytes32[](0), directionBits: 0, leaf: nonExistentCommitment});
        assertNotEq(computedRoot, root);
        assertEq(computedRoot, invalidRoot);
    }

    function test_should_produce_an_invalid_root_for_a_non_existent_leaf() public {
        bytes32 nonExistentCommitment = sha256("NON_EXISTENT");

        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            bytes32 root = _cmAcc.addCommitment(_a[i + 1][i]);

            for (uint256 j = 0; j <= i; ++j) {
                bytes32 computedRoot = MerkleTree.processProof({
                    siblings: _siblings[i + 1][j],
                    directionBits: _directionBits[_cmAcc.capacity()][j],
                    leaf: nonExistentCommitment
                });

                assertNotEq(computedRoot, root);
            }
        }
    }

    function test_merkleProof_returns_proofs_that_match_the_latest_root() public {
        for (uint256 i = 0; i < _N_LEAFS; ++i) {
            bytes32 latestRoot = _cmAcc.addCommitment(_a[_N_ROOTS - 1][i]);

            // Check that all leaves of the current tree result in proofs reproducing the latest root.
            for (uint256 j = 0; j <= i; ++j) {
                bytes32 cm = _a[_N_ROOTS - 1][i];

                (bytes32[] memory siblings, uint256 directionBits) = _cmAcc.merkleProof(cm);
                bytes32 computedRoot = MerkleTree.processProof(siblings, directionBits, cm);

                assertEq(computedRoot, latestRoot);
            }
        }
    }

    function test_verifyMerkleProof_should_pass_on_valid_inputs() public {
        bytes32 cm = sha256("SOMETHING");
        bytes32 latestRoot = _cmAcc.addCommitment(cm);
        _cmAcc.storeRoot(latestRoot);

        (bytes32[] memory path, uint256 directionBits) = _cmAcc.merkleProof(cm);

        _cmAcc.verifyMerkleProof({root: latestRoot, commitment: cm, path: path, directionBits: directionBits});
    }

    function test_verifyMerkleProof_reverts_on_non_existent_root() public {
        bytes32 nonExistingRoot = sha256("NON_EXISTENT_ROOT");

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.NonExistingRoot.selector, nonExistingRoot), address(_cmAcc)
        );
        _cmAcc.verifyMerkleProof({root: nonExistingRoot, commitment: 0, path: new bytes32[](0), directionBits: 0});
    }

    function test_verifyMerkleProof_verifies_the_empty_tree_with_depth_zero() public view {
        _cmAcc.verifyMerkleProof({
            root: _cmAcc.latestRoot(),
            commitment: SHA256.EMPTY_HASH,
            path: new bytes32[](0),
            directionBits: 0
        });
    }

    function test_verifyMerkleProof_reverts_on_non_existent_commitment() public {
        /*
          (1)
           R   
         /  \  
        1   []
        */

        bytes32 commitment = bytes32(uint256(1));
        bytes32 newRoot = _cmAcc.addCommitment(commitment);
        _cmAcc.storeRoot(newRoot);

        bytes32 nonExistingCommitment = bytes32(uint256(2));
        bytes32 nonExistingRoot = SHA256.hash(commitment, nonExistingCommitment);
        bytes32[] memory siblingsCorrespondingToNonExistingRoot = new bytes32[](1);
        siblingsCorrespondingToNonExistingRoot[0] = commitment;
        uint256 directionBitsCorrespondingToNonExistingRoot = 0;

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.InvalidRoot.selector, newRoot, nonExistingRoot),
            address(_cmAcc)
        );
        _cmAcc.verifyMerkleProof({
            root: newRoot,
            commitment: nonExistingCommitment,
            path: siblingsCorrespondingToNonExistingRoot,
            directionBits: directionBitsCorrespondingToNonExistingRoot
        });
    }

    function test_verifyMerkleProof_reverts_on_wrong_path_length() public {
        _cmAcc.storeRoot(_cmAcc.addCommitment(0));
        bytes32[] memory wrongPath = new bytes32[](3);

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.InvalidPathLength.selector, _cmAcc.depth(), wrongPath.length),
            address(_cmAcc)
        );
        _cmAcc.verifyMerkleProof({root: 0, commitment: 0, path: wrongPath, directionBits: 0});
    }

    function test_verifyMerkleProof_reverts_on_wrong_path() public {
        bytes32 commitment = sha256("SOMETHING");
        bytes32 newRoot = _cmAcc.addCommitment(commitment);
        _cmAcc.storeRoot(newRoot);

        bytes32[] memory wrongPath = new bytes32[](_cmAcc.depth());

        // Compute the expected, invalid root.
        bytes32 invalidRoot = wrongPath.processProof({directionBits: 0, leaf: commitment});

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentAccumulator.InvalidRoot.selector, newRoot, invalidRoot), address(_cmAcc)
        );
        _cmAcc.verifyMerkleProof({root: newRoot, commitment: commitment, path: wrongPath, directionBits: 0});
    }
}
