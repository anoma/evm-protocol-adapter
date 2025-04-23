// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {BlobStorage, DeletionCriterion} from "../../src/state/BlobStorage.sol";

contract BlobStorageMock is BlobStorage {
    function storeBlob(bytes calldata blob, DeletionCriterion deletionCriterion) external returns (bytes32 blobHash) {
        blobHash = _storeBlob(blob, deletionCriterion);
    }
}
