// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {CommitmentTree} from "../../src/state/CommitmentTree.sol";

contract CommitmentTreeMock is CommitmentTree {
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using MerkleTree for MerkleTree.Tree;

    function addCommitment(bytes32 commitment) external returns (bytes32 newRoot) {
        newRoot = _addCommitment(commitment);
    }

    function addCommitmentTreeRoot(bytes32 root) external {
        _addCommitmentTreeRoot(root);
    }

    function initialRoot() external view returns (bytes32 hash) {
        hash = _roots.at(0);
    }
}
