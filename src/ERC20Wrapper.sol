// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { ComputableComponents } from "./libs/ComputableComponents.sol";
import { Reference } from "./libs/Reference.sol";
import { WrapperBase } from "./WrapperBase.sol";
import { Resource } from "./Types.sol";
import { UNIVERSAL_NULLIFIER_KEY_COMMITMENT } from "./Constants.sol";

contract ERC20Wrapper is Ownable, WrapperBase {
    using Address for address;
    using Reference for address;
    using Reference for bytes;
    using ComputableComponents for Resource;

    IERC20 internal immutable TOKEN_CONTRACT;

    uint256 internal nonce;

    constructor(
        address protocolAdapter,
        bytes32 wrappedLogicRef,
        bytes32 wrappedLabelRef,
        IERC20 erc20,
        bytes4[] memory allowedFunctionSelectors
    )
        WrapperBase(protocolAdapter, wrappedLogicRef, wrappedLabelRef, allowedFunctionSelectors)
    {
        TOKEN_CONTRACT = erc20;
    }

    // TODO is this sufficient?
    function _evmCall(bytes calldata input) internal override returns (bytes memory output) {
        bytes4 selector = bytes4(input[:4]);

        // TODO: MOVE THIS CHECK INTO THE RESOURCE LOGIC
        if (!_isAllowed(selector)) {
            revert ForbiddenFunctionCall(selector);
        }

        output = address(TOKEN_CONTRACT).functionCall(abi.encodeWithSelector(selector, input[4:]));
    }
}
