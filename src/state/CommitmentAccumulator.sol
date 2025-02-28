// SPDX-License-Identifier: MIT
pragma solidity >=0.8.27;

import { MerkleTree } from "openzeppelin-contracts/utils/structs/MerkleTree.sol";
import { MerkleProof } from "openzeppelin-contracts/utils/cryptography/MerkleProof.sol";
import { Arrays } from "openzeppelin-contracts/utils/Arrays.sol";
import { EnumerableSet } from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import { SHA256 } from "../libs/SHA256.sol";

contract CommitmentAccumulator {
    using MerkleTree for MerkleTree.Bytes32PushTree;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    using Arrays for bytes32[];

    // slither-disable-next-line max-line-length
    bytes32 internal constant EMPTY_LEAF_HASH = 0x283d1bb3a401a7e0302d0ffb9102c8fc1f4730c2715a2bfd46a9d9209d5965e0; // sha256("EMPTY_LEAF");

    MerkleTree.Bytes32PushTree internal merkleTree;
    EnumerableSet.Bytes32Set internal roots;

    // TODO Use a better merkle tree implementation that doesn't require maintaining a set for fast retrieval.
    EnumerableSet.Bytes32Set internal commitments;

    error NonExistingRoot(bytes32 root);
    error PreExistingRoot(bytes32 root);
    error InvalidRoot(bytes32 expected, bytes32 actual);

    error NonExistingCommitment(bytes32 commitment);
    error PreExistingCommitment(bytes32 commitment);

    event CommitmentAdded(bytes32 indexed commitment, uint256 indexed index, bytes32 root);

    constructor(uint8 treeDepth) {
        bytes32 initialRoot = merkleTree.setup(treeDepth, EMPTY_LEAF_HASH, SHA256.commutativeHash);

        bool success = roots.add(initialRoot);
        if (!success) revert PreExistingRoot(initialRoot);
    }

    function latestRoot() external view returns (bytes32) {
        return _latestRoot();
    }

    function containsRoot(bytes32 root) external view returns (bool) {
        return _containsRoot(root);
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

    // TODO
    // slither-disable-next-line dead-code
    function _checkCommitmentPreExistence(bytes32 commitment) internal view {
        if (!commitments.contains(commitment)) {
            revert NonExistingCommitment(commitment);
        }
    }

    function _addCommitmentUnchecked(bytes32 commitment) internal {
        // slither-disable-next-line unused-return
        commitments.add(commitment);

        (uint256 index, bytes32 newRoot) = merkleTree.push(commitment, SHA256.commutativeHash);

        // slither-disable-next-line unused-return
        roots.add(newRoot);

        emit CommitmentAdded({ commitment: commitment, index: index, root: newRoot });
    }

    function _addCommitment(bytes32 commitment) internal {
        if (!commitments.add(commitment)) {
            revert PreExistingCommitment(commitment);
        }

        (uint256 index, bytes32 newRoot) = merkleTree.push(commitment, SHA256.commutativeHash);

        if (!roots.add(newRoot)) {
            revert PreExistingRoot(newRoot);
        }

        emit CommitmentAdded({ commitment: commitment, index: index, root: newRoot });
    }

    function _latestRoot() internal view returns (bytes32) {
        return roots.at(roots.length() - 1);
    }

    function _containsRoot(bytes32 root) internal view returns (bool) {
        return roots.contains(root);
    }
}
