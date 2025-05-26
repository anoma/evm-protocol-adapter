// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {
    ExpirableBlob,
    DeletionCriterion,
    ComplianceInstance,
    CreatedRefs,
    ConsumedRefs,
    ComplianceUnit,
    LogicInstance,
    LogicProof,
    Transaction,
    ResourceForwarderCalldataPair,
    Action
} from "../../src/Types.sol";
import {INITIAL_COMMITMENT_TREE_ROOT} from "../state/CommitmentAccumulator.t.sol";

library Example {
    bytes32 internal constant _CONSUMED_NULLIFIER = 0x8320c7eb5b5dc80f950d4a5da77c58e7c678d4314011e85216851f32e452b26b;
    bytes32 internal constant _CREATED_COMMITMENT = 0xb9a737dcf88058e86d299cc2882d22f09f5741864aaa4eb493ec8569fe55b4d7;
    bytes32 internal constant _ACTION_TREE_ROOT = 0x6032785d515a72a20aa0eff803a63ef97ce1002c50163629634b9eb820e3df38;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x2fee2ae67fdf0b4f68f71768632101c637a2936f421e5e613a3b9f688687e5c9;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"9f39696c0d7e99ff3be98c3fa98e35834129a6fb0ee3afa92d279373c699b6e1ee77a5b111dc40ae4b7a944ef70c5a2bfb191132676917228a4149c93e2f0f4efcc71c4208f882b8e0660b25be1695c926563aee6b5c852975576c429d25651747a6e0c12c7010de58e2f8883b5afc8a0be257e2253c07691a1c0d1fde4dd9539496f4541264161674dbf3b4fbcb10dccba7e3dec2069aec0b90abf1035a1dfd8b26354e16512323cc7fa31bdf7a39fb3c1021d5eab36dbbd97fedfd4564822c5a2aba320fb68abc10826a6b23910179a2218b2ecae9cebc3a3c898f736edc072eb3207d28d5e2ff14f47b5e6f6fd061bcbf09ac670e2b8fb0bab637a6b5ccd8dc278a75";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"9f39696c1823bea05358cbdd711add3344bd0120add6ef2f39b280f8e5651453a6db20570d05b34728a66b40f71a552bcdc05c3a0a7fd12aa0646000417887b32f8968101c2031bc8c252360e590513336a98e218852b9477fc83e81a41f6db79e84efc727c425e303e1f6ccfbe10e5091e95085ba13100d43100ac065d6d5d2692e2c0511af8415ad69180a082365f299d9de491359c91f82b174f420fdb4ce64719a332585e89323aa9e11afb4a21908fcb1e17c299f76b38f13fcb17cc55abd4d01de12dee4f4f4b0f65697c9d27be1552bd64dbb8166370216db36620e9b467246e609561b0e80bd7a038064c5ff4e806b438efec9c515371dbfce1699284818e622";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"9f39696c23adcf13391a7ccea62f5dee82ee028f894a4185e020512e5fc86dec1f5d3dec00b12a83b6d1309acf3f1a431bbe711600e8873bfa559a0901f3656af7e73ad50696c3c08a22b59d5330b5b892d581032c5970f87444be04fe45324b2870e12b1b0f731a45019e09733b9edd860709a15e9f76597d6ec4db6a518a52b98d7d01126fcc48ea8998bfd3b82a3b92b7861c4b658b9ec10dc42c9d99536999d8aca125f74e93a116193bc75c648001981bbaa9c28d39a0ea97c0a160f09832446ef5183bce3627678a6edc08e7f0ae2f7753b49b06ef7d336d47d5f00262227cbec301104ea80b25dc8e3ef78336815b4a3978d8d6067be06d137480425bd330292a";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"09eb4f4f11cb979c00a593e471e0ce76a86ecd511825ef7f2c900b47dc899f8105796334f8d2672e9a5440c7c772998482ff9647d39a6672a5cf0dd7a4f2abb71b";

    function ciphertext() internal pure returns (bytes memory cipher) {
        cipher = hex"3f0000007f000000bf000000ff000000";
    }

    function expirableBlobs() internal pure returns (ExpirableBlob[] memory blobs) {
        blobs = new ExpirableBlob[](2);
        blobs[0] = ExpirableBlob({
            blob: hex"1f0000003f0000005f0000007f000000",
            deletionCriterion: DeletionCriterion.Immediately
        });
        blobs[1] =
            ExpirableBlob({blob: hex"9f000000bf000000df000000ff000000", deletionCriterion: DeletionCriterion.Never});
    }

    function complianceInstance() internal pure returns (ComplianceInstance memory instance) {
        instance = ComplianceInstance({
            consumed: ConsumedRefs({
                nullifier: _CONSUMED_NULLIFIER,
                commitmentTreeRoot: INITIAL_COMMITMENT_TREE_ROOT,
                logicRef: _CONSUMED_LOGIC_REF
            }),
            created: CreatedRefs({commitment: _CREATED_COMMITMENT, logicRef: _CREATED_LOGIC_REF}),
            unitDeltaX: _UNIT_DELTA_X,
            unitDeltaY: _UNIT_DELTA_Y
        });
    }

    function complianceUnit() internal pure returns (ComplianceUnit memory unit) {
        unit = ComplianceUnit({proof: _COMPLIANCE_PROOF, instance: complianceInstance()});
    }

    function logicInstance(bool isConsumed) internal pure returns (LogicInstance memory instance) {
        instance = LogicInstance({
            tag: isConsumed ? _CONSUMED_NULLIFIER : _CREATED_COMMITMENT,
            isConsumed: isConsumed,
            actionTreeRoot: _ACTION_TREE_ROOT,
            ciphertext: ciphertext(),
            appData: expirableBlobs()
        });
    }

    function logicProof(bool isConsumed) internal pure returns (LogicProof memory data) {
        data = LogicProof({
            proof: isConsumed ? _CONSUMED_LOGIC_PROOF : _CREATED_LOGIC_PROOF,
            instance: logicInstance(isConsumed),
            logicRef: isConsumed ? _CONSUMED_LOGIC_REF : _CREATED_LOGIC_REF
        });
    }

    function transaction() internal pure returns (Transaction memory txn) {
        ResourceForwarderCalldataPair[] memory emptyForwarderCallData = new ResourceForwarderCalldataPair[](0);

        LogicProof[] memory logicProofs = new LogicProof[](2);
        logicProofs[0] = logicProof({isConsumed: true});
        logicProofs[1] = logicProof({isConsumed: false});

        ComplianceUnit[] memory complianceUnits = new ComplianceUnit[](1);
        complianceUnits[0] = complianceUnit();

        Action[] memory actions = new Action[](1);
        actions[0] = Action({
            logicProofs: logicProofs,
            complianceUnits: complianceUnits,
            resourceCalldataPairs: emptyForwarderCallData
        });

        txn = Transaction({actions: actions, deltaProof: _DELTA_PROOF});
    }
}
