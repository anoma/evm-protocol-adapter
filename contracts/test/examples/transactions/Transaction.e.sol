// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../../src/libs/MerkleTree.sol";
import {Compliance} from "../../../src/libs/proving/Compliance.sol";
import {Logic} from "../../../src/libs/proving/Logic.sol";

import {SHA256} from "../../../src/libs/SHA256.sol";
import {Transaction, Action} from "../../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0x87e0e80da87375087b454bcb365ee9fa902cd758debd5f519a487c92fea5c079;
    bytes32 internal constant _CREATED_COMMITMENT = 0xa333f44e030b37407901873f3b661f2298ebccd30f301608d2bce351daf81e49;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0xdbd32d16521ea6a48da53ade6f3d794bd247b5f035710472f5a5c6d1b347a92b;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"73c457ba171af7d299a3f886a40e3e6e61b061a285a482b08e57d91078046cb4b81f8ef605933b99196165869adec867374b471bd8c2f30f873f64561cff12eae26416ec23d089e73e57e43cdecf15459ea3203539c66f56563bfca01bde42463626e9650e7f818b5dc7810d7e8c8308490edd4ded9c364e291eda6f8890ec7dbdf96ebb1cdbba54226931127be9acc3318e5c20a6590f5aea4ec77a73c85bc5683bd7be03d16604c59d72ac19c148acd76a3fdb30f14b214c3aa63ae1e15690e91eae8d18e9fdb8b3f0149bc5badd2175139cb5c5cdae1b7b5fac8fede1f29e0529d46a07fd8a819b676b17271ec62219d8da6c3b485a56bca4c77ef7d1db85b2bb4b96";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"73c457ba030e74ec8bfa4c81beb77284003462c1ce5e4ae95ddf70127f4fa3630540ac3a287c95dc80b95e20f6b8b669589c9991cc69c2e870d5d7258faa06c0aa06321303823abdd90b743ec4c0566c09c0dac462fe9860d8c8ae428f467fe39556092706d161d0d0e17252d18a86569256fb86ca47fce4076584d14527c3b7c5d48fbd2cfd1ea8b42ea437942ea599a653a9402031b2a558398f0508da3474946732501343b80194e22e39ed9e58b543e405314004ef76a843dd5593b4a7cfffffa3672562410ed6573fb667bfc3da2c683dbc0ed4976b7158393cec909248cb37c27e0a6e41c01370444eb11a75652f3c011c94c1b9992f618b562b6243b4c92794b8";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"73c457ba270221cb8df067d9fcc4d54c3ec52a00aea789d7e296de997169bc72ac81eda31226e5fedeb356835ba7bd7a06563a89a46a68e29e7d7af5a20f24945a8ff6911028f782ba5628cd83b166e5268bc8733ea72b46675aaf496d840a13a24879321f2c09f1523ed3ec894d58ffc358d51544698f6da7d1471a5daf4c7757a0996112bdaa833ce2af8209f94e45307a03805530cdff0bd30d63b310d05218c1a28b1c6ca2efb07befd1f33146831d92194e87e6a650f232cd0626a790bef7079aa9036a20d8b187fff9ef6d2f969dae936c1bff01c0f7847e803c660ee921a689f30f066f298327b46ae28bf9e9779fa6b3d920c89d47d280e935bcf6af82e827b3";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"2f2887e3b2eecaedbd5ff1dbf299352a78ef1d14ff2de334528d71a507c4f5f06253d81573edb315cbb1e8a1b0a22c33c18cc20f265145e1146635fad0f340371c";

    function complianceInstance() internal pure returns (Compliance.Instance memory instance) {
        instance = Compliance.Instance({
            consumed: Compliance.ConsumedRefs({
                nullifier: _CONSUMED_NULLIFIER, commitmentTreeRoot: SHA256.EMPTY_HASH, logicRef: _CONSUMED_LOGIC_REF
            }),
            created: Compliance.CreatedRefs({commitment: _CREATED_COMMITMENT, logicRef: _CREATED_LOGIC_REF}),
            unitDeltaX: _UNIT_DELTA_X,
            unitDeltaY: _UNIT_DELTA_Y
        });
    }

    function complianceVerifierInput() internal pure returns (Compliance.VerifierInput memory unit) {
        unit = Compliance.VerifierInput({proof: _COMPLIANCE_PROOF, instance: complianceInstance()});
    }

    function logicVerifierInput(bool isConsumed) internal pure returns (Logic.VerifierInput memory input) {
        Logic.AppData memory appData = Logic.AppData({
            resourcePayload: new Logic.ExpirableBlob[](2),
            discoveryPayload: new Logic.ExpirableBlob[](1),
            externalPayload: new Logic.ExpirableBlob[](0),
            applicationPayload: new Logic.ExpirableBlob[](1)
        });

        if (isConsumed) {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"dbd32d16521ea6a48da53ade6f3d794bd247b5f035710472f5a5c6d1b347a92b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"dbd32d16521ea6a48da53ade6f3d794bd247b5f035710472f5a5c6d1b347a92b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f292587e0e80da87375087b454bcb365ee9fa902cd758debd5f519a487c92fea5c079000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        }

        appData.discoveryPayload[0] = Logic.ExpirableBlob({
            blob: hex"11000000000000003c9d8a6b8ebd29e54cae4ee3f68fcf2cf900000000000000000000000021000000000000000279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f817980000",
            deletionCriterion: Logic.DeletionCriterion.Never
        });

        appData.applicationPayload[0] =
            Logic.ExpirableBlob({blob: hex"0001020304050607", deletionCriterion: Logic.DeletionCriterion.Never});

        input = Logic.VerifierInput({
            tag: isConsumed ? _CONSUMED_NULLIFIER : _CREATED_COMMITMENT,
            verifyingKey: isConsumed ? _CONSUMED_LOGIC_REF : _CREATED_LOGIC_REF,
            appData: appData,
            proof: isConsumed ? _CONSUMED_LOGIC_PROOF : _CREATED_LOGIC_PROOF
        });
    }

    function transaction() internal pure returns (Transaction memory txn) {
        Logic.VerifierInput[] memory logicVerifierInputs = new Logic.VerifierInput[](2);
        logicVerifierInputs[0] = logicVerifierInput({isConsumed: true});
        logicVerifierInputs[1] = logicVerifierInput({isConsumed: false});

        Compliance.VerifierInput[] memory complianceVerifierInputs = new Compliance.VerifierInput[](1);
        complianceVerifierInputs[0] = complianceVerifierInput();

        Action[] memory actions = new Action[](1);
        actions[0] =
            Action({logicVerifierInputs: logicVerifierInputs, complianceVerifierInputs: complianceVerifierInputs});

        txn = Transaction({actions: actions, deltaProof: _DELTA_PROOF, aggregationProof: ""});
    }

    function commitmentTreeRoot() internal pure returns (bytes32 root) {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = _CONSUMED_NULLIFIER;
        leaves[1] = _CREATED_COMMITMENT;

        root = leaves.computeRoot();
    }
}
