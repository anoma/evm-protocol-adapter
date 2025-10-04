// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {Logic} from "../../src/libs/proving/Logic.sol";
import {RiscZeroUtils} from "../../src/libs/utils/RiscZeroUtils.sol";
import {TransactionExample} from "../examples/transactions/Transaction.e.sol";
import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

contract LogicProofTest is Test {
    using Logic for Logic.VerifierInput;
    using RiscZeroUtils for Logic.Instance;

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;

    function setUp() public {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run();
    }

    function test_verify_example_logic_proof_consumed() public view {
        Logic.VerifierInput memory input = TransactionExample.logicVerifierInput({isConsumed: true});
        bytes32 root = TransactionExample.commitmentTreeRoot();
        _router.verify({
            seal: input.proof,
            imageId: input.verifyingKey,
            journalDigest: sha256(input.toInstance(root, true).toJournal())
        });
    }

    function test_verify_example_logic_proof_created() public view {
        Logic.VerifierInput memory input = TransactionExample.logicVerifierInput({isConsumed: false});
        bytes32 root = TransactionExample.commitmentTreeRoot();
        _router.verify({
            seal: input.proof,
            imageId: input.verifyingKey,
            journalDigest: sha256(input.toInstance(root, false).toJournal())
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
