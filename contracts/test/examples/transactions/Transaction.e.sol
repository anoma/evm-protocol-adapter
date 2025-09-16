// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../../src/libs/MerkleTree.sol";
import {SHA256} from "../../../src/libs/SHA256.sol";
import {Compliance} from "../../../src/proving/Compliance.sol";
import {Logic} from "../../../src/proving/Logic.sol";
import {Transaction, Action} from "../../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0x0ed55923022b29ceaebf204f0b1ae9cf2bd33b5cfd0ec66ab44f2c0998519aa9;
    bytes32 internal constant _CREATED_COMMITMENT = 0xca35087e78e0f34d08bd14db105604bfcac902a4d211298d463f8dfb9a2f4d16;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0xf830be2a0b1ff23e5febaf6e2a52a3d2f0cac7a315a75ca2cadfd569e81f6016;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"73c457ba1cc95fac059e0b0858292b16d139025cc6568c7075f0d717ca1a5aaa5598356f2c3d9d47f1ec58a5e59216efcf270a4e5a55f7858246e4a44f7dc40f3f440ff824d9b8416e4d1324d52c11ac555910c067bf19125f70d4580cf5b1cbb2f8ddfd21e2971c71b8829b901048ccbcccfe1427002de59fbd1b1955e9833a7f3631362a0102dfc180cfe97c544c5d52bfaeab3ed4e0cdf83784e4a1c9822a3e35a78215ebf5e654ddd0888e804dd149bd78afd13ffc46df15bdcb62700d35746e53fe0743780f2b413937e84c5de3db2920d584bbac6e7f3f4dc5e387d12e3c6a188f11b32882ad74ad067ea4602740c22a52aef3e6b26b25bacb42b769fc39e4c6b2";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"73c457ba25178f486401707c9f252e95971356b1fee3ba4d72f4c08353a72bf14e4aba112e808fc03a050171c497efa45b56d2193e6da8a30f5b628faf052c6bc454ab110bf18d02f1306857f97beb4116b377d6e9bf2929fefbb3745843bab3aba7aa872f5c838ec89c6d3f859f651fa3b1977a7a914705afb42566ac2baf58e33802c21e1a346028f0df6ab28d3fded7564226df29bc2cc805e8e217054bff268245ef21b8db96baabe70249613905563dc96d99fda2a13f780ce29923ba150e445995015be0cd5b32e55fd979d3e522480cef944c1a36ad03aee58c68d356232595c5128a9a209ef2a90788b86e357e34a3907fb1c77b6949757512ba3fee1265c1d1";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"73c457ba043b243db46772ffc6053d0721528e3d60b55a962c898b87cd8d060326d926540ca90d28efdbad313bdbb6ea863269f179f0fe41f1122298c155d1a352b6a5612e75d699404f0674111dec90c30581f1a48b2b56c8b82b1160538f88507a26192f95b4d8e36ae7fc73c506321b107c9e53a1983e1511ba94d66248491da6e4bb17fd54aa07f7860cf26b28c60b027a8bf2c80d6ace469cbb4647100fbcb7423b2f01bdcf580232b92eee88ec63de1d58a8a83aaf705e53664017214f1498deac1f2d95208a73af3660438a6eaa8ad045b6548bada237dae93b233e886cc203e52f064d2daa84e9fed1ea3180ca12d53da6629fa0a3352354ea0034b74acc0633";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"d9ea0e58e8f3513a0700731530255c87283c4d741d1fa27699495dd20644c2145f8d7d4d913c83f954d6c7039f363bfec36777eecb759816c6938d691d7561661c";

    function complianceInstance() internal pure returns (Compliance.Instance memory instance) {
        instance = Compliance.Instance({
            consumed: Compliance.ConsumedRefs({
                nullifier: _CONSUMED_NULLIFIER,
                commitmentTreeRoot: SHA256.EMPTY_HASH,
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
        Logic.AppData memory appData = Logic.AppData({
            resourcePayload: new Logic.ExpirableBlob[](2),
            discoveryPayload: new Logic.ExpirableBlob[](1),
            externalPayload: new Logic.ExpirableBlob[](0),
            applicationPayload: new Logic.ExpirableBlob[](1)
        });

        if (isConsumed) {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"f830be2a0b1ff23e5febaf6e2a52a3d2f0cac7a315a75ca2cadfd569e81f60160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"f830be2a0b1ff23e5febaf6e2a52a3d2f0cac7a315a75ca2cadfd569e81f60160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250ed55923022b29ceaebf204f0b1ae9cf2bd33b5cfd0ec66ab44f2c0998519aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        }

        appData.discoveryPayload[0] = Logic.ExpirableBlob({
            blob: hex"1100000000000000ce33ae4b7da7279a657bb29076a094d43e0000000000000000000000000100000000000000000000",
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

        txn = Transaction({actions: actions, deltaProof: _DELTA_PROOF});
    }

    function treeRoot() internal pure returns (bytes32 root) {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = _CONSUMED_NULLIFIER;
        leaves[1] = _CREATED_COMMITMENT;

        root = leaves.computeRoot();
    }
}
