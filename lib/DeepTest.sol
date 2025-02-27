// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "forge-std/Test.sol";
import {StdStyle} from "forge-std/StdStyle.sol";
import {LibString} from "solady/utils/LibString.sol";
import "src/state/BlobStorage.sol";
import "src/proving/Compliance.sol";
import "src/proving/Logic.sol";
import "src/libs/AppData.sol";
import "src/Types.sol";


abstract contract DeepTest is Test {
    using LibString for *;

    struct Comparison {
        string a;
        string b;
    }

    string private constant TAB = "    ";

    function _tab(string memory str, uint256 numTabs)
        private 
        pure 
        returns (string memory) 
    {
        string memory tabs;
        for (uint256 i = 0; i < numTabs; i++) {
            tabs = tabs.concat(TAB);
        }
        return tabs.concat(str);
    }

    function _boldRed(string memory str) 
        private 
        pure 
        returns (string memory)
    {
        return StdStyle.bold(StdStyle.red(str));
    }

    function prettyPrint(uint256 a)
        internal
    {
        emit log(a.toString());
    }    

    function _prettyPrint(
        uint256 a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat(a.toString()), recursionDepth);
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }
    
    function _comparePrint(
        uint256 a,
        uint256 b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a
            .concat(_prettyPrint(a, prefix, suffix, recursionDepth, a != b));
        comparison.b = comparison.b
            .concat(_prettyPrint(b, prefix, suffix, recursionDepth, a != b));
    }
    
    function prettyPrint(bytes32 a) 
        internal
    {
        emit log(uint256(a).toHexString(32));
    }

    function _prettyPrint(
        bytes32 a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight        
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat(uint256(a).toHexString(32)), recursionDepth);
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        bytes32 a,
        bytes32 b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a
            .concat(_prettyPrint(a, prefix, suffix, recursionDepth, a != b));
        comparison.b = comparison.b
            .concat(_prettyPrint(b, prefix, suffix, recursionDepth, a != b));
    }
    
    function prettyPrint(address a)
        internal
    {
        emit log(a.toHexString());
    }

    function _prettyPrint(
        address a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat(a.toHexString()), recursionDepth);
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }    

    function _comparePrint(
        address a,
        address b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a
            .concat(_prettyPrint(a, prefix, suffix, recursionDepth, a != b));
        comparison.b = comparison.b
            .concat(_prettyPrint(b, prefix, suffix, recursionDepth, a != b));
    }
    
    function prettyPrint(bool a)
        internal
    {
        emit log(a ? "true" : "false");
    }

    function _prettyPrint(
        bool a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat(a ? "true" : "false"), recursionDepth);
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        bool a,
        bool b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a
            .concat(_prettyPrint(a, prefix, suffix, recursionDepth, a != b));
        comparison.b = comparison.b
            .concat(_prettyPrint(b, prefix, suffix, recursionDepth, a != b));
    }

    function prettyPrint(string memory a)
        internal
    {
        emit log(string.concat('"', a, '"'));
    }

    function _prettyPrint(
        string memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat(string.concat('"', a, '"')), recursionDepth);
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        string memory a,
        string memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        bool equal = keccak256(bytes(a)) == keccak256(bytes(b));
        comparison.a = comparison.a
            .concat(_prettyPrint(a, prefix, suffix, recursionDepth, !equal));
        comparison.b = comparison.b
            .concat(_prettyPrint(b, prefix, suffix, recursionDepth, !equal));
    }

    function prettyPrint(bytes memory a)
        internal
    {
        emit log(a.toHexString());
    }

    function _prettyPrint(
        bytes memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat(a.toHexString()), recursionDepth);
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        bytes memory a,
        bytes memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        bool equal = keccak256(a) == keccak256(b);
        comparison.a = comparison.a
            .concat(_prettyPrint(a, prefix, suffix, recursionDepth, !equal));
        comparison.b = comparison.b
            .concat(_prettyPrint(b, prefix, suffix, recursionDepth, !equal));
    }
    
    //////////////////// BEGIN GENERATED ////////////////////

    
    function prettyPrint(DeletionCriterion a)
        internal
    {
        emit log(_prettyPrint(a, "", "", 0, false));
    }

    function assertDeepEq(DeletionCriterion a, DeletionCriterion b)
        internal
    {
        if (a != b) {
            emit log("Error: a == b not satisfied [DeletionCriterion]");
            emit log_named_string("      Left", _prettyPrint(a, "", "", 0, false));
            emit log_named_string("     Right", _prettyPrint(b, "", "", 0, false));
            fail();
        }
    }

    function _prettyPrint(
        DeletionCriterion a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string[2] memory DeletionCriterionStrings = ["Immediately", "Never"];
        string memory str = _tab(
            prefix.concat(DeletionCriterionStrings[uint8(a)]),
            recursionDepth
        );
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        DeletionCriterion a,
        DeletionCriterion b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a
            .concat(_prettyPrint(a, prefix, suffix, recursionDepth, a != b));
        comparison.b = comparison.b
            .concat(_prettyPrint(b, prefix, suffix, recursionDepth, a != b)
        );
    }

    function prettyPrint(ExpirableBlob memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(ExpirableBlob memory a, ExpirableBlob memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [ExpirableBlob]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        ExpirableBlob memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.deletionCriterion, "deletionCriterion: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.blob, "blob: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        ExpirableBlob memory a,
        ExpirableBlob memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.deletionCriterion, b.deletionCriterion, "deletionCriterion: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.blob, b.blob, "blob: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(uint256[2] memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(uint256[2] memory a, uint256[2] memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [uint256[2]]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }
    
    function _prettyPrint(
        uint256[2] memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("[\n"), recursionDepth);
        for (uint256 i = 0; i < a.length; i++) {
            str = str.concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, false));
        }
        str = str.concat(_tab("]", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }
    
    function _comparePrint(
        uint256[2] memory a,
        uint256[2] memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("[\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("[\n"), recursionDepth));
        if (a.length < b.length) {
            for (uint256 i = 0; i < a.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = a.length; i < b.length; i++) {
                comparison.b = comparison.b
                    .concat(_prettyPrint(b[i], "", ",\n", recursionDepth + 1, true));
            }
        } else {
            for (uint256 i = 0; i < b.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = b.length; i < a.length; i++) {
                comparison.a = comparison.a
                    .concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, true));
            }
        } 
        comparison.a = comparison.a.concat(_tab("]", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("]", recursionDepth)).concat(suffix);
    }

    function prettyPrint(ComplianceUnit memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(ComplianceUnit memory a, ComplianceUnit memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [ComplianceUnit]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        ComplianceUnit memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.proof, "proof: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.instance, "instance: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.verifyingKey, "verifyingKey: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        ComplianceUnit memory a,
        ComplianceUnit memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.proof, b.proof, "proof: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.instance, b.instance, "instance: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.verifyingKey, b.verifyingKey, "verifyingKey: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(ComplianceInstance memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(ComplianceInstance memory a, ComplianceInstance memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [ComplianceInstance]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        ComplianceInstance memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.consumed, "consumed: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.created, "created: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.unitDelta, "unitDelta: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        ComplianceInstance memory a,
        ComplianceInstance memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.consumed, b.consumed, "consumed: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.created, b.created, "created: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.unitDelta, b.unitDelta, "unitDelta: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(ConsumedRefs memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(ConsumedRefs memory a, ConsumedRefs memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [ConsumedRefs]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        ConsumedRefs memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.nullifierRef, "nullifierRef: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.rootRef, "rootRef: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.logicRef, "logicRef: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        ConsumedRefs memory a,
        ConsumedRefs memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.nullifierRef, b.nullifierRef, "nullifierRef: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.rootRef, b.rootRef, "rootRef: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.logicRef, b.logicRef, "logicRef: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(CreatedRefs memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(CreatedRefs memory a, CreatedRefs memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [CreatedRefs]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        CreatedRefs memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.commitmentRef, "commitmentRef: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.logicRef, "logicRef: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        CreatedRefs memory a,
        CreatedRefs memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.commitmentRef, b.commitmentRef, "commitmentRef: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.logicRef, b.logicRef, "logicRef: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(bytes32[] memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(bytes32[] memory a, bytes32[] memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [bytes32[]]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }
    
    function _prettyPrint(
        bytes32[] memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("[\n"), recursionDepth);
        for (uint256 i = 0; i < a.length; i++) {
            str = str.concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, false));
        }
        str = str.concat(_tab("]", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }
    
    function _comparePrint(
        bytes32[] memory a,
        bytes32[] memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("[\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("[\n"), recursionDepth));
        if (a.length < b.length) {
            for (uint256 i = 0; i < a.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = a.length; i < b.length; i++) {
                comparison.b = comparison.b
                    .concat(_prettyPrint(b[i], "", ",\n", recursionDepth + 1, true));
            }
        } else {
            for (uint256 i = 0; i < b.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = b.length; i < a.length; i++) {
                comparison.a = comparison.a
                    .concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, true));
            }
        } 
        comparison.a = comparison.a.concat(_tab("]", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("]", recursionDepth)).concat(suffix);
    }

    function prettyPrint(TagLogicProofPair[] memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(TagLogicProofPair[] memory a, TagLogicProofPair[] memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [TagLogicProofPair[]]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }
    
    function _prettyPrint(
        TagLogicProofPair[] memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("[\n"), recursionDepth);
        for (uint256 i = 0; i < a.length; i++) {
            str = str.concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, false));
        }
        str = str.concat(_tab("]", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }
    
    function _comparePrint(
        TagLogicProofPair[] memory a,
        TagLogicProofPair[] memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("[\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("[\n"), recursionDepth));
        if (a.length < b.length) {
            for (uint256 i = 0; i < a.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = a.length; i < b.length; i++) {
                comparison.b = comparison.b
                    .concat(_prettyPrint(b[i], "", ",\n", recursionDepth + 1, true));
            }
        } else {
            for (uint256 i = 0; i < b.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = b.length; i < a.length; i++) {
                comparison.a = comparison.a
                    .concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, true));
            }
        } 
        comparison.a = comparison.a.concat(_tab("]", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("]", recursionDepth)).concat(suffix);
    }

    function prettyPrint(LogicInstance memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(LogicInstance memory a, LogicInstance memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [LogicInstance]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        LogicInstance memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.tag, "tag: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.isConsumed, "isConsumed: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.consumed, "consumed: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.created, "created: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.appDataForTag, "appDataForTag: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        LogicInstance memory a,
        LogicInstance memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.tag, b.tag, "tag: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.isConsumed, b.isConsumed, "isConsumed: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.consumed, b.consumed, "consumed: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.created, b.created, "created: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.appDataForTag, b.appDataForTag, "appDataForTag: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(TagLogicProofPair memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(TagLogicProofPair memory a, TagLogicProofPair memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [TagLogicProofPair]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        TagLogicProofPair memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.tag, "tag: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.pair, "pair: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        TagLogicProofPair memory a,
        TagLogicProofPair memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.tag, b.tag, "tag: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.pair, b.pair, "pair: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(LogicRefProofPair memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(LogicRefProofPair memory a, LogicRefProofPair memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [LogicRefProofPair]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        LogicRefProofPair memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.logicRef, "logicRef: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.proof, "proof: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        LogicRefProofPair memory a,
        LogicRefProofPair memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.logicRef, b.logicRef, "logicRef: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.proof, b.proof, "proof: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(TagAppDataPair[] memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(TagAppDataPair[] memory a, TagAppDataPair[] memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [TagAppDataPair[]]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }
    
    function _prettyPrint(
        TagAppDataPair[] memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("[\n"), recursionDepth);
        for (uint256 i = 0; i < a.length; i++) {
            str = str.concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, false));
        }
        str = str.concat(_tab("]", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }
    
    function _comparePrint(
        TagAppDataPair[] memory a,
        TagAppDataPair[] memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("[\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("[\n"), recursionDepth));
        if (a.length < b.length) {
            for (uint256 i = 0; i < a.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = a.length; i < b.length; i++) {
                comparison.b = comparison.b
                    .concat(_prettyPrint(b[i], "", ",\n", recursionDepth + 1, true));
            }
        } else {
            for (uint256 i = 0; i < b.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = b.length; i < a.length; i++) {
                comparison.a = comparison.a
                    .concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, true));
            }
        } 
        comparison.a = comparison.a.concat(_tab("]", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("]", recursionDepth)).concat(suffix);
    }

    function prettyPrint(TagAppDataPair memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(TagAppDataPair memory a, TagAppDataPair memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [TagAppDataPair]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        TagAppDataPair memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.tag, "tag: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.appData, "appData: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        TagAppDataPair memory a,
        TagAppDataPair memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.tag, b.tag, "tag: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.appData, b.appData, "appData: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(Action[] memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(Action[] memory a, Action[] memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [Action[]]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }
    
    function _prettyPrint(
        Action[] memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("[\n"), recursionDepth);
        for (uint256 i = 0; i < a.length; i++) {
            str = str.concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, false));
        }
        str = str.concat(_tab("]", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }
    
    function _comparePrint(
        Action[] memory a,
        Action[] memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("[\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("[\n"), recursionDepth));
        if (a.length < b.length) {
            for (uint256 i = 0; i < a.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = a.length; i < b.length; i++) {
                comparison.b = comparison.b
                    .concat(_prettyPrint(b[i], "", ",\n", recursionDepth + 1, true));
            }
        } else {
            for (uint256 i = 0; i < b.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = b.length; i < a.length; i++) {
                comparison.a = comparison.a
                    .concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, true));
            }
        } 
        comparison.a = comparison.a.concat(_tab("]", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("]", recursionDepth)).concat(suffix);
    }

    function prettyPrint(ComplianceUnit[] memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(ComplianceUnit[] memory a, ComplianceUnit[] memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [ComplianceUnit[]]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }
    
    function _prettyPrint(
        ComplianceUnit[] memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("[\n"), recursionDepth);
        for (uint256 i = 0; i < a.length; i++) {
            str = str.concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, false));
        }
        str = str.concat(_tab("]", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }
    
    function _comparePrint(
        ComplianceUnit[] memory a,
        ComplianceUnit[] memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("[\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("[\n"), recursionDepth));
        if (a.length < b.length) {
            for (uint256 i = 0; i < a.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = a.length; i < b.length; i++) {
                comparison.b = comparison.b
                    .concat(_prettyPrint(b[i], "", ",\n", recursionDepth + 1, true));
            }
        } else {
            for (uint256 i = 0; i < b.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = b.length; i < a.length; i++) {
                comparison.a = comparison.a
                    .concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, true));
            }
        } 
        comparison.a = comparison.a.concat(_tab("]", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("]", recursionDepth)).concat(suffix);
    }

    function prettyPrint(KindFFICallPair[] memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(KindFFICallPair[] memory a, KindFFICallPair[] memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [KindFFICallPair[]]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }
    
    function _prettyPrint(
        KindFFICallPair[] memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("[\n"), recursionDepth);
        for (uint256 i = 0; i < a.length; i++) {
            str = str.concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, false));
        }
        str = str.concat(_tab("]", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }
    
    function _comparePrint(
        KindFFICallPair[] memory a,
        KindFFICallPair[] memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("[\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("[\n"), recursionDepth));
        if (a.length < b.length) {
            for (uint256 i = 0; i < a.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = a.length; i < b.length; i++) {
                comparison.b = comparison.b
                    .concat(_prettyPrint(b[i], "", ",\n", recursionDepth + 1, true));
            }
        } else {
            for (uint256 i = 0; i < b.length; i++) {
                _comparePrint(a[i], b[i], "", ",\n", recursionDepth + 1, comparison);
            }
            for (uint256 i = b.length; i < a.length; i++) {
                comparison.a = comparison.a
                    .concat(_prettyPrint(a[i], "", ",\n", recursionDepth + 1, true));
            }
        } 
        comparison.a = comparison.a.concat(_tab("]", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("]", recursionDepth)).concat(suffix);
    }

    function prettyPrint(Resource memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(Resource memory a, Resource memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [Resource]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        Resource memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.logicRef, "logicRef: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.labelRef, "labelRef: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.valueRef, "valueRef: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.nullifierKeyCommitment, "nullifierKeyCommitment: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.quantity, "quantity: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.nonce, "nonce: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.randSeed, "randSeed: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.ephemeral, "ephemeral: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        Resource memory a,
        Resource memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.logicRef, b.logicRef, "logicRef: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.labelRef, b.labelRef, "labelRef: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.valueRef, b.valueRef, "valueRef: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.nullifierKeyCommitment, b.nullifierKeyCommitment, "nullifierKeyCommitment: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.quantity, b.quantity, "quantity: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.nonce, b.nonce, "nonce: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.randSeed, b.randSeed, "randSeed: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.ephemeral, b.ephemeral, "ephemeral: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(Transaction memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(Transaction memory a, Transaction memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [Transaction]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        Transaction memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.roots, "roots: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.actions, "actions: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.deltaProof, "deltaProof: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        Transaction memory a,
        Transaction memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.roots, b.roots, "roots: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.actions, b.actions, "actions: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.deltaProof, b.deltaProof, "deltaProof: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(Action memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(Action memory a, Action memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [Action]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        Action memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.commitments, "commitments: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.nullifiers, "nullifiers: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.logicProofs, "logicProofs: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.complianceUnits, "complianceUnits: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.tagAppDataPairs, "tagAppDataPairs: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.kindFFICallPairs, "kindFFICallPairs: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        Action memory a,
        Action memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.commitments, b.commitments, "commitments: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.nullifiers, b.nullifiers, "nullifiers: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.logicProofs, b.logicProofs, "logicProofs: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.complianceUnits, b.complianceUnits, "complianceUnits: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.tagAppDataPairs, b.tagAppDataPairs, "tagAppDataPairs: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.kindFFICallPairs, b.kindFFICallPairs, "kindFFICallPairs: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(KindFFICallPair memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(KindFFICallPair memory a, KindFFICallPair memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [KindFFICallPair]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        KindFFICallPair memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.kind, "kind: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.ffiCall, "ffiCall: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        KindFFICallPair memory a,
        KindFFICallPair memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.kind, b.kind, "kind: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.ffiCall, b.ffiCall, "ffiCall: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    function prettyPrint(FFICall memory a)
        internal
    {
        emit log(_prettyPrint(a, "\n", "", 0, false));
    }

    function assertDeepEq(FFICall memory a, FFICall memory b)
        internal
    {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit log("Error: a == b not satisfied [FFICall]");
            Comparison memory comparison;
            _comparePrint(a, b, "", "", 0, comparison);
            emit log_named_string("\na", comparison.a);
            emit log_named_string("\nb", comparison.b);
            fail();
        }
    }

    function _prettyPrint(
        FFICall memory a,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        bool highlight
    )
        private
        pure
        returns (string memory)
    {
        string memory str = _tab(prefix.concat("{\n"), recursionDepth);
        str = str.concat(_prettyPrint(a.wrapperContract, "wrapperContract: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.input, "input: ", ",\n", recursionDepth + 1, false));
            str = str.concat(_prettyPrint(a.output, "output: ", ",\n", recursionDepth + 1, false));
        str = str.concat(_tab("}", recursionDepth));
        return highlight ? _boldRed(str).concat(suffix) : str.concat(suffix);
    }

    function _comparePrint(
        FFICall memory a,
        FFICall memory b,
        string memory prefix,
        string memory suffix,
        uint256 recursionDepth,
        Comparison memory comparison
    )
        private
        pure
    {
        comparison.a = comparison.a.concat(_tab(prefix.concat("{\n"), recursionDepth));
        comparison.b = comparison.b.concat(_tab(prefix.concat("{\n"), recursionDepth));
        _comparePrint(a.wrapperContract, b.wrapperContract, "wrapperContract: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.input, b.input, "input: ", ",\n", recursionDepth + 1, comparison);
            _comparePrint(a.output, b.output, "output: ", ",\n", recursionDepth + 1, comparison);
        comparison.a = comparison.a.concat(_tab("}", recursionDepth)).concat(suffix);
        comparison.b = comparison.b.concat(_tab("}", recursionDepth)).concat(suffix);
    }

    ///////////////////// END GENERATED /////////////////////
}