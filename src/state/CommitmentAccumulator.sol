// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { MerkleTree } from "@openzeppelin/contracts/utils/structs/MerkleTree.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import { SHA256 } from "../libs/SHA256.sol";

contract CommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using MerkleProof for MerkleTree.Bytes32PushTree;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    bytes32 internal constant EMPTY_LEAF_HASH = sha256("EMPTY_LEAF");
    bytes32 internal immutable INITIAL_ROOT;

    MerkleTree.Bytes32PushTree internal merkleTree;
    EnumerableSet.Bytes32Set internal roots;
    EnumerableSet.Bytes32Set internal commitments;

    error NonExistingRoot(bytes32 root);
    error PreExistingRoot(bytes32 root);
    error InvalidRoot(bytes32 expected, bytes32 actual);
    error NonExistingCommitment(bytes32 commitment);
    error PreExistingCommitment(bytes32 commitment);

    function(bytes32, bytes32) internal view returns (bytes32) internal fnHash = SHA256.commutativeHash;

    event CommitmentAdded(bytes32 indexed commitment, uint256 indexed index, bytes32 root);

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
    function _checkMerklePath(
        bytes32 root, // proof
        bytes32 commitment, // verifying key
        bytes32[] memory siblings // instance
    )
        internal
        pure
    {
        bytes32 expectedRoot = MerkleProof.processProof({ proof: siblings, leaf: commitment });

        if (root != expectedRoot) {
            revert InvalidRoot({ expected: expectedRoot, actual: root });
        }
    }

    function _checkRootPreExistence(bytes32 root) internal view {
        if (!roots.contains(root)) {
            revert NonExistingRoot(root);
            // NOTE by Xuyang: If `root` doesn't exist, the corresponding resource doesn't exist.
            // In the compliance, we checked the root generation. This makes sure that the root corresponds to the
            // resource.
        }
    }

    function _checkCommitmentNonExistence(bytes32 commitment) internal view {
        if (commitments.contains(commitment)) {
            revert PreExistingCommitment(commitment);
        }
    }

    function _checkCommitmentPreExistence(bytes32 commitment) internal view {
        if (!commitments.contains(commitment)) {
            revert NonExistingCommitment(commitment);
        }
    }

    function _addCommitment(bytes32 commitment) internal {
        if (!commitments.add(commitment)) {
            revert PreExistingCommitment(commitment);
        }

        (uint256 index, bytes32 newRoot) = merkleTree.push(commitment, fnHash);
        if (!roots.add(newRoot)) {
            revert PreExistingRoot(newRoot);
        }
        emit CommitmentAdded({ commitment: commitment, index: index, root: newRoot });
    }
}
