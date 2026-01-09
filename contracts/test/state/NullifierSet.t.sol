// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std-1.14.0/src/Test.sol";
import {NullifierSet} from "../../src/state/NullifierSet.sol";
import {NullifierSetMock} from "../mocks/NullifierSet.m.sol";

contract NullifierSetTest is Test {
    bytes32 internal constant _EXAMPLE_NF = bytes32(uint256(1));

    NullifierSetMock internal _nfSet;

    function setUp() public {
        _nfSet = new NullifierSetMock();
    }

    function test_addNullifier_adds_nullifier() public {
        assertEq(_nfSet.isNullifierContained(_EXAMPLE_NF), false);
        _nfSet.addNullifier(_EXAMPLE_NF);
    }

    function test_addNullifier_reverts_on_duplicate() public {
        _nfSet.addNullifier(_EXAMPLE_NF);

        vm.expectRevert(
            abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, _EXAMPLE_NF), address(_nfSet)
        );
        _nfSet.addNullifier(_EXAMPLE_NF);
    }

    function test_length_returns_the_length() public {
        assertEq(_nfSet.nullifierCount(), 0);

        uint256 n = 10;
        for (uint256 i = 1; i < n; ++i) {
            _nfSet.addNullifier(bytes32(uint256(i)));
            assertEq(_nfSet.nullifierCount(), i);
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
            assertEq(_nfSet.nullifierAtIndex(i), nf);
        }
    }

    function test_contains_returns_true_if_the_nullifier_is_contained() public {
        _nfSet.addNullifier(_EXAMPLE_NF);
        assertEq(_nfSet.isNullifierContained(_EXAMPLE_NF), true);
    }

    function test_contains_returns_false_if_the_nullifier_is_not_contained() public view {
        assertEq(_nfSet.isNullifierContained(_EXAMPLE_NF), false);
    }
}
