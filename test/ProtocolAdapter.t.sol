// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import {Test} from "forge-std/Test.sol";

import {IRiscZeroVerifier, Receipt as RiscZeroReceipt} from "risc0-ethereum/IRiscZeroVerifier.sol";

import {RiscZeroVerifierRouter} from "risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "risc0-ethereum/test/RiscZeroMockVerifier.sol";

import {ComputableComponents} from "../src/libs/ComputableComponents.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {ExpirableBlob, DeletionCriterion} from "../src/state/BlobStorage.sol";
import {Transaction, Resource, Action, KindFFICallPair} from "../src/Types.sol";
import {Universal} from "../src/libs/Identities.sol";

import {LogicInstance, TagLogicProofPair, LogicRefProofPair} from "../src/proving/Logic.sol";
import {ComplianceUnit} from "../src/proving/Compliance.sol";
import {Delta} from "../src/proving/Delta.sol";

import {AppData, TagAppDataPair} from "../src/libs/AppData.sol";

contract ProtocolAdapterTest is Test {
    using ComputableComponents for Resource;
    using AppData for TagAppDataPair[];
    using Delta for uint256[2];

    uint256 internal testNumber;
    ProtocolAdapter internal protocolAdapter;

    uint8 internal constant TREE_DEPTH = 2 ^ 8;
    bytes32 internal constant LOGIC_CIRCUIT_ID = 0x0000000000000000000000000000000000000000000000000000000000000001;
    bytes32 internal constant COMPLIANCE_CIRCUIT_ID = 0x0000000000000000000000000000000000000000000000000000000000000002;

    bytes32 internal constant ALWAYS_VALID_LOGIC_REF = bytes32(0);
    bytes32 internal constant EMPTY_BLOB_REF = bytes32(0);

    IRiscZeroVerifier internal constant sepoliaVerifier =
        IRiscZeroVerifier(address(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187));

    RiscZeroMockVerifier mockVerifier = new RiscZeroMockVerifier(bytes4(0x12345678));

    function setUp() public {
        protocolAdapter = new ProtocolAdapter({
            logicCircuitID: bytes32(0),
            complianceCircuitID: bytes32(0),
            riscZeroVerifier: mockVerifier,
            treeDepth: TREE_DEPTH
        });
    }

    function test_verify_empty_tx() public view {
        Resource[] memory consumed;
        Resource[] memory created;
        protocolAdapter.verify(_mockTransaction({consumed: consumed, created: created}));
    }

    function test_verify() public view {
        (Resource[] memory consumed, Resource[] memory created) = _mockResources();
        protocolAdapter.verify(_mockTransaction({consumed: consumed, created: created}));
    }

    function test_execute() public {
        (Resource[] memory consumed, Resource[] memory created) = _mockResources();
        protocolAdapter.execute(_mockTransaction({consumed: consumed, created: created}));
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
        consumed[0] = created[0];
        consumed[0].ephemeral = true;
    }

    function _mockTransaction(Resource[] memory consumed, Resource[] memory created)
        internal
        view
        returns (Transaction memory)
    {
        bytes32[] memory nfs = new bytes32[](consumed.length);
        for (uint256 i = 0; i < consumed.length; ++i) {
            nfs[i] = consumed[i].nullifier(Universal.INTERNAL_IDENTITY);
        }

        bytes32[] memory cms = new bytes32[](created.length);
        for (uint256 i = 0; i < created.length; ++i) {
            cms[i] = created[i].commitment();
        }

        TagAppDataPair[] memory appData = _mockAppData({nullifiers: nfs, commitments: cms});
        TagLogicProofPair[] memory logicProofs = _mockLogicProofs({nullifiers: nfs, commitments: cms, appData: appData});

        ComplianceUnit[] memory emptyComplianceUnits;

        KindFFICallPair[] memory emptyFfiCalls;

        Action memory action = Action({
            commitments: cms,
            nullifiers: nfs,
            logicProofs: logicProofs,
            complianceUnits: emptyComplianceUnits,
            tagAppDataPairs: appData,
            kindFFICallPairs: emptyFfiCalls
        });

        Action[] memory actions = new Action[](1);
        actions[0] = action;

        // TODO compute real delta
        bytes memory deltaProof = Delta.zero().toSignature();

        bytes32[] memory roots = new bytes32[](1);
        roots[0] = protocolAdapter.latestRoot();

        return Transaction({roots: roots, actions: actions, deltaProof: deltaProof});
    }

    function _mockAppData(bytes32[] memory nullifiers, bytes32[] memory commitments)
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
                    appData: ExpirableBlob({deletionCriterion: DeletionCriterion.Immediately, blob: emptyBlob})
                });
            }
            for (uint256 i = 0; i < commitments.length; ++i) {
                appData[nullifiers.length + i] = TagAppDataPair({
                    tag: commitments[i],
                    appData: ExpirableBlob({deletionCriterion: DeletionCriterion.Immediately, blob: emptyBlob})
                });
            }
        }
    }

    function _mockLogicProofs(
        bytes32[] memory nullifiers,
        bytes32[] memory commitments,
        TagAppDataPair[] memory appData
    ) internal view returns (TagLogicProofPair[] memory logicProofs) {
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

            RiscZeroReceipt memory logicProofReceipt = mockVerifier.mockProve({
                imageId: LOGIC_CIRCUIT_ID,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            logicProofs[i] = TagLogicProofPair({
                tag: tag,
                pair: LogicRefProofPair({logicRef: ALWAYS_VALID_LOGIC_REF, proof: logicProofReceipt.seal})
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

            RiscZeroReceipt memory logicProofReceipt = mockVerifier.mockProve({
                imageId: LOGIC_CIRCUIT_ID,
                journalDigest: sha256(abi.encode(verifyingKey, instance))
            });

            logicProofs[nullifiers.length + i] = TagLogicProofPair({
                tag: tag,
                pair: LogicRefProofPair({logicRef: ALWAYS_VALID_LOGIC_REF, proof: logicProofReceipt.seal})
            });
        }
    }

    function _mockComplianceProofs() internal view returns (TagLogicProofPair[] memory logicProofs) {}
}
