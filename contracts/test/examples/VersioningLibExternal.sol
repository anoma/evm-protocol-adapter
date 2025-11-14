// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Versioning} from "../../src/libs/Versioning.sol";

contract VersioningLibExternal {
    function version() external pure returns (bytes32 v) {
        v = Versioning._PROTOCOL_ADAPTER_VERSION;
    }
}
