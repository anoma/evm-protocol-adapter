// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

enum DeletionCriterion {
    Immediately,
    Never
}

// ExpirableBlob
struct ExpirableBlob {
    DeletionCriterion deletionCriterion;
    bytes blob;
}

contract BlobStorage {
    error BlobEmpty();
    error BlobNotFound(bytes32 blobHash);
    error BlobHashMismatch(bytes32 expected, bytes32 actual);
    error DeletionCriterionNotSupported(DeletionCriterion deletionCriterion);

    mapping(bytes32 blobHash => bytes blob) internal blobs;

    bytes internal constant EMPTY_BLOB = bytes("");
    bytes32 internal constant EMPTY_BLOB_HASH = sha256(EMPTY_BLOB);

    function getBlob(bytes32 blobHash) external view returns (bytes memory) {
        return _getBlob(blobHash);
    }

    function _storeBlob(ExpirableBlob calldata expirableBlob) internal returns (bytes32 blobHash) {
        blobHash = _storeBlob(expirableBlob.blob, expirableBlob.deletionCriterion);
    }

    function _storeBlob(bytes calldata blob, DeletionCriterion deletionCriterion) internal returns (bytes32 blobHash) {
        // Blob doesn't need to be stored
        if (deletionCriterion == DeletionCriterion.Immediately) {
            // Return zero
            return blobHash;
        }

        // Compute the blob hash
        blobHash = sha256(blob);

        // Blob is empty
        if (blobHash == EMPTY_BLOB_HASH) {
            revert BlobEmpty();
        }
        // Blob is stored already
        else if (sha256(blobs[blobHash]) != EMPTY_BLOB_HASH) {
            return blobHash;
        }
        // Store blob forever
        else if (deletionCriterion == DeletionCriterion.Never) {
            blobs[blobHash] = blob;
            return blobHash;
        }

        revert DeletionCriterionNotSupported(deletionCriterion);
    }

    function _getBlob(bytes32 blobHash) internal view returns (bytes memory blob) {
        if (blobHash == EMPTY_BLOB_HASH) {
            revert BlobEmpty();
        }

        // DeletionCriterion.Never
        {
            blob = blobs[blobHash];
            bytes32 retrievedBlobHash = sha256(blob);
            if (retrievedBlobHash != EMPTY_BLOB_HASH) {
                _checkIntegrity(blobHash, retrievedBlobHash);
                return blob;
            }
        }

        revert BlobNotFound(blobHash);
    }

    function _checkIntegrity(bytes32 blobHash, bytes32 retrievedBlobHash) internal pure {
        if (blobHash != retrievedBlobHash) {
            revert BlobHashMismatch({ expected: blobHash, actual: retrievedBlobHash });
        }
    }
}
