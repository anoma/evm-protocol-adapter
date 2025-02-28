// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface IBlobStorage {
    /// @notice Looks a blob up in the blob storage or reverts.
    /// @param blobHash The hash of the blob to lookup.
    /// @return blob The found blob.
    function lookupBlob(bytes32 blobHash) external view returns (bytes memory blob);
}
