// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, console} from "forge-std/Test.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {LogicProof, LogicInstance, ExpirableBlob, DeletionCriterion} from "../../src/Types.sol";
import {Example} from "../mocks/Example.sol";

contract LogicProofTest is Test {
    using RiscZeroUtils for LogicInstance;
    using RiscZeroUtils for uint32;

    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;
    bytes32 internal _complianceCircuitID;

    function setUp() public {
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";
        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));
    }

    function test_uint32_transform() public pure {
        assertEq(uint32(1).uint32ToRisc0(), bytes4(0x01000000));
        assertEq(uint32(16).uint32ToRisc0(), bytes4(0x10000000));
    }

    function test_example_appdata_encoding() public pure {
        ExpirableBlob[] memory expBlobs = new ExpirableBlob[](3);
        expBlobs[0] = ExpirableBlob({blob: hex"aaaaaaaa", deletionCriterion: DeletionCriterion.Never});
        expBlobs[1] = ExpirableBlob({blob: hex"bbbbbbbbbbbbbbbb", deletionCriterion: DeletionCriterion.Immediately});
        expBlobs[2] =
            ExpirableBlob({blob: hex"cccccccccccccccccccccccccccccccc", deletionCriterion: DeletionCriterion.Never});

        uint256 nBlobs = expBlobs.length;
        bytes memory encoded = abi.encodePacked(uint32(expBlobs.length));

        for (uint256 i = 0; i < nBlobs; ++i) {
            bytes memory blobEncoded =
                abi.encodePacked(uint32(expBlobs[i].blob.length), expBlobs[i].blob, expBlobs[i].deletionCriterion);
            encoded = abi.encodePacked(encoded, blobEncoded);
        }
        // 0x0000000300000004aaaaaaaa0100000008bbbbbbbbbbbbbbbb0000000010cccccccccccccccccccccccccccccccc01
        console.logBytes(encoded);
    }

    function test_instance_encoding() public pure {
        console.logBytes(Example.logicInstance({isConsumed: true}).convertJournal());
    }

    // 4, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 5, 0, 0, 0, 6, 0, 0, 0, 7, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0

    /*

    4, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 5, 0, 0, 0, 6, 0, 0, 0, 7, 0, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0

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

    function test_example_logic_proof() public view {
        {
            LogicProof memory lp = Example.logicProof({isConsumed: true});

            _sepoliaVerifierRouter.verify({
                seal: lp.proof,
                imageId: lp.logicRef,
                journalDigest: lp.instance.toJournalDigest()
            });
        }
        {
            LogicProof memory lp = Example.logicProof({isConsumed: false});

            _sepoliaVerifierRouter.verify({
                seal: lp.proof,
                imageId: lp.logicRef,
                journalDigest: lp.instance.toJournalDigest()
            });
        }
    }
}
