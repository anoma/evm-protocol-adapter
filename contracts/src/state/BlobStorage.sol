// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IBlobStorage} from "../interfaces/IBlobStorage.sol";

/// @title BlobStorage
/// @author Anoma Foundation, 2025
/// @notice A on-chain blob storage implementation being inherited by the protocol adapter with two deletion criteria.
/// @custom:security-contact security@anoma.foundation
contract BlobStorage is IBlobStorage {
    /// @notice An enum representing the supported blob deletion criteria.
    enum DeletionCriterion {
        Immediately,
        Never
    }

    /// @notice A blob with a deletion criterion attached.
    /// @param deletionCriterion The deletion criterion.
    /// @param blob The bytes-encoded blob data.
    struct ExpirableBlob {
        DeletionCriterion deletionCriterion;
        bytes blob;
    }

    bytes internal constant _EMPTY_BLOB = bytes("");
    bytes32 internal constant _EMPTY_BLOB_HASH = sha256(_EMPTY_BLOB);

    mapping(bytes32 blobHash => bytes blob) internal _blobs;

    error BlobEmpty();
    error BlobNotFound(bytes32 blobHash);
    error BlobHashMismatch(bytes32 expected, bytes32 actual);
    error DeletionCriterionNotSupported(DeletionCriterion deletionCriterion);

    /// @inheritdoc IBlobStorage
    function lookupBlob(bytes32 blobHash) external view override returns (bytes memory blob) {
        blob = _lookupBlob(blobHash);
    }

    /// @notice Stores a blob with a deletion criterion and returns the blob hash.
    /// @param expirableBlob The deletion criterion and blob.
    /// @return blobHash The resulting blob hash.
    function _storeBlob(ExpirableBlob calldata expirableBlob) internal returns (bytes32 blobHash) {
        blobHash = _storeBlob(expirableBlob.blob, expirableBlob.deletionCriterion);
    }

    /// @notice Stores a blob with a deletion criterion and returns the blob hash.
    /// @param blob The blob to be stored.
    /// @param deletionCriterion The deletion criterion of the blob.
    /// @return blobHash The resulting blob hash.
    function _storeBlob(bytes calldata blob, DeletionCriterion deletionCriterion) internal returns (bytes32 blobHash) {
        // Compute the blob hash
        blobHash = sha256(blob);

        // Blob cannot be empty
        if (blobHash == _EMPTY_BLOB_HASH) {
            revert BlobEmpty();
        }

        // Blob doesn't need to be stored
        if (deletionCriterion == DeletionCriterion.Immediately) {
            // Return zero
            return blobHash;
        }
        // Blob is stored already
        else if (sha256(_blobs[blobHash]) != _EMPTY_BLOB_HASH) {
            return blobHash;
        }
        // Store blob forever
        else if (deletionCriterion == DeletionCriterion.Never) {
            emit BlobStored({blobHash: blobHash, deletionCriterion: DeletionCriterion.Never});

            _blobs[blobHash] = blob;
            return blobHash;
        }

        revert DeletionCriterionNotSupported(deletionCriterion);
    }

    /// @notice Looks up a blob hash and returns the blob success or reverts.
    /// @param blobHash The blob hash to look up.
    /// @return blob The associated blob.
    function _lookupBlob(bytes32 blobHash) internal view returns (bytes memory blob) {
        if (blobHash == _EMPTY_BLOB_HASH) {
            revert BlobEmpty();
        }

        // DeletionCriterion.Never
        {
            blob = _blobs[blobHash];
            bytes32 retrievedBlobHash = sha256(blob);
            if (retrievedBlobHash != _EMPTY_BLOB_HASH) {
                // Check integrity for the retrieved blob
                if (blobHash != retrievedBlobHash) {
                    revert BlobHashMismatch({expected: blobHash, actual: retrievedBlobHash});
                }
                return blob;
            }
        }

        revert BlobNotFound(blobHash);
    }
}
