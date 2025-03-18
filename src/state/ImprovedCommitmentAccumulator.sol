// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Arrays } from "@openzeppelin-contracts/utils/Arrays.sol";
import { EnumerableSet } from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import { ICommitmentAccumulator } from "../interfaces/ICommitmentAccumulator.sol";
import { ImprovedMerkleTree } from "./ImprovedMerkleTree.sol";

contract ImprovedCommitmentAccumulator is ICommitmentAccumulator {
    using ImprovedMerkleTree for ImprovedMerkleTree.Tree;
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using Arrays for bytes32[];

    uint256 internal constant _COMMITMENT_INDEX_OFFSET = 1;

    ImprovedMerkleTree.Tree internal _merkleTree;
    EnumerableSet.Bytes32Set internal _roots;

    mapping(bytes32 commitment => uint256 index) internal _indices;

    constructor(uint8 treeDepth) {
        bytes32 initialRoot = _merkleTree.setup(treeDepth);

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
        uint256 index;
        (index, newRoot) = _merkleTree.push(commitment);
        _indices[commitment] = index + _COMMITMENT_INDEX_OFFSET; // Add 1 to use 0 as a sentinel value

        // TODO
        //emit CommitmentAdded({ commitment: commitment, index: index, root: newRoot });
    }

    function _addCommitment(bytes32 commitment) internal returns (bytes32 newRoot) {
        _checkCommitmentNonExistence(commitment);

        newRoot = _addCommitmentUnchecked(commitment);
    }

    function _isContained(bytes32 commitment) internal view returns (bool isContained) {
        uint256 index = _indices[commitment];

        isContained = index != 0;
    }

    function _findCommitmentIndex(bytes32 commitment) internal view returns (uint256 index) {
        if (commitment == _emptyLeaf()) {
            revert EmptyCommitment();
        }

        index = _indices[commitment];

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
        if (index + 1 > _merkleTree._nextLeafIndex) {
            revert CommitmentIndexOutOfBounds({ current: index, limit: _merkleTree._nextLeafIndex });
        }

        commitment = _merkleTree._nodes[0][index];
    }

    function _checkCommitmentNonExistence(bytes32 commitment) internal view {
        if (_isContained(commitment)) {
            revert PreExistingCommitment(commitment);
        }
    }

    // TODO
    // slither-disable-next-line dead-code
    function _checkCommitmentPreExistence(bytes32 commitment) internal view {
        if (!_isContained(commitment)) {
            revert NonExistingCommitment(commitment);
        }
    }

    function _checkRootPreExistence(bytes32 root) internal view {
        if (!_roots.contains(root)) {
            revert NonExistingRoot(root);
            // NOTE by Xuyang: If `root` doesn't exist, the corresponding resource doesn't exist.
            // In the compliance, we checked the root generation. This makes sure that the root corresponds to the
            // resource.
        }
    }

    function _emptyLeaf() internal view returns (bytes32 emptyLeaf) {
        emptyLeaf = _merkleTree._zeros[0];
    }

    function _latestRoot() internal view returns (bytes32 root) {
        // TODO Remove? TODO root = _merkleTree._root();
        root = _roots.at(_roots.length() - 1);
    }

    function _containsRoot(bytes32 root) internal view returns (bool isContained) {
        isContained = _roots.contains(root);
    }
}
