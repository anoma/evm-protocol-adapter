// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";

import {IForwarder} from "../interfaces/IForwarder.sol";
import {ProtocolAdapter} from "../ProtocolAdapter.sol";

/// @title ForwarderBase
/// @author Anoma Foundation, 2025
/// @notice The base contract to inherit from to create a forwarder contracts owning EVM state and executing EVM calls.
/// @custom:security-contact security@anoma.foundation
abstract contract ForwarderBase is IForwarder {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    /// @notice The protocol adapter contract that can forward calls.
    ProtocolAdapter internal immutable _PROTOCOL_ADAPTER;

    /// @notice The set of permitted logics.
    EnumerableSet.Bytes32Set internal _logicRefSet;
    /// @notice The set of permitted labels.
    EnumerableSet.Bytes32Set internal _labelRefSet;

    error ZeroNotAllowed();
    error UnauthorizedCaller(address expected, address actual);
    error UnauthorizedResourceLabelCaller(bytes32 labelRef);
    error UnauthorizedResourceLogicCaller(bytes32 logicRef);

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.

    /// @param logicRefs Permitted logics for making calls.
    /// @param labelRefs Permitted labels for making calls.
    constructor(address protocolAdapter, bytes32[] memory logicRefs, bytes32[] memory labelRefs) {
        if (protocolAdapter == address(0)) {
            revert ZeroNotAllowed();
        }

        _PROTOCOL_ADAPTER = ProtocolAdapter(protocolAdapter);

        uint256 nLogics = logicRefs.length;
        for (uint256 i = 0; i < nLogics; ++i) {
            // slither-disable-next-line unused-return
            _logicRefSet.add(logicRefs[i]);
        }

        uint256 nLabels = labelRefs.length;
        for (uint256 j = 0; j < nLabels; ++j) {
            // slither-disable-next-line unused-return
            _labelRefSet.add(labelRefs[j]);
        }
    }

    /// @inheritdoc IForwarder
    function forwardCall(bytes32, bytes32, bytes calldata input) external returns (bytes memory output) {
        _checkCaller(address(_PROTOCOL_ADAPTER));

        output = _forwardCall(input);
    }

    /// @inheritdoc IForwarder
    function authorizeCall(bytes32 logicRef, bytes32 labelRef) external view {
        if (!_logicRefSet.contains(logicRef)) {
            revert UnauthorizedResourceLogicCaller(logicRef);
        } else if (!_labelRefSet.contains(labelRef)) {
            revert UnauthorizedResourceLabelCaller(labelRef);
        }
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal virtual returns (bytes memory output);

    /// @notice Checks that an expected caller is calling the function and reverts otherwise.
    /// @param expected The expected caller.
    function _checkCaller(address expected) internal view {
        if (msg.sender != expected) {
            revert UnauthorizedCaller({expected: expected, actual: msg.sender});
        }
    }
}
