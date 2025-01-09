// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { IResourceWrapper } from "./interfaces/IResourceWrapper.sol";
import { Resource, Map } from "./Types.sol";

contract ERC20ResourceWrapper is IResourceWrapper, Ownable {
    using Map for Map.KeyValuePair[];

    bytes32 internal immutable RESOURCE_KIND;
    IERC20 internal immutable TOKEN_CONTRACT;

    constructor(address protocolAdapter, bytes32 resourceKind, IERC20 erc20) Ownable(protocolAdapter) {
        TOKEN_CONTRACT = erc20;
        RESOURCE_KIND = resourceKind;
    }

    function kind() external view returns (bytes32) {
        return RESOURCE_KIND;
    }

    function wrap(
        bytes32 nullifier,
        Resource calldata resource,
        Map.KeyValuePair[] calldata appData
    )
        external
        onlyOwner
    {
        bytes memory value = appData.lookup(resource.valueRef);
        address _owner = abi.decode(value, (address));

        TOKEN_CONTRACT.transferFrom({ from: _owner, to: address(this), value: resource.quantity });

        emit ResourceWrapped(nullifier, resource);
    }

    function unwrap(
        bytes32 commitment,
        Resource calldata resource,
        Map.KeyValuePair[] calldata appData
    )
        external
        onlyOwner
    {
        bytes memory value = appData.lookup(resource.valueRef);
        address _owner = abi.decode(value, (address));

        TOKEN_CONTRACT.transfer({ to: _owner, value: resource.quantity });

        emit ResourceUnwrapped(commitment, resource);
    }
}
