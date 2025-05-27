// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ComplianceInstance} from "../Types.sol";

import {Logic} from "../proving/Logic.sol";

library RiscZeroUtils {
    function toJournalDigest(ComplianceInstance memory instance) internal pure returns (bytes32 digest) {
        digest = sha256(abi.encode(instance));
    }

    function toJournalDigest(Logic.Instance memory instance) internal pure returns (bytes32 digest) {
        digest = sha256(convertJournal(instance));
    }

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

    function toRiscZero(bool value) internal pure returns (bytes4 converted) {
        converted = value ? bytes4(0x01000000) : bytes4(0x00000000);
    }

    function toRiscZero(uint32 value) internal pure returns (bytes4 converted) {
        converted = bytes4(
            ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8) | ((value & 0x00FF0000) >> 8)
                | ((value & 0xFF000000) >> 24)
        );
    }
}
