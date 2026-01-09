// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std-1.14.0/src/Test.sol";
import {SemVerLib} from "solady-0.1.26/src/utils/SemVerLib.sol";

import {Versioning} from "../../src/libs/Versioning.sol";

contract VersioningTest is Test {
    int256 internal constant _LT = -1;
    int256 internal constant _EQ = 0;
    int256 internal constant _GT = 1;

    function test_check_that_the_current_version_is_the_initial_release() public pure {
        assertEq(SemVerLib.cmp(Versioning._PROTOCOL_ADAPTER_VERSION, "1.0.0"), _EQ);
    }
}
