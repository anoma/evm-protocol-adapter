// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {BlobStorage} from "../../src/state/BlobStorage.sol";

contract BlobStorageMock is BlobStorage {
    function storeBlob(bytes calldata blob, BlobStorage.DeletionCriterion deletionCriterion)
        external
        returns (bytes32 blobHash)
    {
        blobHash = _storeBlob(blob, deletionCriterion);
    }
}
