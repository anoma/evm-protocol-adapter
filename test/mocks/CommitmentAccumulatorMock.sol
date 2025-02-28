// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { MerkleProof } from "@openzeppelin-contracts/utils/cryptography/MerkleProof.sol";
import { EnumerableSet } from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import { MerkleTree } from "@openzeppelin-contracts/utils/structs/MerkleTree.sol";

import { SHA256 } from "../../src/libs/SHA256.sol";
import { CommitmentAccumulator } from "../../src/state/CommitmentAccumulator.sol";

contract CommitmentAccumulatorMock is CommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using MerkleProof for bytes32[];
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // TODO Why does this offset exist in `EnumerableSet`?
    uint256 internal constant _COMMITMENT_INDEX_OFFSET = 1;

    error EmptyCommitment();
    error InvalidCommitmentIndexPanic(bytes32 commitment, uint256 index, uint256 nextLeafIndex);

    constructor(uint8 treeDepth) CommitmentAccumulator(treeDepth) { }

    function addCommitment(bytes32 commitment) external {
        _addCommitment(commitment);
    }

    function addCommitmentUnchecked(bytes32 commitment) external {
        _addCommitmentUnchecked(commitment);
    }

    function merkleTreeZero(uint8 level) external view returns (bytes32 zeroHash) {
        zeroHash = _merkleTree._zeros[level];
    }

    function checkMerklePath(bytes32 root, bytes32 commitment, bytes32[] calldata path) external view {
        bytes32 computedRoot = path.processProof(commitment, SHA256.commutativeHash);
        if (root != computedRoot) {
            revert InvalidRoot({ expected: root, actual: computedRoot });
        }
    }

    function computeMerklePath(bytes32 commitment) external view returns (bytes32[] memory path) {
        uint256 leafIndex = findCommitmentIndex(commitment);

        bytes32[][] memory nodes = computeFullTree();

        uint256 treeDepth = _merkleTree.depth();
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

    function emptyLeafHash() external pure returns (bytes32 hash) {
        hash = _EMPTY_LEAF_HASH;
    }

    /// @notice This implementation is very inefficient for large tree depths.
    function computeFullTree() public view returns (bytes32[][] memory tree) {
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
                tree[0][i] = _EMPTY_LEAF_HASH;
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

    function findCommitmentIndex(bytes32 commitment) public view returns (uint256 index) {
        if (commitment == _EMPTY_LEAF_HASH) {
            revert EmptyCommitment();
        }

        index = _commitments._inner._positions[commitment] - _COMMITMENT_INDEX_OFFSET;

        if (index == 0 && _commitments.at(0) != commitment) {
            revert NonExistingCommitment(commitment);
        }

        if (index >= _merkleTree._nextLeafIndex) {
            revert InvalidCommitmentIndexPanic(commitment, index, _merkleTree._nextLeafIndex);
        }
    }
}
