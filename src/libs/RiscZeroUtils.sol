// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ComplianceInstance, LogicInstance} from "../Types.sol";

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

    // TODO Use calldata?
    function convertJournal(LogicInstance memory instance) internal pure returns (bytes memory converted) {
        converted = abi.encodePacked(
            instance.tag,
            boolToRisc0(instance.isConsumed),
            instance.actionTreeRoot,
            _EMPTY, // TODO! Encode real ciphertext.
            _EMPTY // TODO! Encode real appData.
        );
    }

    function boolToRisc0(bool value) internal pure returns (bytes4 converted) {
        converted = value ? bytes4(0x01000000) : bytes4(0x00000000);
    }
}
