// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Address} from "@openzeppelin-contracts/utils/Address.sol";
import {EnumerableSet} from "@openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IUpdatable} from "../interfaces/IUpdatable.sol";
import {EmergencyMigratableForwarderBase} from "./EmergencyMigratableForwarderBase.sol";

/// @title ERC20Forwarder
/// @author Anoma Foundation, 2025
/// @notice A forwarder contract forwarding calls and holding funds to wrap and unwrap ERC-20 tokens as resources.
/// @custom:security-contact security@anoma.foundation
contract MultiERC20Forwarder is EmergencyMigratableForwarderBase, IUpdatable {
    using Address for address;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    /// @notice A structured call
    /// @param ammount Ammount to withdraw
    /// @param ERC20Addr The address of a relevant ERC20
    /// @param userAddr The address of user
    /// @param minting Indicates whether we the call is to mint or to burn.
    struct ERC20Call {
        uint256 ammount;
        address erc20Addr;
        address userAddr;
        bool minting;
    }

    // @notice The address of the committee deciding which kinds to support.
    address internal immutable _APP_COMMITTEE;

    error UnsanctionedAppUpdate(address expected, address actual);
    error LabelsNotUpdatable();

    /// @notice Initializes the ERC-20 forwarder contract supporting arbitrary tokens given
    /// approval from appropriate address.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param logicRefs Permitted logics for making calls.
    /// @param labelRefs Permitted labels for making calls.
    /// @param appCommittee The committee for changing supported kinds.
    /// @param emergencyCommittee The emergency committee address that is allowed to set the emergency caller if the
    /// RISC Zero verifier has been stopped.
    constructor(
        address protocolAdapter,
        bytes32[] memory logicRefs,
        bytes32[] memory labelRefs,
        address appCommittee,
        address emergencyCommittee
    ) EmergencyMigratableForwarderBase(protocolAdapter, logicRefs, labelRefs, emergencyCommittee) {
        if (appCommittee == address(0)) {
            revert ZeroNotAllowed();
        }
        _APP_COMMITTEE = appCommittee;
    }

    /// @inheritdoc IUpdatable
    function addLabel(bytes32 labelRef) external override returns (bool output) {
        // slither-disable-next-line redundant-statements
        labelRef;
        revert LabelsNotUpdatable();
    }

    /// @inheritdoc IUpdatable
    function addLogic(bytes32 logicRef) external override returns (bool output) {
        _appCommitteeCheck(msg.sender);
         output = _labelRefSet.add(logicRef);
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        ERC20Call memory call = abi.decode(input, (ERC20Call));
        if (call.minting) {
            // slither-disable-next-line arbitrary-send-erc20
            output = abi.encode(IERC20(call.erc20Addr).transferFrom(call.userAddr, address(this), call.ammount));
        } else {
            output = abi.encode(IERC20(call.erc20Addr).transfer(call.userAddr, call.ammount));
        }
    }

    /// @notice Forwards emergency calls.
    /// @param input The `bytes`  encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardEmergencyCall(bytes calldata input) internal override returns (bytes memory output) {
        ERC20Call memory call = abi.decode(input, (ERC20Call));
        if (call.minting) {
            // slither-disable-next-line arbitrary-send-erc20
            output = abi.encode(IERC20(call.erc20Addr).transferFrom(call.userAddr, address(this), call.ammount));
        } else {
            output = abi.encode(IERC20(call.erc20Addr).transfer(call.userAddr, call.ammount));
        }
    }

    /// @notice Allows for arbitrary label to pass
    /// @param labelRef The labelRef of the resource making the call
    function _authorizeLabel(bytes32 labelRef) internal view override {
         // slither-disable-next-line redundant-statements
        labelRef;
    }

    /// @notice Checks that the updates are submitted by specified address.
    /// @param sender The sender of update request.
    function _appCommitteeCheck(address sender) internal view {
        if (sender != _APP_COMMITTEE) {
            revert UnsanctionedAppUpdate(_APP_COMMITTEE, msg.sender);
        }
    }
}
