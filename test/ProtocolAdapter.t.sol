// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IRiscZeroVerifier, Receipt as RiscZeroReceipt } from "@risc0-ethereum/IRiscZeroVerifier.sol";
import { RiscZeroMockVerifier } from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import { DeepTest } from "./../lib/DeepTest.sol";
import { AppData, TagAppDataPair } from "./../src/libs/AppData.sol";
import { ComputableComponents } from "./../src/libs/ComputableComponents.sol";
import { Universal } from "./../src/libs/Identities.sol";
import { ProtocolAdapter } from "./../src/ProtocolAdapter.sol";

import { ComplianceUnit, ComplianceInstance, ConsumedRefs, CreatedRefs } from "./../src/proving/Compliance.sol";
import { Delta } from "./../src/proving/Delta.sol";
import { LogicInstance, TagLogicProofPair, LogicRefProofPair } from "./../src/proving/Logic.sol";

import { ExpirableBlob, DeletionCriterion } from "./../src/state/BlobStorage.sol";
import { Action, KindFFICallPair, Resource, Transaction } from "./../src/Types.sol";

import { MockDelta } from "./mocks/MockDelta.sol";
import { MockRiscZeroProof } from "./mocks/MockRiscZeroProof.sol";

contract ProtocolAdapterTest is DeepTest {
    using ComputableComponents for Resource;
    using AppData for TagAppDataPair[];
    using Delta for uint256[2];

    uint8 internal constant _TREE_DEPTH = 2 ^ 8;
    bytes32 internal constant _ALWAYS_VALID_LOGIC_REF = bytes32(0);
    bytes32 internal constant _EMPTY_BLOB_REF = bytes32(0);
    IRiscZeroVerifier internal constant _SEPOLIA_VERIFIER =
        IRiscZeroVerifier(address(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187));

    RiscZeroMockVerifier internal _mockVerifier;
    ProtocolAdapter internal _pa;

    error SevereError();

    function setUp() public {
        _mockVerifier = new RiscZeroMockVerifier(MockRiscZeroProof.VERIFIER_SELECTOR);

        _pa = new ProtocolAdapter({
            riscZeroVerifier: _mockVerifier,
            logicCircuitID: MockRiscZeroProof.IMAGE_ID_1,
            complianceCircuitID: MockRiscZeroProof.IMAGE_ID_2,
            treeDepth: _TREE_DEPTH
        });
    }

    function test_deepEq() public {
        assertDeepEq(_paddingResource(0), _paddingResource(0));
    }

    function test_execute() public {
        (Resource[] memory consumed, Resource[] memory created) = _mockResources();

        _pa.execute(_mockTransaction({ consumed: consumed, created: created }));
    }

    function test_verifyEmptyTx() public view {
        Resource[] memory consumed;
        Resource[] memory created;
        _pa.verify(_mockTransaction({ consumed: consumed, created: created }));
    }

    function test_verifyTx() public view {
        (Resource[] memory consumed, Resource[] memory created) = _mockResources();

        _pa.verify(_mockTransaction({ consumed: consumed, created: created }));
    }

    function _mockTransaction(
        Resource[] memory consumed,
        Resource[] memory created
    )
        internal
        view
        returns (Transaction memory transaction)
    {
        (consumed, created) = _padResources({ consumed: consumed, created: created });

        uint256 nNfs = consumed.length;
        bytes32[] memory nfs = new bytes32[](nNfs);
        for (uint256 i = 0; i < nNfs; ++i) {
            nfs[i] = consumed[i].nullifier(Universal.INTERNAL_IDENTITY);
        }

        uint256 nCms = created.length;
        bytes32[] memory cms = new bytes32[](nCms);
        for (uint256 i = 0; i < nCms; ++i) {
            cms[i] = created[i].commitment();
        }

        TagAppDataPair[] memory appData = _mockAppData({ nullifiers: nfs, commitments: cms });
        TagLogicProofPair[] memory rlProofs = _mockLogicProofs({ nullifiers: nfs, commitments: cms, appData: appData });

        bytes32[] memory roots = new bytes32[](1);
        roots[0] = _pa.latestRoot();

        ComplianceUnit[] memory complianceUnits =
            _mockComplianceUnits({ root: roots[0], commitments: cms, nullifiers: nfs });

        KindFFICallPair[] memory emptyFfiCalls;

        Action memory action = Action({
            commitments: cms,
            nullifiers: nfs,
            logicProofs: rlProofs,
            complianceUnits: complianceUnits,
            tagAppDataPairs: appData,
            kindFFICallPairs: emptyFfiCalls
        });

        Action[] memory actions = new Action[](1);
        actions[0] = action;

        bytes memory deltaProof = MockDelta.PROOF;

        transaction = Transaction({ roots: roots, actions: actions, deltaProof: deltaProof });
    }

    // solhint-disable-next-line function-max-lines
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

            RiscZeroReceipt memory receipt = _mockVerifier.mockProve({
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

            RiscZeroReceipt memory receipt = _mockVerifier.mockProve({
                imageId: MockRiscZeroProof.IMAGE_ID_1,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            logicProofs[nullifiers.length + i] = TagLogicProofPair({
                tag: tag,
                pair: LogicRefProofPair({ logicRef: _ALWAYS_VALID_LOGIC_REF, proof: receipt.seal })
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

            RiscZeroReceipt memory receipt = _mockVerifier.mockProve({
                imageId: MockRiscZeroProof.IMAGE_ID_2,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            units[i] = ComplianceUnit({ proof: receipt.seal, instance: instance, verifyingKey: verifyingKey });
        }
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

    function _mockResources() internal pure returns (Resource[] memory consumed, Resource[] memory created) {
        created = new Resource[](1);
        created[0] = Resource({
            logicRef: _ALWAYS_VALID_LOGIC_REF,
            labelRef: _EMPTY_BLOB_REF,
            valueRef: _EMPTY_BLOB_REF,
            nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
            quantity: 1,
            nonce: 0,
            randSeed: 0,
            ephemeral: false
        });

        consumed = new Resource[](1);
        consumed[0] = Resource({
            logicRef: _ALWAYS_VALID_LOGIC_REF,
            labelRef: _EMPTY_BLOB_REF,
            valueRef: _EMPTY_BLOB_REF,
            nullifierKeyCommitment: Universal.EXTERNAL_IDENTITY,
            quantity: 1,
            nonce: 0,
            randSeed: 0,
            ephemeral: true
        });
    }

    function _paddingResource(uint256 nonce) internal pure returns (Resource memory r) {
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
}
