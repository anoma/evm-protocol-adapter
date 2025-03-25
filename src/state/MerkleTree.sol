// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Arrays } from "@openzeppelin-contracts/utils/Arrays.sol";

import { SHA256 } from "../libs/SHA256.sol";

/// @dev This is a modified version of the OpenZeppelin MerkleTree implementation.
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.2.0/contracts/utils/structs/MerkleTree.sol
library MerkleTree {
    struct Tree {
        uint256 _nextLeafIndex;
        mapping(uint256 level => mapping(uint256 index => bytes32 node)) _nodes;
        bytes32[] _zeros;
    }

    /// @dev Obtained from `sha256("EMPTY_LEAF")`.
    bytes32 internal constant _EMPTY_LEAF_HASH = 0x283d1bb3a401a7e0302d0ffb9102c8fc1f4730c2715a2bfd46a9d9209d5965e0;

    error TreeCapacityExceeded();
    error NonExistentLeafIndex(uint256 index);

    /// @dev The caller
    function setup(Tree storage self, uint8 treeDepth) internal returns (bytes32 initialRoot) {
        Arrays.unsafeSetLength(self._zeros, treeDepth);

        bytes32 currentZero = _EMPTY_LEAF_HASH;

        for (uint256 i = 0; i < treeDepth; ++i) {
            Arrays.unsafeAccess(self._zeros, i).value = currentZero;
            currentZero = SHA256.hash2(currentZero, currentZero);
        }

        initialRoot = currentZero;

        self._nextLeafIndex = 0;
    }

    function push(Tree storage self, bytes32 leaf) internal returns (uint256 index, bytes32 newRoot) {
        // Cache read
        uint256 treeDepth = depth(self);

        // Get leaf index.
        // solhint-disable-next-line gas-increment-by-one
        index = self._nextLeafIndex++;

        // Check if tree is full.
        if (index + 1 > 1 << treeDepth) revert TreeCapacityExceeded();

        // Rebuild branch from leaf to root.
        uint256 currentIndex = index;
        bytes32 currentLevelHash = leaf;
        for (uint256 i = 0; i < treeDepth; ++i) {
            // Store the current node
            self._nodes[i][currentIndex] = currentLevelHash;

            // Reaching the parent node, is currentLevelHash the left child?
            bytes32 sibling = isLeft(currentIndex) ? self._zeros[i] : self._nodes[i][currentIndex - 1];

            currentLevelHash = SHA256.hash2(currentLevelHash, sibling);

            currentIndex >>= 1;
        }
        newRoot = currentLevelHash;
    }

    function merkleProof(Tree storage self, uint256 index) internal view returns (bytes32[] memory proof) {
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
