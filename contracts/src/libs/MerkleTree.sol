// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Arrays} from "@openzeppelin-contracts/utils/Arrays.sol";

import {SHA256} from "../libs/SHA256.sol";

/// @title MerkleTree
/// @author Anoma Foundation, 2025
/// @notice A Merkle tree implementation populating a tree of variable depth from left to right
/// and providing on-chain Merkle proofs.
/// @dev This is a modified version of the OpenZeppelin `MerkleTree` and `MerkleProof` implementation.
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.4.0/contracts/utils/structs/MerkleTree.sol
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.4.0/contracts/utils/cryptography/MerkleProof.sol
/// @custom:security-contact security@anoma.foundation
library MerkleTree {
    struct Tree {
        uint256 _nextLeafIndex;
        bytes32[] _sides;
        bytes32[] _zeros;
    }

    /// @notice Thrown if the leaf index does not exist.
    error NonExistentLeafIndex(uint256 index);

    /// @notice Sets up the tree with an initial capacity (i.e. number of leaves) of 1
    /// and returns the initial root of the empty tree.
    /// @param self The tree data structure.
    /// @return initialRoot The initial root of the empty tree.
    function setup(Tree storage self) internal returns (bytes32 initialRoot) {
        initialRoot = SHA256.EMPTY_HASH;

        // Build each root of zero-filled subtrees
        bytes32 currentZero = SHA256.EMPTY_HASH;
        self._zeros.push(currentZero);
        self._sides.push(currentZero);

        self._nextLeafIndex = 0;
    }

    /// @notice Pushes a leaf to the tree.
    /// @param self The tree data structure.
    /// @param leaf The leaf to add.
    /// @return index The index of the leaf.
    /// @return accumulatorNode The new root of the tree.
    function push(Tree storage self, bytes32 leaf) internal returns (uint256 index, bytes32 accumulatorNode) {
        // If the capacity of the current Merkle tree is exhausted, then expand it
        if (self._nextLeafIndex != 0 && (self._nextLeafIndex & (self._nextLeafIndex - 1)) == 0) {
            // Compute the next zero for the next level.
            bytes32 currentZero = Arrays.unsafeAccess(self._zeros, self._zeros.length - 1).value;
            bytes32 nextZero = SHA256.hash(currentZero, currentZero);
            self._zeros.push(nextZero);
            self._sides.push(nextZero);
        }
        uint256 height = 0;
        bytes32 replacementNode = leaf;
        // Propagate a hash update up the Merkle tree until there's space
        for (; self._nextLeafIndex & (1 << height) != 0; height++) {
            // Compute the replacement of the parent node
            replacementNode = SHA256.hash(self._sides[height], replacementNode);
            // Delete the current level as it's now completed
            delete self._sides[height];
        }
        accumulatorNode = replacementNode;
        // Record where we are going to insert the new node
        uint256 insertHeight = height;
        // Now let's compute the new root hash starting from the replacement node
        for (; height < self._zeros.length - 1; height++) {
            if (self._nextLeafIndex & (1 << height) == 0) {
                // If no partial tree at current level, then right-pad the accumulator
                accumulatorNode = SHA256.hash(accumulatorNode, self._zeros[height]);
            } else {
                // If there's a partial tree, then combine it with the accumulator
                accumulatorNode = SHA256.hash(self._sides[height], accumulatorNode);
            }
        }
        // Finish off the propagation with a final assignment
        self._sides[insertHeight] = replacementNode;
        index = self._nextLeafIndex++;
    }

    /// @notice Returns the tree depth.
    /// @param self The tree data structure.
    /// @return treeDepth The depth of the tree.
    function depth(Tree storage self) internal view returns (uint256 treeDepth) {
        treeDepth = self._sides.length;
    }

    /// @notice Returns the number of leaves that have been added to the tree.
    /// @param self The tree data structure.
    /// @return count The number of leaves in the tree.
    function leafCount(Tree storage self) internal view returns (uint256 count) {
        count = self._nextLeafIndex;
    }

    /// @notice Calculates the capacity of the tree.
    /// @param self The tree data structure.
    /// @return treeCapacity The computed tree capacity.
    function capacity(Tree storage self) internal view returns (uint256 treeCapacity) {
        treeCapacity = 1 << depth(self);
    }

    /// @notice Checks whether a node is the left or right child according to its index.
    /// @param index The index to check.
    /// @return isLeft Whether this node is the left or right child.
    function isLeftChild(uint256 index) internal pure returns (bool isLeft) {
        isLeft = (index & 1) == 0;
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

    /// @notice Computes the root of a Merkle tree.
    /// @param leaves The leaves of the tree.
    /// @param treeDepth The depth of the tree.
    /// @return root The computed root.
    /// @dev This method should only be used for trees with low depth.
    function computeRoot(bytes32[] memory leaves, uint8 treeDepth) internal pure returns (bytes32 root) {
        uint256 treeCapacity = 1 << treeDepth; // 2^treeDepth

        // Create array of full leaf set with padding if necessary
        bytes32[] memory nodes = new bytes32[](treeCapacity);
        for (uint256 i = 0; i < treeCapacity; ++i) {
            if (i < leaves.length) {
                nodes[i] = leaves[i];
            } else {
                nodes[i] = SHA256.EMPTY_HASH;
            }
        }

        // Build the tree upward
        uint256 currentLevelCapacity = treeCapacity;
        while (currentLevelCapacity > 1) {
            currentLevelCapacity /= 2;

            for (uint256 i = 0; i < currentLevelCapacity; ++i) {
                nodes[i] = SHA256.hash(nodes[2 * i], nodes[2 * i + 1]);
            }
        }

        root = nodes[0];
    }

    /// @notice Computes the root of a Merkle tree using the minimal tree depth to fit all leaves.
    /// @param leaves The leaves of the tree.
    /// @return root The computed root.
    /// @dev This method should only be used for trees with low depth.
    function computeRoot(bytes32[] memory leaves) internal pure returns (bytes32 root) {
        root = MerkleTree.computeRoot({leaves: leaves, treeDepth: computeMinimalTreeDepth(leaves.length)});
    }

    /// @notice Computes the minimal required tree depth for a number of leaves.
    /// @param leavesCount The number of leaves.
    /// @return treeDepth The minimal required tree depth.
    function computeMinimalTreeDepth(uint256 leavesCount) internal pure returns (uint8 treeDepth) {
        uint256 treeCapacity = 1;
        treeDepth = 0;

        while (treeCapacity < leavesCount) {
            treeCapacity *= 2;
            ++treeDepth;
        }

        return treeDepth;
    }
}
