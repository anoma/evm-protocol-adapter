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
        assertEq(uint32(1).toRiscZero(), bytes4(0x01000000));
        assertEq(uint32(16).toRiscZero(), bytes4(0x10000000));
        assertEq(uint32(255).toRiscZero(), bytes4(0xff000000));
    }

    function test_instance_encoding() public pure {
        console.logBytes(Example.logicInstance({isConsumed: true}).convertJournal());
    }

    /*
    0x
    47d140b002864789e014b2dbc222d2bce62a6ef80f0eb1995c758dffb88dbe32
    01000000
    ab82530843896e639200bad250cbef46f7f2fae9115ba14958076768c167e342
    04000000
        3f0000007f000000bf000000ff000000
    
    02000000
        04000000
            1f0000003f0000005f0000007f000000
        00000000
        04000000
            9f000000bf000000df000000ff000000
        01000000

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

    function test_example_logic_proof_consmed() public view {
        LogicProof memory lp = Example.logicProof({isConsumed: true});

        _sepoliaVerifierRouter.verify({
            seal: lp.proof,
            imageId: lp.logicRef,
            journalDigest: lp.instance.toJournalDigest()
        });
    }

    function test_example_logic_proof_created() public view {
        LogicProof memory lp = Example.logicProof({isConsumed: false});

        _sepoliaVerifierRouter.verify({
            seal: lp.proof,
            imageId: lp.logicRef,
            journalDigest: lp.instance.toJournalDigest()
        });
    }
}
