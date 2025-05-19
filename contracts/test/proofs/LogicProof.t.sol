// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {LogicProof, LogicInstance} from "../../src/Types.sol";
import {Example} from "../mocks/Example.sol";

contract LogicProofTest is Test {
    using RiscZeroUtils for LogicInstance;

    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;
    bytes32 internal _complianceCircuitID;

    function setUp() public {
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";
        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));
    }

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
