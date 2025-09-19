// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IPermit2} from "@permit2/src/interfaces/IPermit2.sol";
import {Permit2Lib} from "@permit2/src/libraries/Permit2Lib.sol";

import {Test} from "forge-std/Test.sol";

import {DeployPermit2} from "../script/DeployPermit2.s.sol";

contract DeployPermit2Test is Test {
    IPermit2 internal _permit2;

    function setUp() public {
        _permit2 = new DeployPermit2().run();
    }

    function test_deploys_Permit2_to_the_canonical_address() public view {
        assertEq(address(_permit2), address(Permit2Lib.PERMIT2));
    }
}
