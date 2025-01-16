// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { MerkleTree } from "@openzeppelin/contracts/utils/structs/MerkleTree.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { SHA256 } from "./libs/SHA256.sol";

contract CommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using MerkleProof for MerkleTree.Bytes32PushTree;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    bytes32 internal constant EMPTY_LEAF_HASH = sha256("EMPTY_LEAF");
    bytes32 internal immutable INITIAL_ROOT;

    MerkleTree.Bytes32PushTree internal merkleTree;
    EnumerableSet.Bytes32Set internal roots;
    mapping(bytes32 commitmentIdentifier => bool exists) public commitments;

    error DuplicateCommitment(bytes32 commitmentIdentifier);

    function(bytes32, bytes32) internal view returns (bytes32) internal fnHash = SHA256.commutativeHash;

    event CommitmentAdded(bytes32 indexed commitmentIdentifier, uint256 indexed index, bytes32 root);

    constructor(uint8 treeDepth) {
        INITIAL_ROOT = merkleTree.setup(treeDepth, EMPTY_LEAF_HASH, fnHash);
    }

    function latestRoot() external view returns (bytes32) {
        return roots.at(roots.length() - 1);
    }

    function containsRoot(bytes32 root) public view returns (bool) {
        return roots.contains(root);
    }

    function rootByIndex(uint256 index) external view returns (bytes32) {
        return roots.at(index);
    }

    // TODO Does the Protocol adapter backend need this function?
    function verifyMerklePath(
        bytes32 root,
        bytes32 commitmentIdentifier,
        bytes32[] memory witness
    )
        public
        view
        returns (bool)
    {
        if (!roots.contains(root)) {
            revert("ROOT DOES NOT EXISTENT"); // TODO return false or revert?
                // NOTE by Xuyang: If `root` doesn't exist, the corresponding resource doesn't exist.
                // In the compliance, we checked the root generation. This makes sure that the root corresponds to the
                // resource.
        }
        return MerkleProof.verify({ proof: witness, root: root, leaf: commitmentIdentifier });
    }

    function _addCommitment(bytes32 commitmentIdentifier) internal {
        if (commitments[commitmentIdentifier]) {
            revert DuplicateCommitment(commitmentIdentifier);
        }

        commitments[commitmentIdentifier] = true;
        (uint256 index, bytes32 newRoot) = merkleTree.push(commitmentIdentifier, fnHash);
        roots.add(newRoot);
        emit CommitmentAdded({ commitmentIdentifier: commitmentIdentifier, index: index, root: newRoot });
    }
}
