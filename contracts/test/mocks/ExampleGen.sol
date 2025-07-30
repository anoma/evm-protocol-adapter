// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {ComputableComponents} from "../../src/libs/ComputableComponents.sol";
import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {Compliance} from "../../src/proving/Compliance.sol";

import {Delta} from "../../src/proving/Delta.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {Transaction, ResourceForwarderCalldataPair, Action, Resource} from "../../src/Types.sol";

import {INITIAL_COMMITMENT_TREE_ROOT} from "../state/CommitmentAccumulator.t.sol";

library ExampleGen {
    using ComputableComponents for Resource;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;
    using Logic for Logic.VerifierInput[];
    using Delta for uint256[2];

    struct ActionConfig {
        uint256 nCUs;
    }

    struct ResourcePosition {
        uint256 actId;
        uint256 cuId;
        bool isConsumed;
    }

    function complianceVerifierInput(
        RiscZeroMockVerifier mockVerifier,
        bytes32 commitmentTreeRoot, // historical root
        Resource memory consumed,
        Resource memory created
    ) internal view returns (Compliance.VerifierInput memory unit) {
        bytes32 nf = consumed.nullifier_({nullifierKey: 0});
        bytes32 cm = created.commitment_();

        bytes32 unitDeltaX;
        bytes32 unitDeltaY;
        unchecked {
            unitDeltaX =
                bytes32(uint256(ComputableComponents.kind(consumed.logicRef, consumed.labelRef)) * consumed.quantity);
            unitDeltaY =
                bytes32(uint256(ComputableComponents.kind(created.logicRef, created.labelRef)) * created.quantity);
        }

        Compliance.Instance memory instance = Compliance.Instance({
            consumed: Compliance.ConsumedRefs({
                nullifier: nf,
                commitmentTreeRoot: commitmentTreeRoot,
                logicRef: consumed.logicRef
            }),
            created: Compliance.CreatedRefs({commitment: cm, logicRef: created.logicRef}),
            unitDeltaX: unitDeltaX,
            unitDeltaY: unitDeltaY
        });

        unit = Compliance.VerifierInput({
            proof: mockVerifier.mockProve({imageId: Compliance._VERIFYING_KEY, journalDigest: instance.toJournalDigest()})
                .seal,
            instance: instance
        });
    }

    function logicVerifierInput(
        RiscZeroMockVerifier mockVerifier,
        bytes32 actionTreeRoot,
        Resource memory resource,
        bool isConsumed
    ) internal view returns (Logic.VerifierInput memory input) {
        Logic.Instance memory instance = Logic.Instance({
            tag: isConsumed ? resource.nullifier_({nullifierKey: 0}) : resource.commitment_(),
            isConsumed: isConsumed,
            actionTreeRoot: actionTreeRoot,
            ciphertext: ciphertext(),
            appData: expirableBlobs()
        });

        input = Logic.VerifierInput({
            proof: mockVerifier.mockProve({imageId: resource.logicRef, journalDigest: instance.toJournalDigest()}).seal,
            instance: instance,
            verifyingKey: resource.logicRef
        });
    }

    function createAction(RiscZeroMockVerifier mockVerifier, uint256 nonce, uint256 nCUs)
        internal
        view
        returns (Action memory action, uint256 updatedNonce)
    {
        updatedNonce = nonce;

        Logic.VerifierInput[] memory logicVerifierInputs = new Logic.VerifierInput[](2 * nCUs);
        Compliance.VerifierInput[] memory complianceVerifierInputs = new Compliance.VerifierInput[](nCUs);

        Resource[] memory resources = new Resource[](2 * nCUs);
        bytes32[] memory actionTreeTags = new bytes32[](2 * nCUs);

        for (uint256 i = 0; i < nCUs; ++i) {
            uint256 index = (i * 2);

            Resource memory consumed =
                ExampleGen.mockResource({nonce: updatedNonce++, logicRef: bytes32(i), quantity: nonce, eph: true});
            resources[index] = consumed;
            actionTreeTags[index] = consumed.nullifier_({nullifierKey: 0});

            Resource memory created =
                ExampleGen.mockResource({nonce: updatedNonce++, logicRef: bytes32(i), quantity: nonce, eph: true});
            resources[index + 1] = created;
            actionTreeTags[index + 1] = created.commitment_();
        }

        bytes32 actionTreeRoot = MerkleTree.computeRoot(actionTreeTags, 4);

        for (uint256 i = 0; i < nCUs; ++i) {
            uint256 index = i * 2;

            logicVerifierInputs[index] = logicVerifierInput({
                mockVerifier: mockVerifier,
                actionTreeRoot: actionTreeRoot,
                resource: resources[index],
                isConsumed: true
            });

            logicVerifierInputs[index + 1] = logicVerifierInput({
                mockVerifier: mockVerifier,
                actionTreeRoot: actionTreeRoot,
                resource: resources[index + 1],
                isConsumed: false
            });

            complianceVerifierInputs[i] = complianceVerifierInput({
                mockVerifier: mockVerifier,
                commitmentTreeRoot: INITIAL_COMMITMENT_TREE_ROOT, // Note: Doesn't really matter since compliance proofs are mocked.
                consumed: resources[index],
                created: resources[index + 1]
            });
        }

        ResourceForwarderCalldataPair[] memory emptyForwarderCallData = new ResourceForwarderCalldataPair[](0);

        action = Action({
            logicVerifierInputs: logicVerifierInputs,
            complianceVerifierInputs: complianceVerifierInputs,
            resourceCalldataPairs: emptyForwarderCallData
        });
    }

    function transaction(RiscZeroMockVerifier mockVerifier, uint256 nonce, ActionConfig[] memory configs)
        internal
        view
        returns (Transaction memory txn, uint256 updatedNonce)
    {
        uint256 nActions = configs.length;
        Action[] memory actions = new Action[](nActions);

        updatedNonce = nonce;

        uint256 counter = 0;
        for (uint256 i = 0; i < nActions; ++i) {
            uint256 nCUs = configs[i].nCUs;

            (actions[i], updatedNonce) = createAction({mockVerifier: mockVerifier, nonce: updatedNonce, nCUs: nCUs});
        }

        bytes32[] memory tags = new bytes32[](updatedNonce - nonce);
        counter = 0;

        for (uint256 i = 0; i < nActions; ++i) {
            uint256 nCUs = actions[i].complianceVerifierInputs.length;

            for (uint256 j = 0; j < nCUs; ++j) {
                tags[counter++] = actions[i].complianceVerifierInputs[j].instance.consumed.nullifier;
                tags[counter++] = actions[i].complianceVerifierInputs[j].instance.created.commitment;
            }
        }

        txn = Transaction({actions: actions, deltaProof: abi.encodePacked(tags)});
    }

    function generateActionConfigs(uint256 nActions, uint256 nCUs)
        internal
        pure
        returns (ActionConfig[] memory configs)
    {
        configs = new ExampleGen.ActionConfig[](nActions);
        for (uint256 i = 0; i < nActions; ++i) {
            configs[i] = ExampleGen.ActionConfig({nCUs: nCUs});
        }
    }

    function mockResource(uint256 nonce, bytes32 logicRef, uint256 quantity, bool eph)
        internal
        pure
        returns (Resource memory mock)
    {
        mock = Resource({
            logicRef: logicRef,
            labelRef: bytes32(0),
            valueRef: bytes32(0),
            nullifierKeyCommitment: bytes32(0),
            quantity: quantity,
            nonce: nonce,
            randSeed: 0,
            ephemeral: eph
        });
    }

    function ciphertext() internal pure returns (bytes memory cipher) {
        cipher = hex"3f0000007f000000bf000000ff000000";
    }

    function expirableBlobs() internal pure returns (Logic.ExpirableBlob[] memory blobs) {
        blobs = new Logic.ExpirableBlob[](2);
        blobs[0] = Logic.ExpirableBlob({
            blob: hex"1f0000003f0000005f0000007f000000",
            deletionCriterion: Logic.DeletionCriterion.Immediately
        });
        blobs[1] = Logic.ExpirableBlob({
            blob: hex"9f000000bf000000df000000ff000000",
            deletionCriterion: Logic.DeletionCriterion.Never
        });
    }
}
