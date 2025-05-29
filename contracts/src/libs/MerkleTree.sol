// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Arrays} from "@openzeppelin-contracts/utils/Arrays.sol";

import {SHA256} from "../libs/SHA256.sol";

/// @notice A Merkle tree implementation populating a tree of variable depth from left to right
/// and providing on-chain Merkle proofs.
/// @dev This is a modified version of the OpenZeppelin `MerkleTree` and `MerkleProof` implementation.
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.3.0/contracts/utils/structs/MerkleTree.sol
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.3.0/contracts/utils/cryptography/MerkleProof.sol
library MerkleTree {
    struct Tree {
        uint256 _nextLeafIndex;
        mapping(uint256 level => mapping(uint256 index => bytes32 node)) _nodes;
        bytes32[] _zeros;
    }

    /// @notice Thrown if the tree capacity is reached.
    error TreeCapacityExceeded();

    /// @notice Thrown if the leaf index does not exist.
    error NonExistentLeafIndex(uint256 index);

    /// @notice Sets up the tree with a capacity (i.e. number of leaves) of `2**treeDepth`
    /// and computes the initial root of the empty tree.
    /// @param self The tree data structure.
    /// @param treeDepth The tree depth [0, 255].
    /// @return initialRoot The initial root of the empty tree.
    function setup(Tree storage self, uint8 treeDepth) internal returns (bytes32 initialRoot) {
        Arrays.unsafeSetLength(self._zeros, treeDepth);

        bytes32 currentZero = SHA256.EMPTY_HASH;

        for (uint256 i = 0; i < treeDepth; ++i) {
            Arrays.unsafeAccess(self._zeros, i).value = currentZero;
            currentZero = SHA256.hash(currentZero, currentZero);
        }

        initialRoot = currentZero;

        self._nextLeafIndex = 0;
    }

    /// @notice Pushes a leaf to the tree.
    /// @param self The tree data structure.
    /// @param leaf The leaf to add.
    /// @return index The index of the leaf.
    /// @return newRoot The new root of the tree.
    function push(Tree storage self, bytes32 leaf) internal returns (uint256 index, bytes32 newRoot) {
        // Cache the tree depth read.
        uint256 treeDepth = depth(self);

        // Get the next leaf index and increment it after assignment.
        // solhint-disable-next-line gas-increment-by-one
        index = self._nextLeafIndex++;

        // Check if the tree is already full.
        if (index + 1 > 1 << treeDepth) revert TreeCapacityExceeded();

        // Rebuild the branch from leaf to root.
        uint256 currentIndex = index;
        bytes32 currentLevelHash = leaf;
        for (uint256 i = 0; i < treeDepth; ++i) {
            // Store the current node hash at depth `i`.
            self._nodes[i][currentIndex] = currentLevelHash;

            // Compute the next level hash for depth `i+1`.
            // Check whether the `currentIndex` node is the left or right child of its parent.
            if (isLeftChild(currentIndex)) {
                // Compute the `currentLevelHash` using the right sibling.
                // Because we fill the tree from left to right,
                // the right child is empty and we must use the depth `i` zero hash.
                currentLevelHash = SHA256.hash(currentLevelHash, Arrays.unsafeAccess(self._zeros, i).value);
            } else {
                // Compute the `currentLevelHash` using the left sibling.
                // Because we fill the tree from left to right,
                // the left child is the previous node at depth `i`.
                currentLevelHash = SHA256.hash(self._nodes[i][currentIndex - 1], currentLevelHash);
            }

            currentIndex >>= 1;
        }
        newRoot = currentLevelHash;
    }

    /// @notice Computes a Merkle proof consisting of the sibling at each depth and the associated direction bit
    /// indicating whether the sibling is left (0) or right (1) at the respective depth.
    /// @param self The tree data structure.
    /// @param index The index of the leaf.
    /// @return siblings The siblings of the leaf to proof inclusion for.
    /// @return directionBits The direction bits indicating whether the siblings are left of right.
    function merkleProof(Tree storage self, uint256 index)
        internal
        view
        returns (bytes32[] memory siblings, uint256 directionBits)
    {
        uint256 treeDepth = depth(self);

        // Check whether the index exists or not.
        if (index + 1 > self._nextLeafIndex) revert NonExistentLeafIndex(index);

        siblings = new bytes32[](treeDepth);
        uint256 currentIndex = index;
        bytes32 currentSibling;

        // Iterate over the different tree levels starting at the bottom at the leaf level.
        for (uint256 i = 0; i < treeDepth; ++i) {
            // Check if the current node the left or right child of its parent.
            if (isLeftChild(currentIndex)) {
                // Sibling is right.
                currentSibling = self._nodes[i][currentIndex + 1];

                // Set the direction bit at position `i` to 1.
                directionBits |= (1 << i);
            } else {
                // Sibling is left.
                currentSibling = self._nodes[i][currentIndex - 1];

                // Leave the direction bit at position `i` as 0.
            }

            // Check if the sibling is an empty subtree.
            if (currentSibling == bytes32(0)) {
                // The subtree node doesn't exist, so we store the zero hash instead.
                siblings[i] = Arrays.unsafeAccess(self._zeros, i).value;
            } else {
                // The subtree node exists, so we store it.
                siblings[i] = currentSibling;
            }

            // Shift the number one bit to the right to drop the last binary digit.
            currentIndex >>= 1;
        }
    }

    /// @notice Returns the tree depth.
    /// @param self The tree data structure.
    /// @return treeDepth The depth of the tree.
    function depth(Tree storage self) internal view returns (uint256 treeDepth) {
        treeDepth = self._zeros.length;
    }

    /// @notice Returns the number of leafs that have been added to the tree.
    /// @param self The tree data structure.
    /// @return count The number of leaves in the tree.
    function leafCount(Tree storage self) internal view returns (uint256 count) {
        count = self._nextLeafIndex;
    }

    /// @notice Checks whether a node is the left or right child according to its index.
    /// @param index The index to check.
    /// @return isLeft Whether this node is the left or right child.
    function isLeftChild(uint256 index) internal pure returns (bool isLeft) {
        isLeft = index & 1 == 0;
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
    /// @param treeDepth The tree depth.
    /// @return root The computed root.
    /// @dev This method should only be used for trees with low depth.
    function computeRoot(bytes32[] memory leaves, uint256 treeDepth) internal pure returns (bytes32 root) {
        uint256 totalLeafs = 1 << treeDepth; // 2^treeDepth

        // Create array of full leaf set with padding if necessary
        bytes32[] memory nodes = new bytes32[](totalLeafs);
        for (uint256 i = 0; i < totalLeafs; ++i) {
            if (i < leaves.length) {
                nodes[i] = leaves[i];
            } else {
                nodes[i] = SHA256.EMPTY_HASH;
            }
        }

        // Build the tree upward
        uint256 currentSize = totalLeafs;
        while (currentSize > 1) {
            currentSize /= 2;

            for (uint256 i = 0; i < currentSize; ++i) {
                nodes[i] = sha256(abi.encodePacked(nodes[2 * i], nodes[2 * i + 1]));
            }
        }

        root = nodes[0];
    }
}
