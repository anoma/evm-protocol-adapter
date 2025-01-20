// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { AppData, DeletionCriterion } from "../libs/AppData.sol";

contract BlobStorage {
    mapping(bytes32 bindingReference => bytes blob) internal blobs;
    // TODO add transient storage.

    // We use `keccak256` for bytes comparison, because it is cheaper than `sha256`.
    bytes32 internal constant EMPTY = keccak256(bytes(""));

    function _storeBlob(AppData calldata appData) internal {
        if (appData.deletionCriterion == DeletionCriterion.Never) {
            bytes32 bindingReference = sha256(appData.data);

            // Skip if the Blob exists already.
            if (keccak256(blobs[bindingReference]) == EMPTY) {
                blobs[bindingReference] = appData.data;
            }
        }

        if (appData.deletionCriterion == DeletionCriterion.AfterTransaction) {
            // TODO Put into transient storage.
        }
    }

    function getBlob(bytes32 bindingReference) external view returns (bytes memory) {
        return blobs[bindingReference];
    }
}
