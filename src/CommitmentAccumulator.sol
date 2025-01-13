// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { MerkleTree } from "@openzeppelin/contracts/utils/structs/MerkleTree.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { Hashes } from "@openzeppelin/contracts/utils/cryptography/Hashes.sol";
//TODO import { Poseidon } from "./libs/Poseidon.sol";

contract CommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using MerkleProof for MerkleTree.Bytes32PushTree;

    MerkleTree.Bytes32PushTree internal merkleTree;

    bytes32 public immutable initialRoot;
    mapping(uint256 index => bytes32 root) public roots;

    // TODO Use merkle tree that cannot include duplicates by construction.
    mapping(bytes32 commitmentIdentifier => bool exists) public commitments;

    error DuplicateCommitment(bytes32 commitmentIdentifier);

    //TODO use Poseidon.commutativeHash2;
    function(bytes32, bytes32) internal view returns (bytes32) internal fnHash = Hashes.commutativeKeccak256;

    event CommitmentAdded(bytes32 indexed commitmentIdentifier, uint256 indexed index, bytes32 root);

    constructor(uint8 treeDepth) {
        bytes32 emptyLeafHash = keccak256("EMPTY LEAF");
        initialRoot = merkleTree.setup(treeDepth, emptyLeafHash, fnHash);
    }

    function latestRoot() external view returns (bytes32) {
        return roots[nextLeafIndex() - 1];
    }

    // TODO Does the Protocol adapter backend need this function?
    function verify(bytes32 root, bytes32 commitmentIdentifier, bytes32[] memory witness) public pure returns (bool) {
        return MerkleProof.verify({ proof: witness, root: root, leaf: commitmentIdentifier });
    }

    function _addCommitment(bytes32 commitmentIdentifier) internal {
        // TODO Use merkle tree that cannot include duplicates by construction.
        if (commitments[commitmentIdentifier]) {
            revert DuplicateCommitment(commitmentIdentifier);
        }

        (uint256 index, bytes32 newRoot) = merkleTree.push(commitmentIdentifier, fnHash);
        roots[index] = (newRoot);
        emit CommitmentAdded({ commitmentIdentifier: commitmentIdentifier, index: index, root: newRoot });
    }

    function nextLeafIndex() internal view returns (uint256) {
        return merkleTree._nextLeafIndex;
    }
}
