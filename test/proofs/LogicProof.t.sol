// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ECDSA} from "@openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import {Test, console} from "forge-std/Test.sol";

import {ComputableComponents} from "../../src/libs/ComputableComponents.sol";
import {Delta} from "../../src/proving/Delta.sol";
import {Example} from "../mocks/Example.sol";
import {MockDelta} from "../mocks/MockDelta.sol";

contract LogicProofTest is Test {
    function test_arr_encoding() public pure {
        bytes32[] memory tags = new bytes32[](2);
        tags[0] = Example._CONSUMED_NULLIFIER;
        tags[1] = Example._CREATED_COMMITMENT;

        console.logBytes(abi.encode(tags));
        console.logBytes(abi.encodePacked(tags));
    }

    /*
    
      0x
      00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000002
      81df30066f64e51cfade805b17718be06eb34aeb3839177dc0a26f470de4a5f138507f7ea10368b792c09076b6514dfa3a2d8f809f5a86f62c8b5d7df04f58dd
      // PACKED
      0x
      81df30066f64e51cfade805b17718be06eb34aeb3839177dc0a26f470de4a5f138507f7ea10368b792c09076b6514dfa3a2d8f809f5a86f62c8b5d7df04f58dd
    */
}
