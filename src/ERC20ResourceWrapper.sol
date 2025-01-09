// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { IResourceWrapper } from "./interfaces/IResourceWrapper.sol";
import { Resource, Map } from "./Types.sol";

contract ERC20ResourceWrapper is IResourceWrapper, Ownable {
    using Map for Map.KeyValuePair[];

    IERC20 public immutable TOKEN;

    constructor(address protocolAdapter, IERC20 _erc20) Ownable(protocolAdapter) {
        TOKEN = _erc20;
    }

    function wrap(
        bytes32 nullifier,
        Resource memory resource,
        Map.KeyValuePair[] calldata appData
    )
        external
        onlyOwner
    {
        bytes memory value = appData.lookup(resource.valueRef);
        address _owner = abi.decode(value, (address));

        TOKEN.transferFrom({ from: _owner, to: address(this), value: resource.quantity });

        emit ResourceWrapped(nullifier, resource);
    }

    function unwrap(
        bytes32 commitment,
        Resource memory resource,
        Map.KeyValuePair[] calldata appData
    )
        external
        onlyOwner
    {
        bytes memory value = appData.lookup(resource.valueRef);
        address _owner = abi.decode(value, (address));

        TOKEN.transfer({ to: _owner, value: resource.quantity });

        emit ResourceUnwrapped(commitment, resource);
    }
}
