// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Arrays} from "@openzeppelin-contracts/utils/Arrays.sol";
import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import {ICommitmentAccumulator} from "../interfaces/ICommitmentAccumulator.sol";
import {MerkleTree} from "../libs/MerkleTree.sol";

contract CommitmentAccumulator is ICommitmentAccumulator {
    using MerkleTree for MerkleTree.Tree;
    using MerkleTree for bytes32[];
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using Arrays for bytes32[];

    uint256 internal constant _COMMITMENT_INDEX_OFFSET = 1;

    MerkleTree.Tree internal _merkleTree;
    EnumerableSet.Bytes32Set internal _roots;

    mapping(bytes32 commitment => uint256 index) internal _indices;

    error EmptyCommitment();
    error NonExistingCommitment(bytes32 commitment);
    error PreExistingCommitment(bytes32 commitment);
    error CommitmentMismatch(bytes32 expected, bytes32 actual);
    error CommitmentIndexOutOfBounds(uint256 current, uint256 limit);

    error NonExistingRoot(bytes32 root);
    error PreExistingRoot(bytes32 root);
    error InvalidRoot(bytes32 expected, bytes32 actual);
    error InvalidPathLength(uint256 expected, uint256 actual);

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

    function verifyMerkleProof(bytes32 root, bytes32 commitment, bytes32[] calldata path, uint256 directionBits)
        external
        view
        override
    {
        _verifyMerkleProof({root: root, commitment: commitment, path: path, directionBits: directionBits});
    }

    function merkleProof(bytes32 commitment)
        external
        view
        override
        returns (bytes32[] memory proof, uint256 directionBits)
    {
        (proof, directionBits) = _merkleProof(commitment);
    }

    function _addCommitmentUnchecked(bytes32 commitment) internal returns (bytes32 newRoot) {
        uint256 index;
        (index, newRoot) = _merkleTree.push(commitment);
        _indices[commitment] = index + _COMMITMENT_INDEX_OFFSET; // Add 1 to use 0 as a sentinel value

        emit CommitmentAdded({commitment: commitment, index: index});
    }

    // slither-disable-next-line dead-code
    function _addCommitment(bytes32 commitment) internal returns (bytes32 newRoot) {
        _checkCommitmentNonExistence(commitment);
        newRoot = _addCommitmentUnchecked(commitment);
    }

    function _storeRoot(bytes32 root) internal {
        if (!_roots.add(root)) {
            revert PreExistingRoot(root);
        }
        emit RootAdded(root);
    }

    function _verifyMerkleProof(bytes32 root, bytes32 commitment, bytes32[] calldata path, uint256 directionBits)
        internal
        view
    {
        // Check length.
        if (path.length != _merkleTree.depth()) {
            revert InvalidPathLength({expected: _merkleTree.depth(), actual: path.length});
        }

        // Check root existence.
        if (!_roots.contains(root)) revert NonExistingRoot(root);

        // Check that the commitment leaf and path reproduce the root.
        bytes32 computedRoot = path.processProof(directionBits, commitment);

        if (root != computedRoot) {
            revert InvalidRoot({expected: root, actual: computedRoot});
        }
    }

    function _merkleProof(bytes32 commitment) internal view returns (bytes32[] memory proof, uint256 directionBits) {
        uint256 leafIndex = _findCommitmentIndex(commitment);
        (proof, directionBits) = (_merkleTree.merkleProof(leafIndex));
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
            revert CommitmentMismatch({expected: commitment, actual: retrieved});
        }
    }

    function _commitmentAtIndex(uint256 index) internal view returns (bytes32 commitment) {
        if (index + 1 > _merkleTree._nextLeafIndex) {
            revert CommitmentIndexOutOfBounds({current: index, limit: _merkleTree._nextLeafIndex});
        }

        commitment = _merkleTree._nodes[0][index];
    }

    function _checkCommitmentNonExistence(bytes32 commitment) internal view {
        if (_isContained(commitment)) {
            revert PreExistingCommitment(commitment);
        }
    }

    // slither-disable-next-line dead-code
    function _checkCommitmentPreExistence(bytes32 commitment) internal view {
        if (!_isContained(commitment)) {
            revert NonExistingCommitment(commitment);
        }
    }

    function _checkRootPreExistence(bytes32 root) internal view {
        if (!_roots.contains(root)) {
            revert NonExistingRoot(root);
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
}
