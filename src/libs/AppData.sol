// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { IResourceWrapper } from "../interfaces/IResourceWrapper.sol";
import { UNIVERSAL_NULLIFIER_KEY } from "../Constants.sol";
import { Resource } from "../Types.sol";
import { ComputableComponents } from "./ComputableComponents.sol";
import { Map } from "./Map.sol";

library AppData {
    using Map for Map.KeyValuePair[];

    error KindMismatch(bytes32 resourceKind, bytes32 wrapperKind);

    function lookupConsumedResource(
        Map.KeyValuePair[] memory appData,
        bytes32 nullifier
    )
        internal
        pure
        returns (bool success, Resource memory resource)
    {
        resource = abi.decode(appData.lookup(nullifier), (Resource));
        success = ComputableComponents.nullifier(resource, UNIVERSAL_NULLIFIER_KEY) == nullifier;
    }

    function lookupCreatedResource(
        Map.KeyValuePair[] memory appData,
        bytes32 commitment
    )
        internal
        pure
        returns (bool success, Resource memory resource)
    {
        resource = abi.decode(appData.lookup(commitment), (Resource));
        success = ComputableComponents.commitment(resource) == commitment;
    }

    // TODO Refactor
    function lookupWrapperFromResourceLabel(
        Map.KeyValuePair[] memory appData,
        Resource memory resource
    )
        internal
        view
        returns (IResourceWrapper wrapper)
    {
        bytes memory label = appData.lookup(resource.labelRef); // TODO Require `Label` to be a map
        wrapper = abi.decode(label, (IResourceWrapper));

        // Integrity check the resource kind
        {
            bytes32 resourceKind = ComputableComponents.kind(resource);
            bytes32 wrapperKind = wrapper.kind();
            if (resourceKind != wrapperKind) {
                revert KindMismatch({ resourceKind: resourceKind, wrapperKind: wrapperKind });
            }
        }
    }
}
