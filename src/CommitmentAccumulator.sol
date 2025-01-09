// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { MerkleTree } from "@openzeppelin/contracts/utils/structs/MerkleTree.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { Hashes } from "@openzeppelin/contracts/utils/cryptography/Hashes.sol";

contract CommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using MerkleProof for MerkleTree.Bytes32PushTree;

    MerkleTree.Bytes32PushTree internal merkleTree;

    bytes32[] public _roots;

    event CommitmentAdded(bytes32 indexed commitmentIdentifier, uint256 indexed index, bytes32 root);

    function(bytes32, bytes32) internal view returns (bytes32) internal fnHash = Hashes.commutativeKeccak256;

    constructor(uint8 treeDepth) {
        bytes32 initialRoot = merkleTree.setup(treeDepth, keccak256("EMPTY LEAF"), fnHash);
        _roots.push(initialRoot);
    }

    function latestRoot() public view returns (bytes32) {
        return _roots[_roots.length - 1];
    }

    function verify(bytes32 root, bytes32 commitment, bytes32[] memory witness) public pure returns (bool) {
        return MerkleProof.verify({ proof: witness, root: root, leaf: commitment });
    }

    function _addCommitment(bytes32 commitmentIdentifier) internal {
        (uint256 index, bytes32 newRoot) = merkleTree.push(commitmentIdentifier, fnHash);
        _roots.push(newRoot);
        // TODO What happens if key exists already/
        emit CommitmentAdded({ commitmentIdentifier: commitmentIdentifier, index: index, root: newRoot });
    }
}
