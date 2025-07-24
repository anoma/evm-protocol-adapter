// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {TagLookup} from "../src/libs/TagLookup.sol";

contract TagLookupTest is Test {
    using TagLookup for bytes32[];

    bytes32[] internal _tags;

    function setUp() public {
        _tags = new bytes32[](4);

        _tags[0] = bytes32(uint256(0)); // Nf 1
        _tags[1] = bytes32(uint256(1)); // Cm 1
        _tags[2] = bytes32(uint256(2)); // Nf 2
        _tags[3] = bytes32(uint256(3)); // Cm 1
    }

    function test_checkNullifierNonExistence_reverts_if_the_nullifier_exists() public {
        vm.expectRevert(abi.encodeWithSelector(TagLookup.NullifierDuplicated.selector, _tags[0]), address(this));
        _tags.checkNullifierNonExistence(_tags[0]);
    }

    function test_checkCommitmentNonExistence_reverts_if_commitment_exists() public {
        vm.expectRevert(abi.encodeWithSelector(TagLookup.CommitmentDuplicated.selector, _tags[1]), address(this));
        _tags.checkCommitmentNonExistence(_tags[1]);
    }

    function test_checkNullifierNonExistence_passes_if_the_nullifier_does_not_exist() public view {
        _tags.checkNullifierNonExistence(_tags[1]);
    }

    function test_checkCommitmentNonExistence_passes_if_the_commitment_does_not_exist() public view {
        _tags.checkCommitmentNonExistence(_tags[0]);
    }

    function test_isFoundInEvenOrOddPosition_returns_true_for_existent_tag_in_even_positions() public view {
        assertEq(_tags.isFoundInEvenOrOddPosition({tag: _tags[0], even: true}), true);
        assertEq(_tags.isFoundInEvenOrOddPosition({tag: _tags[2], even: true}), true);
    }

    function test_isFoundInEvenOrOddPosition_returns_false_for_non_existent_tag_in_even_positions() public view {
        assertEq(_tags.isFoundInEvenOrOddPosition({tag: _tags[1], even: true}), false);
        assertEq(_tags.isFoundInEvenOrOddPosition({tag: _tags[3], even: true}), false);
    }

    function test_isFoundInEvenOrOddPosition_returns_true_for_existent_tag_in_odd_positions() public view {
        assertEq(_tags.isFoundInEvenOrOddPosition({tag: _tags[1], even: false}), true);
        assertEq(_tags.isFoundInEvenOrOddPosition({tag: _tags[3], even: false}), true);
    }

    function test_isFoundInEvenOrOddPosition_returns_false_for_non_existent_tag_in_odd_positions() public view {
        assertEq(_tags.isFoundInEvenOrOddPosition({tag: _tags[0], even: false}), false);
        assertEq(_tags.isFoundInEvenOrOddPosition({tag: _tags[2], even: false}), false);
    }
}
