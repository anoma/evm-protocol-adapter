// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { MerkleProof } from "@openzeppelin-contracts/utils/cryptography/MerkleProof.sol";

import { EnumerableSet } from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import { MerkleTree } from "@openzeppelin-contracts/utils/structs/MerkleTree.sol";

import { SHA256 } from "../../src/libs/SHA256.sol";

import { CommitmentAccumulator } from "../../src/state/CommitmentAccumulator.sol";
import { ImprovedMerkleTree } from "../../src/state/ImprovedMerkleTree.sol";

import { ICommitmentAccumulatorMock } from "./ICommitmentAccumulatorMock.sol";

contract CommitmentAccumulatorMock is ICommitmentAccumulatorMock, CommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using MerkleProof for bytes32[];
    using EnumerableSet for EnumerableSet.Bytes32Set;

    constructor(uint8 treeDepth) CommitmentAccumulator(treeDepth) { }

    function addCommitment(bytes32 commitment) external returns (bytes32 newRoot) {
        newRoot = _addCommitment(commitment);
    }

    function addCommitmentUnchecked(bytes32 commitment) external returns (bytes32 newRoot) {
        newRoot = _addCommitmentUnchecked(commitment);
    }

    function merkleTreeZero(uint8 level) external view returns (bytes32 zeroHash) {
        zeroHash = _merkleTreeZero(level);
    }

    function checkMerklePath(bytes32 root, bytes32 commitment, bytes32[] calldata path) external view {
        bytes32 computedRoot = path.processProof(commitment, SHA256.commutativeHash);
        if (root != computedRoot) {
            revert InvalidRoot({ expected: root, actual: computedRoot });
        }
    }

    function computeMerklePath(bytes32 commitment) external view returns (bytes32[] memory path) {
        uint256 leafIndex = _findCommitmentIndex(commitment);

        bytes32[][] memory nodes = _computeFullTree();

        uint256 treeDepth = _merkleTree.depth();
        path = new bytes32[](treeDepth);

        uint256 currentIndex = leafIndex;

        bool isLeft;
        // Merkle Path
        for (uint256 d = 0; d < treeDepth; ++d) {
            isLeft = currentIndex % 2 == 0;

            if (isLeft) {
                uint256 rightIndex = currentIndex + 1;
                path[d] = nodes[d][rightIndex];
            } else {
                uint256 leftIndex = currentIndex - 1;
                path[d] = nodes[d][leftIndex];
            }

            currentIndex >>= 1; // Move to the parent node
        }

        return path;
    }

    function commitmentCount() external view returns (uint256 count) {
        count = _merkleTree._nextLeafIndex;
    }

    function initialRoot() external view returns (bytes32 hash) {
        hash = _roots.at(0);
    }

    function emptyLeafHash() external view returns (bytes32 hash) {
        hash = _merkleTreeZero(0);
    }

    function findCommitmentIndex(bytes32 commitment) external view returns (uint256 index) {
        index = _findCommitmentIndex(commitment);
    }

    function commitmentAtIndex(uint256 index) external view returns (bytes32 commitment) {
        commitment = _commitmentAtIndex(index);
    }

    function _merkleTreeZero(uint256 level) internal view returns (bytes32 zeroHash) {
        zeroHash = _merkleTree._zeros[level];
    }

    /// @notice This implementation is very inefficient for large tree depths.
    function _computeFullTree() internal view returns (bytes32[][] memory tree) {
        uint256 treeDepth = _merkleTree.depth();

        tree = new bytes32[][](treeDepth);

        uint256 nNodes;
        // Leaves
        {
            nNodes = 2 ** treeDepth;
            uint256 nCMs = _commitments.length();
            tree[0] = new bytes32[](nNodes);

            // Non-empty leaves
            for (uint256 i = 0; i < nCMs; ++i) {
                tree[0][i] = _commitments.at(i);
            }

            // Empty leaves
            for (uint256 i = nCMs; i < nNodes; ++i) {
                tree[0][i] = ImprovedMerkleTree._EMPTY_LEAF_HASH;
            }
        }

        // Nodes
        for (uint256 d = 1; d < treeDepth; ++d) {
            nNodes = 2 ** (treeDepth - d);
            tree[d] = new bytes32[](nNodes);

            for (uint256 i = 0; i < nNodes; ++i) {
                tree[d][i] = SHA256.commutativeHash({ a: tree[d - 1][(i * 2)], b: tree[d - 1][(i * 2) + 1] });
            }
        }
    }
}
