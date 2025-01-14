// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { Resource } from "../Types.sol";
import { Poseidon } from "./Poseidon.sol";

library ComputableComponents {
    function commitment(Resource memory resource) internal pure returns (bytes32) {
        return Poseidon.hash1(preHashResource(resource));
    }

    function nullifier(Resource memory resource, bytes32 nullifierKey) internal pure returns (bytes32) {
        return Poseidon.hash2(preHashResource(resource), nullifierKey);
    }

    function kind(Resource memory resource) internal pure returns (bytes32) {
        return Poseidon.hash2(resource.logicRef, resource.labelRef);
    }

    function preHashResource(Resource memory resource) internal pure returns (bytes32) {
        return sha256(abi.encode(resource));
    }

    function commitmentCalldata(Resource calldata resource) internal pure returns (bytes32) {
        return Poseidon.hash1(preHashResourceCalldata(resource));
    }

    function nullifierCalldata(Resource calldata resource, bytes32 nullifierKey) internal pure returns (bytes32) {
        return Poseidon.hash2(preHashResourceCalldata(resource), nullifierKey);
    }

    function kindCalldata(Resource calldata resource) internal pure returns (bytes32) {
        return Poseidon.hash2(resource.logicRef, resource.labelRef);
    }

    function preHashResourceCalldata(Resource calldata resource) internal pure returns (bytes32) {
        return sha256(abi.encode(resource));
    }
}
