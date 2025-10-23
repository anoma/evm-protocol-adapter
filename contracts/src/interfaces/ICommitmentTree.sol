// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title ICommitmentTree
/// @author Anoma Foundation, 2025
/// @notice The interface of the commitment tree contract.
/// @custom:security-contact security@anoma.foundation
interface ICommitmentTree {
    /// @notice Emitted when a commitment tree root is added to the set of historical roots.
    /// @param root The commitment tree root being stored.
    event CommitmentTreeRootAdded(bytes32 root);

    /// @notice Returns the number of commitments that have been added to the tree.
    /// @return count The number of commitments in the tree.
    function commitmentCount() external view returns (uint256 count);

    /// @notice Returns the commitment tree depth.
    /// @return depth The depth of the tree.
    function commitmentTreeDepth() external view returns (uint8 depth);

    /// @notice Computes the capacity of the tree based on the current tree depth.
    /// @return capacity The computed tree capacity.
    function commitmentTreeCapacity() external view returns (uint256 capacity);

    /// @notice Returns the latest  commitment tree root.
    /// @return root The latest commitment tree root.
    function latestCommitmentTreeRoot() external view returns (bytes32 root);

    /// @notice Returns whether a commitment tree root is contained in the set of historical roots or not.
    /// @param root The root to check.
    /// @return isContained Whether the root exists or not.
    function isCommitmentTreeRootContained(bytes32 root) external view returns (bool isContained);

    /// @notice Returns the number of commitment roots in the historical root set.
    /// @return count The number of commitment roots in the set.
    function commitmentTreeRootCount() external view returns (uint256 count);

    /// @notice Returns the historical commitment tree root with the given index.
    /// @param index The index to return the commitment tree root for.
    /// @return root The root at the given index.
    function commitmentTreeRootAtIndex(uint256 index) external view returns (bytes32 root);
}
