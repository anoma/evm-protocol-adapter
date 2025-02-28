// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Arrays } from "@openzeppelin-contracts/utils/Arrays.sol";
import { EnumerableSet } from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import { MerkleTree } from "@openzeppelin-contracts/utils/structs/MerkleTree.sol";

import { ICommitmentAccumulator } from "../interfaces/ICommitmentAccumulator.sol";

import { SHA256 } from "../libs/SHA256.sol";

contract CommitmentAccumulator is ICommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    using Arrays for bytes32[];

    // slither-disable-next-line max-line-length
    /// @dev Obtained from `sha256("EMPTY_LEAF")`.
    bytes32 internal constant _EMPTY_LEAF_HASH = 0x283d1bb3a401a7e0302d0ffb9102c8fc1f4730c2715a2bfd46a9d9209d5965e0;

    MerkleTree.Bytes32PushTree internal _merkleTree;
    EnumerableSet.Bytes32Set internal _roots;

    // TODO Use a better merkle tree implementation that doesn't require maintaining a set for fast retrieval.
    EnumerableSet.Bytes32Set internal _commitments;

    event CommitmentAdded(bytes32 indexed commitment, uint256 indexed index, bytes32 root);

    error NonExistingRoot(bytes32 root);
    error PreExistingRoot(bytes32 root);
    error InvalidRoot(bytes32 expected, bytes32 actual);

    error NonExistingCommitment(bytes32 commitment);
    error PreExistingCommitment(bytes32 commitment);

    constructor(uint8 treeDepth) {
        bytes32 initialRoot = _merkleTree.setup(treeDepth, _EMPTY_LEAF_HASH, SHA256.commutativeHash);

        bool success = _roots.add(initialRoot);
        if (!success) revert PreExistingRoot(initialRoot);
    }

    /// @inheritdoc ICommitmentAccumulator
    function latestRoot() external view override returns (bytes32 root) {
        root = _latestRoot();
    }

    /// @inheritdoc ICommitmentAccumulator
    function containsRoot(bytes32 root) external view override returns (bool isContained) {
        isContained = _containsRoot(root);
    }

    function _addCommitmentUnchecked(bytes32 commitment) internal {
        // slither-disable-next-line unused-return
        _commitments.add(commitment);

        (uint256 index, bytes32 newRoot) = _merkleTree.push(commitment, SHA256.commutativeHash);

        // slither-disable-next-line unused-return
        _roots.add(newRoot);

        emit CommitmentAdded({ commitment: commitment, index: index, root: newRoot });
    }

    function _addCommitment(bytes32 commitment) internal {
        if (!_commitments.add(commitment)) {
            revert PreExistingCommitment(commitment);
        }

        (uint256 index, bytes32 newRoot) = _merkleTree.push(commitment, SHA256.commutativeHash);

        if (!_roots.add(newRoot)) {
            revert PreExistingRoot(newRoot);
        }

        emit CommitmentAdded({ commitment: commitment, index: index, root: newRoot });
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

    function _latestRoot() internal view returns (bytes32 root) {
        root = _roots.at(_roots.length() - 1);
    }

    function _containsRoot(bytes32 root) internal view returns (bool isContained) {
        isContained = _roots.contains(root);
    }
}
