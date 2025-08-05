// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Resource} from "../Types.sol";

/// @title ComputableComponents
/// @author Anoma Foundation, 2025
/// @notice A library containing methods to calculate computable components from resource objects.
/// @custom:security-contact security@anoma.foundation
library ComputableComponents {
    /// @notice Computes the resource commitment.
    /// @param resource The resource object.
    /// @return cm The computed commitment.
    function commitment(Resource memory resource) internal pure returns (bytes32 cm) {
        cm = sha256(
            abi.encodePacked(
                resource.logicRef,
                resource.labelRef,
                resource.quantity,
                resource.valueRef,
                resource.ephemeral,
                resource.nonce,
                resource.nullifierKeyCommitment,
                rcm(resource)
            )
        );
    }

    /// @notice Computes the resource nullifier given a nullifier key.
    /// @param resource The resource object.
    /// @param nullifierKey The nullifier key.
    /// @return nf The computed nullifier.
    /// @dev This methods does not check that the nullifier key commitment matches the nullifier key.
    function nullifier(Resource memory resource, bytes32 nullifierKey) internal pure returns (bytes32 nf) {
        nf = sha256(abi.encodePacked(nullifierKey, resource.nonce, psi(resource), commitment(resource)));
    }

    /// @notice Computes the resource kind.
    /// @param resource The resource object.
    /// @return k The computed kind.
    function kind(Resource memory resource) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(resource.logicRef, resource.labelRef));
    }

    /// @notice Computes the resource kind.
    /// @param logicRef The resource logic reference.
    /// @param labelRef The resource label reference.
    /// @return k The computed kind.
    function kind(bytes32 logicRef, bytes32 labelRef) internal pure returns (bytes32 k) {
        k = sha256(abi.encode(logicRef, labelRef));
    }

    /// @notice Computes the randomness for the commitment
    /// @param resource The resource whose randomness we compute
    /// @return randCm The randomness for the resource commitment
    function rcm(Resource memory resource) internal pure returns (bytes32 randCm) {
        bytes17 prfExpandPersonalization = 0x52495343305f457870616e645365656401;
        randCm = sha256(abi.encodePacked(prfExpandPersonalization, resource.randSeed, resource.nonce));
    }

    /// @notice Computes the randomness for the nullifier
    /// @param resource The resource whose randomness we compute
    /// @return randNf The randomness for the resource nullifier
    function psi(Resource memory resource) internal pure returns (bytes32 randNf) {
        bytes17 prfExpandPersonalization = 0x52495343305f457870616e645365656400;
        randNf = sha256(abi.encodePacked(prfExpandPersonalization, resource.randSeed, resource.nonce));
    }
}
