// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "../proving/Compliance.sol";
import {Logic} from "../proving/Logic.sol";

/// @title RiscZeroUtils
/// @author Anoma Foundation, 2025
/// @notice A library containing utility functions to convert and encode types for RISC Zero.
/// @custom:security-contact security@anoma.foundation
library RiscZeroUtils {
    bytes4 internal constant _SELECTOR = 0xbb001d44;

    /// @notice Calculates the digest of the compliance instance (journal).
    /// @param instance The compliance instance.
    /// @return digest The journal digest.
    function toJournalDigest(Compliance.Instance memory instance) internal pure returns (bytes32 digest) {
        bytes4 eight = hex"08000000";
        bytes memory encodedInstance = abi.encodePacked(
            eight,
            instance.consumed.nullifier,
            eight,
            instance.consumed.logicRef,
            eight,
            instance.consumed.commitmentTreeRoot,
            eight,
            instance.created.commitment,
            eight,
            instance.created.logicRef,
            eight,
            instance.unitDeltaX,
            eight,
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
                bytes memory blobEncoded = abi.encodePacked(
                    toRiscZero(uint32(input.appData.resourcePayload[i].blob.length / 4)),
                    input.appData.resourcePayload[i].blob,
                    toRiscZero(uint32(input.appData.resourcePayload[i].deletionCriterion))
                );
                encodedAppData = abi.encodePacked(encodedAppData, blobEncoded);
            }
        }

        nBlobs = uint32(input.appData.discoveryPayload.length);
        encodedAppData = abi.encodePacked(encodedAppData, toRiscZero(nBlobs));
        {
            for (uint256 i = 0; i < nBlobs; ++i) {
                bytes memory blobEncoded = abi.encodePacked(
                    toRiscZero(uint32(input.appData.discoveryPayload[i].blob.length / 4)),
                    input.appData.discoveryPayload[i].blob,
                    toRiscZero(uint32(input.appData.discoveryPayload[i].deletionCriterion))
                );
                encodedAppData = abi.encodePacked(encodedAppData, blobEncoded);
            }
        }

        nBlobs = uint32(input.appData.externalPayload.length);
        encodedAppData = abi.encodePacked(encodedAppData, toRiscZero(nBlobs));
        {
            for (uint256 i = 0; i < nBlobs; ++i) {
                bytes memory blobEncoded = abi.encodePacked(
                    toRiscZero(uint32(input.appData.externalPayload[i].blob.length / 4)),
                    input.appData.externalPayload[i].blob,
                    toRiscZero(uint32(input.appData.externalPayload[i].deletionCriterion))
                );
                encodedAppData = abi.encodePacked(encodedAppData, blobEncoded);
            }
        }

        nBlobs = uint32(input.appData.applicationPayload.length);
        encodedAppData = abi.encodePacked(encodedAppData, toRiscZero(nBlobs));
        {
            for (uint256 i = 0; i < nBlobs; ++i) {
                bytes memory blobEncoded = abi.encodePacked(
                    toRiscZero(uint32(input.appData.applicationPayload[i].blob.length / 4)),
                    input.appData.applicationPayload[i].blob,
                    toRiscZero(uint32(input.appData.applicationPayload[i].deletionCriterion))
                );
                encodedAppData = abi.encodePacked(encodedAppData, blobEncoded);
            }
        }

        bytes4 eight = hex"08000000";
        converted = abi.encodePacked(eight, input.tag, toRiscZero(consumed), eight, root, encodedAppData);
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
