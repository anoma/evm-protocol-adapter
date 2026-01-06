// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../../src/libs/MerkleTree.sol";
import {Compliance} from "../../../src/libs/proving/Compliance.sol";
import {Logic} from "../../../src/libs/proving/Logic.sol";

import {SHA256} from "../../../src/libs/SHA256.sol";
import {Transaction, Action} from "../../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0xbcd98a751af652915bfb215fa2ab462ba9e0ead05e6e12bc53fedc8df87c5d8e;
    bytes32 internal constant _CREATED_COMMITMENT = 0xb4b51eb862f724450e4e0da2ad4bfae9858be88a5456501837ad98777a2f3d78;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x3cdf4e49f23543ff8a32f7f2da63a1d918c0d32167e4723b1435838a61cebf0a;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"73c457ba26782bb8f402d19882882b8025e18f27c12b0459084acdbfde243ecb46d1b3dd2f52c2682f53bc9caffe4105ef3fa6749743b0492b8d3664debea2573ba85da620066f1bb83a255c4250e31834db17453df88aa271793962b7e975976f66204c104db36066341fceddf1fbfd43d4055669e96bb8744f316d8216028494a6a34b1d5833a3fe1fd3ae33bc9f89edeff76baee6672ee11cdb5b3084ee9eb829db8a0f3f5e0cfb53f81abacaa489d4bb9bb3b1abdc2220daac7ba8bc6fad0be8cf8e03273d8090e0adec5d088fb82875f24b20510ad52c4ad85d771318be468bb67a017d3050971b9e0f48e6d60199fb623983535cb091aa496448221237c598f94c";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"73c457ba2fd29d932e6ed43908ddb4b0cf9c209e994d94eb5335d136d174d2901828071007bdb649249733c388e5a5f4c598d91cf402b1fcc12c68f9808fef859fe0c7671c5fd11d28631b42df8e380aff6eedee3d0cc182a7774e353419c7a776d189c00bc4d955c9c1ed19c38841a733f46ab0fdd26a72e56dcc17449d869cc3383e9827600c03139a6d5fa5699b0fce39b50d9f88ff0d31f3bb8a023a325db7cd7dcc0c1a29c4824d1a824b8ee7647fc9c1b4fddd7d61cdf989e8c117d66a6de37bbb2cc0dcd6ce10a9923570999dc35711890965ba2436facbaa172d9ecac4773d3802b2ac110e7a0aba8e4274346c93511755abde0961cd8f3872c7d4cdc5acbe20";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"73c457ba2b8f6be5e95284f74a50cadab03a2e7e68d2a3f1953032054b602605b82f45a2075f9bcaecc7b6d850cf6f8aa90a42896f0d9a8d08654a0b5a0bd583f076a1b112e9a710886f838e56bf73a50c1d6a7dc04c07bc8521528b09fb246b5e406b0f00b17c4e7b96da27a0eaa3eb3249607df678874c2ba7922b88dc3b8b51aa35c41809eafe9d011baa40121b0ca1b5d84f4e45f28414821e7d2bb712816c9b82ef06bba53156990da2072a88da64bc1f7f3f3c3a7d82a5e23ffabd95fdcb1c1481198dd885af229e0949596be0bbc1c0cfcc393acd366bfa551dd24a4a0b2191ca2a953ba0f7614b0be6b65163339ccdad2ba85caf50e024a3885e2df440245585";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"363217c1bb20bcf765c688083de06de62bcd6886502f9758e39ad5e20b4955d97a05cf8ecc60c4115d07a965a3f5900204f9a4d50d88623f969ba687f0fa705c1c";

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
                blob: hex"3cdf4e49f23543ff8a32f7f2da63a1d918c0d32167e4723b1435838a61cebf0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"3cdf4e49f23543ff8a32f7f2da63a1d918c0d32167e4723b1435838a61cebf0a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925bcd98a751af652915bfb215fa2ab462ba9e0ead05e6e12bc53fedc8df87c5d8e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
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
