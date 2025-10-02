// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {reverseByteOrderUint32} from "@risc0-ethereum/Util.sol";

import {Aggregation} from "./proving/Aggregation.sol";
import {Compliance} from "./proving/Compliance.sol";
import {Logic} from "./proving/Logic.sol";

/// @title RiscZeroUtils
/// @author Anoma Foundation, 2025
/// @notice A library containing utility functions to encode resource machine types to the RISC Zero journal format.
/// @custom:security-contact security@anoma.foundation
library RiscZeroUtils {
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
    /// @param input The logic verifier input.
    /// @return converted The converted journal.
    /// @dev Blob counts / payload lengths can safely be assumed to not exceed the `type(uint32).max` as this would
    /// exceed Ethereum's block gas limit. Note that safe-math is still applied.
    function toJournal(Logic.Instance memory input) internal pure returns (bytes memory converted) {
        Logic.AppData memory appData = input.appData;

        converted = abi.encodePacked(
            input.tag,
            // Encode the `isConsumed` boolean as a `uint32` in reverse (little-endian) byte order.
            input.isConsumed ? uint32(0x01000000) : uint32(0x00000000),
            input.actionTreeRoot,
            //
            // Encode the resource payload length as a `uint32` in reverse byte order.
            reverseByteOrderUint32(uint32(appData.resourcePayload.length)),
            encodePayload(appData.resourcePayload),
            //
            // Encode the discovery payload length as a `uint32` in reverse byte order.
            reverseByteOrderUint32(uint32(appData.discoveryPayload.length)),
            encodePayload(appData.discoveryPayload),
            //
            // Encode the external payload length as a `uint32` in reverse byte order.
            reverseByteOrderUint32(uint32(appData.externalPayload.length)),
            encodePayload(appData.externalPayload),
            //
            // Encode the application payload length as a `uint32` in reverse byte order.
            reverseByteOrderUint32(uint32(appData.applicationPayload.length)),
            encodePayload(appData.applicationPayload)
        );
    }

    /// @notice Converts the aggregation instance to the RISC Zero journal format.
    /// @param instance The aggregation instance.
    /// @return journal The resulting RISC Zero journal.
    /// @dev Payload, blob, and journal lengths (divided by 4) can safely be assumed to not exceed the
    /// `type(uint32).max` as this would exceed Ethereum's block gas limit.
    function toJournal(Aggregation.Instance memory instance) internal pure returns (bytes memory journal) {
        uint256 complianceUnitCount = instance.complianceInstances.length;

        bytes memory packedComplianceJournals = "";
        bytes memory packedLogicJournals = "";

        for (uint256 i = 0; i < complianceUnitCount; ++i) {
            // Pack the compliance instance journals.
            packedComplianceJournals =
                abi.encodePacked(packedComplianceJournals, instance.complianceInstances[i].toJournal());

            // Pack the logic instance journals.
            {
                bytes memory consumedJournal = instance.logicInstances[(i * 2)].toJournal();
                bytes memory createdJournal = instance.logicInstances[(i * 2) + 1].toJournal();

                packedLogicJournals = abi.encodePacked(
                    packedLogicJournals,
                    // Encode the created journal length (which is a multiple of `32 bytes`) divided by 4 (bytes)
                    // representing the number of RISC Zero words in reverse (little-endian) byte order.
                    reverseByteOrderUint32(uint32(consumedJournal.length / 4)),
                    consumedJournal,
                    // Encode the consumed journal length (which is a multiple of `32 bytes`) divided by 4 (bytes)
                    // representing the number of RISC Zero words in reverse (little-endian) byte order.
                    reverseByteOrderUint32(uint32(createdJournal.length / 4)),
                    createdJournal
                );
            }
        }

        // Encode the compliance unit and tag count as a `uint32` in reverse (little-endian) byte order.
        uint32 complianceUnitCountPadding = reverseByteOrderUint32(uint32(complianceUnitCount));
        uint32 tagCountPadding = reverseByteOrderUint32(uint32(complianceUnitCount * 2));

        // Pack the aggregation instance journal.
        journal = abi.encodePacked(
            // Add the padded compliance journals.
            complianceUnitCountPadding,
            packedComplianceJournals,
            //
            // Add the compliance verifying key.
            Compliance._VERIFYING_KEY,
            //
            // Add the tag count-padded logic journals.
            tagCountPadding,
            packedLogicJournals,
            //
            // Add the tag count-padded logic references.
            tagCountPadding,
            instance.logicRefs
        );
    }

    /// @notice Encodes a payload to the RISC Zero journal format.
    /// @param payload The payload.
    /// @return encoded The encoded bytes of the payload.
    /// @dev The blob length divided by 4 can safely be assumed to not exceed the `type(uint32).max` as this
    /// would exceed Ethereum's block gas limit.
    function encodePayload(Logic.ExpirableBlob[] memory payload) internal pure returns (bytes memory encoded) {
        uint256 blobCount = payload.length;
        for (uint256 i = 0; i < blobCount; ++i) {
            encoded = abi.encodePacked(
                encoded,
                // Encode the blob length (which is a multiple of `32 bytes`) divided by 4 (bytes) representing the
                // number of RISC Zero words in reverse (little-endian) byte order.
                reverseByteOrderUint32(uint32(payload[i].blob.length / 4)),
                payload[i].blob,
                // Encode the blob deletion criterion as a `uint32` in reverse (little-endian) byte order.
                reverseByteOrderUint32(uint32(payload[i].deletionCriterion))
            );
        }
    }
}
