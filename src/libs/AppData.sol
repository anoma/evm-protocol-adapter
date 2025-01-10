// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { IResourceWrapper } from "../interfaces/IResourceWrapper.sol";

import { Resource } from "../Types.sol";

import { Map } from "./Map.sol";

library AppData {
    using Map for Map.KeyValuePair[];

    function lookupResource(
        Map.KeyValuePair[] memory appData,
        bytes32 key
    )
        internal
        pure
        returns (bool, Resource memory)
    {
        (bool success, bytes memory data) = appData.lookup(key);
        return (success, abi.decode(data, (Resource)));
    }

    /// @notice Looks up the wrapper contract lookup from the resource label reference and app data.
    function lookupWrapper(
        Map.KeyValuePair[] memory appData,
        bytes32 key
    )
        internal
        pure
        returns (bool, IResourceWrapper)
    {
        (bool success, bytes memory data) = appData.lookup(key);

        return (success, abi.decode(data, (IResourceWrapper)));
    }

    function lookupOwner(Map.KeyValuePair[] calldata appData, bytes32 key) internal pure returns (bool, address) {
        (bool success, bytes memory data) = appData.lookup(key);

        return (success, abi.decode(data, (address)));
    }
}
