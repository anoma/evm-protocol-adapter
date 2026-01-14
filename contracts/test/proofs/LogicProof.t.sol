// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, Vm} from "forge-std-1.14.0/src/Test.sol";
import {
    RiscZeroVerifierEmergencyStop
} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierRouter.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {Logic} from "../../src/libs/proving/Logic.sol";
import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {Transaction} from "../../src/Types.sol";

import {Parsing} from "../libs/Parsing.sol";
import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

contract LogicProofTest is Test {
    using Parsing for Vm;
    using MerkleTree for bytes32[];
    using Logic for Logic.VerifierInput;
    using RiscZeroUtils for Logic.Instance;

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;

    Transaction internal _exampleTx;

    bytes32 internal _actionTreeRoot;

    function setUp() public {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run({admin: msg.sender, guardian: msg.sender});

        _exampleTx = vm.parseTransaction("test/examples/transactions/test_tx_reg_01_01.bin");

        {
            bytes32[] memory leaves = new bytes32[](2);
            leaves[0] = _exampleTx.actions[0].logicVerifierInputs[0].tag; // Nullifier of consumed resource
            leaves[1] = _exampleTx.actions[0].logicVerifierInputs[1].tag; // Commitment of consumed resource

            _actionTreeRoot = leaves.computeRoot();
        }
    }

    function test_verify_example_logic_proof_consumed() public view {
        Logic.VerifierInput memory input = _exampleTx.actions[0].logicVerifierInputs[0];
        _router.verify({
            seal: input.proof,
            imageId: input.verifyingKey,
            journalDigest: sha256(input.toInstance(_actionTreeRoot, true).toJournal())
        });
    }

    function test_verify_example_logic_proof_created() public view {
        Logic.VerifierInput memory input = _exampleTx.actions[0].logicVerifierInputs[1];
        _router.verify({
            seal: input.proof,
            imageId: input.verifyingKey,
            journalDigest: sha256(input.toInstance(_actionTreeRoot, false).toJournal())
        });
    }

    function testFuzz_different_empty_payloads_produce_different_digest(
        bytes32 root,
        bool consumed,
        bytes memory payload
    ) public pure {
        Logic.VerifierInput memory input;
        Logic.ExpirableBlob memory blob = Logic.ExpirableBlob(Logic.DeletionCriterion.Never, payload);

        Logic.ExpirableBlob[] memory payloadList = new Logic.ExpirableBlob[](1);
        payloadList[0] = blob;

        // Generate digest where only resource payload is filled.
        input.appData.resourcePayload = payloadList;
        bytes32 resourcePayloadDigest = sha256(input.toInstance(root, consumed).toJournal());
        assertEq(input.appData.resourcePayload.length, 1);
        assertEq(input.appData.discoveryPayload.length, 0);
        assertEq(input.appData.externalPayload.length, 0);
        assertEq(input.appData.applicationPayload.length, 0);
        input.appData.resourcePayload = new Logic.ExpirableBlob[](0);

        // Generate digest where only discovery payload is filled.
        input.appData.discoveryPayload = payloadList;
        bytes32 discoveryPayloadDigest = sha256(input.toInstance(root, consumed).toJournal());
        assertEq(input.appData.resourcePayload.length, 0);
        assertEq(input.appData.discoveryPayload.length, 1);
        assertEq(input.appData.externalPayload.length, 0);
        assertEq(input.appData.applicationPayload.length, 0);
        input.appData.discoveryPayload = new Logic.ExpirableBlob[](0);

        // Generate digest where only external payload is filled.
        input.appData.externalPayload = payloadList;
        bytes32 externalPayloadDigest = sha256(input.toInstance(root, consumed).toJournal());
        assertEq(input.appData.resourcePayload.length, 0);
        assertEq(input.appData.discoveryPayload.length, 0);
        assertEq(input.appData.externalPayload.length, 1);
        assertEq(input.appData.applicationPayload.length, 0);
        input.appData.externalPayload = new Logic.ExpirableBlob[](0);

        // Generate digest where only application payload is filled.
        input.appData.applicationPayload = payloadList;
        bytes32 applicationPayloadDigest = sha256(input.toInstance(root, consumed).toJournal());
        assertEq(input.appData.resourcePayload.length, 0);
        assertEq(input.appData.discoveryPayload.length, 0);
        assertEq(input.appData.externalPayload.length, 0);
        assertEq(input.appData.applicationPayload.length, 1);

        // Assert that all four produce different digests.
        assert(resourcePayloadDigest != discoveryPayloadDigest);
        assert(resourcePayloadDigest != externalPayloadDigest);
        assert(resourcePayloadDigest != applicationPayloadDigest);

        assert(discoveryPayloadDigest != externalPayloadDigest);
        assert(discoveryPayloadDigest != applicationPayloadDigest);

        assert(externalPayloadDigest != applicationPayloadDigest);
    }
}
