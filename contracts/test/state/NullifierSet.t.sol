// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {NullifierSet} from "../../src/state/NullifierSet.sol";
import {NullifierSetMock} from "../mocks/NullifierSetMock.sol";

contract NullifierSetTest is Test {
    bytes32 internal constant _EXAMPLE_NF = bytes32(0);

    NullifierSetMock internal _nfSet;

    function setUp() public {
        _nfSet = new NullifierSetMock();
    }

    function test_addNullifier_adds_nullifier() public {
        _nfSet.checkNullifierNonExistence(_EXAMPLE_NF);
        _nfSet.addNullifier(_EXAMPLE_NF);
    }

    function test_addNullifier_reverts_on_duplicate() public {
        _nfSet.addNullifier(_EXAMPLE_NF);

        vm.expectRevert(
            abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, _EXAMPLE_NF), address(_nfSet)
        );
        _nfSet.addNullifier(_EXAMPLE_NF);
    }

    function test_checkNullifierNonExistence_reverts_on_existent_nullifier() public {
        _nfSet.addNullifier(_EXAMPLE_NF);

        vm.expectRevert(
            abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, _EXAMPLE_NF), address(_nfSet)
        );
        _nfSet.checkNullifierNonExistence(_EXAMPLE_NF);
    }

    function test_checkNullifierNonExistence_passes_on_non_existent_nullifier() public view {
        _nfSet.checkNullifierNonExistence(_EXAMPLE_NF);
    }
}
