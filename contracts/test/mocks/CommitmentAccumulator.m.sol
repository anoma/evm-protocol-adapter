// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {CommitmentAccumulator} from "../../src/state/CommitmentAccumulator.sol";

contract CommitmentAccumulatorMock is CommitmentAccumulator {
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using MerkleTree for MerkleTree.Tree;

    constructor() CommitmentAccumulator() {}

    function addCommitment(bytes32 commitment) external returns (bytes32 newRoot) {
        newRoot = _addCommitment(commitment);
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

    function capacity() external view returns (uint256 treeCapacity) {
        treeCapacity = _merkleTree.capacity();
    }

    function depth() external view returns (uint256 treeDepth) {
        treeDepth = _merkleTree.depth();
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
