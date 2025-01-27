// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { ResourceWrapperBase } from "./ResourceWrapperBase.sol";
import { AppDataOLD, Map } from "./libs/AppDataOLD.sol";
import { Resource } from "./Types.sol";

contract ERC20ResourceWrapper is Ownable, ResourceWrapperBase {
    using Address for address;

    bytes constant NOTHING = "";
    IERC20 internal immutable TOKEN_CONTRACT;

    constructor(
        address protocolAdapter,
        bytes32 resourceKind,
        IERC20 erc20
    )
        ResourceWrapperBase(protocolAdapter, resourceKind)
    {
        TOKEN_CONTRACT = erc20;
    }

    function _wrap(bytes calldata input) internal override returns (bytes memory output) {
        (uint256 _quantity, address _owner) = abi.decode(input, (uint256, address));

        TOKEN_CONTRACT.transferFrom({ from: _owner, to: address(this), value: _quantity });

        output = NOTHING;
    }

    // TODO is this sufficient?
    function _evmCall(bytes calldata input) internal returns (bytes memory output) {
        output = address(TOKEN_CONTRACT).functionCall(input);
    }

    function _unwrap(bytes calldata input) internal override returns (bytes memory output) {
        (uint256 _quantity, address _owner) = abi.decode(input, (uint256, address));

        TOKEN_CONTRACT.transfer({ to: _owner, value: _quantity });

        output = NOTHING;
    }
}
