// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Resource } from "../Types.sol";

library Universal {
    // https://www.rfctools.com/ethereum-address-test-tool/

    // 0- Private ECDSA Key:
    // 0000000000000000000000000000000000000000000000000000000000000001
    bytes32 constant internalIdentity = 0x0000000000000000000000000000000000000000000000000000000000000001;

    // 1- Public ECDSA Key:
    // 79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8

    // 2- Keccak-256 hash of 1:
    // c0a6c424ac7157ae408398df7e5f4552091a69125d5dfcb7b8c2659029395bdf
    bytes32 constant externalIdentity = 0xc0a6c424ac7157ae408398df7e5f4552091a69125d5dfcb7b8c2659029395bdf;

    // 3- last 20 bytes of 2:
    // 7e5f4552091a69125d5dfcb7b8c2659029395bdf

    // 4- Keccak-256(tolowercase( value of 3 )):
    // a8aaec6aceafa450816b295770adcd144ce18d630d6ce74288aa4f1569eda4ca

    // 5- ethereum address with checksum:
    // 7E5F4552091A69125d5DfCb7b8C2659029395Bdf

    // 6- add 0x prefix to 5:
    // 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf
    address constant account = 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf;
}

// https://cyphr.me/ed25519_tool/ed.html)

// Private Ed25519 Key:
// 0000000000000000000000000000000000000000000000000000000000000001

// Public Ed25519 Key:
// 4CB5ABF6AD79FBF5ABBCCAFCC269D85CD2651ED4B885B5869F241AEDF0A5BA29

// Seed || Public
// 00000000000000000000000000000000000000000000000000000000000000014CB5ABF6AD79FBF5ABBCCAFCC269D85CD2651ED4B885B5869F241AEDF0A5BA29
