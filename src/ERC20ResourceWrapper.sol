// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { ResourceWrapperBase } from "./ResourceWrapperBase.sol";
import { AppData, Map } from "./libs/AppData.sol";
import { Resource } from "./Types.sol";

contract ERC20ResourceWrapper is Ownable, ResourceWrapperBase {
    using AppData for Map.KeyValuePair[];

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

    function _wrap(
        bytes32, // nullifier, // NOTE: unused
        Resource calldata resource,
        Map.KeyValuePair[] calldata appData
    )
        internal
        override
    {
        (bool success, address owner) = appData.lookupOwner({ key: resource.valueRef });

        if (!success) revert Map.KeyNotFound({ key: resource.valueRef });

        TOKEN_CONTRACT.transferFrom({ from: owner, to: address(this), value: resource.quantity });
    }

    function _unwrap(
        bytes32, //commitment, // NOTE: unused
        Resource calldata resource,
        Map.KeyValuePair[] calldata appData
    )
        internal
        override
    {
        (bool success, address owner) = appData.lookupOwner({ key: resource.valueRef });

        if (!success) revert Map.KeyNotFound({ key: resource.valueRef });

        TOKEN_CONTRACT.transfer({ to: owner, value: resource.quantity });
    }
}
