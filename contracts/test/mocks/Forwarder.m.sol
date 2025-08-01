// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Address} from "@openzeppelin-contracts/utils/Address.sol";

import {ForwarderBase} from "../../src/forwarders/ForwarderBase.sol";

import {ForwarderTargetMock} from "./ForwarderTarget.m.sol";

contract ForwarderMock is ForwarderBase {
    using Address for address;

    address internal immutable _TARGET;

    constructor(address protocolAdapter, address emergencyCommittee, bytes32 calldataCarrierLogicRef)
        ForwarderBase(protocolAdapter, emergencyCommittee, calldataCarrierLogicRef)
    {
        _TARGET = address(new ForwarderTargetMock());
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _TARGET.functionCall(input);
    }

    /// @notice Forwards emergency calls.
    /// @param input The `bytes`  encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardEmergencyCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _TARGET.functionCall(input);
    }
}
