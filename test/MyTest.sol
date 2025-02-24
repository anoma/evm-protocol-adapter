// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import { Test } from "forge-std/Test.sol";

contract MyContract {
    function method() external pure {
        _method();
    }

    function methodWithSha() external pure {
        _methodWithSha();
    }

    function _method() internal pure {
        revert();
    }

    function _methodWithSha() internal pure {
        sha256("SOMETHING");
        revert();
    }
}

contract MyTest is Test, MyContract {
    MyContract mc;

    function setUp() public {
        mc = new MyContract();
    }

    function test_external_method_revert() public {
        vm.expectRevert();
        mc.method();
        // [PASS]
    }

    function test_external_method_with_sha_revert() public {
        vm.expectRevert();
        mc.methodWithSha();
        // [PASS]
    }

    function test_internal_method_revert() public {
        vm.expectRevert();
        _method();
        // [PASS]
    }

    function test_internal_method_with_sha_revert() public {
        vm.expectRevert();
        _methodWithSha();
        // [FAIL: next call did not revert as expected]
    }
}
