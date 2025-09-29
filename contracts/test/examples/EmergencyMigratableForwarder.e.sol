// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Address} from "@openzeppelin-contracts/utils/Address.sol";

import {EmergencyMigratableForwarderBase} from "../../src/forwarders/bases/EmergencyMigratableForwarderBase.sol";

import {ForwarderTargetExample} from "./ForwarderTarget.e.sol";

contract EmergencyMigratableForwarderExample is EmergencyMigratableForwarderBase {
    using Address for address;

    address public immutable TARGET;

    event CallForwarded(bytes input, bytes output);
    event EmergencyCallForwarded(bytes input, bytes output);

    constructor(address protocolAdapter, address emergencyCommittee, bytes32 calldataCarrierLogicRef)
        EmergencyMigratableForwarderBase(protocolAdapter, calldataCarrierLogicRef, emergencyCommittee)
    {
        TARGET = address(new ForwarderTargetExample());
    }

    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        output = TARGET.functionCall(input);

        emit CallForwarded({input: input, output: output});
    }

    function _forwardEmergencyCall(bytes calldata input) internal override returns (bytes memory output) {
        output = TARGET.functionCall(input);

        emit EmergencyCallForwarded({input: input, output: output});
    }
}
