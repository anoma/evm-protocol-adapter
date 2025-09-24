// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20ForwarderV2} from "../../src/forwarders/drafts/ERC20ForwarderV2.sol";

import {ERC20ForwarderTest} from "./ERC20Forwarder.t.sol";

contract ERC20ForwarderV2Test is ERC20ForwarderTest {
    address internal constant _PA_V2 = address(uint160(2));

    ERC20ForwarderV2 internal _fwdV2;

    function setUp() public override {
        super.setUp();

        _fwdV2 = new ERC20ForwarderV2({
            protocolAdapter: _PA_V2,
            calldataCarrierLogicRef: _CALLDATA_CARRIER_LOGIC_REF,
            emergencyCommittee: _EMERGENCY_COMMITTEE,
            protocolAdapterV1: address(_pa),
            erc20ForwarderV1: address(_fwd)
        });
    }
}
