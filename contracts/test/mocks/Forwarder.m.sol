// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Address} from "@openzeppelin-contracts/utils/Address.sol";

import {ForwarderBase} from "../../src/forwarders/ForwarderBase.sol";
import {ForwarderTarget} from "./ForwarderTarget.m.sol";

contract ForwarderMock is ForwarderBase {
    using Address for address;

    address public immutable TARGET;

    event CallForwarded(bytes input, bytes output);
    event EmergencyCallForwarded(bytes input, bytes output);

    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef)
        ForwarderBase(protocolAdapter, calldataCarrierLogicRef)
    {
        TARGET = address(new ForwarderTarget());
    }

    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        output = TARGET.functionCall(input);

        emit CallForwarded({input: input, output: output});
    }
}
