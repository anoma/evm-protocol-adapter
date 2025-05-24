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

    function complianceCircuitID() internal pure returns (bytes32 id) {
        // /Users/michaelheuer/Projects/Anoma/aarm-risc0/target/debug/build/compliance-methods-5cb536499c35ce55/out/methods.rs
        // pub const COMPLIANCE_GUEST_ID: [u32; 8] = [3090118071, 2046858913, 4187123841, 1403752873, 1328899817, 1064955823, 809758477, 955615332];
        /*
        id = bytes32(
            abi.encodePacked(
                uint32(3090118071),
                uint32(2046858913),
                uint32(4187123841),
                uint32(1403752873),
                uint32(1328899817),
                uint32(1064955823),
                uint32(809758477),
                uint32(955615332)
            )
        ); // 0xb82f75b77a0096a1f992708153ab91a94f3566e93f79efaf3043ef0d38f58864
        */

        // /Users/michaelheuer/Projects/Anoma/evm-protocol-adapter/bindings/target/debug/build/compliance-methods-51e9697bae8b4140/out/methods.rs
        // [2042205920, 594384590, 401169715, 3848800549, 2343010086, 3791765588, 2592415277, 176323215]
        id = bytes32(
            abi.encodePacked(
                uint32(2042205920),
                uint32(594384590),
                uint32(401169715),
                uint32(3848800549),
                uint32(2343010086),
                uint32(3791765588),
                uint32(2592415277),
                uint32(176323215)
            )
        ); // 0x79b996e0236d96ce17e95d33e56809258ba77f26e201c0549a851e2d0a827a8f
    }

    function convertJournal(LogicInstance memory instance) internal pure returns (bytes memory converted) {
        uint32 nCiphertext = uint32(instance.ciphertext.length);
        bytes memory encodedCipher =
            abi.encodePacked(toRiscZero(nCiphertext / 4 /* NOTE: IMPORTANT divde by 4 ? /4*/ ), instance.ciphertext);

        uint32 nBlobs = uint32(instance.appData.length);
        bytes memory encodedAppData = abi.encodePacked(toRiscZero(nBlobs));
        {
            for (uint256 i = 0; i < nBlobs; ++i) {
                bytes memory blobEncoded = abi.encodePacked(
                    toRiscZero(uint32(instance.appData[i].blob.length / 4 /* IMPORTANT divde by 4 ? /4*/ )),
                    instance.appData[i].blob,
                    toRiscZero(uint32(instance.appData[i].deletionCriterion))
                );
                encodedAppData = abi.encodePacked(encodedAppData, blobEncoded);
            }
        }

        converted = abi.encodePacked(
            instance.tag, toRiscZero(instance.isConsumed), instance.actionTreeRoot, encodedCipher, encodedAppData
        );

        /*
        0x
        be9a265315ceda7486e778e31b1f50d25382f9468ca7bf768ce3072b49e524fd
        01000000
        9e13e5091a5ac3ea740beec4094a42bb1f5588477a6d3d79233e9701afb8ccf9
        // Ciphers
        02000000 // nCiphers = 2
        00000000000000000000000000000000
        ff000000ff000000ff000000ff000000

        // AppData
        0x
        02000000 // nBlobs = 2
        04000000 // Blob 1 Length = 4
        00000000000000000000000000000000
        00000000 // Del Crit 1
        04000000 // Blob 2 Length = 4
        ff000000ff000000ff000000ff000000 // Blob 2
        01000000 // Del Crit 2
        */

        /*
        4, 0, 0, 0, 
        1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 
        2, 0, 0, 0, 
        4, 0, 0, 0, 
        1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 
        0, 0, 0, 0, 
        4, 0, 0, 0, 
        5, 0, 0, 0, 6, 0, 0, 0, 7, 0, 0, 0, 8, 0, 0, 0, 
        1, 0, 0, 0

        cipher: vec![1, 2, 3, 4],
            app_data: vec![
                ExpirableBlob {
                    blob: vec![1, 2, 3, 4],
                    deletion_criterion: 0,
                },
                ExpirableBlob {
                    blob: vec![5, 6, 7, 8],
                    deletion_criterion: 1,
                },
            ],

       */
    }

    function toRiscZero(bool value) internal pure returns (bytes4 converted) {
        converted = value ? bytes4(0x01000000) : bytes4(0x00000000);
    }

    function toRiscZero(uint32 value) public pure returns (bytes4 converted) {
        converted = bytes4(
            ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8) | ((value & 0x00FF0000) >> 8)
                | ((value & 0xFF000000) >> 24)
        );
    }
}
