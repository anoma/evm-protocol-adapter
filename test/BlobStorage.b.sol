pragma solidity >=0.8.25 <0.9.0;

import {Test} from "forge-std/src/Test.sol";

import {BlobStorage, DeletionCriterion} from "../src/state/BlobStorage.sol";

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
    bytes32 internal constant EMPTY_BLOB_HASH = sha256(bytes(""));

    BlobStorageMock private bs;

    function setUp() public {
        bs = new BlobStorageMock();
    }

    function test_store_delete_after_transaction() public {
        // store
        bytes32 blobHash = bs.storeBlob(BLOB, DeletionCriterion.AfterTransaction);
        assertEq(blobHash, EXPECTED_BLOB_HASH);

        // check storage
        assertEq(bs.getBlob(blobHash), BLOB);

        emit log_uint(block.number);
        // advance block
        vm.roll(block.number + 1);
        emit log_uint(block.number);

        assertEq(bs.getBlob(blobHash), EMPTY_BLOB);
    }

    function test_store_delete_never() public {
        // store
        bytes32 blobHash = bs.storeBlob(BLOB, DeletionCriterion.Never);
        assertEq(blobHash, EXPECTED_BLOB_HASH);

        assertEq(bs.getBlob(blobHash), BLOB);

        vm.roll(block.number + 100);

        assertEq(bs.getBlob(blobHash), BLOB);
    }

    function test_cannot_be_stored_with_deletion_criterion_after_timestamp() public {
        vm.expectRevert(
            abi.encodeWithSelector(BlobStorage.DeletionCriterionNotSupported.selector, DeletionCriterion.AfterTimestamp)
        );
        bs.storeBlob(BLOB, DeletionCriterion.AfterTimestamp);
    }
}
