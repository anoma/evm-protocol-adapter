// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Test } from "forge-std/Test.sol";

import { BlobStorage, DeletionCriterion } from "../../src/state/BlobStorage.sol";

import { BlobStorageMock } from "./BlobStorageMock.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract BlobStorageTest is Test {
    string internal constant _BLOB_CONTENT = "Blob";
    bytes internal constant _BLOB = abi.encode(_BLOB_CONTENT);
    bytes32 internal constant _EXPECTED_BLOB_HASH = sha256(_BLOB);

    bytes internal constant _EMPTY__BLOB = bytes("");

    bytes32 internal constant _ZERO_HASH = bytes32(0);
    bytes32 internal constant _EMPTY__BLOB_HASH = sha256(bytes(""));

    BlobStorageMock private _bs;

    function setUp() public {
        _bs = new BlobStorageMock();
    }

    function test_storeDeleteNeverReturnsCorrectBlobhash() public {
        assertEq(_bs.storeBlob(_BLOB, DeletionCriterion.Never), _EXPECTED_BLOB_HASH);
    }

    function test_storeDeleteImmediatelyReturnsEmptyBlobhash() public {
        assertEq(_bs.storeBlob(_BLOB, DeletionCriterion.Immediately), _ZERO_HASH);
    }

    function test_storeDeleteNeverShouldRevertForEmptyBlob() public {
        vm.expectRevert(BlobStorage.BlobEmpty.selector);
        _bs.storeBlob(_EMPTY__BLOB, DeletionCriterion.Never);
    }

    function test_storeDeleteImmediately() public {
        bytes32 blobHash = _bs.storeBlob(_BLOB, DeletionCriterion.Immediately);

        vm.expectRevert(abi.encodeWithSelector(BlobStorage.BlobNotFound.selector, blobHash));
        _bs.lookupBlob(blobHash);
    }

    function test_storeDeleteNever() public {
        bytes32 blobHash = _bs.storeBlob(_BLOB, DeletionCriterion.Never);

        assertEq(blobHash, _EXPECTED_BLOB_HASH);

        assertEq(_bs.lookupBlob(blobHash), _BLOB);

        vm.roll(block.number + 100);

        assertEq(_bs.lookupBlob(blobHash), _BLOB);
    }
}
