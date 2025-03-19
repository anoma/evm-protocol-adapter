// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Arrays } from "@openzeppelin-contracts/utils/Arrays.sol";

import { SHA256 } from "../libs/SHA256.sol";

library MerkleTree {
    struct Tree {
        uint256 _nextLeafIndex;
        mapping(uint256 level => mapping(uint256 index => bytes32 node)) _nodes;
        bytes32[] _zeros;
    }

    // TODO move in separate file
    // slither-disable-next-line max-line-length
    /// @dev Obtained from `sha256("EMPTY_LEAF")`.
    bytes32 internal constant _EMPTY_LEAF_HASH = 0x283d1bb3a401a7e0302d0ffb9102c8fc1f4730c2715a2bfd46a9d9209d5965e0;

    error FullTree();
    error NonExistentLeafIndex(uint256 index);

    function setup(Tree storage self, uint8 treeDepth) internal returns (bytes32 initialRoot) {
        Arrays.unsafeSetLength(self._zeros, treeDepth);

        bytes32 currentZero = _EMPTY_LEAF_HASH;

        for (uint256 i = 0; i < treeDepth; ++i) {
            Arrays.unsafeAccess(self._zeros, i).value = currentZero;
            currentZero = SHA256.commutativeHash(currentZero, currentZero);
        }

        initialRoot = currentZero;

        // Store the initial root
        //TODO self._nodes[treeDepth][0] = initialRoot;

        self._nextLeafIndex = 0;
    }

    function push(Tree storage self, bytes32 leaf) internal returns (uint256 index, bytes32 newRoot) {
        uint256 treeDepth = depth(self);

        // Get the leaf's index. Note, that `_nextLeafIndex` is incremented AFTER the assignment.
        // solhint-disable-next-line gas-increment-by-one
        index = self._nextLeafIndex++;

        // Check if tree is full.
        if (index + 1 > 1 << treeDepth) {
            revert FullTree();
        }

        uint256 currentIndex = index;
        bytes32 currentHash = leaf;

        // level 0 -> leaf level, treeDepth -> root level
        for (uint256 i = 0; i < treeDepth; ++i) {
            // Store the current node
            self._nodes[i][currentIndex] = currentHash;

            // Get left sibling if it's a right child
            bytes32 sibling = isLeft(currentIndex) ? self._zeros[i] : self._nodes[i][currentIndex - 1];

            currentHash = SHA256.commutativeHash(currentHash, sibling);

            currentIndex >>= 1;
        }
        newRoot = currentHash;
    }

    function getProof(Tree storage self, uint256 index) internal view returns (bytes32[] memory proof) {
        uint256 treeDepth = depth(self);

        if (index + 1 > self._nextLeafIndex) revert NonExistentLeafIndex(index);

        proof = new bytes32[](treeDepth);
        uint256 currentIndex = index;

        bytes32 sibling;
        bytes32 empty = 0;

        for (uint256 i = 0; i < treeDepth; ++i) {
            if (isLeft(currentIndex)) {
                // Left sibling
                sibling = self._nodes[i][currentIndex + 1];
            } else {
                // Right sibling
                sibling = self._nodes[i][currentIndex - 1];
            }
            proof[i] = sibling == empty ? self._zeros[i] : sibling;

            currentIndex >>= 1;
        }
    }

    function depth(Tree storage self) internal view returns (uint256 treeDepth) {
        treeDepth = self._zeros.length;
    }

    function leafCount(Tree storage self) internal view returns (uint256 numberOfLeafs) {
        numberOfLeafs = self._nextLeafIndex;
    }

    function isLeft(uint256 index) internal pure returns (bool isIndexLeft) {
        isIndexLeft = index % 2 == 0;
    }
}
