// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Logic} from "../../src/libs/proving/Logic.sol";

contract TagLookupTest is Test {
    using Logic for Logic.VerifierInput[];

    Logic.VerifierInput[] internal _exampleList;

    error LookupCallFailed();

    function externalLookupHelper(Logic.VerifierInput[] calldata list, bytes32 tag)
        external
        pure
        returns (Logic.VerifierInput calldata found)
    {
        found = list.lookup(tag);
    }

    function setUp() public {
        uint256 n = 10;
        for (uint256 i = 0; i < n; ++i) {
            _exampleList.push();
            _exampleList[i].tag = bytes32(i);
        }
    }

    function test_lookup_reverts_on_empty_list() public {
        Logic.VerifierInput[] memory empty;

        bytes32 missing = keccak256("missing");
        vm.expectRevert(abi.encodeWithSelector(Logic.TagNotFound.selector, missing));
        _lookupMem(empty, missing);
    }

    function test_lookup_reverts_if_the_tag_is_not_found() public {
        bytes32 missing = keccak256("missing");
        vm.expectRevert(abi.encodeWithSelector(Logic.TagNotFound.selector, missing));
        _lookupMem(_exampleList, missing);
    }

    function test_lookup_returns_the_verifier_input_if_it_finds_the_lookup_tag() public {
        for (uint256 i = 0; i < _exampleList.length; ++i) {
            assertEq(
                keccak256(abi.encode(_lookupMem(_exampleList, _exampleList[i].tag))),
                keccak256(abi.encode(_exampleList[i]))
            );
        }
    }

    function _lookupMem(Logic.VerifierInput[] memory list, bytes32 tag)
        internal
        returns (Logic.VerifierInput memory found)
    {
        bytes memory data = abi.encodeCall(this.externalLookupHelper, (list, tag));

        // Perform a staticcall to `self` with the encoded calldata
        (bool ok, bytes memory result) = address(this).call(data); // solhint-disable-line avoid-low-level-calls
        if (!ok) {
            revert LookupCallFailed();
        }

        // Decode the result back into memory
        found = abi.decode(result, (Logic.VerifierInput));
    }
}
