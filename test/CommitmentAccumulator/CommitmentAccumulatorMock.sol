// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { MerkleTree } from "openzeppelin-contracts/utils/structs/MerkleTree.sol";
import { MerkleProof } from "openzeppelin-contracts/utils/cryptography/MerkleProof.sol";
import { EnumerableSet } from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import { CommitmentAccumulator } from "../../src/state/CommitmentAccumulator.sol";
import { SHA256 } from "../../src/libs/SHA256.sol";

import { console } from "forge-std/console.sol";

contract CommitmentAccumulatorMock is CommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using MerkleProof for MerkleTree.Bytes32PushTree;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // TODO Why does this offset exist in `EnumerableSet`?
    uint256 internal constant COMMITMENT_INDEX_OFFSET = 1;

    error EmptyCommitment();
    error InvalidCommitmentIndexPanic(bytes32 commitment, uint256 index, uint256 nextLeafIndex);

    constructor(uint8 treeDepth) CommitmentAccumulator(treeDepth) { }

    function _checkMerklePath(
        bytes32 root, // proof
        bytes32 commitment, // verifying key
        bytes32[] memory path // instance
    )
        internal
        view
    {
        bytes32 computedRoot =
            MerkleProof.processProof({ proof: path, leaf: commitment, hasher: SHA256.commutativeHash });
        if (root != computedRoot) {
            revert InvalidRoot({ expected: root, actual: computedRoot });
        }
    }

    /// @notice This implementation is very inefficient for large tree depths.
    function _computeFullTree() internal view returns (bytes32[][] memory tree) {
        uint256 treeDepth = merkleTree.depth();

        tree = new bytes32[][](treeDepth);

        uint256 nNodes;
        // Leaves
        {
            nNodes = 2 ** treeDepth;
            uint256 nCMs = commitments.length();
            tree[0] = new bytes32[](nNodes);

            // Non-empty leaves
            for (uint256 i = 0; i < nCMs; ++i) {
                tree[0][i] = commitments.at(i);
            }

            // Empty leaves
            for (uint256 i = nCMs; i < nNodes; ++i) {
                tree[0][i] = EMPTY_LEAF_HASH;
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

    function _findCommitmentIndex(bytes32 commitment) internal view returns (uint256 index) {
        if (commitment == EMPTY_LEAF_HASH) {
            revert EmptyCommitment();
        }

        index = commitments._inner._positions[commitment] - COMMITMENT_INDEX_OFFSET;

        if (index == 0 && commitments.at(0) != commitment) {
            revert NonExistingCommitment(commitment);
        }

        if (index >= merkleTree._nextLeafIndex) {
            revert InvalidCommitmentIndexPanic(commitment, index, merkleTree._nextLeafIndex);
        }
    }

    function _computeMerklePath(bytes32 commitment) internal view returns (bytes32[] memory path) {
        uint256 leafIndex = _findCommitmentIndex(commitment);

        bytes32[][] memory nodes = _computeFullTree();

        uint256 treeDepth = merkleTree.depth();
        path = new bytes32[](treeDepth);

        uint256 currentIndex = leafIndex;

        bool isLeft = currentIndex % 2 == 0;
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
}
