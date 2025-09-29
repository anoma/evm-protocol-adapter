// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "../proving/Compliance.sol";
import {Logic} from "../proving/Logic.sol";

/// @title RiscZeroUtils
/// @author Anoma Foundation, 2025
/// @notice A library containing utility functions to convert and encode types for RISC Zero.
/// @custom:security-contact security@anoma.foundation
library RiscZeroUtils {
    using RiscZeroUtils for bytes;

    /// @notice Calculates the digest of the compliance instance (journal).
    /// @param instance The compliance instance.
    /// @return digest The journal digest.
    function toJournalDigest(Compliance.Instance memory instance) internal pure returns (bytes32 digest) {
        bytes memory encodedInstance = abi.encodePacked(
            instance.consumed.nullifier,
            instance.consumed.logicRef,
            instance.consumed.commitmentTreeRoot,
            instance.created.commitment,
            instance.created.logicRef,
            instance.unitDeltaX,
            instance.unitDeltaY
        );
        digest = sha256(encodedInstance);
    }

    /// @notice Calculates the digest of the logic instance (journal).
    /// @param input The logic verifier input.
    /// @param actionTreeRoot The action tree root computed per-action.
    /// @param consumed The bool describing whether the input is for a consumed or created resource.
    /// @return digest The journal digest.
    function toJournalDigest(Logic.VerifierInput memory input, bytes32 actionTreeRoot, bool consumed)
        internal
        pure
        returns (bytes32 digest)
    {
        digest = sha256(convertJournal(input, actionTreeRoot, consumed));
    }

    /// @notice Converts the logic instance to match the RISC Zero journal.
    /// @param input The logic verifier input.
    /// @param actionTreeRoot The action tree root computed per-action.
    /// @param consumed The bool describing whether the input is for a consumed or created resource.
    /// @return converted The converted journal.
    function convertJournal(Logic.VerifierInput memory input, bytes32 actionTreeRoot, bool consumed)
        internal
        pure
        returns (bytes memory converted)
    {
        bytes memory encodedAppData;

        encodedAppData = encodedAppData.appendPayload(input.appData.resourcePayload);
        encodedAppData = encodedAppData.appendPayload(input.appData.discoveryPayload);
        encodedAppData = encodedAppData.appendPayload(input.appData.externalPayload);
        encodedAppData = encodedAppData.appendPayload(input.appData.applicationPayload);

        converted = abi.encodePacked(input.tag, toRiscZero(consumed), actionTreeRoot, encodedAppData);
    }

    /// @notice Appends expirable blob payload to the encode app data.
    /// @param encodedAppData The app data to append the payload to.
    /// @param payload The payload.
    /// @return updated The updated app data.
    function appendPayload(bytes memory encodedAppData, Logic.ExpirableBlob[] memory payload)
        internal
        pure
        returns (bytes memory updated)
    {
        uint32 nBlobs = uint32(payload.length);
        updated = abi.encodePacked(encodedAppData, toRiscZero(nBlobs));

        for (uint256 i = 0; i < nBlobs; ++i) {
            updated = abi.encodePacked(
                updated,
                abi.encodePacked(
                    toRiscZero(uint32(payload[i].blob.length / 4)),
                    payload[i].blob,
                    toRiscZero(uint32(payload[i].deletionCriterion))
                )
            );
        }
    }

    /// @notice Converts a `bool` to the RISC Zero format to `bytes4` by appending three zero bytes.
    /// @param value The value.
    /// @return converted The converted value.
    function toRiscZero(bool value) internal pure returns (bytes4 converted) {
        converted = value ? bytes4(0x01000000) : bytes4(0x00000000);
    }

    /// @notice Converts a `uint32` to RISC Zero's format (`bytes4`) by reversing the byte order (endianness).
    /// @param value The 32-bit unsigned integer to convert.
    /// @return converted The converted 4-byte value in little-endian order.
    function toRiscZero(uint32 value) internal pure returns (bytes4 converted) {
        converted = bytes4(
            // Extract the most significant byte and move it right to the least significant position.
            (value >> 24)
            // Extract the second-most significant byte and shift it right by one byte.
            | ((value >> 8) & 0x0000FF00)
            // Extract the second-least significant byte and shift it left by one byte.
            | ((value << 8) & 0x00FF0000)
            // Extract the least significant byte and move it left to the most significant position.
            | (value << 24)
        );
    }
}
