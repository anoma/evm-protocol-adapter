// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Address} from "@openzeppelin-contracts/utils/Address.sol";

import {ForwarderBase} from "../../src/forwarders/ForwarderBase.sol";
import {ForwarderTargetExample} from "./ForwarderTarget.e.sol";

contract ForwarderExample is ForwarderBase {
    using Address for address;

    address public immutable TARGET;

    event CallForwarded(bytes32 carrierTag, bytes input, bytes output);

    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef)
        ForwarderBase(protocolAdapter, calldataCarrierLogicRef)
    {
        TARGET = address(new ForwarderTargetExample());
    }

    function _forwardCall(bytes32 carrierTag, bytes calldata input) internal override returns (bytes memory output) {
        {
            carrierTag;
        }
        output = TARGET.functionCall(input);

        emit CallForwarded({carrierTag: carrierTag, input: input, output: output});
    }
}
