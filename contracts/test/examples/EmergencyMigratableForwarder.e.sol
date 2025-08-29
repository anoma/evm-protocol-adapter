// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Address} from "@openzeppelin-contracts/utils/Address.sol";
import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import {EmergencyMigratableForwarderBase} from "../../src/forwarders/EmergencyMigratableForwarderBase.sol";

import {ForwarderTargetExample} from "./ForwarderTarget.e.sol";

contract EmergencyMigratableForwarderExample is EmergencyMigratableForwarderBase {
    using Address for address;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    address public immutable TARGET;

    event CallForwarded(bytes input, bytes output);
    event EmergencyCallForwarded(bytes input, bytes output);

    constructor(
        address protocolAdapter,
        address emergencyCommittee,
        bytes32[] memory logicRefs,
        bytes32[] memory labelRefs
    ) EmergencyMigratableForwarderBase(protocolAdapter, logicRefs, labelRefs, emergencyCommittee) {
        _labelRefSet.add(sha256(abi.encode(this)));
        _logicRefSet.add(bytes32(uint256(123)));
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
