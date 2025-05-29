// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Resource} from "../Types.sol";

/// @notice A library containing methods to calculate computable components from resource objects.
library ComputableComponents {
    /// @notice Computes the resource commitment.
    /// @param resource The resource object.
    /// @return cm The computed commitment.
    function commitment(Resource calldata resource) internal pure returns (bytes32 cm) {
        cm = sha256(abi.encode(resource));
    }

    /// @notice Computes the resource nullifier given a nullifier key.
    /// @param resource The resource object.
    /// @param nullifierKey The nullifier key.
    /// @return nf The computed nullifier.
    /// @dev This methods does not check that the nullifier key commitment matches the nullifier key.
    function nullifier(Resource calldata resource, bytes32 nullifierKey) internal pure returns (bytes32 nf) {
        nf = sha256(abi.encode(resource, nullifierKey));
    }

    /// @notice Computes the resource kind.
    /// @param resource The resource object.
    /// @return k The computed kind.
    function kind(Resource calldata resource) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(resource.logicRef, resource.labelRef));
    }

    /// @notice Computes the resource kind.
    /// @param logicRef The resource logic reference.
    /// @param labelRef The resource label reference.
    /// @return k The computed kind.
    function kind(bytes32 logicRef, bytes32 labelRef) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(logicRef, labelRef));
    }
}
