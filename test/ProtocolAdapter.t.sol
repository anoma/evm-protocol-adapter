// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import {Test} from "forge-std/src/Test.sol";

import {ComputableComponents} from "../src/libs/ComputableComponents.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {ExpirableBlob, DeletionCriterion} from "../src/state/BlobStorage.sol";
import {Transaction, Resource, Action, KindFFICallPair} from "../src/Types.sol";
import {Universal} from "../src/libs/Identities.sol";
import {TagLogicProofPair, LogicRefProofPair} from "../src/proving/Logic.sol";
import {ComplianceUnit} from "../src/proving/Compliance.sol";
import {TagAppDataPair} from "../src/libs/AppData.sol";
import {Delta} from "../src/proving/Delta.sol";

contract ProtocolAdapterTest is Test {
    using ComputableComponents for Resource;

    uint256 internal testNumber;
    ProtocolAdapter internal protocolAdapter;

    uint8 internal constant TREE_DEPTH = 2 ^ 8;
    address RISC_ZERO_VERIFIER_ROUTER_SEPOLIA = 0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187;

    function setUp() public {
        protocolAdapter = new ProtocolAdapter({
            logicCircuitID: bytes32(0),
            complianceCircuitID: bytes32(0),
            riscZeroVerifier: RISC_ZERO_VERIFIER_ROUTER_SEPOLIA,
            treeDepth: TREE_DEPTH
        });
    }

    function testTransaction() public view returns (Transaction memory) {
        Resource memory res;
        Resource memory ephRes;

        bytes32 alwaysValidLogicRef = bytes32(0);
        {
            bytes32 empty = bytes32(0);

            // Created
            res = Resource({
                logicRef: alwaysValidLogicRef,
                labelRef: empty,
                valueRef: empty,
                nullifierKeyCommitment: Universal.externalIdentity,
                quantity: 1,
                nonce: uint256(blockhash(block.number)),
                randSeed: 0,
                ephemeral: false
            });

            ephRes = res;
            ephRes.ephemeral = true;
        }

        bytes32[] memory cms = new bytes32[](1);
        bytes32[] memory nfs = new bytes32[](1);

        TagLogicProofPair[] memory logicProofs = new TagLogicProofPair[](2);
        {
            cms[0] = res.commitment();
            nfs[0] = res.nullifier(Universal.internalIdentity);

            bytes[] memory createdResourceProofs = new bytes[](1);
            bytes[] memory consumedResourceProofs = new bytes[](1);

            createdResourceProofs[0] = bytes("LOGIC PROOF MISSING");
            consumedResourceProofs[0] = bytes("LOGIC PROOF MISSING");

            logicProofs = new TagLogicProofPair[](2);
            logicProofs[0] = TagLogicProofPair({
                tag: cms[0],
                pair: LogicRefProofPair({logicRef: alwaysValidLogicRef, proof: createdResourceProofs[0]})
            });
            logicProofs[0] = TagLogicProofPair({
                tag: nfs[0],
                pair: LogicRefProofPair({logicRef: alwaysValidLogicRef, proof: consumedResourceProofs[0]})
            });
        }

        ComplianceUnit[] memory emptyComplianceUnits;

        TagAppDataPair[] memory appData = new TagAppDataPair[](2);
        {
            bytes memory empty = bytes("");

            appData[0] = TagAppDataPair({
                tag: cms[0],
                appData: ExpirableBlob({deletionCriterion: DeletionCriterion.Immediately, blob: empty})
            });

            appData[1] = TagAppDataPair({
                tag: nfs[0],
                appData: ExpirableBlob({deletionCriterion: DeletionCriterion.Immediately, blob: empty})
            });
        }

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

        bytes memory deltaProof = bytes("TODO");

        bytes32[] memory roots = new bytes32[](1);
        roots[0] = protocolAdapter.latestRoot();

        return Transaction({roots: roots, actions: actions, deltaProof: deltaProof});
    }

    function test_verify() public view {
        protocolAdapter.verify(testTransaction());
    }

    function test_execute() public {
        protocolAdapter.execute(testTransaction());
    }
}
