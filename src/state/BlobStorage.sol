// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

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

    // TODO refactor/optimize
    function _storeBlob(bytes memory blob, DeletionCriterion deletionCriterion) internal returns (bytes32) {
        bytes32 blobHash = sha256(blob);

        // Blob is empty
        if (blobHash == EMPTY_BLOB_HASH) {
            revert BlobEmpty();
        }

        // Blob exists already
        if (sha256(blobs[blobHash][deletionCriterion]) != EMPTY_BLOB_HASH) {
            return blobHash;
        }

        if (deletionCriterion == DeletionCriterion.Never) {
            blobs[blobHash][deletionCriterion] = blob;
            return blobHash;
        }

        if (deletionCriterion == DeletionCriterion.AfterTransaction) {
            blobHash.set(blob);
            return blobHash;
        }

        revert DeletionCriterionNotSupported(deletionCriterion);
    }

    function _storeBlob(ExpirableBlob memory expirableBlob) internal returns (bytes32) {
        return _storeBlob(expirableBlob.blob, expirableBlob.deletionCriterion);
    }

    function _storeBlobCalldata(bytes calldata blob, DeletionCriterion deletionCriterion) internal returns (bytes32) {
        bytes32 blobHash = sha256(blob);

        // Blob exists already
        if (sha256(blobs[blobHash][deletionCriterion]) != EMPTY_BLOB_HASH) {
            return blobHash;
        }

        if (deletionCriterion == DeletionCriterion.Never) {
            blobs[blobHash][deletionCriterion] = blob;
            return blobHash;
        }

        if (deletionCriterion == DeletionCriterion.AfterTransaction) {
            blobHash.set(blob);
            return blobHash;
        }

        revert DeletionCriterionNotSupported(deletionCriterion);
    }

    function _storeBlobCalldata(ExpirableBlob calldata expirableBlob) internal returns (bytes32) {
        return _storeBlob(expirableBlob.blob, expirableBlob.deletionCriterion);
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
