// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {Compliance} from "../../src/proving/Compliance.sol";
import {Delta} from "../../src/proving/Delta.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {Transaction, ResourceForwarderCalldataPair, Action} from "../../src/Types.sol";

import {INITIAL_COMMITMENT_TREE_ROOT} from "../state/CommitmentAccumulator.t.sol";

library MockExamples {
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;
    using Logic for Logic.VerifierInput[];
    using Delta for uint256[2];

    struct ActionConfig {
        uint256 nCUs;
    }

    error NonceZeroNotAllowed();

    function complianceVerifierInput(
        RiscZeroMockVerifier mockVerifier,
        bytes32 consumedNullifier,
        bytes32 commitmentTreeRoot,
        bytes32 consumedLogicRef,
        bytes32 createdCommitment,
        bytes32 createdLogicRef
    ) internal view returns (Compliance.VerifierInput memory unit) {
        Compliance.Instance memory instance = Compliance.Instance({
            consumed: Compliance.ConsumedRefs({
                nullifier: consumedNullifier,
                commitmentTreeRoot: commitmentTreeRoot,
                logicRef: consumedLogicRef
            }),
            created: Compliance.CreatedRefs({commitment: createdCommitment, logicRef: createdLogicRef}),
            unitDeltaX: bytes32(0), // TODO!
            unitDeltaY: bytes32(0) // TODO!
        });

        unit = Compliance.VerifierInput({
            proof: mockVerifier.mockProve({imageId: Compliance._VERIFYING_KEY, journalDigest: instance.toJournalDigest()})
                .seal,
            instance: instance
        });
    }

    function logicVerifierInput(
        RiscZeroMockVerifier mockVerifier,
        bool isConsumed,
        bytes32 tag,
        bytes32 logicRef,
        bytes32 actionTreeRoot
    ) internal view returns (Logic.VerifierInput memory input) {
        Logic.Instance memory instance = Logic.Instance({
            tag: tag,
            isConsumed: isConsumed,
            actionTreeRoot: actionTreeRoot,
            ciphertext: ciphertext(),
            appData: expirableBlobs()
        });

        input = Logic.VerifierInput({
            proof: mockVerifier.mockProve({imageId: logicRef, journalDigest: instance.toJournalDigest()}).seal,
            instance: instance,
            verifyingKey: logicRef
        });
    }

    function createAction(RiscZeroMockVerifier mockVerifier, uint256 nonce, uint256 nCUs)
        internal
        view
        returns (Action memory action)
    {
        if (nonce == 0) revert NonceZeroNotAllowed();

        Logic.VerifierInput[] memory logicVerifierInputs = new Logic.VerifierInput[](2 * nCUs);
        Compliance.VerifierInput[] memory complianceVerifierInputs = new Compliance.VerifierInput[](nCUs);

        bytes32 logicRef = bytes32(type(uint256).max);

        bytes32[] memory actionTags = new bytes32[](2 * nCUs);

        for (uint256 i = 0; i < nCUs; ++i) {
            // solhint-disable-next-line gas-increment-by-one
            bytes32 nullifier = bytes32(uint256(nonce++));
            // solhint-disable-next-line gas-increment-by-one
            bytes32 commitment = bytes32(uint256(nonce++));

            actionTags[i * 2] = nullifier;
            actionTags[i * 2 + 1] = commitment;
        }
        bytes32 actionTreeRoot = MerkleTree.computeRoot(actionTags, 4);

        for (uint256 i = 0; i < nCUs; ++i) {
            logicVerifierInputs[i * 2] = logicVerifierInput({
                mockVerifier: mockVerifier,
                isConsumed: true,
                tag: actionTags[i * 2],
                logicRef: logicRef,
                actionTreeRoot: actionTreeRoot
            });

            logicVerifierInputs[i * 2 + 1] = logicVerifierInput({
                mockVerifier: mockVerifier,
                isConsumed: false,
                tag: actionTags[i * 2 + 1],
                logicRef: logicRef,
                actionTreeRoot: actionTreeRoot
            });

            complianceVerifierInputs[i] = complianceVerifierInput({
                mockVerifier: mockVerifier,
                consumedNullifier: actionTags[i * 2],
                commitmentTreeRoot: INITIAL_COMMITMENT_TREE_ROOT, // TODO!
                consumedLogicRef: logicRef,
                createdCommitment: actionTags[i * 2 + 1],
                createdLogicRef: logicRef
            });
        }

        ResourceForwarderCalldataPair[] memory emptyForwarderCallData = new ResourceForwarderCalldataPair[](0);

        action = Action({
            logicVerifierInputs: logicVerifierInputs,
            complianceVerifierInputs: complianceVerifierInputs,
            resourceCalldataPairs: emptyForwarderCallData
        });
    }

    function transaction(RiscZeroMockVerifier mockVerifier, uint256 nonce, ActionConfig[] memory actionConfigs)
        internal
        view
        returns (Transaction memory txn, uint256 updatedNonce)
    {
        if (nonce == 0) revert NonceZeroNotAllowed();

        uint256 nActions = actionConfigs.length;
        Action[] memory actions = new Action[](nActions);

        updatedNonce = nonce;

        for (uint256 i = 0; i < nActions; ++i) {
            uint256 nCUs = actionConfigs[i].nCUs;

            actions[i] = createAction({mockVerifier: mockVerifier, nonce: updatedNonce, nCUs: nCUs});
            updatedNonce += nCUs * 2;
        }

        txn = Transaction({actions: actions, deltaProof: abi.encode(true)});
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
