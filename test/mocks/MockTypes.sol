// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Receipt as RiscZeroReceipt } from "@risc0-ethereum/IRiscZeroVerifier.sol";
import { RiscZeroMockVerifier } from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import { AppData, TagAppDataPair } from "../../src/libs/AppData.sol";
import { ComputableComponents } from "../../src/libs/ComputableComponents.sol";
import { Universal } from "../../src/libs/Identities.sol";

import { ComplianceUnit, ComplianceInstance, ConsumedRefs, CreatedRefs } from "../../src/proving/Compliance.sol";
import { Delta } from "../../src/proving/Delta.sol";
import { LogicInstance, TagLogicProofPair, LogicRefProofPair } from "../../src/proving/Logic.sol";

import { ExpirableBlob, DeletionCriterion } from "../../src/state/BlobStorage.sol";
import { Action, KindFFICallPair, Resource, Transaction } from "../../src/Types.sol";

import { MockDelta } from "../mocks/MockDelta.sol";
import { MockRiscZeroProof } from "../mocks/MockRiscZeroProof.sol";

library MockTypes {
    using ComputableComponents for Resource;
    using AppData for TagAppDataPair[];
    using Delta for uint256[2];

    bytes32 internal constant _ALWAYS_VALID_LOGIC_REF = bytes32(0);
    bytes32 internal constant _EMPTY_BLOB_REF = bytes32(0);

    error SevereError();

    function mockTransaction(
        RiscZeroMockVerifier mockVerifier,
        bytes32 root,
        Resource[] memory consumed,
        Resource[] memory created
    )
        internal
        view
        returns (Transaction memory transaction)
    {
        bytes32[] memory roots = new bytes32[](1);
        roots[0] = root;

        (consumed, created) = padResources({ consumed: consumed, created: created });

        if (consumed.length != created.length) revert SevereError();

        uint256 chunkSize = 5;
        uint256 nChunks = consumed.length / chunkSize;
        uint256 remainder = consumed.length % chunkSize;

        uint256 nActions = nChunks + (remainder != 0 ? 1 : 0);
        Action[] memory actions = new Action[](nActions);

        bytes32[] memory nfs;
        bytes32[] memory cms;

        for (uint256 a = 0; a < nActions; ++a) {
            if (a < nChunks) {
                nfs = new bytes32[](chunkSize);
                for (uint256 i = 0; i < chunkSize; ++i) {
                    nfs[i] = consumed[a * chunkSize + i].nullifier(Universal.INTERNAL_IDENTITY);
                }
            } else if (remainder != 0) {
                nfs = new bytes32[](remainder);
                for (uint256 i = 0; i < remainder; ++i) {
                    nfs[i] = consumed[a * chunkSize + i].nullifier(Universal.INTERNAL_IDENTITY);
                }
            }

            if (a < nChunks) {
                cms = new bytes32[](chunkSize);
                for (uint256 i = 0; i < chunkSize; ++i) {
                    cms[i] = created[a * chunkSize + i].commitment();
                }
            } else if (remainder != 0) {
                cms = new bytes32[](remainder);
                for (uint256 i = 0; i < remainder; ++i) {
                    cms[i] = created[a * chunkSize + i].commitment();
                }
            }

            TagAppDataPair[] memory appData = mockAppData({ nullifiers: nfs, commitments: cms });
            TagLogicProofPair[] memory rlProofs =
                _mockLogicProofs({ mockVerifier: mockVerifier, nullifiers: nfs, commitments: cms, appData: appData });

            ComplianceUnit[] memory complianceUnits =
                mockComplianceUnits({ mockVerifier: mockVerifier, root: roots[0], commitments: cms, nullifiers: nfs });

            KindFFICallPair[] memory emptyFfiCalls;

            actions[a] = Action({
                commitments: cms,
                nullifiers: nfs,
                logicProofs: rlProofs,
                complianceUnits: complianceUnits,
                tagAppDataPairs: appData,
                kindFFICallPairs: emptyFfiCalls
            });
        }

        bytes memory deltaProof = MockDelta.PROOF;

        transaction = Transaction({ roots: roots, actions: actions, deltaProof: deltaProof });
    }

    // solhint-disable-next-line function-max-lines
    function _mockLogicProofs(
        RiscZeroMockVerifier mockVerifier,
        bytes32[] memory nullifiers,
        bytes32[] memory commitments,
        TagAppDataPair[] memory appData
    )
        internal
        view
        returns (TagLogicProofPair[] memory logicProofs)
    {
        logicProofs = new TagLogicProofPair[](nullifiers.length + commitments.length);

        uint256 len = nullifiers.length;
        for (uint256 i = 0; i < len; ++i) {
            bytes32 tag = nullifiers[i];

            LogicInstance memory instance = LogicInstance({
                tag: tag,
                isConsumed: true,
                consumed: nullifiers,
                created: commitments,
                appDataForTag: appData.lookup(tag)
            });

            bytes32 verifyingKey = _ALWAYS_VALID_LOGIC_REF;

            RiscZeroReceipt memory receipt = mockVerifier.mockProve({
                imageId: MockRiscZeroProof.IMAGE_ID_1,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            logicProofs[i] = TagLogicProofPair({
                tag: tag,
                pair: LogicRefProofPair({ logicRef: _ALWAYS_VALID_LOGIC_REF, proof: receipt.seal })
            });
        }

        len = commitments.length;
        for (uint256 i = 0; i < len; ++i) {
            bytes32 tag = commitments[i];

            LogicInstance memory instance = LogicInstance({
                tag: tag,
                isConsumed: false,
                consumed: nullifiers,
                created: commitments,
                appDataForTag: appData.lookup(tag)
            });

            bytes32 verifyingKey = _ALWAYS_VALID_LOGIC_REF;

            RiscZeroReceipt memory receipt = mockVerifier.mockProve({
                imageId: MockRiscZeroProof.IMAGE_ID_1,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            logicProofs[nullifiers.length + i] = TagLogicProofPair({
                tag: tag,
                pair: LogicRefProofPair({ logicRef: _ALWAYS_VALID_LOGIC_REF, proof: receipt.seal })
            });
        }
    }

    function mockComplianceUnits(
        RiscZeroMockVerifier mockVerifier,
        bytes32 root,
        bytes32[] memory nullifiers,
        bytes32[] memory commitments
    )
        internal
        view
        returns (ComplianceUnit[] memory units)
    {
        if (nullifiers.length != commitments.length) revert SevereError();

        bytes32 verifyingKey = MockRiscZeroProof.IMAGE_ID_2; // TODO

        uint256 nUnits = nullifiers.length;
        units = new ComplianceUnit[](nUnits);

        for (uint256 i = 0; i < nUnits; ++i) {
            ComplianceInstance memory instance = ComplianceInstance({
                consumed: ConsumedRefs({ nullifierRef: nullifiers[i], rootRef: root, logicRef: _ALWAYS_VALID_LOGIC_REF }),
                created: CreatedRefs({ commitmentRef: commitments[i], logicRef: _ALWAYS_VALID_LOGIC_REF }),
                unitDelta: Delta.zero() // TODO
             });

            RiscZeroReceipt memory receipt = mockVerifier.mockProve({
                imageId: MockRiscZeroProof.IMAGE_ID_2,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            units[i] = ComplianceUnit({ proof: receipt.seal, instance: instance, verifyingKey: verifyingKey });
        }
    }

    function mockResources(
        uint16 nConsumed,
        bool ephConsumed,
        uint16 nCreated,
        bool ephCreated,
        uint256 seed
    )
        internal
        pure
        returns (Resource[] memory consumed, Resource[] memory created)
    {
        consumed = new Resource[](nConsumed);
        for (uint256 i = 0; i < nConsumed; ++i) {
            consumed[i] = Resource({
                logicRef: _ALWAYS_VALID_LOGIC_REF,
                labelRef: _EMPTY_BLOB_REF,
                valueRef: _EMPTY_BLOB_REF,
                nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
                quantity: 1,
                nonce: uint256(keccak256(abi.encodePacked(seed, i))),
                randSeed: 0,
                ephemeral: ephConsumed
            });
        }

        created = new Resource[](nCreated);
        for (uint256 i = 0; i < nCreated; ++i) {
            created[i] = Resource({
                logicRef: _ALWAYS_VALID_LOGIC_REF,
                labelRef: _EMPTY_BLOB_REF,
                valueRef: _EMPTY_BLOB_REF,
                nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
                quantity: 1,
                nonce: uint256(keccak256(abi.encodePacked(i, seed))),
                randSeed: 0,
                ephemeral: ephCreated
            });
        }
    }

    function mockAppData(
        bytes32[] memory nullifiers,
        bytes32[] memory commitments
    )
        internal
        pure
        returns (TagAppDataPair[] memory appData)
    {
        appData = new TagAppDataPair[](nullifiers.length + commitments.length);
        {
            bytes memory emptyBlob = bytes("");

            uint256 len = nullifiers.length;
            for (uint256 i = 0; i < len; ++i) {
                appData[i] = TagAppDataPair({
                    tag: nullifiers[i],
                    appData: ExpirableBlob({ deletionCriterion: DeletionCriterion.Immediately, blob: emptyBlob })
                });
            }
            len = commitments.length;
            for (uint256 i = 0; i < len; ++i) {
                appData[nullifiers.length + i] = TagAppDataPair({
                    tag: commitments[i],
                    appData: ExpirableBlob({ deletionCriterion: DeletionCriterion.Immediately, blob: emptyBlob })
                });
            }
        }
    }

    function paddingResource(uint256 nonce) internal pure returns (Resource memory r) {
        r = Resource({
            logicRef: _ALWAYS_VALID_LOGIC_REF,
            labelRef: _EMPTY_BLOB_REF,
            valueRef: _EMPTY_BLOB_REF,
            nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
            quantity: 0,
            nonce: nonce,
            randSeed: 0,
            ephemeral: true
        });
    }

    function padResources(
        Resource[] memory consumed,
        Resource[] memory created
    )
        internal
        pure
        returns (Resource[] memory consumedPadded, Resource[] memory createdPadded)
    {
        uint256 nfCount = consumed.length;
        uint256 cmCount = created.length;

        uint256 diff = 0;

        if (nfCount > cmCount) {
            consumedPadded = consumed;
            createdPadded = new Resource[](nfCount);

            for (uint256 i = 0; i < cmCount; ++i) {
                createdPadded[i] = created[i];
            }

            // Pad created resources
            diff = nfCount - cmCount;
            for (uint256 i = 0; i < diff; ++i) {
                // Use the commitment as a nonce.
                uint256 nonce = uint256(keccak256(abi.encode(created[i])));
                createdPadded[cmCount + i] = paddingResource(nonce);
            }
        } else if (nfCount < cmCount) {
            createdPadded = created;
            consumedPadded = new Resource[](cmCount);

            for (uint256 i = 0; i < nfCount; ++i) {
                consumedPadded[i] = consumed[i];
            }

            // Pad consumed resources
            diff = cmCount - nfCount;
            for (uint256 i = 0; i < diff; ++i) {
                // Use the commitment as a nonce.
                uint256 nonce = uint256(keccak256(abi.encode(consumed[i])));
                consumedPadded[nfCount + i] = paddingResource(nonce);
            }
        } else {
            consumedPadded = consumed;
            createdPadded = created;
        }
    }
}
