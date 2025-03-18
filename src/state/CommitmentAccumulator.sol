// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Arrays } from "@openzeppelin-contracts/utils/Arrays.sol";
import { EnumerableSet } from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import { MerkleTree } from "@openzeppelin-contracts/utils/structs/MerkleTree.sol";

import { ICommitmentAccumulator } from "../interfaces/ICommitmentAccumulator.sol";

import { SHA256 } from "../libs/SHA256.sol";

import { ImprovedMerkleTree } from "./ImprovedMerkleTree.sol";

contract CommitmentAccumulator is ICommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using Arrays for bytes32[];

    uint256 internal constant _COMMITMENT_INDEX_OFFSET = 1;

    MerkleTree.Bytes32PushTree internal _merkleTree;
    EnumerableSet.Bytes32Set internal _roots;

    // TODO Use a better merkle tree implementation that doesn't require maintaining a set for fast retrieval.
    EnumerableSet.Bytes32Set internal _commitments;

    constructor(uint8 treeDepth) {
        bytes32 initialRoot = _merkleTree.setup(treeDepth, ImprovedMerkleTree._EMPTY_LEAF_HASH, SHA256.commutativeHash);

        if (!_roots.add(initialRoot)) revert PreExistingRoot(initialRoot);
    }

    /// @inheritdoc ICommitmentAccumulator
    function latestRoot() external view override returns (bytes32 root) {
        root = _latestRoot();
    }

    /// @inheritdoc ICommitmentAccumulator
    function containsRoot(bytes32 root) external view override returns (bool isContained) {
        isContained = _containsRoot(root);
    }

    function _addCommitmentUnchecked(bytes32 commitment) internal returns (bytes32 newRoot) {
        // slither-disable-next-line unused-return
        _commitments.add(commitment);

        uint256 index;
        (index, newRoot) = _merkleTree.push(commitment, SHA256.commutativeHash);

        emit CommitmentAdded({ commitment: commitment, index: index });
    }

    function _addCommitment(bytes32 commitment) internal returns (bytes32 newRoot) {
        if (!_commitments.add(commitment)) {
            revert PreExistingCommitment(commitment);
        }
        uint256 index;
        (index, newRoot) = _merkleTree.push(commitment, SHA256.commutativeHash);

        emit CommitmentAdded({ commitment: commitment, index: index });
    }

    function _findCommitmentIndex(bytes32 commitment) internal view returns (uint256 index) {
        if (commitment == _emptyLeaf()) {
            revert EmptyCommitment();
        }

        index = _commitments._inner._positions[commitment];

        if (index == 0) {
            revert NonExistingCommitment(commitment);
        }

        index -= _COMMITMENT_INDEX_OFFSET;

        bytes32 retrieved = _commitmentAtIndex(index);
        if (retrieved != commitment) {
            revert CommitmentMismatch({ expected: commitment, actual: retrieved });
        }
    }

    function _commitmentAtIndex(uint256 index) internal view returns (bytes32 commitment) {
        uint256 nextIndex = _merkleTree._nextLeafIndex;
        // TODO test: index >= nextIndex
        if (index + 1 > nextIndex) {
            revert CommitmentIndexOutOfBounds({ current: index, limit: nextIndex });
        }

        commitment = _commitments.at(index);
    }

    function _checkRootPreExistence(bytes32 root) internal view {
        if (!_roots.contains(root)) {
            revert NonExistingRoot(root);
            // NOTE by Xuyang: If `root` doesn't exist, the corresponding resource doesn't exist.
            // In the compliance, we checked the root generation. This makes sure that the root corresponds to the
            // resource.
        }
    }

    function _checkCommitmentNonExistence(bytes32 commitment) internal view {
        if (_commitments.contains(commitment)) {
            revert PreExistingCommitment(commitment);
        }
    }

    // TODO
    // slither-disable-next-line dead-code
    function _checkCommitmentPreExistence(bytes32 commitment) internal view {
        if (!_commitments.contains(commitment)) {
            revert NonExistingCommitment(commitment);
        }
    }

    function _emptyLeaf() internal view returns (bytes32 emptyLeaf) {
        emptyLeaf = _merkleTree._zeros[0];
    }

    function _latestRoot() internal view returns (bytes32 root) {
        root = _roots.at(_roots.length() - 1);
    }

    function _containsRoot(bytes32 root) internal view returns (bool isContained) {
        isContained = _roots.contains(root);
    }

    /// @dev Tree's depth (set at initialization)
    function _depth(MerkleTree.Bytes32PushTree storage self) internal view returns (uint256 depth) {
        depth = self._zeros.length;
    }
}
