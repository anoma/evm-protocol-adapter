// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { EnumerableSet } from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import { CommitmentAccumulator } from "../../src/state/CommitmentAccumulator.sol";
import { MerkleTree } from "../../src/state/MerkleTree.sol";

contract CommitmentAccumulatorMock is CommitmentAccumulator {
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using MerkleTree for MerkleTree.Tree;

    constructor(uint8 treeDepth) CommitmentAccumulator(treeDepth) { }

    function addCommitment(bytes32 commitment) external returns (bytes32 newRoot) {
        newRoot = _addCommitment(commitment);
    }

    function addCommitmentUnchecked(bytes32 commitment) external returns (bytes32 newRoot) {
        newRoot = _addCommitmentUnchecked(commitment);
    }

    function storeRoot(bytes32 root) external {
        _storeRoot(root);
    }

    function merkleTreeZero(uint8 level) external view returns (bytes32 zeroHash) {
        zeroHash = _merkleTreeZero(level);
    }

    function commitmentCount() external view returns (uint256 count) {
        count = _merkleTree.leafCount();
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
}
