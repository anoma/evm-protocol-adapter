// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ICommitmentTree} from "../interfaces/ICommitmentTree.sol";
import {SHA256} from "../libs/SHA256.sol";
import {CommitmentTree} from "../state/CommitmentTree.sol";

/// @title MerkleProofVerification
/// @author Anoma Foundation, 2025
/// @notice A library to verify Merkle proofs against historical commitment tree roots.
/// @custom:security-contact security@anoma.foundation
library MerkleProofVerification {
    using MerkleProofVerification for bytes32[];

    error PathLengthExceedsLatestDepth(uint256 latestDepth, uint256 provided);
    error InvalidRoot(bytes32 expected, bytes32 actual);

    /// @notice An internal function verifying that a Merkle path (proof) and a commitment leaf reproduce a historical
    /// root of a commitment tree.
    /// @dev To prevent second-preimage attacks, ensure that the commitment is a leaf and not an intermediary node.
    /// @param commitmentTree The commitment tree to verify the Merkle proof for.
    /// @param commitmentTreeRoot The commitment tree root to reproduce.
    /// @param commitment The commitment leaf to proof inclusion in the tree for.
    /// @param path The siblings constituting the path from the leaf to the root.
    /// @param directionBits The direction bits indicating whether the siblings are left of right.
    function verifyMerkleProof(
        ICommitmentTree commitmentTree,
        bytes32 commitmentTreeRoot,
        bytes32 commitment,
        bytes32[] memory path,
        uint256 directionBits
    ) internal view {
        // Check length.
        if (path.length > commitmentTree.commitmentTreeDepth()) {
            revert PathLengthExceedsLatestDepth({
                latestDepth: commitmentTree.commitmentTreeDepth(), provided: path.length
            });
        }

        // Check root existence.
        if (!commitmentTree.isCommitmentTreeRootContained(commitmentTreeRoot)) {
            revert CommitmentTree.NonExistingRoot(commitmentTreeRoot);
        }

        // Check that the commitment leaf and path reproduce the root.
        bytes32 computedRoot = path.processProof(directionBits, commitment);

        if (commitmentTreeRoot != computedRoot) {
            revert InvalidRoot({expected: commitmentTreeRoot, actual: computedRoot});
        }
    }

    /// @notice Processes a Merkle proof consisting of siblings and direction bits and returns the resulting root.
    /// @param siblings The siblings.
    /// @param directionBits The direction bits indicating whether the siblings are left of right.
    /// @param leaf The leaf.
    /// @return root The resulting root obtained by processing the leaf, siblings, and direction bits.
    function processProof(bytes32[] memory siblings, uint256 directionBits, bytes32 leaf)
        internal
        pure
        returns (bytes32 root)
    {
        bytes32 computedHash = leaf;

        uint256 treeDepth = siblings.length;
        for (uint256 i = 0; i < treeDepth; ++i) {
            if (isLeftSibling(directionBits, i)) {
                // Left sibling
                computedHash = SHA256.hash(siblings[i], computedHash);
            } else {
                // Right sibling
                computedHash = SHA256.hash(computedHash, siblings[i]);
            }
        }
        root = computedHash;
    }

    /// @notice Checks whether a direction bit encodes the left or right sibling.
    /// @param directionBits The direction bits.
    /// @param d The index of the bit to check.
    /// @return isLeft Whether the sibling is left or right.
    function isLeftSibling(uint256 directionBits, uint256 d) internal pure returns (bool isLeft) {
        isLeft = (directionBits >> d) & 1 == 0;
    }
}
