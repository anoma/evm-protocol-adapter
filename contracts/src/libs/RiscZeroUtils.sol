// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "../proving/Compliance.sol";
import {Logic} from "../proving/Logic.sol";

/// @notice A library containing utility functions to convert and encode types for RISC Zero.
library RiscZeroUtils {
    /// @notice Calculates the digest of the compliance instance (journal).
    /// @param instance The compliance instance.
    /// @return digest The journal digest.
    function toJournalDigest(Compliance.Instance memory instance) internal pure returns (bytes32 digest) {
        digest = sha256(abi.encode(instance));
    }

    /// @notice Calculates the digest of the logic instance (journal).
    /// @param instance The logic instance.
    /// @return digest The journal digest.
    function toJournalDigest(Logic.Instance memory instance) internal pure returns (bytes32 digest) {
        digest = sha256(convertJournal(instance));
    }

    /// @notice Converts the logic instance to match the RISC Zero journal.
    /// @param instance The logic instance.
    /// @return converted The converted journal.
    function convertJournal(Logic.Instance memory instance) internal pure returns (bytes memory converted) {
        uint32 nCiphertext = uint32(instance.ciphertext.length);
        bytes memory encodedCipher = abi.encodePacked(toRiscZero(nCiphertext / 4), instance.ciphertext);

        uint32 nBlobs = uint32(instance.appData.length);
        bytes memory encodedAppData = abi.encodePacked(toRiscZero(nBlobs));
        {
            for (uint256 i = 0; i < nBlobs; ++i) {
                bytes memory blobEncoded = abi.encodePacked(
                    toRiscZero(uint32(instance.appData[i].blob.length / 4)),
                    instance.appData[i].blob,
                    toRiscZero(uint32(instance.appData[i].deletionCriterion))
                );
                encodedAppData = abi.encodePacked(encodedAppData, blobEncoded);
            }
        }

        converted = abi.encodePacked(
            instance.tag, toRiscZero(instance.isConsumed), instance.actionTreeRoot, encodedCipher, encodedAppData
        );
    }

    /// @notice Converts a `bool` to the RISC Zero format to `bytes4` by appending three zero bytes.
    /// @param value The value.
    /// @return converted The converted value.
    function toRiscZero(bool value) internal pure returns (bytes4 converted) {
        converted = value ? bytes4(0x01000000) : bytes4(0x00000000);
    }

    /// @notice Converts a `uint32` to the RISC Zero format to `bytes4` by appending three zero bytes.
    /// @param value The value.
    /// @return converted The converted value.
    function toRiscZero(uint32 value) internal pure returns (bytes4 converted) {
        converted = bytes4(
            ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8) | ((value & 0x00FF0000) >> 8)
                | ((value & 0xFF000000) >> 24)
        );
    }
}
