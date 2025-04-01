// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface ICommitmentAccumulator {
    event CommitmentAdded(bytes32 indexed commitment, uint256 indexed index);
    event RootAdded(bytes32 indexed root);

    /// @notice Returns the latest  commitment tree state root.
    /// @return root The latest commitment tree state root.
    function latestRoot() external view returns (bytes32 root);

    /// @notice Checks if a commitment tree state root exists.
    /// @param root The root to check.
    /// @return isContained Whether the root exists or not.
    function containsRoot(bytes32 root) external view returns (bool isContained);

    /// @notice Verifies a that a Merkle path (proof) and a commitment leaf reproduces the given root.
    /// @param root The root to reproduce.
    /// @param commitment The commitment leaf to proof inclusion in the tree for.
    /// @param path The siblings constituting the path from the leaf to the root.
    /// @param directionBits The direction bits for the proof.

    function verifyMerkleProof(
        bytes32 root,
        bytes32 commitment,
        bytes32[] calldata path,
        uint256 directionBits
    )
        external
        view;

    /// @notice Returns the Merkle proof and associated root for a commitment leaf in the tree.
    /// @param commitment The commitment leaf to proof inclusion in the tree for.
    /// @return path The siblings constituting the path from the commitment leaf to the root.
    /// @return directionBits The direction bits for the proof.
    /// @return root The root associated with the Merkle proof.
    function merkleProof(bytes32 commitment)
        external
        view
        returns (bytes32[] memory path, uint256 directionBits, bytes32 root);
}
