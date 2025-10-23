// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {ICommitmentTree} from "../src/interfaces/ICommitmentTree.sol";
import {MerkleProofVerification} from "../src/libs/MerkleProofVerification.sol";
import {SHA256} from "../src/libs/SHA256.sol";
import {CommitmentTree} from "../src/state/CommitmentTree.sol";
import {MerkleTreeExample} from "./examples/MerkleTree.e.sol";
import {CommitmentTreeMock} from "./mocks/CommitmentTree.m.sol";

contract MerkleProofVerificationCaller {
    using MerkleProofVerification for ICommitmentTree;

    function callVerifyMerkleProof(
        ICommitmentTree commitmentTree,
        bytes32 commitmentTreeRoot,
        bytes32 commitment,
        bytes32[] calldata path,
        uint256 directionBits
    ) external view {
        commitmentTree.verifyMerkleProof({
            commitmentTreeRoot: commitmentTreeRoot, commitment: commitment, path: path, directionBits: directionBits
        });
    }
}

contract CommitmentTreeTest is Test, MerkleTreeExample {
    using MerkleProofVerification for bytes32[];
    using MerkleProofVerification for ICommitmentTree;

    CommitmentTreeMock internal _cmAcc;
    MerkleProofVerificationCaller internal _libCaller;

    constructor() {
        _setupMockTree();
        _cmAcc = new CommitmentTreeMock();
        _libCaller = new MerkleProofVerificationCaller();
    }

    function test_verifyMerkleProof_reverts_on_non_existent_root() public {
        bytes32 nonExistingRoot = sha256("NON_EXISTENT_ROOT");

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentTree.NonExistingRoot.selector, nonExistingRoot), address(_libCaller)
        );
        _libCaller.callVerifyMerkleProof({
            commitmentTree: ICommitmentTree(_cmAcc),
            commitmentTreeRoot: nonExistingRoot,
            commitment: 0,
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
        _cmAcc.addCommitmentTreeRoot(newRoot);

        bytes32 nonExistingCommitment = bytes32(uint256(2));
        bytes32 nonExistingRoot = SHA256.hash(commitment, nonExistingCommitment);
        bytes32[] memory siblingsCorrespondingToNonExistingRoot = new bytes32[](1);
        siblingsCorrespondingToNonExistingRoot[0] = commitment;
        uint256 directionBitsCorrespondingToNonExistingRoot = 0;

        vm.expectRevert(
            abi.encodeWithSelector(MerkleProofVerification.InvalidRoot.selector, newRoot, nonExistingRoot),
            address(_libCaller)
        );
        _libCaller.callVerifyMerkleProof({
            commitmentTree: ICommitmentTree(_cmAcc),
            commitmentTreeRoot: newRoot,
            commitment: nonExistingCommitment,
            path: siblingsCorrespondingToNonExistingRoot,
            directionBits: directionBitsCorrespondingToNonExistingRoot
        });
    }

    function test_verifyMerkleProof_reverts_on_wrong_path_length() public {
        _cmAcc.addCommitmentTreeRoot(_cmAcc.addCommitment(0));
        bytes32[] memory wrongPath = new bytes32[](3);

        vm.expectRevert(
            abi.encodeWithSelector(
                MerkleProofVerification.PathLengthExceedsLatestDepth.selector,
                _cmAcc.commitmentTreeDepth(),
                wrongPath.length
            ),
            address(_libCaller)
        );
        _libCaller.callVerifyMerkleProof({
            commitmentTree: ICommitmentTree(_cmAcc),
            commitmentTreeRoot: 0,
            commitment: 0,
            path: wrongPath,
            directionBits: 0
        });
    }

    function test_verifyMerkleProof_reverts_on_wrong_path() public {
        bytes32 commitment = sha256("SOMETHING");
        bytes32 newRoot = _cmAcc.addCommitment(commitment);
        _cmAcc.addCommitmentTreeRoot(newRoot);

        bytes32[] memory wrongPath = new bytes32[](_cmAcc.commitmentTreeDepth());

        // Compute the expected, invalid root.
        bytes32 invalidRoot = wrongPath.processProof({directionBits: 0, leaf: commitment});

        vm.expectRevert(
            abi.encodeWithSelector(MerkleProofVerification.InvalidRoot.selector, newRoot, invalidRoot),
            address(_libCaller)
        );
        _libCaller.callVerifyMerkleProof({
            commitmentTree: ICommitmentTree(_cmAcc),
            commitmentTreeRoot: newRoot,
            commitment: commitment,
            path: wrongPath,
            directionBits: 0
        });
    }

    function test_verifyMerkleProof_verifies_path_for_roots() public {
        // Fix old root
        bytes32 oldRoot = _cmAcc.latestCommitmentTreeRoot();

        // Update the tree with some commitment
        bytes32 commitment = sha256("SOMETHING");
        bytes32 newRoot = _cmAcc.addCommitment(commitment);
        _cmAcc.addCommitmentTreeRoot(newRoot);

        // Assert that the new root is different
        assert(_cmAcc.latestCommitmentTreeRoot() != oldRoot);

        // Check merkle path verification for initial root works
        _libCaller.callVerifyMerkleProof({
            commitmentTree: ICommitmentTree(_cmAcc),
            commitmentTreeRoot: oldRoot,
            commitment: SHA256.EMPTY_HASH,
            path: new bytes32[](0),
            directionBits: 0
        });
    }

    function test_processProof_produces_an_invalid_root_for_a_non_existent_leaf() public {
        bytes32 nonExistentCommitment = sha256("NON_EXISTENT");

        for (uint256 i = 0; i < _N_LEAVES; ++i) {
            bytes32 root = _cmAcc.addCommitment(_leaves[i + 1][i]);

            for (uint256 j = 0; j <= i; ++j) {
                bytes32 computedRoot = MerkleProofVerification.processProof({
                    siblings: _siblings[i + 1][j],
                    directionBits: _directionBits[_cmAcc.commitmentTreeCapacity()][j],
                    leaf: nonExistentCommitment
                });

                assertNotEq(computedRoot, root);
            }
        }
    }

    function test_verifyMerkleProof_verifies_the_empty_tree_with_depth_zero() public view {
        _libCaller.callVerifyMerkleProof({
            commitmentTree: ICommitmentTree(_cmAcc),
            commitmentTreeRoot: _cmAcc.latestCommitmentTreeRoot(),
            commitment: SHA256.EMPTY_HASH,
            path: new bytes32[](0),
            directionBits: 0
        });
    }

    function test_processProof_produces_an_invalid_root_for_a_non_existent_leaf_in_the_empty_tree() public view {
        bytes32 root = _cmAcc.initialRoot();

        bytes32 nonExistentCommitment = sha256("NON_EXISTENT");
        bytes32 invalidRoot = nonExistentCommitment;

        bytes32 computedRoot = MerkleProofVerification.processProof({
            siblings: new bytes32[](0), directionBits: 0, leaf: nonExistentCommitment
        });
        assertNotEq(computedRoot, root);
        assertEq(computedRoot, invalidRoot);
    }
}
