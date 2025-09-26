// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title ICommitmentAccumulator
/// @author Anoma Foundation, 2025
/// @notice The interface of the commitment accumulator contract.
/// @custom:security-contact security@anoma.foundation
interface ICommitmentAccumulator {
    /// @notice Emitted when a commitment tree root is stored in the set of historical roots.
    /// @param root The root that was stored.
    event CommitmentRootStored(bytes32 root);

    /// @notice Returns the number of commitments that have been added to the tree.
    /// @return count The number of commitments in the tree.
    function commitmentCount() external view returns (uint256 count);

    /// @notice Returns the commitment tree depth.
    /// @return depth The depth of the tree.
    function commitmentTreeDepth() external view returns (uint8 depth);

    /// @notice Computes the capacity of the tree based on the depth.
    /// @return capacity The computed tree capacity.
    function commitmentTreeCapacity() external view returns (uint256 capacity);

    /// @notice Returns the latest  commitment tree state root.
    /// @return root The latest commitment tree state root.
    function latestCommitmentRoot() external view returns (bytes32 root);

    /// @notice Checks if a commitment tree root is contained in the set of historical roots.
    /// @param root The root to check.
    /// @return isContained Whether the root exists or not.
    function isCommitmentRootContained(bytes32 root) external view returns (bool isContained);

    /// @notice Returns the number of commitment roots in the historical root set.
    /// @return count The number of commitment roots in the set.
    function commitmentRootCount() external view returns (uint256 count);

    /// @notice Returns the historical commitment tree root with the given index.
    /// @param index The index to return the commitment tree root for.
    /// @return root The root at the given index.
    function commitmentRootAtIndex(uint256 index) external view returns (bytes32 root);

    /// @notice Verifies that a Merkle path (proof) and a commitment leaf reproduce a given root.
    /// @param commitmentRoot The commitment tree root to reproduce.
    /// @param commitment The commitment leaf to proof inclusion in the tree for.
    /// @param path The siblings constituting the path from the leaf to the root.
    /// @param directionBits The direction bits indicating whether the siblings are left of right.
    function verifyMerkleProof(
        bytes32 commitmentRoot,
        bytes32 commitment,
        bytes32[] calldata path,
        uint256 directionBits
    ) external view;
}
