// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { TransientContextBytes } from "@transience/src/TransientContextBytes.sol";

// ExpirableBlob
struct ExpirableBlob {
    DeletionCriterion deletionCriterion;
    bytes blob;
}

enum DeletionCriterion {
    AfterTransaction, // Specs say "AfterBlock"
    AfterTimestamp,
    AfterSigOverData,
    AfterPredicate,
    Never
}

contract BlobStorage {
    using TransientContextBytes for bytes32;

    error BlobEmpty();
    error BlobNotFound(bytes32 blobHash);
    error BlobNotExpired(bytes32 blobHash);
    error BlobExpired(bytes32 blobHash);
    error BlobHashMismatch(bytes32 expected, bytes32 actual);
    error InvalidExpiryTime(bytes32 blobHash);
    error DeletionCriterionNotSupported(DeletionCriterion deletionCriterion);

    mapping(bytes32 blobHash => mapping(DeletionCriterion => bytes blob)) internal blobs;
    mapping(bytes32 blobHash => uint256 timestamp) internal expiryTimes;

    bytes32 internal constant EMPTY_BLOB_HASH = sha256(bytes(""));

    function _storeBlob(ExpirableBlob calldata expirableBlob) internal {
        bytes32 blobHash = sha256(expirableBlob.blob);

        // Blob exists already
        if (sha256(blobs[blobHash][expirableBlob.deletionCriterion]) != EMPTY_BLOB_HASH) {
            return;
        }

        if (expirableBlob.deletionCriterion == DeletionCriterion.Never) {
            blobs[blobHash][expirableBlob.deletionCriterion] = expirableBlob.blob;
            return;
        }

        if (expirableBlob.deletionCriterion == DeletionCriterion.AfterTransaction) {
            blobHash.set(expirableBlob.blob);
            return;
        }

        revert DeletionCriterionNotSupported(expirableBlob.deletionCriterion);
    }

    function getBlob(bytes32 blobHash) external view returns (bytes memory) {
        return _getBlob(blobHash);
    }

    function _getBlob(bytes32 blobHash) internal view returns (bytes memory blob) {
        if (blobHash == EMPTY_BLOB_HASH) {
            revert BlobEmpty();
        }

        bytes32 retrievedBlobHash;

        // Try all deletion criteria

        // DeletionCriterion.AfterTransaction
        {
            blob = blobHash.get();
            retrievedBlobHash = sha256(blob);
            if (retrievedBlobHash != EMPTY_BLOB_HASH) {
                _checkIntegrity(blobHash, retrievedBlobHash);
                return blob;
            }
        }

        // DeletionCriterion.Never
        {
            blob = blobs[blobHash][DeletionCriterion.Never];
            retrievedBlobHash = sha256(blob);
            if (retrievedBlobHash != EMPTY_BLOB_HASH) {
                _checkIntegrity(blobHash, retrievedBlobHash);
                return blob;
            }
        }

        // DeletionCriterion.AfterTimestamp
        {
            blob = blobs[blobHash][DeletionCriterion.AfterTimestamp];
            retrievedBlobHash = sha256(blob);
            if (retrievedBlobHash != EMPTY_BLOB_HASH) {
                _checkExpiration(blobHash);
                _checkIntegrity(blobHash, retrievedBlobHash);

                return blob;
            }
        }

        revert BlobNotFound(blobHash);
    }

    function _checkExpiration(bytes32 blobHash) internal view {
        if (block.timestamp <= expiryTimes[blobHash]) {
            revert BlobExpired(blobHash);
        }
    }

    function _checkIntegrity(bytes32 blobHash, bytes32 retrievedBlobHash) internal pure {
        if (blobHash != retrievedBlobHash) {
            revert BlobHashMismatch({ expected: blobHash, actual: retrievedBlobHash });
        }
    }

    // TODO Protect with only owner?
    function deleteAfterTimestamp(bytes32 blobHash) external {
        _deleteAfterTimestamp(blobHash);
    }

    function _deleteAfterTimestamp(bytes32 blobHash) internal {
        if (expiryTimes[blobHash] != 0) revert InvalidExpiryTime(blobHash);
        if (block.timestamp < expiryTimes[blobHash]) revert BlobNotExpired(blobHash);

        // Deallocate storage
        blobs[blobHash][DeletionCriterion.AfterTimestamp] = bytes("");
        expiryTimes[blobHash] = 0;
    }
}
