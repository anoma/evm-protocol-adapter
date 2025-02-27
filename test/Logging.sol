// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {Transaction, Resource, Action} from "../src/Types.sol";
import {LogicInstance, LogicProofs, TagLogicProofPair, LogicRefProofPair} from "../src/proving/Logic.sol";

library Log {
    using Strings for uint256;

    string internal constant separator = "  : ";

    function log(Resource memory r) internal pure {
        string[] memory fields = new string[](8);

        fields[0] = _entryBytes32("logicRef ", r.logicRef);
        fields[1] = _entryBytes32("labelRef ", r.labelRef);
        fields[2] = _entryBytes32("valueRef ", r.valueRef);
        fields[3] = _entryBytes32("nkc      ", r.nullifierKeyCommitment);
        fields[4] = _entryUint256("quantity ", r.quantity);
        fields[5] = _entryUint256("nonce    ", r.nonce);
        fields[6] = _entryUint256("randSeed ", r.randSeed);
        fields[7] = _entryBool("ephemeral", r.ephemeral);

        console.log(wrap("{", concatFields(fields, 1), "}", 0));
    }

    function log(LogicInstance memory i) internal pure {
        string[] memory fields = new string[](4);

        fields[0] = _entryBytes32("tag        ", i.tag);
        fields[1] = _entryBool("isConsumed ", i.isConsumed);
        fields[2] = _entryString("consumed   ", wrap("[", concatFields(_entriesBytes32Arr(i.consumed), 3), "]", 2));
        fields[3] = _entryString("created   ", wrap("[", concatFields(_entriesBytes32Arr(i.created), 3), "]", 2));
        // fields[4] =  todo
        console.log(wrap("{", concatFields(fields, 1), "}", 0));
    }

    function concatFields(string[] memory entries, uint256 level) internal pure returns (string memory loggedEntries) {
        string memory ind = indentation(level);
        for (uint256 i = 0; i < entries.length; ++i) {
            loggedEntries = string.concat(loggedEntries, string.concat(ind, entries[i], "\n"));
        }
    }

    function indent(string memory content, uint256 level) internal pure returns (string memory) {
        return string.concat(indentation(level), content);
    }

    function indentation(uint256 level) internal pure returns (string memory ind) {
        for (uint256 i = 0; i < level; ++i) {
            ind = string.concat(ind, "  ");
        }
    }

    function wrap(string memory start, string memory content, string memory end, uint256 level)
        internal
        pure
        returns (string memory)
    {
        string memory ind = indentation(level);
        return string.concat("\n", ind, start, "\n", content, ind, end, "\n");
    }

    function _entryBytes32(string memory fieldname, bytes32 value) internal pure returns (string memory entry) {
        entry = string.concat(fieldname, separator, uint256(value).toHexString());
    }

    function _entryUint256(string memory fieldname, uint256 value) internal pure returns (string memory entry) {
        entry = string.concat(fieldname, separator, value.toString());
    }

    function _entryBool(string memory fieldname, bool value) internal pure returns (string memory entry) {
        entry = string.concat(fieldname, separator, value ? "true" : "false");
    }

    function _entryString(string memory fieldname, string memory value) internal pure returns (string memory entry) {
        entry = string.concat(fieldname, separator, value);
    }

    function _entriesBytes32Arr(bytes32[] memory values) internal pure returns (string[] memory entries) {
        entries = new string[](values.length);

        for (uint256 i = 0; i < values.length; ++i) {
            string memory val = string.concat(uint256(values[i]).toHexString());

            if (i < values.length - 1) {
                entries[i] = string.concat(val, ",\n");
            } else {
                entries[i] = val;
            }
        }
    }
}
