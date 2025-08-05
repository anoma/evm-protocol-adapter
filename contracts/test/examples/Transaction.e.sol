// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {Compliance} from "../../src/proving/Compliance.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {Transaction, /*ResourceForwarderCalldataPair,*/ Action} from "../../src/Types.sol";

import {INITIAL_COMMITMENT_TREE_ROOT} from "../state/CommitmentAccumulator.t.sol";

library TransactionExample {
    bytes32 internal constant _CONSUMED_NULLIFIER = 0x2fe6775e82ad71cd3f0531ebe9f85b9d00ad7bc21e8ac5f5c6fd1a68b4dfba2b;
    bytes32 internal constant _CREATED_COMMITMENT = 0x193e55bfc8d65a9efd4471c0287c69c8918e7d9331901a01ee2841533ca1f719;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0xf8047dc2cf6cbe45137a588a3f019814218e7d7199b1b86a57b51c310e04fae9;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"bb001d4407a197561e75ff04be754784dd72c3bb032746ff6c60294708e9e16d6abd451d2b95b12955aa302ad11819e7e77ef4a2a013f4b3d66817b63af158bee50ae34803bddc43fbf30151ea56a7c68dbeccb98e1e09fd624af2b58c785953f9536c4e01c798fd6fd373e29e29170003ced169509e80d3d1a097b11c1495e9967379041a34fb79721bd2549bfbbdda742fa1fd5ffc7076e949fccd729f767a7c32dfad1f7f1eb14dfd537eaba372d3b81e3c3430b7ff9073ac69bbe9bf730458ed30ec240c0897034eb24cc64312048e78b796873e9974df828cc63c61eb513c0de1d204b7bb5a3632107b3f5ccc17d358a59b6f9518c704800163a63aab2d31958311";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"bb001d4413222060708b223191bbe0c578a2b28fc9f4b982b5788c58aaff238863acbda524182c1c33cbe89df260f2e8dc4694cb39d2c8dac0aefa047a4ab8ed96e381dd26faf7ec9e0de4d242ee5f611f5f8ea7cd3d480a07419cb10d33988c9d76845f00114cc6c2d0a1efa8037b873d9123f9523d080c4540de1f947bc8efa13aead9169bcbc91b74fb1c2ef5d58a2bdea1d12917e410826bd16a70c7e0949d8f3cc3190250fc7202f1402a17974e1eef5ed75704fb18511bb30f60b27538082a226b090002c42b32b9e206cad780f8dd00bb22a6ff98297ca03a5c020e4cac3e94672a1ba8e2b96c5819d6fec6705846c75af84fcb5f790f1c4340094567b8d9d1b8";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"bb001d44152a1d6fd8f45d1c979342581b7953614b228b43218a5c8559b0f4415b836f392fe183f44bd4b3488d3fe36c0f2c6de21bf11fe18c3403adf2d4a33e7b7a0bc50028b0681cb33df7b915d6bea43654f85cc42839accff571f27799d9b04641461057137e2297539f9bf791bd0f9a9c35a0e0b1a6f99bd3ec41d563a091d2d40d0178aa6fad1be69f3360a61d8f1ae6690bfb234b90bc6485985bc98eb04f33cd01f6c852998de57eaf57a369f4106164ffcbb550d41dffa8a2d75f1efa9ddd230def4d79a3d63170e0c68f52ba1593a32ce264a61a43f97f4304dedd8aea304609241a2c93a7447a309694603afcc4160531e0c9d3c2fe3630a25cf6aa55f1c3";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"84573c4cb7358f0251e661ac747756df1ade611cb00d76e17bf292952c0de69451f047436136cc0ada65d69bff88e872f5d147f4c5548c18b244822d7a758eeb1b";

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

    function complianceInstance() internal pure returns (Compliance.Instance memory instance) {
        instance = Compliance.Instance({
            consumed: Compliance.ConsumedRefs({
                nullifier: _CONSUMED_NULLIFIER,
                commitmentTreeRoot: INITIAL_COMMITMENT_TREE_ROOT,
                logicRef: _CONSUMED_LOGIC_REF
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
        input = Logic.VerifierInput({
            tag: isConsumed ? _CONSUMED_NULLIFIER : _CREATED_COMMITMENT,
            verifyingKey: isConsumed ? _CONSUMED_LOGIC_REF : _CREATED_LOGIC_REF,
            appData: Logic.AppData({
                discoveryPayload: new Logic.ExpirableBlob[](0),
                resourcePayload: new Logic.ExpirableBlob[](0),
                externalPayload: new Logic.ExpirableBlob[](0),
                applicationPayload: new Logic.ExpirableBlob[](0)
            }),
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

        txn = Transaction({actions: actions, deltaProof: _DELTA_PROOF});
    }

    function treeRoot() internal pure returns (bytes32 root) {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = _CONSUMED_NULLIFIER;
        leaves[1] = _CREATED_COMMITMENT;

        root = MerkleTree.computeRoot(leaves, 4);
    }
}
