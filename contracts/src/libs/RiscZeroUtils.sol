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
    using RiscZeroUtils for uint32;
    using RiscZeroUtils for bytes;
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
    /// @param actionTreeRoot The action tree root computed per-action.
    /// @param isConsumed Whether the logic instance belongs to a consumed or created resource.
    /// @return converted The converted journal.
    function toJournal(Logic.VerifierInput memory input, bytes32 actionTreeRoot, bool isConsumed)
        internal
        pure
        returns (bytes memory converted)
    {
        converted = abi.encodePacked(
            input.tag,
            reverseByteOrderUint32(isConsumed ? 1 : 0),
            actionTreeRoot,
            encodePayload(input.appData.resourcePayload),
            encodePayload(input.appData.discoveryPayload),
            encodePayload(input.appData.externalPayload),
            encodePayload(input.appData.applicationPayload)
        );
    }

    /// @notice Converts the aggregation instance to the RISC Zero journal format.
    /// @param instance The aggregation instance.
    /// @return journal The resulting RISC Zero journal.
    /// @dev `instance.logicRefs.length` can be assumed to fit into `uint32` because the block gas limit constitutes a
    /// lower bound in practice.
    function toJournal(Aggregation.Instance memory instance) internal pure returns (bytes memory journal) {
        uint32 tagCount = uint32(instance.logicRefs.length);

        uint32 complianceCountPadding = reverseByteOrderUint32(tagCount / 2);
        uint32 tagCountPadding = reverseByteOrderUint32(tagCount);

        journal = abi.encodePacked(
            complianceCountPadding,
            instance.packedComplianceProofJournals,
            Compliance._VERIFYING_KEY,
            //
            tagCountPadding,
            instance.packedLogicProofJournals,
            //
            tagCountPadding,
            instance.logicRefs
        );
    }

    /// @notice Encodes a given payload for Risc0 Journal format.
    /// @param payload The payload.
    /// @return encoded The encoded bytes of the payload.
    /// @dev `payload.length` and `blob.length` can be assumed to fit into `uint32` because the block gas limit
    /// constitutes a lower bound in practice.
    function encodePayload(Logic.ExpirableBlob[] memory payload) internal pure returns (bytes memory encoded) {
        uint256 nBlobs = payload.length;
        encoded = abi.encodePacked(reverseByteOrderUint32(uint32(nBlobs)));

        for (uint256 i = 0; i < nBlobs; ++i) {
            encoded = abi.encodePacked(
                encoded,
                reverseByteOrderUint32(uint32(payload[i].blob.length / 4)),
                payload[i].blob,
                reverseByteOrderUint32(uint32(payload[i].deletionCriterion))
            );
        }
    }

    /// @notice Encodes a journal with its length in bytes divided by 4 (bytes) representing the number of RISC Zero
    /// words in little-endian order.
    /// @param journal The journal to encode.
    /// @return lengthEncodedJournal The length encoded journal.
    /// @dev `journal.length` can be assumed to fit into `uint32` because the block gas limit constitutes a lower bound
    /// in practice.
    function toJournalWithEncodedLength(bytes memory journal)
        internal
        pure
        returns (bytes memory lengthEncodedJournal)
    {
        lengthEncodedJournal = abi.encodePacked(reverseByteOrderUint32(uint32(journal.length / 4)), journal);
    }
}
