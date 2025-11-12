// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../../src/libs/MerkleTree.sol";
import {Compliance} from "../../../src/libs/proving/Compliance.sol";
import {Logic} from "../../../src/libs/proving/Logic.sol";

import {SHA256} from "../../../src/libs/SHA256.sol";
import {Transaction, Action} from "../../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0x743279772ca84badfef86d2721c3a1f889817c183ec9c11a0594487771c99414;
    bytes32 internal constant _CREATED_COMMITMENT = 0x18c3b52f942770eb3914c31d6b7417f1f356ed00b6c1d2216c35c37d77149564;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0xd17dd6c88f4a3435a0f3d9e3d69c6d001e92ff4bd80453833f9efda45f22f077;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"73c457ba0f833bc1be7cbc7576c559e43ab8d2c711284f153a7f09ff6e2ecad0b033e18a1f0f6f114961583c12ee71b616b93ef79205fb88d44f7b406a02ec1a7c92dfc220aeca93821cc7bb304590a3c97b3774b6227a580d64609d6d85d638256316511b13a2eb942ab6bee1fa1feb4679ccd36914efef99e44536c5bf8539f5d19eab13b9e1e397ec36128c779a5f7a0120b5df6469bb34ffa34d2a5636b40909aa3f2f4f9a34035bccfe3b232585611f8b0eb37d9ffd2d6368db0fde358f61dc362c04db705c3de9e8704897d5a56be815aa0312a2ac1c34f8987d75463d33583b4e0970d787982dc8f33d3146a09e75bf67f4256dc7cc45464164d1fbb42c667aaf";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"73c457ba09f05047c4a7df9a37b591334a58ea8d7396d11c4a6c9ff8d2e7dfb1a241b9281a7b3b27b28653d7e2787411f18a3f6330d2b1caca138232c90d2db91107d9fb2cf3281870cc4c10a40966a4587187a46eaff622790ffe059876ad11e15fd48f183dfb4fae3fcbf449e810e14b144d250cef6a5e7cc97c576cbc92e82894a5aa25c85a4601af88af9bc3d3245b516a544b328057654d179748f882ccdf06ed262ace0aa4ff29a983166024bba23f0e5a8e7672baea23750318c6813b7a6ec4161346e7df447cc23e3c601be6c667ff55b7ce92195413bacf71f5c480e7d5ab98146372684482d850c2910f2326cb268321fcf9cf0b20fd80d7bf330c577323dc";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"73c457ba02140e1b3bae7bc2f549c2c8219b5cbe8e2ab02d0e635bbc7cdce154d01823890a3e7c685cb6b9901a9412e67a798e918caddd5f272352e9bddebedf19fe1a7a2893b8378e59d7ef9ef616b3d72550800b4b338b99a0c8add2276a7a4028f7f60a58f1becdd2dece39e89dbc7059a685b8af3ebf2d19799516db364c6b3a396d0b9e8aed679f2098b814c3672ad0f4b0b28f664729384bcc11503554e895e0f5079e60807411106e7b38881303e4277829937da12c22237c8b4e31eff9e0998122323f263fd677ff961d8103cc0cf253e594c61190bf71e5d18a57a794e77fb60b1e7a337a07fffd72641086f1871ef696c2fa6d39d7af9487aba9ad75a87b9d";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"7208f908bd70e4c8d85c597a804f74e25306e3eff9cf7c492e53586128a58690066d137ed7458d17a66c7ce82e4597d07963c84fe15d8eba8eb91a93df047fcb1b";

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
                blob: hex"d17dd6c88f4a3435a0f3d9e3d69c6d001e92ff4bd80453833f9efda45f22f0770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"d17dd6c88f4a3435a0f3d9e3d69c6d001e92ff4bd80453833f9efda45f22f0770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925743279772ca84badfef86d2721c3a1f889817c183ec9c11a0594487771c99414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
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
