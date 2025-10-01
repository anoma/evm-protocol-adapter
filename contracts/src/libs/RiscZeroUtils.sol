// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Aggregation} from "../proving/Aggregation.sol";
import {Compliance} from "../proving/Compliance.sol";
import {Logic} from "../proving/Logic.sol";

/// @title RiscZeroUtils
/// @author Anoma Foundation, 2025
/// @notice A library containing utility functions to convert and encode types for RISC Zero.
/// @custom:security-contact security@anoma.foundation
library RiscZeroUtils {
    using RiscZeroUtils for uint32;
    using RiscZeroUtils for bytes;
    using RiscZeroUtils for bool;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;

    /// @notice Converts the compliance instance to the RISC Zero journal format.
    /// @param instance The compliance instance.
    /// @return journal The resulting RISC Zero journal.
    function toJournal(Compliance.Instance memory instance) internal pure returns (bytes memory journal) {
        journal = abi.encodePacked(
            instance.consumed.nullifier,
            instance.consumed.logicRef,
            instance.consumed.commitmentTreeRoot,
            instance.created.commitment,
            instance.created.logicRef,
            instance.unitDeltaX,
            instance.unitDeltaY
        );
    }

    /// @notice Converts the logic instance to the RISC Zero journal format.
    /// @param input The resource logic instance.
    /// @return converted The converted journal.
    function toJournal(Logic.Instance memory input) internal pure returns (bytes memory converted) {
        converted = abi.encodePacked(
            input.tag,
            input.isConsumed.toRiscZero(),
            input.actionTreeRoot,
            encodePayload(input.appData.resourcePayload),
            encodePayload(input.appData.discoveryPayload),
            encodePayload(input.appData.externalPayload),
            encodePayload(input.appData.applicationPayload)
        );
    }

    /// @notice Converts the aggregation instance to the RISC Zero journal format.
    /// @param instance The aggregation instance.
    /// @return journal The resulting RISC Zero journal.
    function toJournal(Aggregation.Instance memory instance) internal pure returns (bytes memory journal) {
        uint256 tagCount = instance.logicRefs.length;

        bytes4 complianceCountPadding = uint32(tagCount / 2).toRiscZero();
        bytes4 tagCountPadding = uint32(tagCount).toRiscZero();

        bytes memory compliancesJournal = "";
        bytes memory logicsJournal = "";

        for (uint256 i = 0; i < (tagCount / 2); ++i) {
            compliancesJournal = abi.encodePacked(compliancesJournal, instance.complianceInstances[i].toJournal());
        }

        for (uint256 j = 0; j < (tagCount / 2); ++j) {
            Logic.Instance memory nfInstance = instance.logicInstances[j * 2];
            Logic.Instance memory cmInstance = instance.logicInstances[(j * 2) + 1];
            bytes memory nfJournal = nfInstance.toJournal();
            bytes memory cmJournal = cmInstance.toJournal();
            logicsJournal = abi.encodePacked(
                logicsJournal,
                uint32(nfJournal.length / 4).toRiscZero(),
                nfJournal,
                uint32(cmJournal.length / 4).toRiscZero(),
                cmJournal
            );
        }

        journal = abi.encodePacked(
            complianceCountPadding,
            compliancesJournal,
            Compliance._VERIFYING_KEY,
            //
            tagCountPadding,
            logicsJournal,
            //
            tagCountPadding,
            instance.logicRefs
        );
    }

    /// @notice Encodes a given payload for Risc0 Journal format.
    /// @param payload The payload.
    /// @return encoded The encoded bytes of the payload.
    function encodePayload(Logic.ExpirableBlob[] memory payload) internal pure returns (bytes memory encoded) {
        uint32 nBlobs = uint32(payload.length);
        encoded = abi.encodePacked(nBlobs.toRiscZero());

        for (uint256 i = 0; i < nBlobs; ++i) {
            encoded = abi.encodePacked(
                encoded,
                uint32(payload[i].blob.length / 4).toRiscZero(),
                payload[i].blob,
                uint32(payload[i].deletionCriterion).toRiscZero()
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
