// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Address} from "@openzeppelin-contracts-5.5.0/utils/Address.sol";

import {ForwarderTargetExample} from "./ForwarderTarget.e.sol";

contract ForwarderExample {
    using Address for address;

    /// @notice The protocol adapter contract that can forward calls.
    address internal immutable _PROTOCOL_ADAPTER;

    /// @notice The calldata carrier resource logic reference.
    bytes32 internal immutable _CALLDATA_CARRIER_LOGIC_REF;

    address public immutable TARGET;

    event CallForwarded(bytes input, bytes output);
    event EmergencyCallForwarded(bytes input, bytes output);

    error ZeroNotAllowed();
    error UnauthorizedCaller(address expected, address actual);
    error UnauthorizedLogicRef(bytes32 expected, bytes32 actual);

    /// @notice Initializes the forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef) {
        require(protocolAdapter != address(0), ZeroNotAllowed());
        require(calldataCarrierLogicRef != bytes32(0), ZeroNotAllowed());

        _PROTOCOL_ADAPTER = protocolAdapter;

        _CALLDATA_CARRIER_LOGIC_REF = calldataCarrierLogicRef;

        TARGET = address(new ForwarderTargetExample());
    }

    function forwardCall(bytes32 logicRef, bytes calldata input) external returns (bytes memory output) {
        require(msg.sender == _PROTOCOL_ADAPTER, UnauthorizedCaller({expected: _PROTOCOL_ADAPTER, actual: msg.sender}));

        require(
            _CALLDATA_CARRIER_LOGIC_REF == logicRef,
            UnauthorizedLogicRef({expected: _CALLDATA_CARRIER_LOGIC_REF, actual: logicRef})
        );

        output = TARGET.functionCall(input);

        emit CallForwarded({input: input, output: output});
    }
}
