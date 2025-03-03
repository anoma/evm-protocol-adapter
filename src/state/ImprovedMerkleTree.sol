// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Arrays } from "@openzeppelin-contracts/utils/Arrays.sol";
import { Panic } from "@openzeppelin-contracts/utils/Panic.sol";

import { SHA256 } from "../libs/SHA256.sol";

import { console } from "forge-std/console.sol";

library ImprovedMerkleTree {
    // TODO move in separate file

    // slither-disable-next-line max-line-length
    /// @dev Obtained from `sha256("EMPTY_LEAF")`.
    bytes32 internal constant _EMPTY_LEAF_HASH = 0x283d1bb3a401a7e0302d0ffb9102c8fc1f4730c2715a2bfd46a9d9209d5965e0;

    struct Tree {
        uint256 _nextLeafIndex;
        mapping(uint256 level => mapping(uint256 index => bytes32 node)) _nodes; // Stores all nodes [level][index]
        bytes32[] _zeros;
    }

    function setup(Tree storage self, uint8 treeDepth) internal returns (bytes32 initialRoot) {
        Arrays.unsafeSetLength(self._zeros, treeDepth);

        bytes32 currentZero = _EMPTY_LEAF_HASH;
        for (uint32 i = 0; i < treeDepth; ++i) {
            Arrays.unsafeAccess(self._zeros, i).value = currentZero;
            currentZero = SHA256.commutativeHash(currentZero, currentZero);
        }

        initialRoot = currentZero;

        // Store the initial root
        self._nodes[treeDepth][0] = initialRoot;

        self._nextLeafIndex = 0;
    }

    function push(Tree storage self, bytes32 leaf) internal returns (uint256 index, bytes32 newRoot) {
        uint256 treeDepth = _depth(self);

        // increments after assignment
        index = self._nextLeafIndex++;

        if (index >= 1 << treeDepth) {
            Panic.panic(Panic.RESOURCE_ERROR);
        }

        uint256 currentIndex = index;
        bytes32 currentHash = leaf;

        // level 0 -> leaf level, treeDepth -> root level
        for (uint32 i = 0; i < treeDepth; i++) {
            // Store the current node
            self._nodes[i][currentIndex] = currentHash;

            // Get left sibling if it's a right child
            bytes32 sibling = _isLeft(currentIndex) ? self._zeros[i] : self._nodes[i][currentIndex - 1];

            currentHash = SHA256.commutativeHash(currentHash, sibling);

            currentIndex >>= 1;
        }
        newRoot = currentHash;

        // Store the new root
        self._nodes[treeDepth][0] = newRoot;
    }

    function getProof(Tree storage self, uint256 index) internal view returns (bytes32[] memory proof) {
        uint256 treeDepth = _depth(self);
        require(index < self._nextLeafIndex, "Leaf does not exist");

        proof = new bytes32[](treeDepth);
        uint256 currentIndex = index;

        bytes32 sibling;
        bytes32 empty = 0;

        for (uint32 i = 0; i < treeDepth; i++) {
            if (_isLeft(currentIndex)) {
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

    function _root(Tree storage self) internal view returns (bytes32) {
        return self._nodes[_depth(self)][0];
    }

    /// @dev Tree's depth (set at initialization)
    function _depth(Tree storage self) internal view returns (uint8) {
        // TODO safecast
        return uint8(self._zeros.length);
    }

    // TODO move?
    function _leafCount(Tree storage self) internal view returns (uint256) {
        return self._nextLeafIndex;
    }

    function _isLeft(uint256 index) internal pure returns (bool isLeft) {
        isLeft = index % 2 == 0;
    }
}
