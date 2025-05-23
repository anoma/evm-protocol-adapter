// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ComplianceInstance, LogicInstance, ExpirableBlob} from "../Types.sol";

library RiscZeroUtils {
    bytes internal constant _EMPTY = abi.encodePacked(bytes4(0));

    // TODO Use calldata?
    function toJournalDigest(ComplianceInstance memory instance) internal pure returns (bytes32 digest) {
        digest = sha256(abi.encode(instance));
    }

    // TODO Use calldata?
    function toJournalDigest(LogicInstance memory instance) internal pure returns (bytes32 digest) {
        digest = sha256(convertJournal(instance));
    }

    function convertJournal(LogicInstance memory instance) internal pure returns (bytes memory converted) {
        bytes memory appData = "";

        uint32 nCiphertexts = uint32(instance.ciphertexts.length);
        bytes memory encodedCipher = abi.encodePacked(uint32ToRisc0(nCiphertexts));
        {
            for (uint256 i = 0; i < nCiphertexts; ++i) {
                encodedCipher = abi.encodePacked(encodedCipher, instance.ciphertexts[i]);
            }
        }

        {
            uint256 nBlobs = instance.appData.length;
            for (uint256 i = 0; i < nBlobs; ++i) {
                bytes memory blobEncoded = abi.encodePacked(
                    instance.appData[i].blob.length, instance.appData[i].blob, instance.appData[i].deletionCriterion
                );
                appData = abi.encodePacked(appData, blobEncoded);
            }
        }

        converted = abi.encodePacked(
            instance.tag,
            boolToRisc0(instance.isConsumed),
            instance.actionTreeRoot,
            encodedCipher, // TODO! Encode real ciphertext.
            appData // TODO! Encode real appData.
        );
    }

    function boolToRisc0(bool value) internal pure returns (bytes4 converted) {
        converted = value ? bytes4(0x01000000) : bytes4(0x00000000);
    }

    function uint32ToRisc0(uint32 value) public pure returns (bytes4 converted) {
        converted = bytes4(
            ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8) | ((value & 0x00FF0000) >> 8)
                | ((value & 0xFF000000) >> 24)
        );
    }
}
