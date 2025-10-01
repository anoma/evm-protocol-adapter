// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {reverseByteOrderUint32} from "@risc0-ethereum/Util.sol";

import {Aggregation} from "../proving/Aggregation.sol";
import {Compliance} from "../proving/Compliance.sol";
import {Logic} from "../proving/Logic.sol";

/// @title RiscZeroUtils
/// @author Anoma Foundation, 2025
/// @notice A library containing utility functions to convert and encode types for RISC Zero.
/// @custom:security-contact security@anoma.foundation
library RiscZeroUtils {
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;
    using RiscZeroUtils for uint32;
    using RiscZeroUtils for bool;

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
        uint256 complianceUnitCount = uint32(instance.complianceInstances.length);

        uint32 complianceCountPadding = reverseByteOrderUint32(uint32(complianceUnitCount));
        uint32 tagCountPadding = reverseByteOrderUint32(uint32(complianceUnitCount * 2));

        bytes memory packedComplianceJournals = "";
        bytes memory packedLogicJournals = "";

        for (uint256 i = 0; i < complianceUnitCount; ++i) {
            packedComplianceJournals =
                abi.encodePacked(packedComplianceJournals, instance.complianceInstances[i].toJournal());

            {
                bytes memory consumedJournal = instance.logicInstances[(i * 2)].toJournal();
                bytes memory createdJournal = instance.logicInstances[(i * 2) + 1].toJournal();

                packedLogicJournals = abi.encodePacked(
                    packedLogicJournals,
                    reverseByteOrderUint32(uint32(consumedJournal.length / 4)),
                    consumedJournal,
                    reverseByteOrderUint32(uint32(createdJournal.length / 4)),
                    createdJournal
                );
            }
        }

        journal = abi.encodePacked(
            complianceCountPadding,
            packedComplianceJournals,
            Compliance._VERIFYING_KEY,
            //
            tagCountPadding,
            packedLogicJournals,
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
        encoded = abi.encodePacked(reverseByteOrderUint32(nBlobs));

        for (uint256 i = 0; i < nBlobs; ++i) {
            encoded = abi.encodePacked(
                encoded,
                reverseByteOrderUint32(uint32(payload[i].blob.length / 4)),
                payload[i].blob,
                reverseByteOrderUint32(uint32(payload[i].deletionCriterion))
            );
        }
    }

    /// @notice Converts a `bool` to the RISC Zero format to `bytes4` by appending three zero bytes.
    /// @param value The value.
    /// @return converted The converted value.
    function toRiscZero(bool value) internal pure returns (uint32 converted) {
        converted = value ? 0x01000000 : 0x00000000;
    }
}
