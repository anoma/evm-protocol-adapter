// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EnumerableSet} from "@openzeppelin-contracts-5.5.0/utils/structs/EnumerableSet.sol";

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
    using EnumerableSet for EnumerableSet.Bytes32Set;

    MerkleTree.Tree internal _merkleTree;
    EnumerableSet.Bytes32Set internal _roots;

    error NonExistingRoot(bytes32 root);
    error PreExistingRoot(bytes32 root);

    /// @notice Initializes the commitment accumulator by setting up a Merkle tree.
    constructor() {
        bytes32 initialRoot = _merkleTree.setup();

        // slither-disable-next-line unused-return
        _roots.add(initialRoot);

        emit CommitmentTreeRootAdded({root: initialRoot});
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

    /// @notice Checks if a commitment tree root is contained in the set of historical roots.
    /// @param root The root to check.
    /// @return isContained Whether the root exists or not.
    function _isCommitmentTreeRootContained(bytes32 root) internal view returns (bool isContained) {
        isContained = _roots.contains(root);
    }
}
