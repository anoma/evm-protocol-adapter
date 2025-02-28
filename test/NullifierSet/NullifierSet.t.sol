// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Test } from "forge-std/Test.sol";

import { NullifierSetMock, NullifierSet } from "./NullifierSetMock.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract NullifierSetTest is Test {
    bytes32 internal constant _EXAMPLE_NF = bytes32(0);

    NullifierSetMock private _nfSet;

    function setUp() public {
        _nfSet = new NullifierSetMock();
    }

    // addNullifier
    function test_addNullifier_shouldAdd() public {
        _nfSet.checkNullifierNonExistence(_EXAMPLE_NF);
        _nfSet.addNullifier(_EXAMPLE_NF);

        vm.expectRevert(abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, _EXAMPLE_NF));
        _nfSet.checkNullifierNonExistence(_EXAMPLE_NF);
    }

    function test_addNullifier_shouldRevertOnDuplicate() public {
        _nfSet.addNullifier(_EXAMPLE_NF);

        vm.expectRevert(abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, _EXAMPLE_NF));
        _nfSet.addNullifier(_EXAMPLE_NF);
    }

    function test_addNullifierUnchecked_shouldAdd() public {
        _nfSet.checkNullifierNonExistence(_EXAMPLE_NF);
        _nfSet.addNullifierUnchecked(_EXAMPLE_NF);

        vm.expectRevert(abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, _EXAMPLE_NF));
        _nfSet.checkNullifierNonExistence(_EXAMPLE_NF);
    }

    function test_addNullifierUnchecked_shouldNotRevertOnDuplicate() public {
        _nfSet.addNullifierUnchecked(_EXAMPLE_NF);

        _nfSet.addNullifierUnchecked(_EXAMPLE_NF);
    }
}
