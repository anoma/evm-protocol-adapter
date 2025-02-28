// SPDX-License-Identifier: MIT
pragma solidity >=0.8.27;

import { Test } from "forge-std/Test.sol";

import { IRiscZeroVerifier, Receipt as RiscZeroReceipt } from "risc0-ethereum/IRiscZeroVerifier.sol";

import { RiscZeroVerifierRouter } from "risc0-ethereum/RiscZeroVerifierRouter.sol";
import { RiscZeroMockVerifier } from "risc0-ethereum/test/RiscZeroMockVerifier.sol";

import { ComputableComponents } from "../src/libs/ComputableComponents.sol";
import { ProtocolAdapter } from "../src/ProtocolAdapter.sol";
import { ExpirableBlob, DeletionCriterion } from "../src/state/BlobStorage.sol";
import { Transaction, Resource, Action, KindFFICallPair } from "../src/Types.sol";
import { Universal } from "../src/libs/Identities.sol";

import { LogicInstance, TagLogicProofPair, LogicRefProofPair } from "../src/proving/Logic.sol";
import { ComplianceUnit, ComplianceInstance, ConsumedRefs, CreatedRefs } from "../src/proving/Compliance.sol";
import { Delta } from "../src/proving/Delta.sol";

import { AppData, TagAppDataPair } from "../src/libs/AppData.sol";

import { MockRiscZeroProof } from "./MockRiscZeroProof.sol";
import { MockDelta } from "./MockDelta.sol";

import "../lib/DeepTest.sol";

