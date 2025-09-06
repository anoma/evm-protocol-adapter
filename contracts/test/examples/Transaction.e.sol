// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {Compliance} from "../../src/proving/Compliance.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {Transaction, Action} from "../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0xaf54af132b0e1c0df591d3b8096ba5a686c0b69447885a29fbf97627cee1a8e3;
    bytes32 internal constant _CREATED_COMMITMENT = 0x4734b9228c0a75aea9ba88b7a48be25ce99a38bc8fab4fde34a87159aa63e3de;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x39060282dd7b47c5dcc824f1f52b5f832f5943d1a4b269de95d9e2c84c82222a;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"bb001d440f32bbb51b691e66c8506dd0a4069e2bdd41fda114663ee055c5f4054affaca00357df371425264bd2050f1d0311466a0a9449be154c3e883931f5bcb32f951015a91aafe833cbaaff057903eedcc546d920606c189e166c12bc9318ad305b2a0b4516893c47b54b242052456f6dfdbd1bb6f2c496eab7f237ccbabb5947cfe0282e5353aa0073cd58d3f95117a4a8ebfbf56619f2af9bf9b0593e14e4de7bcc18ab857afd5722fab21aadd5a7fcb915dc59c1597d00410a9db4c31d5c7d6e181355bb76c8461098defae929d677f0a3796a336771aff93af40fd59a1d4c86e610eeb1ced5fd652421753358641e18055c10d276186a1f5d19de016d344d434f";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"bb001d4419d369bc06df6499e031cbfec62c4a399eaac517365acf9cc12043535ae1758428579fe81312bfb4f0a494bac4ea2da7d4cc441335e01b0fd70b7c4ba4111c570367922bdf403e6c043906aa83f4dd0db236370568682b9eecf27e826926c4c6265438b197ca1e975f09760aaf7c87cbd0620f9ceb15c7c6a494fe8c0f5536e30d63cee4768de6ff7082786dd09608477f73376967759236f348bfc6e117aba301c80e317397bfb9434659a88cfc0c6f68bd4bcd0c3571c01742fdd0a90553bb2ad0a7ee2816d5b019a050b5013eadb96f9c528d19c52a142e8b06563a1b412d26b10dc649a2cdfd3f63998380cbc8ea380ca097d106afcca43803e1ff3a8c58";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"bb001d4424b4b81e464462be15a20ac473af4e2d752a730f82b8be3f37401314c097272b2946ac565bdc85345dbf4064f5d3bad795938748fceb9ec546d2df0580396ef51d93d7eb02b0086f6c153bf1cbc5e193bf1fa5724879815be149eb2fd5ca86d821f642c5f0e37e5ec398fa9193341ee554aef7f9f2888ddcb409e4b9a78951cc1ab229c5bb7fdefe8f92260d9f93117b43df60997f749d94b84e1dfda0d20bd227c3d70c2fb450bcf4525cd9a550ce1c71b60f359d6e525dc58b217bf319ca4f259707c62ab73f78a7ac49fdcf178bdd749a2b3b427459def37e772307b425610abf6ceb48531a5c51c0df981955ff23a72f80a617f4eb02d8b530427fad51f1";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"b6ac6c3dd9976f792533ebbc82fb0145cf538b8eb63b332a9778bd7859c41a045ea31562bea4ca203ba19b1f05c870e5b20fe42852cd317bac3769c645b071241c";

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
                blob: hex"39060282dd7b47c5dcc824f1f52b5f832f5943d1a4b269de95d9e2c84c82222a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"39060282dd7b47c5dcc824f1f52b5f832f5943d1a4b269de95d9e2c84c82222a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925af54af132b0e1c0df591d3b8096ba5a686c0b69447885a29fbf97627cee1a8e3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
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
