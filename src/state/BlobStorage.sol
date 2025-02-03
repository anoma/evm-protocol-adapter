// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { TransientContextBytes } from "@transience/src/TransientContextBytes.sol";

import { console } from "forge-std/src/console.sol";

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
    error BlobHashMismatch(bytes32 expected, bytes32 actual);
    error DeletionCriterionNotSupported(DeletionCriterion deletionCriterion);

    mapping(bytes32 blobHash => mapping(DeletionCriterion => bytes blob)) internal blobs;
    //mapping(bytes32 blobHash => bytes32 deletionCriteriaData) criteriaData; // Stores timestamp, signature, or predicate address

    bytes internal constant EMPTY_BLOB = bytes("");
    bytes32 internal constant EMPTY_BLOB_HASH = sha256(EMPTY_BLOB);

    function getBlob(bytes32 blobHash) external view returns (bytes memory) {
        return _getBlob(blobHash);
    }

    function _storeBlob(ExpirableBlob calldata expirableBlob) internal returns (bytes32 blobHash) {
        blobHash = _storeBlob(expirableBlob.blob, expirableBlob.deletionCriterion);
    }

    // TODO refactor/optimize
    function _storeBlob(bytes calldata blob, DeletionCriterion deletionCriterion) internal returns (bytes32 blobHash) {
        blobHash = sha256(blob);

        // Blob is empty
        if (blobHash == EMPTY_BLOB_HASH) {
            console.logString("Empty");
            revert BlobEmpty();
        }

        // Blob exists already
        if (sha256(blobs[blobHash][deletionCriterion]) != EMPTY_BLOB_HASH) {
            console.logString("PreExisting");
            return blobHash;
        }

        if (deletionCriterion == DeletionCriterion.Never) {
            console.logString("Never");
            blobs[blobHash][deletionCriterion] = blob;
            return blobHash;
        }

        if (deletionCriterion == DeletionCriterion.AfterTransaction) {
            console.logString("AfterTransaction");
            blobHash.set(blob);
            return blobHash;
        }

        revert DeletionCriterionNotSupported(deletionCriterion);
    }

    function _getBlob(bytes32 blobHash) internal view returns (bytes memory blob) {
        if (blobHash == EMPTY_BLOB_HASH) {
            revert BlobEmpty();
        }

        bytes32 retrievedBlobHash;
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

        revert BlobNotFound(blobHash);
    }

    function _checkIntegrity(bytes32 blobHash, bytes32 retrievedBlobHash) internal pure {
        if (blobHash != retrievedBlobHash) {
            revert BlobHashMismatch({ expected: blobHash, actual: retrievedBlobHash });
        }
    }
}
