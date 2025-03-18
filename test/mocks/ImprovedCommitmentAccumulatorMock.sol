// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {MerkleProof} from "@openzeppelin-contracts/utils/cryptography/MerkleProof.sol";
import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import {SHA256} from "../../src/libs/SHA256.sol";
import {ImprovedCommitmentAccumulator} from "../../src/state/ImprovedCommitmentAccumulator.sol";
import {ImprovedMerkleTree} from "../../src/state/ImprovedMerkleTree.sol";

import {ICommitmentAccumulatorMock} from "./ICommitmentAccumulatorMock.sol";

contract ImprovedCommitmentAccumulatorMock is ICommitmentAccumulatorMock, ImprovedCommitmentAccumulator {
    using ImprovedMerkleTree for ImprovedMerkleTree.Tree;
    using MerkleProof for bytes32[];
    using EnumerableSet for EnumerableSet.Bytes32Set;

    constructor(uint8 treeDepth) ImprovedCommitmentAccumulator(treeDepth) {}

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
            revert InvalidRoot({expected: root, actual: computedRoot});
        }
    }

    function computeMerklePath(bytes32 commitment) external view returns (bytes32[] memory proof) {
        uint256 leafIndex = _findCommitmentIndex(commitment);
        return _merkleTree.getProof(leafIndex);
    }

    function commitmentCount() external view returns (uint256 count) {
        count = _merkleTree._leafCount();
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
