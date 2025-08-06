// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {CommonBase} from "../../lib/forge-std/src/Base.sol";
import {StdAssertions} from "../../lib/forge-std/src/StdAssertions.sol";
import {StdChains} from "../../lib/forge-std/src/StdChains.sol";
import {StdCheats, StdCheatsSafe} from "../../lib/forge-std/src/StdCheats.sol";
import {StdUtils} from "../../lib/forge-std/src/StdUtils.sol";
import {Test} from "../../lib/forge-std/src/Test.sol";
import {NullifierSet} from "../../src/state/NullifierSet.sol";
import {NullifierSetMock} from "../mocks/NullifierSetMock.sol";

contract NullifierSetTest is Test {
    bytes32 internal constant _EXAMPLE_NF = bytes32(uint256(1));

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

    function test_length_returns_the_length() public {
        assertEq(_nfSet.length(), 0);

        uint256 n = 10;
        for (uint256 i = 1; i < n; ++i) {
            _nfSet.addNullifier(bytes32(uint256(i)));
            assertEq(_nfSet.length(), i);
        }
    }

    function test_atIndex_returns_the_nullifier_at_the_give_index() public {
        uint256 n = 10;
        for (uint256 i = 0; i < n; ++i) {
            bytes32 nf = bytes32(uint256(i));
            _nfSet.addNullifier(nf);
        }

        for (uint256 i = 0; i < n; ++i) {
            bytes32 nf = bytes32(uint256(i));
            assertEq(_nfSet.atIndex(i), nf);
        }
    }

    function test_contains_returns_true_if_the_nullifier_is_contained() public {
        _nfSet.addNullifier(_EXAMPLE_NF);
        assertEq(_nfSet.contains(_EXAMPLE_NF), true);
    }

    function test_checkNullifierNonExistence_passes_on_non_existent_nullifier() public view {
        _nfSet.checkNullifierNonExistence(_EXAMPLE_NF);
    }

    function test_contains_returns_false_if_the_nullifier_is_not_contained() public view {
        assertEq(_nfSet.contains(_EXAMPLE_NF), false);
    }
}
