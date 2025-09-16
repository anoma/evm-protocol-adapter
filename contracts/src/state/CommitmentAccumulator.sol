// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Arrays} from "@openzeppelin-contracts/utils/Arrays.sol";
import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {TransientSlot} from "@openzeppelin-contracts/utils/TransientSlot.sol";

import {ICommitmentAccumulator} from "../interfaces/ICommitmentAccumulator.sol";
import {MerkleTree} from "../libs/MerkleTree.sol";

/// @title CommitmentAccumulator
/// @author Anoma Foundation, 2025
/// @notice A commitment accumulator being inherited by the protocol adapter.
/// @dev The contract is based on a modified version of OZ's `MerkleTree` implementation and and the unchanged OZ
/// `EnumerableSet` implementation.
/// @custom:security-contact security@anoma.foundation
contract CommitmentAccumulator is ICommitmentAccumulator {
    using MerkleTree for MerkleTree.Tree;
    using MerkleTree for bytes32[];
    using TransientSlot for TransientSlot.Bytes32Slot;
    using TransientSlot for bytes32;
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using Arrays for bytes32[];

    /// @notice The ERC-7201 storage location of the Xan V1 contract (see https://eips.ethereum.org/EIPS/eip-7201).
    // solhint-disable-next-line max-line-length
    /// @dev Obtained from `keccak256(abi.encode(uint256(keccak256("anoma.storage.MerkleTree.v1.currentRoot")) - 1)) & ~bytes32(uint256(0xff))`.
    bytes32 private constant _CURRENT_ROOT_TRANSIENT_STORAGE =
        0x36332f0934cf7f4e10e62c4c446116395e0d782bbbe111b9b0de6d9f16fc0200;

    MerkleTree.Tree internal _merkleTree;
    EnumerableSet.Bytes32Set internal _roots;

    error EmptyCommitment();
    error NonExistingCommitment(bytes32 commitment);
    error PreExistingCommitment(bytes32 commitment);
    error CommitmentMismatch(bytes32 expected, bytes32 actual);
    error CommitmentIndexOutOfBounds(uint256 current, uint256 limit);

    error NonExistingRoot(bytes32 root);
    error PreExistingRoot(bytes32 root);
    error InvalidRoot(bytes32 expected, bytes32 actual);
    error InvalidPathLength(uint256 expected, uint256 actual);

    /// @notice Initializes the commitment accumulator by setting up a Merkle tree.
    constructor() {
        bytes32 initialRoot = _merkleTree.setup();
        _CURRENT_ROOT_TRANSIENT_STORAGE.asBytes32().tstore(initialRoot);
        _storeRoot();
    }

    /// @inheritdoc ICommitmentAccumulator
    function latestRoot() external view override returns (bytes32 root) {
        root = _latestRoot();
    }

    /// @inheritdoc ICommitmentAccumulator
    function containsRoot(bytes32 root) external view override returns (bool isContained) {
        isContained = _containsRoot(root);
    }

    /// @inheritdoc ICommitmentAccumulator
    function verifyMerkleProof(bytes32 root, bytes32 commitment, bytes32[] calldata path, uint256 directionBits)
        external
        view
        override
    {
        _verifyMerkleProof({root: root, commitment: commitment, path: path, directionBits: directionBits});
    }

    /// @notice Adds a commitment to to the set, if it does not exist already and returns the new root.
    /// @param commitment The commitment to add.
    function _addCommitment(bytes32 commitment) internal {
        // slither-disable-next-line unused-return
        (, bytes32 updatedRoot) = _merkleTree.push(commitment);

        _CURRENT_ROOT_TRANSIENT_STORAGE.asBytes32().tstore(updatedRoot);
    }

    /// @notice Stores a root in the set of historical roots.
    function _storeRoot() internal {
        bytes32 currentRoot = _CURRENT_ROOT_TRANSIENT_STORAGE.asBytes32().tload();
        if (!_roots.add(currentRoot)) {
            revert PreExistingRoot(currentRoot);
        }
    }

    /// @notice An internal function verifying that a Merkle path (proof) and a commitment leaf reproduce a given root.
    /// @param root The root to reproduce.
    /// @param commitment The commitment leaf to proof inclusion in the tree for.
    /// @param path The siblings constituting the path from the leaf to the root.
    /// @param directionBits The direction bits indicating whether the siblings are left of right.
    function _verifyMerkleProof(bytes32 root, bytes32 commitment, bytes32[] calldata path, uint256 directionBits)
        internal
        view
    {
        // Check length.
        if (path.length != _merkleTree.depth()) {
            revert InvalidPathLength({expected: _merkleTree.depth(), actual: path.length});
        }

        // Check root existence.
        if (!_roots.contains(root)) {
            revert NonExistingRoot(root);
        }

        // Check that the commitment leaf and path reproduce the root.
        bytes32 computedRoot = path.processProof(directionBits, commitment);

        if (root != computedRoot) {
            revert InvalidRoot({expected: root, actual: computedRoot});
        }
    }

    /// @notice Checks the existence of a root in the set of historical roots.
    /// @param root The root to check.
    function _checkRootPreExistence(bytes32 root) internal view {
        if (!_roots.contains(root)) {
            revert NonExistingRoot(root);
        }
    }

    /// @notice Returns the latest  commitment tree state root.
    /// @return root The latest commitment tree state root.
    function _latestRoot() internal view returns (bytes32 root) {
        root = _roots.at(_roots.length() - 1);
    }

    /// @notice Checks if a commitment tree state root exists.
    /// @param root The root to check.
    /// @return isContained Whether the root exists or not.
    function _containsRoot(bytes32 root) internal view returns (bool isContained) {
        isContained = _roots.contains(root);
    }
}
