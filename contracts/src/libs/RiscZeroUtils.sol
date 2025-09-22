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

    /// @notice The value `8` which is required on `arm-risc0` to encode vector types.
    bytes4 internal constant _EIGHT = hex"08000000"; // TODO This will be refactored in the future..

    /// @notice Calculates the digest of the compliance instance (journal).
    /// @param instance The compliance instance.
    /// @return digest The journal digest.
    function toJournalDigest(Compliance.Instance memory instance) internal pure returns (bytes32 digest) {
        bytes memory encodedInstance = abi.encodePacked(
            _EIGHT,
            instance.consumed.nullifier,
            _EIGHT,
            instance.consumed.logicRef,
            _EIGHT,
            instance.consumed.commitmentTreeRoot,
            _EIGHT,
            instance.created.commitment,
            _EIGHT,
            instance.created.logicRef,
            _EIGHT,
            instance.unitDeltaX,
            _EIGHT,
            instance.unitDeltaY
        );
        digest = sha256(encodedInstance);
    }

    /// @notice Calculates the digest of the logic instance (journal).
    /// @param input The logic verifier input.
    /// @param root The action tree root computed per-action.
    /// @param consumed The bool describing whether the input is for a consumed or created resource.
    /// @return digest The journal digest.
    function toJournalDigest(Logic.VerifierInput memory input, bytes32 root, bool consumed)
        internal
        pure
        returns (bytes32 digest)
    {
        digest = sha256(convertJournal(input, root, consumed));
    }

    /// @notice Converts the logic instance to match the RISC Zero journal.
    /// @param input The logic verifier input.
    /// @param root The action tree root computed per-action.
    /// @param consumed The bool describing whether the input is for a consumed or created resource.
    /// @return converted The converted journal.
    function convertJournal(Logic.VerifierInput memory input, bytes32 root, bool consumed)
        internal
        pure
        returns (bytes memory converted)
    {
        uint32 nBlobs = uint32(input.appData.resourcePayload.length);
        bytes memory encodedAppData = abi.encodePacked(toRiscZero(nBlobs));
        {
            for (uint256 i = 0; i < nBlobs; ++i) {
                encodedAppData = appendBlob(encodedAppData, input.appData.resourcePayload[i]);
            }
        }

        nBlobs = uint32(input.appData.discoveryPayload.length);
        encodedAppData = abi.encodePacked(encodedAppData, toRiscZero(nBlobs));
        {
            for (uint256 i = 0; i < nBlobs; ++i) {
                encodedAppData = appendBlob(encodedAppData, input.appData.discoveryPayload[i]);
            }
        }

        nBlobs = uint32(input.appData.externalPayload.length);
        encodedAppData = abi.encodePacked(encodedAppData, toRiscZero(nBlobs));
        {
            for (uint256 i = 0; i < nBlobs; ++i) {
                encodedAppData = appendBlob(encodedAppData, input.appData.externalPayload[i]);
            }
        }

        nBlobs = uint32(input.appData.applicationPayload.length);
        encodedAppData = abi.encodePacked(encodedAppData, toRiscZero(nBlobs));
        {
            for (uint256 i = 0; i < nBlobs; ++i) {
                encodedAppData = appendBlob(encodedAppData, input.appData.applicationPayload[i]);
            }
        }

        converted = abi.encodePacked(eight, input.tag, toRiscZero(consumed), eight, root, encodedAppData);
    }

    /// @notice Appends an expirable blob to the encodeded app data.
    /// @param encodedAppData The app data to append the blob to.
    /// @param expirableBlob The expirable blob to append.
    /// @return updated The updated app data.
    function appendBlob(bytes memory encodedAppData, Logic.ExpirableBlob memory expirableBlob)
        internal
        pure
        returns (bytes memory updated)
    {
        updated = abi.encodePacked(
            encodedAppData,
            abi.encodePacked(
                toRiscZero(uint32(expirableBlob.blob.length / 4)),
                expirableBlob.blob,
                toRiscZero(uint32(expirableBlob.deletionCriterion))
            )
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