contract ProtocolAdapterTest is DeepTest {
    using ComputableComponents for Resource;
    using AppData for TagAppDataPair[];
    using Delta for uint256[2];

    uint256 internal testNumber;
    ProtocolAdapter internal protocolAdapter;

    uint8 internal constant treeDepth = 2 ^ 8;

    bytes32 internal constant ALWAYS_VALID_LOGIC_REF = bytes32(0);
    bytes32 internal constant EMPTY_BLOB_REF = bytes32(0);

    IRiscZeroVerifier internal constant sepoliaVerifier =
        IRiscZeroVerifier(address(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187));

    RiscZeroMockVerifier mockVerifier = new RiscZeroMockVerifier(MockRiscZeroProof.VERIFIER_SELECTOR);

    function setUp() public {
        protocolAdapter = new ProtocolAdapter({
            _riscZeroVerifier: mockVerifier,
            _logicCircuitID: MockRiscZeroProof.IMAGE_ID_1,
            _complianceCircuitID: MockRiscZeroProof.IMAGE_ID_2,
            _treeDepth: treeDepth
        });
    }

    function test_deep_test() public {
        assertDeepEq(_paddingResource(0), _paddingResource(0));
    }

    function test_verify_empty_tx() public view {
        Resource[] memory consumed;
        Resource[] memory created;
        protocolAdapter.verify(_mockTransaction({ consumed: consumed, created: created }));
    }

    function test_verify_tx() public view {
        (Resource[] memory consumed, Resource[] memory created) = _mockResources();

        protocolAdapter.verify(_mockTransaction({ consumed: consumed, created: created }));
    }

    function test_execute() public {
        (Resource[] memory consumed, Resource[] memory created) = _mockResources();

        protocolAdapter.execute(_mockTransaction({ consumed: consumed, created: created }));
    }

    function _mockResources() internal pure returns (Resource[] memory consumed, Resource[] memory created) {
        created = new Resource[](1);
        created[0] = Resource({
            logicRef: ALWAYS_VALID_LOGIC_REF,
            labelRef: EMPTY_BLOB_REF,
            valueRef: EMPTY_BLOB_REF,
            nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
            quantity: 1,
            nonce: 0,
            randSeed: 0,
            ephemeral: false
        });

        consumed = new Resource[](1);
        consumed[0] = Resource({
            logicRef: ALWAYS_VALID_LOGIC_REF,
            labelRef: EMPTY_BLOB_REF,
            valueRef: EMPTY_BLOB_REF,
            nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
            quantity: 1,
            nonce: 0,
            randSeed: 0,
            ephemeral: true
        });
    }

    function _paddingResource(uint256 nonce) internal pure returns (Resource memory) {
        return Resource({
            logicRef: ALWAYS_VALID_LOGIC_REF,
            labelRef: EMPTY_BLOB_REF,
            valueRef: EMPTY_BLOB_REF,
            nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
            quantity: 0,
            nonce: nonce,
            randSeed: 0,
            ephemeral: true
        });
    }

    function _padResources(
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
                createdPadded[cmCount + i] = _paddingResource(nonce);
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
                consumedPadded[nfCount + i] = _paddingResource(nonce);
            }
        } else {
            consumedPadded = consumed;
            createdPadded = created;
        }
    }

    function _mockTransaction(
        Resource[] memory consumed,
        Resource[] memory created
    )
        internal
        view
        returns (Transaction memory)
    {
        (consumed, created) = _padResources({ consumed: consumed, created: created });

        bytes32[] memory nfs = new bytes32[](consumed.length);
        for (uint256 i = 0; i < consumed.length; ++i) {
            nfs[i] = consumed[i].nullifier(Universal.INTERNAL_IDENTITY);
        }

        bytes32[] memory cms = new bytes32[](created.length);
        for (uint256 i = 0; i < created.length; ++i) {
            cms[i] = created[i].commitment();
        }

        TagAppDataPair[] memory appData = _mockAppData({ nullifiers: nfs, commitments: cms });
        TagLogicProofPair[] memory logicProofs =
            _mockLogicProofs({ nullifiers: nfs, commitments: cms, appData: appData });

        bytes32[] memory roots = new bytes32[](1);
        roots[0] = protocolAdapter.latestRoot();

        ComplianceUnit[] memory complianceUnits =
            _mockComplianceUnits({ root: roots[0], commitments: cms, nullifiers: nfs });

        KindFFICallPair[] memory emptyFfiCalls;

        Action memory action = Action({
            commitments: cms,
            nullifiers: nfs,
            logicProofs: logicProofs,
            complianceUnits: complianceUnits,
            tagAppDataPairs: appData,
            kindFFICallPairs: emptyFfiCalls
        });

        Action[] memory actions = new Action[](1);
        actions[0] = action;

        bytes memory deltaProof = MockDelta.PROOF;

        return Transaction({ roots: roots, actions: actions, deltaProof: deltaProof });
    }

    function _mockAppData(
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

            for (uint256 i = 0; i < nullifiers.length; ++i) {
                appData[i] = TagAppDataPair({
                    tag: nullifiers[i],
                    appData: ExpirableBlob({ deletionCriterion: DeletionCriterion.Immediately, blob: emptyBlob })
                });
            }
            for (uint256 i = 0; i < commitments.length; ++i) {
                appData[nullifiers.length + i] = TagAppDataPair({
                    tag: commitments[i],
                    appData: ExpirableBlob({ deletionCriterion: DeletionCriterion.Immediately, blob: emptyBlob })
                });
            }
        }
    }

    function _mockLogicProofs(
        bytes32[] memory nullifiers,
        bytes32[] memory commitments,
        TagAppDataPair[] memory appData
    )
        internal
        view
        returns (TagLogicProofPair[] memory logicProofs)
    {
        logicProofs = new TagLogicProofPair[](nullifiers.length + commitments.length);

        for (uint256 i = 0; i < nullifiers.length; ++i) {
            bytes32 tag = nullifiers[i];

            LogicInstance memory instance = LogicInstance({
                tag: tag,
                isConsumed: true,
                consumed: nullifiers,
                created: commitments,
                appDataForTag: appData.lookup(tag)
            });

            bytes32 verifyingKey = ALWAYS_VALID_LOGIC_REF;

            RiscZeroReceipt memory receipt = mockVerifier.mockProve({
                imageId: MockRiscZeroProof.IMAGE_ID_1,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            logicProofs[i] = TagLogicProofPair({
                tag: tag,
                pair: LogicRefProofPair({ logicRef: ALWAYS_VALID_LOGIC_REF, proof: receipt.seal })
            });
        }

        for (uint256 i = 0; i < commitments.length; ++i) {
            bytes32 tag = commitments[i];

            LogicInstance memory instance = LogicInstance({
                tag: tag,
                isConsumed: false,
                consumed: nullifiers,
                created: commitments,
                appDataForTag: appData.lookup(tag)
            });

            bytes32 verifyingKey = ALWAYS_VALID_LOGIC_REF;

            RiscZeroReceipt memory receipt = mockVerifier.mockProve({
                imageId: MockRiscZeroProof.IMAGE_ID_1,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            logicProofs[nullifiers.length + i] = TagLogicProofPair({
                tag: tag,
                pair: LogicRefProofPair({ logicRef: ALWAYS_VALID_LOGIC_REF, proof: receipt.seal })
            });
        }
    }

    function _mockComplianceUnits(
        bytes32 root,
        bytes32[] memory nullifiers,
        bytes32[] memory commitments
    )
        internal
        view
        returns (ComplianceUnit[] memory units)
    {
        require(nullifiers.length == commitments.length);

        bytes32 verifyingKey = MockRiscZeroProof.IMAGE_ID_2; // TODO

        units = new ComplianceUnit[](nullifiers.length);

        for (uint256 i = 0; i < nullifiers.length; ++i) {
            ComplianceInstance memory instance = ComplianceInstance({
                consumed: ConsumedRefs({ nullifierRef: nullifiers[i], rootRef: root, logicRef: ALWAYS_VALID_LOGIC_REF }),
                created: CreatedRefs({ commitmentRef: commitments[i], logicRef: ALWAYS_VALID_LOGIC_REF }),
                unitDelta: Delta.zero() // TODO
             });

            RiscZeroReceipt memory receipt = mockVerifier.mockProve({
                imageId: MockRiscZeroProof.IMAGE_ID_2,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            units[i] = ComplianceUnit({ proof: receipt.seal, instance: instance, verifyingKey: verifyingKey });
        }
    }
}
