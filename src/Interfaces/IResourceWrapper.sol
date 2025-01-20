// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Map } from "../libs/Map.sol";
import { Resource } from "../Types.sol";

interface IResourceWrapper {
    event ResourceWrapped(bytes32 indexed nullifier, Resource resource); // TODO Does indexed make sense?

    event ResourceUnwrapped(bytes32 indexed commitment, Resource resource);

    function kind() external view returns (bytes32);

    function wrap(bytes32 nullifier, Resource calldata resource, Map.KeyValuePair[] calldata appData) external;

    function unwrap(bytes32 commitment, Resource calldata resource, Map.KeyValuePair[] calldata appData) external;
}
