// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {BlobStorage} from "../state/BlobStorage.sol";

interface IBlobStorage {
    /// @notice Emitted if a blob is stored.
    /// @param blobHash The hash of the blob being stored.
    /// @param deletionCriterion The deletion criterion of the blob.
    event BlobStored(bytes32 indexed blobHash, BlobStorage.DeletionCriterion indexed deletionCriterion);

    /// @notice Looks a blob up in the blob storage or reverts.
    /// @param blobHash The hash of the blob to lookup.
    /// @return blob The found blob.
    function lookupBlob(bytes32 blobHash) external view returns (bytes memory blob);
}
