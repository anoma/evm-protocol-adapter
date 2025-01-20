// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { StorageSlot } from "@openzeppelin/contracts/utils/StorageSlot.sol";
import { SlotDerivation } from "@openzeppelin/contracts/utils/SlotDerivation.sol";
import { TransientSlot } from "@openzeppelin/contracts/utils/TransientSlot.sol";

struct Blob {
    DeletionCriterion deletionCriterion;
    bytes data;
}

enum DeletionCriterion {
    AfterTransaction, // Specs say "AfterBlock"
    Never
}

contract BlobStorage {
    using StorageSlot for bytes32;
    using TransientSlot for bytes32;
    using SlotDerivation for bytes32;
    using SlotDerivation for string;

    string private constant _NAMESPACE = "Anoma.Blob.Transient";
    mapping(bytes32 bindingReference => Blob) internal blobs;

    // TODO add transient storage.

    // We use `keccak256` for bytes comparison, because it is cheaper than `sha256`.
    bytes32 internal constant EMPTY = keccak256(bytes(""));

    function _storeBlob(Blob calldata blob) internal {
        bytes32 bindingReference = sha256(blob.data);

        if (keccak256(blobs[bindingReference]) != EMPTY) return;

        if (blob.deletionCriterion == DeletionCriterion.Never) {
            // Skip if the Blob exists already.
            if (keccak256(blobs[bindingReference]) == EMPTY) {
                blobs[bindingReference] = blob;
            }
        }

        if (blob.deletionCriterion == DeletionCriterion.AfterTransaction) {
            _setValueInNamespace({ key: bindingReference, newValue: blob.data });
        }
    }

    function getBlob(bytes32 bindingReference) public view returns (bytes memory) {
        return blobs[bindingReference];
    }

    function _getBlob(
        bytes32 bindingReference,
        DeletionCriterion deletionCriterion
    )
        internal
        view
        returns (bytes memory blob)
    {
        if (deletionCriterion == DeletionCriterion.Never) blob = blobs[bindingReference];

        if (deletionCriterion == DeletionCriterion.AfterTransaction) {
            _getTransientBlob({ key: bindingReference, newValue: blob.data });
        }
    }

    function _setTransientBlob(bytes calldata blob) internal {
        // TODO
    }

    function _getTransientBlob(bytes32 bindingReference) internal view returns (bytes calldata) {
        return bytes("TODO");
    }
}
