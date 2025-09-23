// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Arrays} from "@openzeppelin-contracts/utils/Arrays.sol";
import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import {ICommitmentAccumulator} from "../interfaces/ICommitmentAccumulator.sol";
import {MerkleTree} from "../libs/MerkleTree.sol";

/// @title CommitmentAccumulator
/// @author Anoma Foundation, 2025
/// @notice A commitment accumulator being inherited by the protocol adapter.
/// @dev The contract is based on a modified version of OZ's `MerkleTree` implementation and and the unchanged OZ
/// `EnumerableSet` implementation.
/// @custom:security-contact security@anoma.foundation
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

    /// @notice Initializes the commitment accumulator by setting up a Merkle tree.
    constructor() {
        bytes32 initialRoot = _merkleTree.setup();

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

    /// @inheritdoc ICommitmentAccumulator
    function verifyMerkleProof(bytes32 root, bytes32 commitment, bytes32[] calldata path, uint256 directionBits)
        external
        view
        override
    {
        _verifyMerkleProof({root: root, commitment: commitment, path: path, directionBits: directionBits});
    }

    /// @inheritdoc ICommitmentAccumulator
    function merkleProof(bytes32 commitment)
        external
        view
        override
        returns (bytes32[] memory siblings, uint256 directionBits)
    {
        (siblings, directionBits) = _merkleProof(commitment);
    }

    /// @notice Adds a commitment to to the set, if it does not exist already and returns the new root.
    /// @param commitment The commitment to add.
    /// @return newRoot The resulting new root.
    function _addCommitment(bytes32 commitment) internal returns (bytes32 newRoot) {
        _checkCommitmentNonExistence(commitment);

        uint256 index;
        (index, newRoot) = _merkleTree.push(commitment);
        _indices[commitment] = index + _COMMITMENT_INDEX_OFFSET; // Add 1 to use 0 as a sentinel value
    }

    /// @notice Stores a root in the set of historical roots.
    /// @param root The root to store.
    function _storeRoot(bytes32 root) internal {
        if (!_roots.add(root)) {
            revert PreExistingRoot(root);
        }
        emit CommitmentTreeRootStored(root);
    }

    /// @notice An internal function verifying that a Merkle path (proof) and a commitment leaf reproduce a given root.
    /// @param root The root to reproduce.
    /// @param commitment The commitment leaf to proof inclusion in the tree for.
    /// @param path The siblings constituting the path from the leaf to the root.
    /// @param directionBits The direction bits indicating whether the siblings are left of right.
    function _verifyMerkleProof(bytes32 root, bytes32 commitment, bytes32[] calldata path, uint256 directionBits)
        internal
        view
    {
        // Check length.
        if (path.length != _merkleTree.depth()) {
            revert InvalidPathLength({expected: _merkleTree.depth(), actual: path.length});
        }

        // Check root existence.
        if (!_roots.contains(root)) {
            revert NonExistingRoot(root);
        }

        // Check that the commitment leaf and path reproduce the root.
        bytes32 computedRoot = path.processProof(directionBits, commitment);

        if (root != computedRoot) {
            revert InvalidRoot({expected: root, actual: computedRoot});
        }
    }

    /// @notice An internal function returning the Merkle proof and associated root for a commitment leaf in the tree.
    /// @param commitment The commitment leaf to proof inclusion in the tree for.
    /// @return siblings The siblings constituting the path from the leaf to the root.
    /// @return directionBits The direction bits for the proof.
    function _merkleProof(bytes32 commitment)
        internal
        view
        returns (bytes32[] memory siblings, uint256 directionBits)
    {
        uint256 leafIndex = _findCommitmentIndex(commitment);
        (siblings, directionBits) = (_merkleTree.merkleProof(leafIndex));
    }

    /// @notice Returns whether a commitment is already contained in the accumulator.
    /// @param commitment The commitment to check.
    /// @return isContained Whether the commitment is contained or not.
    function _isContained(bytes32 commitment) internal view returns (bool isContained) {
        uint256 index = _indices[commitment];

        isContained = index != 0;
    }

    /// @notice Finds the index of a commitment in the accumulator or reverts.
    /// @param commitment The commitment to find the index for.
    /// @return index The index of the commitment in the accumulator.
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

    /// @notice Returns a commitment based on its index in the accumulator or reverts.
    /// @param index The index to find the commitment for.
    /// @return commitment The commitment associated with the index.
    function _commitmentAtIndex(uint256 index) internal view returns (bytes32 commitment) {
        if (index + 1 > _merkleTree._nextLeafIndex) {
            revert CommitmentIndexOutOfBounds({current: index, limit: _merkleTree._nextLeafIndex});
        }

        commitment = _merkleTree._nodes[0][index];
    }

    /// @notice Checks the non-existence of a commitment in the tree.
    /// @param commitment The commitment to check.
    function _checkCommitmentNonExistence(bytes32 commitment) internal view {
        if (_isContained(commitment)) {
            revert PreExistingCommitment(commitment);
        }
    }

    // slither-disable-start dead-code
    /// @notice Checks the existence of a commitment in the tree.
    /// @param commitment The commitment to check.

    function _checkCommitmentPreExistence(bytes32 commitment) internal view {
        if (!_isContained(commitment)) {
            revert NonExistingCommitment(commitment);
        }
    }
    // slither-disable-end dead-code

    /// @notice Checks the existence of a root in the set of historical roots.
    /// @param root The root to check.
    function _checkRootPreExistence(bytes32 root) internal view {
        if (!_roots.contains(root)) {
            revert NonExistingRoot(root);
        }
    }

    /// @notice Returns the hash indicating that a leaf in the tree is empty.
    /// @return emptyLeaf The empty leaf hash.
    function _emptyLeaf() internal view returns (bytes32 emptyLeaf) {
        emptyLeaf = _merkleTree._zeros[0];
    }

    /// @notice Returns the latest  commitment tree state root.
    /// @return root The latest commitment tree state root.
    function _latestRoot() internal view returns (bytes32 root) {
        root = _roots.at(_roots.length() - 1);
    }

    /// @notice Checks if a commitment tree state root exists.
    /// @param root The root to check.
    /// @return isContained Whether the root exists or not.
    function _containsRoot(bytes32 root) internal view returns (bool isContained) {
        isContained = _roots.contains(root);
    }
}
