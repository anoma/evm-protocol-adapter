// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {Address} from "@openzeppelin-contracts/utils/Address.sol";
import {IPermit2, IAllowanceTransfer} from "@permit2/interfaces/IPermit2.sol";

import {EmergencyMigratableForwarderBase} from "./EmergencyMigratableForwarderBase.sol";

/// @title ERC20Forwarder
/// @author Anoma Foundation, 2025
/// @notice A forwarder contract forwarding calls and holding funds to wrap and unwrap ERC-20 tokens as resources.
/// @custom:security-contact security@anoma.foundation
contract ERC20Forwarder is EmergencyMigratableForwarderBase {
    using Address for address;

    enum TransferFromApproval {
        ERC20,
        Permit2
    }

    /// @notice The canonical Uniswap Permit2 contract deployed at the same address on all supported chains
    /// (see [Uniswap's announcement](https://blog.uniswap.org/permit2-and-universal-router)).
    IPermit2 internal constant _PERMIT2 = IPermit2(0x000000000022D473030F116dDEE9F6B43aC78BA3);

    /// @notice The ERC-20 token contract address to forward calls to.
    address internal immutable _ERC20;

    error SelectorInvalid(bytes4 selector);
    error ERC20PermitSpenderMismatch(address expected, address actual);
    error Permit2SpenderMismatch(address expected, address actual);
    error Permit2TokenMismatch(address expected, address actual);

    /// @notice Initializes the ERC-20 forwarder contract.
    /// @param protocolAdapter The protocol adapter contract that is allowed to forward calls.
    /// @param calldataCarrierLogicRef The resource logic function of the calldata carrier resource.
    /// @param emergencyCommittee The emergency committee address that is allowed to set the emergency caller if the
    /// RISC Zero verifier has been stopped.
    /// @param erc20 The ERC-20 token contract to forward calls to.
    constructor(address protocolAdapter, bytes32 calldataCarrierLogicRef, address emergencyCommittee, address erc20)
        EmergencyMigratableForwarderBase(protocolAdapter, calldataCarrierLogicRef, emergencyCommittee)
    {
        if (erc20 == address(0)) {
            revert ZeroNotAllowed();
        }
        _ERC20 = erc20;
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        bytes4 selector = bytes4(input[:4]);

        if (selector == IERC20.transferFrom.selector) {
            address from = address(0);
            uint256 value = 0;

            TransferFromApproval approvalType = abi.decode(input[4:5], (TransferFromApproval));

            if (approvalType == TransferFromApproval.ERC20) {
                ( /* selector */ , /* approvalType */, from, value) =
                    abi.decode(input, (bytes4, bytes1, address, uint256));
            } else if (approvalType == TransferFromApproval.Permit2) {
                IAllowanceTransfer.PermitSingle memory permitSingle;
                bytes memory signature;

                ( /* selector */ , /* approvalType */, permitSingle, signature, from, value) =
                    abi.decode(input, (bytes4, bytes1, IAllowanceTransfer.PermitSingle, bytes, address, uint256));

                // NOTE: The following checks can be conducted on the carrier resource logic.
                {
                    if (permitSingle.spender != address(this)) {
                        revert Permit2SpenderMismatch({expected: address(this), actual: permitSingle.spender});
                    }
                    if (permitSingle.details.token != _ERC20) {
                        revert Permit2TokenMismatch({expected: _ERC20, actual: permitSingle.details.token});
                    }
                }
                _PERMIT2.permit({owner: msg.sender, permitSingle: permitSingle, signature: signature});
            }

            // slither-disable-next-line arbitrary-send-erc20
            output = abi.encode(IERC20(_ERC20).transferFrom({from: from, to: address(this), value: value}));
        } else if (selector == IERC20.transfer.selector) {
            ( /* selector */ , address to, uint256 value) = abi.decode(input, (bytes4, address, uint256));

            output = abi.encode(IERC20(_ERC20).transfer({to: to, value: value}));
        } else {
            revert SelectorInvalid(selector);
        }
    }

    /// @notice Forwards emergency calls.
    /// @param input The `bytes`  encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardEmergencyCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _forwardCall(input);
    }
}
