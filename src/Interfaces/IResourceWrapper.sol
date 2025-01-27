// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Map } from "../libs/Map.sol";
import { Resource } from "../Types.sol";

interface IResourceWrapper {
    event ResourceWrapped(bytes input, bytes output); // TODO Does indexed make sense?

    event ResourceUnwrapped(bytes input, bytes output);

    function kind() external view returns (bytes32);

    function wrap(bytes calldata input) external returns (bytes memory output);

    function unwrap(bytes calldata input) external returns (bytes memory output);
}
