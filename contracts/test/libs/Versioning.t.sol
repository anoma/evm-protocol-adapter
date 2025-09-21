// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {SemVerLib} from "@solady/utils/SemVerlib.sol";

import {Test} from "forge-std/Test.sol";

import {Versioning} from "../../src/libs/Versioning.sol";

contract VersioningTest is Test {
    int256 internal constant _LT = -1;
    int256 internal constant _EQ = 0;
    int256 internal constant _GT = 1;

    function test_check_that_the_current_version_is_a_pre_release() public pure {
        assertEq(SemVerLib.cmp(Versioning._PROTOCOL_ADAPTER_VERSION, "1.0.0"), _LT);
    }
}
