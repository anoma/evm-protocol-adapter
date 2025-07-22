// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {BlobStorage} from "../state/BlobStorage.sol";

/// @title IBlobStorage
/// @author Anoma Foundation, 2025
/// @notice The interface of the blob storage being inherited by the protocol adapter.
/// @custom:security-contact security@anoma.foundation
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
