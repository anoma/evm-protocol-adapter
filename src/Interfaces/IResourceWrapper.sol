// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Resource, Map } from "../Types.sol";

interface IResourceWrapper {
    event ResourceWrapped(bytes32 indexed nullifier, Resource resource);
    event ResourceUnwrapped(bytes32 indexed commitment, Resource resource);

    function wrap(bytes32 nullifier, Resource memory resource, Map.KeyValuePair[] memory appData) external;

    function unwrap(bytes32 commitment, Resource memory resource, Map.KeyValuePair[] memory appData) external;
}
