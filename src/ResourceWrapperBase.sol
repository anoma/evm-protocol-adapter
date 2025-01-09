// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { IResourceWrapper } from "./interfaces/IResourceWrapper.sol";
import { Resource, Map } from "./Types.sol";

abstract contract ResourceWrapperBase is IResourceWrapper, Ownable {
    using Map for Map.KeyValuePair[];

    bytes32 internal immutable RESOURCE_KIND;

    constructor(address protocolAdapter, bytes32 resourceKind) Ownable(protocolAdapter) {
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
        _wrap(nullifier, resource, appData);
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
        _unwrap(commitment, resource, appData);
        emit ResourceUnwrapped(commitment, resource);
    }

    function _wrap(
        bytes32 nullifier,
        Resource calldata resource,
        Map.KeyValuePair[] calldata appData
    )
        internal
        virtual;
    function _unwrap(
        bytes32 commitment,
        Resource calldata resource,
        Map.KeyValuePair[] calldata appData
    )
        internal
        virtual;
}
