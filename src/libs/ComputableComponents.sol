// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Resource} from "../Types.sol";

library ComputableComponents {
    function commitment(Resource memory resource) internal pure returns (bytes32 cm) {
        cm = sha256(abi.encode(resource));
    }

    function nullifier(Resource memory resource, bytes32 nullifierKey) internal pure returns (bytes32 nf) {
        nf = sha256(abi.encode(resource, nullifierKey));
    }

    function kind(Resource memory resource) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(resource.logicRef, resource.labelRef));
    }

    function kind(bytes32 logicRef, bytes32 labelRef) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(logicRef, labelRef));
    }

    function commitmentCalldata(Resource calldata resource) internal pure returns (bytes32 cm) {
        cm = sha256(abi.encode(resource));
    }

    function nullifierCalldata(Resource calldata resource, bytes32 nullifierKey) internal pure returns (bytes32 nf) {
        nf = sha256(abi.encode(resource, nullifierKey));
    }

    function kindCalldata(Resource calldata resource) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(resource.logicRef, resource.labelRef));
    }

    /// @dev The tags are encoded in packed form to remove the array header.
    /// Since all the tags are 32 bytes, tight variable packing will not occur.
    function tagsHash(bytes32[] memory tags) internal pure returns (bytes32 hash) {
        hash = sha256(abi.encodePacked(tags));
    }
}
