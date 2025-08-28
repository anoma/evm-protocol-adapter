// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Resource} from "../Types.sol";

/// @title ComputableComponents
/// @author Anoma Foundation, 2025
/// @notice A library containing methods to calculate computable components from resource objects.
/// @custom:security-contact security@anoma.foundation
library ComputableComponents {
    /// @notice The personalization constant for computing commitments.
    bytes17 internal constant _COMMITMENT_PERSONALIZATION = 0x52495343305f457870616e645365656401;

    /// @notice The personalization constant for computing nullifiers.
    bytes17 internal constant _NULLIFIER_PERSONALIZATION = 0x52495343305f457870616e645365656400;

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
                computeCommitmentRandomness(resource)
            )
        );
    }

    /// @notice Computes the resource nullifier given a nullifier key.
    /// @param resource The resource object.
    /// @param nullifierKey The nullifier key.
    /// @return nf The computed nullifier.
    /// @dev This methods does not check that the nullifier key commitment matches the nullifier key.
    function nullifier(Resource memory resource, bytes32 nullifierKey) internal pure returns (bytes32 nf) {
        nf = sha256(
            abi.encodePacked(nullifierKey, resource.nonce, computeNullifierRandomness(resource), commitment(resource))
        );
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
    /// see https://github.com/anoma/arm-risc0/blob/main/arm/src/resource.rs
    /// @param resource The resource whose randomness we compute
    /// @return randCm The randomness for the resource commitment
    function computeCommitmentRandomness(Resource memory resource) internal pure returns (bytes32 randCm) {
        randCm = sha256(abi.encodePacked(_COMMITMENT_PERSONALIZATION, resource.randSeed, resource.nonce));
    }

    /// @notice Computes the randomness for the nullifier
    /// see https://github.com/anoma/arm-risc0/blob/main/arm/src/resource.rs
    /// @param resource The resource whose randomness we compute
    /// @return randNf The randomness for the resource nullifier
    function computeNullifierRandomness(Resource memory resource) internal pure returns (bytes32 randNf) {
        randNf = sha256(abi.encodePacked(_NULLIFIER_PERSONALIZATION, resource.randSeed, resource.nonce));
    }
}
