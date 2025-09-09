// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";

import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {Compliance} from "../../src/proving/Compliance.sol";

import {Delta} from "../../src/proving/Delta.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {Transaction, Action, Resource} from "../../src/Types.sol";

library TxGen {
    using MerkleTree for bytes32[];
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.VerifierInput;
    using Logic for Logic.VerifierInput[];
    using Delta for uint256[2];

    struct ActionConfig {
        uint256 nCUs;
    }

    struct ResourceAndAppData {
        Resource resource;
        Logic.AppData appData;
    }

    struct ResourceLists {
        ResourceAndAppData[] consumed;
        ResourceAndAppData[] created;
    }

    error ConsumedCreatedCountMismatch(uint256 nConsumed, uint256 nCreated);

    function complianceVerifierInput(
        RiscZeroMockVerifier mockVerifier,
        bytes32 commitmentTreeRoot, // historical root
        Resource memory consumed,
        Resource memory created
    ) internal view returns (Compliance.VerifierInput memory unit) {
        bytes32 nf = nullifier(consumed, 0);
        bytes32 cm = commitment(created);

        bytes32 unitDeltaX;
        bytes32 unitDeltaY;
        unchecked {
            unitDeltaX = bytes32(uint256(sha256(abi.encode(consumed.logicRef, consumed.labelRef))) * consumed.quantity);
            unitDeltaY = bytes32(uint256(sha256(abi.encode(created.logicRef, created.labelRef))) * created.quantity);
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
        bool isConsumed,
        Logic.AppData memory appData
    ) internal view returns (Logic.VerifierInput memory input) {
        input = Logic.VerifierInput({
            tag: isConsumed ? nullifier(resource, 0) : commitment(resource),
            verifyingKey: resource.logicRef,
            appData: appData,
            proof: ""
        });

        input.proof = mockVerifier.mockProve({
            imageId: resource.logicRef,
            journalDigest: input.toJournalDigest(actionTreeRoot, isConsumed)
        }).seal;
    }

    function createAction(
        RiscZeroMockVerifier mockVerifier,
        ResourceAndAppData[] memory consumed,
        ResourceAndAppData[] memory created
    ) internal view returns (Action memory action) {
        if (consumed.length != created.length) {
            revert ConsumedCreatedCountMismatch({nConsumed: consumed.length, nCreated: created.length});
        }
        uint256 nCUs = consumed.length;

        Logic.VerifierInput[] memory logicVerifierInputs = new Logic.VerifierInput[](2 * nCUs);
        Compliance.VerifierInput[] memory complianceVerifierInputs = new Compliance.VerifierInput[](nCUs);

        bytes32[] memory actionTreeTags = new bytes32[](2 * nCUs);
        for (uint256 i = 0; i < nCUs; ++i) {
            uint256 index = (i * 2);

            actionTreeTags[index] = nullifier(consumed[i].resource, 0);
            actionTreeTags[index + 1] = commitment(created[i].resource);
        }

        bytes32 actionTreeRoot = actionTreeTags.computeRoot();

        for (uint256 i = 0; i < nCUs; ++i) {
            uint256 index = i * 2;

            logicVerifierInputs[index] = logicVerifierInput({
                mockVerifier: mockVerifier,
                actionTreeRoot: actionTreeRoot,
                resource: consumed[i].resource,
                isConsumed: true,
                appData: consumed[i].appData
            });

            logicVerifierInputs[index + 1] = logicVerifierInput({
                mockVerifier: mockVerifier,
                actionTreeRoot: actionTreeRoot,
                resource: created[i].resource,
                isConsumed: false,
                appData: created[i].appData
            });

            complianceVerifierInputs[i] = complianceVerifierInput({
                mockVerifier: mockVerifier,
                commitmentTreeRoot: initialRoot(),
                consumed: consumed[i].resource,
                created: created[i].resource
            });
        }
        action = Action({logicVerifierInputs: logicVerifierInputs, complianceVerifierInputs: complianceVerifierInputs});
    }

    function createDefaultAction(RiscZeroMockVerifier mockVerifier, bytes32 nonce, uint256 nCUs)
        internal
        view
        returns (Action memory action, bytes32 updatedNonce)
    {
        updatedNonce = nonce;

        ResourceAndAppData[] memory consumed = new ResourceAndAppData[](nCUs);
        ResourceAndAppData[] memory created = new ResourceAndAppData[](nCUs);

        for (uint256 i = 0; i < nCUs; ++i) {
            consumed[i] = ResourceAndAppData({
                resource: TxGen.mockResource({
                    nonce: updatedNonce,
                    logicRef: bytes32(i),
                    labelRef: bytes32(i),
                    quantity: uint128(1 + uint256(nonce))
                }),
                appData: Logic.AppData({
                    discoveryPayload: new Logic.ExpirableBlob[](0),
                    resourcePayload: new Logic.ExpirableBlob[](0),
                    externalPayload: new Logic.ExpirableBlob[](0),
                    applicationPayload: new Logic.ExpirableBlob[](0)
                })
            });
            updatedNonce = bytes32(uint256(updatedNonce) + 1);
            created[i] = ResourceAndAppData({
                resource: TxGen.mockResource({
                    nonce: updatedNonce,
                    logicRef: bytes32(i),
                    labelRef: bytes32(i),
                    quantity: uint128(1 + uint256(nonce))
                }),
                appData: Logic.AppData({
                    discoveryPayload: new Logic.ExpirableBlob[](0),
                    resourcePayload: new Logic.ExpirableBlob[](0),
                    externalPayload: new Logic.ExpirableBlob[](0),
                    applicationPayload: new Logic.ExpirableBlob[](0)
                })
            });
            updatedNonce = bytes32(uint256(updatedNonce) + 1);
        }

        action = createAction({mockVerifier: mockVerifier, consumed: consumed, created: created});
    }

    function transaction(RiscZeroMockVerifier mockVerifier, ResourceLists[] memory actionResources)
        internal
        view
        returns (Transaction memory txn)
    {
        Action[] memory actions = new Action[](actionResources.length);

        for (uint256 i = 0; i < actionResources.length; ++i) {
            if (actionResources[i].consumed.length != actionResources[i].created.length) {
                revert ConsumedCreatedCountMismatch(
                    actionResources[i].consumed.length, actionResources[i].created.length
                );
            }

            actions[i] = createAction({
                mockVerifier: mockVerifier,
                consumed: actionResources[i].consumed,
                created: actionResources[i].created
            });
        }

        txn = Transaction({actions: actions, deltaProof: abi.encodePacked(collectTags(actions))});
    }

    function transaction(RiscZeroMockVerifier mockVerifier, bytes32 nonce, ActionConfig[] memory configs)
        internal
        view
        returns (Transaction memory txn, bytes32 updatedNonce)
    {
        updatedNonce = nonce;

        Action[] memory actions = new Action[](configs.length);
        for (uint256 i = 0; i < configs.length; ++i) {
            (actions[i], updatedNonce) =
                createDefaultAction({mockVerifier: mockVerifier, nonce: updatedNonce, nCUs: configs[i].nCUs});
        }

        txn = Transaction({actions: actions, deltaProof: abi.encodePacked(collectTags(actions))});
    }

    function generateActionConfigs(uint256 nActions, uint256 nCUs)
        internal
        pure
        returns (ActionConfig[] memory configs)
    {
        configs = new TxGen.ActionConfig[](nActions);
        for (uint256 i = 0; i < nActions; ++i) {
            configs[i] = TxGen.ActionConfig({nCUs: nCUs});
        }
    }

    function countComplianceUnits(Action[] memory actions) internal pure returns (uint256 nCUs) {
        nCUs = 0;

        for (uint256 i = 0; i < actions.length; ++i) {
            nCUs += actions[i].complianceVerifierInputs.length;
        }
    }

    function collectTags(Action[] memory actions) internal pure returns (bytes32[] memory tags) {
        tags = new bytes32[](countComplianceUnits(actions) * 2);

        uint256 n = 0;
        for (uint256 i = 0; i < actions.length; ++i) {
            uint256 nCUs = actions[i].complianceVerifierInputs.length;

            for (uint256 j = 0; j < nCUs; ++j) {
                tags[n++] = actions[i].complianceVerifierInputs[j].instance.consumed.nullifier;
                tags[n++] = actions[i].complianceVerifierInputs[j].instance.created.commitment;
            }
        }
    }

    function mockResource(bytes32 nonce, bytes32 logicRef, bytes32 labelRef, uint128 quantity)
        internal
        pure
        returns (Resource memory mock)
    {
        mock = Resource({
            logicRef: logicRef,
            labelRef: labelRef,
            valueRef: bytes32(0),
            nullifierKeyCommitment: bytes32(0),
            quantity: quantity,
            nonce: nonce,
            randSeed: 0,
            ephemeral: true
        });
    }

    function commitment(Resource memory resource) internal pure returns (bytes32 hash) {
        hash = sha256(abi.encode(resource));
    }

    function nullifier(Resource memory resource, bytes32 nullifierKey) internal pure returns (bytes32 hash) {
        hash = sha256(abi.encode(resource, nullifierKey));
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

    function initialRoot() internal pure returns (bytes32 root) {
        root = SHA256.EMPTY_HASH;
    }
}
