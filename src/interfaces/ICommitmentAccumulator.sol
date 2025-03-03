// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface ICommitmentAccumulator {
    // Commitment-related
    event CommitmentAdded(bytes32 indexed commitment, uint256 indexed index, bytes32 root);

    error EmptyCommitment();
    error NonExistingCommitment(bytes32 commitment);
    error PreExistingCommitment(bytes32 commitment);

    error CommitmentMismatch(bytes32 expected, bytes32 actual);
    error CommitmentIndexOutOfBounds(uint256 current, uint256 limit);

    // Root-related
    error NonExistingRoot(bytes32 root);
    error PreExistingRoot(bytes32 root);
    error InvalidRoot(bytes32 expected, bytes32 actual);

    /// @notice Returns the latest  commitment tree state root.
    /// @return root The latest commitment tree state root.
    function latestRoot() external view returns (bytes32 root);

    /// @notice Checks if a commitment tree state root exists.
    /// @param root The root to check.
    /// @return isContained Whether the root exists or not.
    function containsRoot(bytes32 root) external view returns (bool isContained);
}
