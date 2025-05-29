// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {BlobStorage} from "../state/BlobStorage.sol";

/// @notice A library containing type definitions and methods of the logic proving system.
library Logic {
    /// @notice The instance of the logic proof associated with a specific resource.
    /// @param tag The nullifier or commitment of the resource depending on if the resource is consumed or not.
    /// @param isConsumed Whether the associated resource is consumed or not.
    /// @param actionTreeRoot The root of the Merkle tree containing all nullifiers and commitments of the action/
    /// @param ciphertext Encrypted information for the receiver of the resource that will be emitted as an event.
    /// The ciphertext contains, at least, the resource plaintext and optional other application specific data.
    /// @param appData The application data associated with the resource.
    struct Instance {
        bytes32 tag;
        bool isConsumed;
        bytes32 actionTreeRoot;
        bytes ciphertext;
        BlobStorage.ExpirableBlob[] appData;
    }

    /// @notice A struct containing all information required to verify a logic proof.
    /// @param proof The logic proof.
    /// @param instance The logic instance to the proof.
    /// @param verifyingKey The logic verifying key (i.e., the hash of the logic function).
    /// @dev In the future and to achieve function privacy, the logic circuit validity will be proven
    //  in another circuit and can be hard-coded similar to the compliance proof verifying key.
    struct VerifierInput {
        bytes proof;
        Instance instance;
        bytes32 verifyingKey;
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
            if (list[i].instance.tag == tag) {
                return foundElement = list[i];
            }
        }
        revert TagNotFound(tag);
    }
}
