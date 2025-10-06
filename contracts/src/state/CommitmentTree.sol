// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import {ICommitmentTree} from "../interfaces/ICommitmentTree.sol";
import {MerkleTree} from "../libs/MerkleTree.sol";

/// @title CommitmentTree
/// @author Anoma Foundation, 2025
/// @notice A commitment tree being inherited by the protocol adapter.
/// @dev The contract is based on a modified version of OZ's `MerkleTree` implementation and and the unchanged OZ
/// `EnumerableSet` implementation.
/// @custom:security-contact security@anoma.foundation
contract CommitmentTree is ICommitmentTree {
    using MerkleTree for MerkleTree.Tree;
    using MerkleTree for bytes32[];
    using EnumerableSet for EnumerableSet.Bytes32Set;

    MerkleTree.Tree internal _merkleTree;
    EnumerableSet.Bytes32Set internal _roots;

    error EmptyCommitment();
    error NonExistingCommitment(bytes32 commitment);
    error PreExistingCommitment(bytes32 commitment);
    error CommitmentMismatch(bytes32 expected, bytes32 actual);
    error CommitmentIndexOutOfBounds(uint256 current, uint256 limit);

    error NonExistingRoot(bytes32 root);
    error PreExistingRoot(bytes32 root);
    error InvalidRoot(bytes32 expected, bytes32 actual);
    error PathLengthExceedsLatestDepth(uint256 latestDepth, uint256 provided);

    /// @notice Initializes the commitment accumulator by setting up a Merkle tree.
    constructor() {
        bytes32 initialRoot = _merkleTree.setup();

        if (!_roots.add(initialRoot)) revert PreExistingRoot(initialRoot);
    }

    /// @inheritdoc ICommitmentTree
    function commitmentCount() external view override returns (uint256 count) {
        count = _merkleTree.leafCount();
    }

    /// @inheritdoc ICommitmentTree
    function commitmentTreeDepth() external view override returns (uint8 depth) {
        depth = _merkleTree.depth();
    }

    /// @inheritdoc ICommitmentTree
    function commitmentTreeCapacity() external view override returns (uint256 capacity) {
        capacity = _merkleTree.capacity();
    }

    /// @inheritdoc ICommitmentTree
    function isCommitmentTreeRootContained(bytes32 root) external view override returns (bool isContained) {
        isContained = _isCommitmentTreeRootContained(root);
    }

    /// @inheritdoc ICommitmentTree
    function commitmentTreeRootCount() external view override returns (uint256 count) {
        count = _roots.length();
    }

    /// @inheritdoc ICommitmentTree
    function commitmentTreeRootAtIndex(uint256 index) external view override returns (bytes32 root) {
        root = _roots.at(index);
    }

    /// @inheritdoc ICommitmentTree
    function latestCommitmentTreeRoot() external view override returns (bytes32 root) {
        root = _roots.at(_roots.length() - 1);
    }

    /// @inheritdoc ICommitmentTree
    function verifyMerkleProof(
        bytes32 commitmentTreeRoot,
        bytes32 commitment,
        bytes32[] calldata path,
        uint256 directionBits
    ) external view override {
        _verifyMerkleProof({
            commitmentTreeRoot: commitmentTreeRoot,
            commitment: commitment,
            path: path,
            directionBits: directionBits
        });
    }

    /// @notice Adds a commitment to the accumulator and returns the new root.
    /// @param commitment The commitment to add.
    /// @return newRoot The resulting new root.
    function _addCommitment(bytes32 commitment) internal returns (bytes32 newRoot) {
        uint256 index;
        (index, newRoot) = _merkleTree.push(commitment);
    }

    /// @notice Adds a root to the set of historical roots and emits the `CommitmentTreeRootAdded` event.
    /// @param root The root to store.
    function _addCommitmentTreeRoot(bytes32 root) internal {
        if (!_roots.add(root)) {
            revert PreExistingRoot(root);
        }
        emit CommitmentTreeRootAdded(root);
    }

    /// @notice An internal function verifying that a Merkle path (proof) and a commitment leaf reproduce a given root.
    /// @dev To prevent second-preimage attacks, ensure that the commitment is a leaf and not an intermediary node.
    /// @param commitmentTreeRoot The commitment tree root to reproduce.
    /// @param commitment The commitment leaf to proof inclusion in the tree for.
    /// @param path The siblings constituting the path from the leaf to the root.
    /// @param directionBits The direction bits indicating whether the siblings are left of right.
    function _verifyMerkleProof(
        bytes32 commitmentTreeRoot,
        bytes32 commitment,
        bytes32[] calldata path,
        uint256 directionBits
    ) internal view {
        // Check length.
        if (path.length > _merkleTree.depth()) {
            revert PathLengthExceedsLatestDepth({latestDepth: _merkleTree.depth(), provided: path.length});
        }

        // Check root existence.
        if (!_roots.contains(commitmentTreeRoot)) {
            revert NonExistingRoot(commitmentTreeRoot);
        }

        // Check that the commitment leaf and path reproduce the root.
        bytes32 computedRoot = path.processProof(directionBits, commitment);

        if (commitmentTreeRoot != computedRoot) {
            revert InvalidRoot({expected: commitmentTreeRoot, actual: computedRoot});
        }
    }

    /// @notice Checks if a commitment tree root is contained in the set of historical roots.
    /// @param root The root to check.
    /// @return isContained Whether the root exists or not.
    function _isCommitmentTreeRootContained(bytes32 root) internal view returns (bool isContained) {
        isContained = _roots.contains(root);
    }
}
