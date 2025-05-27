// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";

import {BlobStorage} from "../../src/state/BlobStorage.sol";

import {BlobStorageMock} from "../mocks/BlobStorageMock.sol";

contract BlobStorageTest is Test {
    string internal constant _BLOB_CONTENT = "Blob";
    bytes internal constant _BLOB = abi.encode(_BLOB_CONTENT);
    bytes32 internal constant _EXPECTED_BLOB_HASH = sha256(_BLOB);
    bytes internal constant _EMPTY_BLOB = bytes("");
    bytes32 internal constant _EMPTY_BLOB_HASH = sha256(bytes(""));

    BlobStorageMock private _bs;

    function setUp() public {
        _bs = new BlobStorageMock();
    }

    function test_storeBlob_deletionCriterion_Never_returns_the_blob_hash() public {
        assertEq(_bs.storeBlob(_BLOB, BlobStorage.DeletionCriterion.Never), _EXPECTED_BLOB_HASH);
    }

    function test_storeBlob_deletionCriterion_Never_reverts_on_empty_blob() public {
        vm.expectRevert(BlobStorage.BlobEmpty.selector);
        _bs.storeBlob(_EMPTY_BLOB, BlobStorage.DeletionCriterion.Never);
    }

    function test_storeBlob_deletionCriterion_Never_stores_blobs_forever() public {
        bytes32 blobHash = _bs.storeBlob(_BLOB, BlobStorage.DeletionCriterion.Never);

        assertEq(blobHash, _EXPECTED_BLOB_HASH);
        assertEq(_bs.lookupBlob(blobHash), _BLOB);

        // Advance to the maximal timestamp.
        vm.roll(type(uint256).max);
        assertEq(_bs.lookupBlob(blobHash), _BLOB);
    }

    function test_storeBlob_deletionCriterion_Immediately_reverts_on_empty_blob() public {
        vm.expectRevert(BlobStorage.BlobEmpty.selector);
        _bs.storeBlob(_EMPTY_BLOB, BlobStorage.DeletionCriterion.Immediately);
    }

    /// @dev Ensures that the non-existent blobs cannot be looked up
    function test_lookupBlob_reverts_for_non_existent_blob() public {
        bytes32 blobHash = sha256("NON_EXISTENT_BLOB");
        vm.expectRevert(abi.encodeWithSelector(BlobStorage.BlobNotFound.selector, blobHash));
        _bs.lookupBlob(blobHash);
    }

    /// @dev Ensures that immediately deleted blobs cannot be looked up.
    function test_lookupBlob_reverts_for_immediately_deleted_blob() public {
        bytes32 blobHash = _bs.storeBlob(_BLOB, BlobStorage.DeletionCriterion.Immediately);

        vm.expectRevert(abi.encodeWithSelector(BlobStorage.BlobNotFound.selector, blobHash));
        _bs.lookupBlob(blobHash);
    }
}
