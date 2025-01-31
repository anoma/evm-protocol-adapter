// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { WrapperBase } from "./WrapperBase.sol";
import { Resource } from "./Types.sol";
import { UNIVERSAL_NULLIFIER_KEY_COMMITMENT } from "./Constants.sol";

contract ERC20Wrapper is Ownable, WrapperBase {
    using Address for address;

    address internal immutable ERC20_CONTRACT;

    uint256 internal nonce;

    constructor(
        address protocolAdapter,
        address erc20,
        bytes32 wrappedResourceKind
    )
        WrapperBase(protocolAdapter, wrappedResourceKind)
    {
        ERC20_CONTRACT = erc20;
    }

    function _evmCall(bytes calldata input) internal override returns (bytes memory output) {
        output = ERC20_CONTRACT.functionCall(input);
    }
}
