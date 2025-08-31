// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {Permit2Lib} from "@permit2/src/libraries/Permit2Lib.sol";

import {EmergencyMigratableForwarderBase} from "./EmergencyMigratableForwarderBase.sol";

/// @title ERC20Forwarder
/// @author Anoma Foundation, 2025
/// @notice A forwarder contract forwarding calls and holding funds to wrap and unwrap ERC-20 tokens as resources.
/// @custom:security-contact security@anoma.foundation
contract ERC20Forwarder is EmergencyMigratableForwarderBase {
    using SafeERC20 for IERC20;

    /// @notice The canonical Uniswap Permit2 contract deployed at the same address on all supported chains
    /// (see [Uniswap's announcement](https://blog.uniswap.org/permit2-and-universal-router)).
    IPermit2 internal immutable _PERMIT2;

    /// @notice The ERC-20 token contract address to forward calls to.
    address internal immutable _ERC20;

    error SelectorInvalid(bytes4 selector);
    error ERC20PermitSpenderMismatch(address expected, address actual);
    error Permit2ToMismatch(address expected, address actual);
    error Permit2TokenMismatch(address expected, address actual);
    error Permit2AmountMismatch(uint256 expected, uint256 actual);
    error Permit2OwnerMismatch(address expected, address actual);

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

        _PERMIT2 = IPermit2(address(Permit2Lib.PERMIT2));
    }

    /// @notice Forwards calls.
    /// @param input The `bytes` encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardCall(bytes calldata input) internal override returns (bytes memory output) {
        bytes4 selector = bytes4(input[:4]);

        if (selector == IERC20.transferFrom.selector) {
            address to = address(this);
            address from = address(0);
            uint256 value = 0;
            ISignatureTransfer.PermitTransferFrom memory permit;
            bytes memory signature;

            ( /* selector */ , from, value, permit, signature) =
                abi.decode(input, (bytes4, address, uint256, ISignatureTransfer.PermitTransferFrom, bytes));

            // NOTE: The following checks could be conducted on the carrier resource logic.
            {
                if (permit.permitted.token != _ERC20) {
                    revert Permit2TokenMismatch({expected: _ERC20, actual: permit.permitted.token});
                }

                if (permit.permitted.amount != value) {
                    revert Permit2AmountMismatch({expected: permit.permitted.amount, actual: value});
                }
            }

            _PERMIT2.permitTransferFrom({
                permit: permit,
                transferDetails: ISignatureTransfer.SignatureTransferDetails({to: to, requestedAmount: value}),
                owner: from,
                signature: signature
            });
        } else if (selector == IERC20.transfer.selector) {
            address to = address(0);
            uint256 value = 0;

            ( /* selector */ , to, value) = abi.decode(input, (bytes4, address, uint256));
            IERC20(_ERC20).safeTransfer({to: to, value: value});
        } else {
            revert SelectorInvalid(selector);
        }
        output = abi.encode(true);
    }

    /// @notice Forwards emergency calls.
    /// @param input The `bytes`  encoded input of the call.
    /// @return output The `bytes` encoded output of the call.
    function _forwardEmergencyCall(bytes calldata input) internal override returns (bytes memory output) {
        output = _forwardCall(input);
    }
}
