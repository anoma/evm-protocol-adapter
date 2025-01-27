// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Resource } from "../Types.sol";

library ComputableComponents {
    function commitment(Resource memory resource) internal pure returns (bytes32) {
        return sha256(abi.encode(resource));
    }

    function nullifier(Resource memory resource, bytes32 nullifierKey) internal pure returns (bytes32) {
        return sha256(abi.encode(resource, nullifierKey));
    }

    function kind(Resource memory resource) internal pure returns (bytes32) {
        return sha256(abi.encode(resource.logicRef, resource.labelRef));
    }

    function kind(bytes32 logicRef, bytes32 labelRef) internal pure returns (bytes32) {
        return sha256(abi.encode(logicRef, labelRef));
    }

    function commitmentCalldata(Resource calldata resource) internal pure returns (bytes32) {
        return sha256(abi.encode(resource));
    }

    function nullifierCalldata(Resource calldata resource, bytes32 nullifierKey) internal pure returns (bytes32) {
        return sha256(abi.encode(resource, nullifierKey));
    }

    function kindCalldata(Resource calldata resource) internal pure returns (bytes32) {
        return sha256(abi.encode(resource.logicRef, resource.labelRef));
    }
}
