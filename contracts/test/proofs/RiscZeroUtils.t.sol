// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";

contract RiscZeroUtilsTest is Test {
    using RiscZeroUtils for *;

    function test_compliance_instance_length_constant() public pure {
        assertEq(RiscZeroUtils._COMPLIANCE_INSTANCE_PADDING, uint32(56).toRiscZero());
    }
}
