pragma solidity >=0.8.25 <0.9.0;

import { Test } from "forge-std/Test.sol";

import { BlobStorage, DeletionCriterion } from "../src/state/BlobStorage.sol";

contract BlobStorageMock is BlobStorage {
    function storeBlob(bytes calldata blob, DeletionCriterion deletionCriterion) external returns (bytes32 blobHash) {
        blobHash = _storeBlob(blob, deletionCriterion);
    }
}

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract BlobStorageTest is Test {
    string internal constant BLOB_CONTENT = "Blob";
    bytes internal constant BLOB = abi.encode(BLOB_CONTENT);
    bytes32 internal constant EXPECTED_BLOB_HASH = sha256(BLOB);

    bytes internal constant EMPTY_BLOB = bytes("");

    bytes32 internal constant ZERO_HASH = bytes32(0);
    bytes32 internal constant EMPTY_BLOB_HASH = sha256(bytes(""));

    BlobStorageMock private bs;

    function setUp() public {
        bs = new BlobStorageMock();
    }

    function test_store_delete_never_returns_correct_blob_hash() public {
        assertEq(bs.storeBlob(BLOB, DeletionCriterion.Never), EXPECTED_BLOB_HASH);
    }

    function test_store_delete_immediately_returns_empty_blob_hash() public {
        assertEq(bs.storeBlob(BLOB, DeletionCriterion.Immediately), ZERO_HASH);
    }

    function test_store_delete_never_should_revert_for_empty_blob() public {
        vm.expectRevert(BlobStorage.BlobEmpty.selector);
        bs.storeBlob(EMPTY_BLOB, DeletionCriterion.Never);
    }

    function test_store_delete_immediately() public {
        bytes32 blobHash = bs.storeBlob(BLOB, DeletionCriterion.Immediately);

        vm.expectRevert(abi.encodeWithSelector(BlobStorage.BlobNotFound.selector, blobHash));
        bs.getBlob(blobHash);
    }

    function test_store_delete_never() public {
        bytes32 blobHash = bs.storeBlob(BLOB, DeletionCriterion.Never);

        assertEq(blobHash, EXPECTED_BLOB_HASH);

        assertEq(bs.getBlob(blobHash), BLOB);

        vm.roll(block.number + 100);

        assertEq(bs.getBlob(blobHash), BLOB);
    }
}
