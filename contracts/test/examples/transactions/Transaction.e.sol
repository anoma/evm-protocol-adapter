// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../../src/libs/MerkleTree.sol";
import {SHA256} from "../../../src/libs/SHA256.sol";
import {Compliance} from "../../../src/proving/Compliance.sol";
import {Logic} from "../../../src/proving/Logic.sol";
import {Transaction, Action} from "../../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0x99a3620304fcdcc36cf5274e09014414c075bc856ab7fb86045e1330a23dd90c;
    bytes32 internal constant _CREATED_COMMITMENT = 0xa4624a1a9ce9bb5ca48cf7bc8516d2a2b2f3f4820912048c9616ba1f6a03a5df;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x979a12ac83b4117036b2d8a2bbba4a149a232d14ac8410b9e60b4613c5bd4d4e;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"73c457ba224d768dca516d1d4a57435a75ee2f4a7cdecfedae373c4f00d6cc30aecd87381195ab72d58123d3036ac475c9bcb71cb14be29b7e82458765b38c4303e5797917ade2adb174203d7a472ede56a7709b4213930b341f0c8fe0d8dea97fc67465141217c68d2450c4be7b63a7bfa8052af4877cf91e4d3db661452a57a53d011f26c57b10b0a2c3e51866a8eff15702ebaa610f3f087acb058bf76121032df8e606511b08bd2ed0f2c6edf911149f454983c58964bdc7f5b223aa3ffe9d12382327f767235cfd65658466fd8e3588440080c2d7feeef68d62fc80d8912af499082484e3a65d4ff8d610f4b1aaa5fd0c70c5e0477a05dd77c2e5c00bc148ae5a7c";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"73c457ba0cfb869716a89adf48aca592cce2d82a91b3e01225daa1e48fcbdb51a4f0a01f1063066419718c75a95132af8fed507d8f276f12881d2c88d6fa601aef897484046c8288c1446f786895a9a0b0f485642bea8fe9a5fb7925257e9a8e704a3c4c2c0263dd3d4a45a9d87ebbc678366cfac106f671b58f666657d8860f1dbdc42928b12770acd6d66e2079aeca1525d6d58e288f016f09758c85959fd60a6cbddb03c088aeaec1ab441e6e675c081e63993d653886038b659fa26a27083b3722c92f89a79045fe2e327ad001e093e5e5f01d91336f41b5dacb06463e7733f2bf251a8cff08aea946aa7ffde7a258695f661b7f45b5cf6aad6ba7c46f97cfa50249";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"73c457ba1ee153ffbc0a1534615c346ac314b39f7598fd87de0ae3cdcd4bce046d40529e12de4c48ecfe5fa8419f0b6b16c1090547932f6a112e95dff1e652326a951a52199c2d25f36a3b2942cfcd149f167d22eaad6d1804de4514d4dc09f71fe40a3d0597e1c5a4355a549142e58b3a1554c1081b726944c3f5d009b48401bb49b8091ed7cbf8a791d45c4c8f9c441e55afa278f9e4bd2923a86a2cdb837a6b4818c2001c8e6f2411c5684f0f429c3f4c98b8d4a83527c47b9da40415d1e9885483da013b1ce48fdc8ed333f53fcc0843b6a42c968d656070ef25f89822d81e7a8a581eb1bdf05b273edcf41d2b1c00ae018468c0ea2f41bab18c15e80f48eb64d7f8";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"e4ed50fc5aeceedf94a5f5e4cd9bccb7dec79366a047288940799631f29196f834cfc742a0dd5501e78de03b23dbe4627a3769a52afe3da4a7379df1b0d410f91b";

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
                blob: hex"979a12ac83b4117036b2d8a2bbba4a149a232d14ac8410b9e60b4613c5bd4d4e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"979a12ac83b4117036b2d8a2bbba4a149a232d14ac8410b9e60b4613c5bd4d4e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f292599a3620304fcdcc36cf5274e09014414c075bc856ab7fb86045e1330a23dd90c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
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

    function commitmentRoot() internal pure returns (bytes32 root) {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = _CONSUMED_NULLIFIER;
        leaves[1] = _CREATED_COMMITMENT;

        root = leaves.computeRoot();
    }
}
