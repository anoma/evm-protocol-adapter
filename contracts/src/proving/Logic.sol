// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Logic
/// @author Anoma Foundation, 2025
/// @notice A library containing type definitions and methods of the logic proving system.
/// @custom:security-contact security@anoma.foundation
library Logic {
    /// @notice An enum representing the supported blob deletion criteria.
    enum DeletionCriterion {
        Immediately,
        Never
    }

    /// @notice A struct containing information required to verify a logic proof.
    /// @param tag The nullifier or commitment of the resource depending on if the resource is consumed or not.
    /// @param verifyingKey The logic verifying key (i.e., the hash of the logic function).
    /// @param appData The application data associated with the resource.
    /// @dev In the future and to achieve function privacy, the logic circuit validity will be proven
    //  in another circuit and can be hard-coded similar to the compliance proof verifying key.
    /// @param proof The logic proof.
    struct VerifierInput {
        bytes32 tag;
        bytes32 verifyingKey;
        AppData appData;
        bytes proof;
    }

    /// @notice A struct containing payloads of different kinds.
    /// @param resourcePayload A list of blobs for encoding plaintext info connected to resources.
    /// @param discoveryPayload A list of blobs for encoding data with public keys for discovery.
    /// @param externalPayload A list of blobs for encoding data connected with external calls.
    /// @param applicationPayload A list of blobs for application-specific purposes.
    struct AppData {
        ExpirableBlob[] resourcePayload;
        ExpirableBlob[] discoveryPayload;
        ExpirableBlob[] externalPayload;
        ExpirableBlob[] applicationPayload;
    }

    /// @notice A blob with a deletion criterion attached.
    /// @param deletionCriterion The deletion criterion.
    /// @param blob The bytes-encoded blob data.
    struct ExpirableBlob {
        DeletionCriterion deletionCriterion;
        bytes blob;
    }

    /// @notice Thrown if a tag is not found in a list of verifier inputs.
    error TagNotFound(bytes32 tag);

    /// @notice Looks up a `VerifierInput` element from a list by its tag.
    /// @param list The list of verifier inputs.
    /// @param tag The tag to look up.
    /// @return foundElement The found `VerifierInput` element.
    function lookup(VerifierInput[] calldata list, bytes32 tag)
        internal
        pure
        returns (VerifierInput calldata foundElement)
    {
        uint256 len = list.length;
        for (uint256 i = 0; i < len; ++i) {
            if (list[i].tag == tag) {
                return foundElement = list[i];
            }
        }
        revert TagNotFound(tag);
    }
}
