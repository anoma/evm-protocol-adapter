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

    function test_isNullifierContained_returns_true_for_existent_nullifier() public view {
        assertEq(_tags.isNullifierContained({nullifier: _tags[0]}), true);
        assertEq(_tags.isNullifierContained({nullifier: _tags[2]}), true);
    }

    function test_isNullifierContained_returns_false_for_non_existent_nullifier() public view {
        assertEq(_tags.isNullifierContained({nullifier: _tags[1]}), false);
        assertEq(_tags.isNullifierContained({nullifier: _tags[3]}), false);
        assertEq(_tags.isNullifierContained({nullifier: bytes32(type(uint256).max)}), false);
    }
}
