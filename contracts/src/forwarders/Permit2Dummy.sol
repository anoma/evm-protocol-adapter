// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";

import {ERC20ForwarderPermit2} from "./ERC20ForwarderPermit2.sol";

contract Permit2Dummy {
    using ERC20ForwarderPermit2 for ERC20ForwarderPermit2.Witness;
    using SafeERC20 for IERC20;

    /// @notice The canonical Uniswap Permit2 contract being deployed at the same address on all supported chains.
    /// (see [Uniswap's announcement](https://blog.uniswap.org/permit2-and-universal-router)).
    IPermit2 internal constant _PERMIT2 = IPermit2(0x000000000022D473030F116dDEE9F6B43aC78BA3);

    error TypeOverflow(uint256 limit, uint256 actual);

    function pullFunds(
        address from,
        ISignatureTransfer.PermitTransferFrom memory permit,
        bytes32 actionTreeRoot,
        bytes memory signature
    ) public {
        if (permit.permitted.amount > type(uint128).max) {
            revert TypeOverflow({limit: type(uint128).max, actual: permit.permitted.amount});
        }

        _PERMIT2.permitWitnessTransferFrom({
            permit: permit,
            transferDetails: ISignatureTransfer.SignatureTransferDetails({
                to: address(this),
                requestedAmount: permit.permitted.amount
            }),
            owner: from,
            witness: ERC20ForwarderPermit2.Witness({actionTreeRoot: actionTreeRoot}).hash(),
            witnessTypeString: ERC20ForwarderPermit2._WITNESS_TYPE_STRING,
            signature: signature
        });
    }
}
