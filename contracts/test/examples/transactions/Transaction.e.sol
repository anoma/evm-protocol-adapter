// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../../src/libs/MerkleTree.sol";
import {Compliance} from "../../../src/libs/proving/Compliance.sol";
import {Logic} from "../../../src/libs/proving/Logic.sol";

import {SHA256Utils} from "../../../src/libs/utils/SHA256Utils.sol";
import {Transaction, Action} from "../../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0x87283297a74fc74b804fdd870b9111232a6cd5afcc712ed45579b399c6f68a50;
    bytes32 internal constant _CREATED_COMMITMENT = 0x087563389a0235881613d1d832fcc64da522e5966afe07a210fb603d913c4c68;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x34c7de7531d47a21c896ca0dc719e3b4c525c26d8f56034517bc2bf7edfb80f5;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"73c457ba122f97c6cb8c790a1d063804665abb52ead8d1f0ad1cbfdd63dd5f6fb7e50440146cd2e5f9c5864725f670486338c7fbb81e3dc7c8933dfc89afe3a7c4b165f92564423f9f34cd301f124434dc53f8fba14e415b75f933e22699209507caba6a0e5b797611a4886f2e11231f8e0c21f958b5dd646594e079188b3d1207f9404d195231cd80e9337cbd5f2f67ea8d65270755a29ab0b54c48597e3f955d7fb15418bbd91ee5382f8167c097eae55c88052561b54689c6e10657f240512ea2988d015dc71f9d2000b9cf249df4490d76c5d31c4c05b345e140eb82e0ef966793e41eb60efb91f040c90a08c214d7acea465aa2662f5aa18686bfe8c52fcafdf90e";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"73c457ba29f359c3c23de4b4ed9b4c6b97f797f41db37eaa5af8afdec99b593c0c43e1c4056f41ae9df15ba039876beac9ca5fe6afaea803a55a05520ae3bba34775196728770fb64250774ad1983b9d3f885182740623255ad46482f21982ca4cebc76f2de5493beeca3f7866f77fd29a09d89932081d902d845503b408640b3e2b6b5e0bdf8fa60389f82150acca705d6472041e93c046055fcffa60da50d73abc5bc32623e1d59ac03b87af7dce6ed763dfca206f166780fe67894d58399dcb87f68c0783f86a6b509f5c898057b6d14f2c656f40bffbcf80030ec2f3750d24e289d82e2fc541385d592f3d5dc6b0c87468af43b835ee3ef12b86be2395ad2730b387";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"73c457ba0d18e7af1d217c86cfa8dcc16bfc67cdbd578df8c5e10159956f69a208c6d268282c2a313bbadaa1320a399051ff2be4a97c388c794a9c2a827ba6bc83c08f7307028cb46ddaa4d21be8a0060dd1de6516c5b80f6b8b625daff37c6c3d72f6b801e30d7329f96453c67dd47f4e75238683a43cef34783e3d7186965ea12e15eb2d0043207a60711003ca472ffcce2f31e57ffda0c37eb2049f3f76695298af810ded47a639f4d0b5694e56d0dcbcc8175c27a52308da700d6334b0788a0f62f70fbb22d5899cf3eb07a166fd8f72b6c8fdb4bd2ee1feb720a34cc88dd11a08981d09b3dc7a45dddcb9951c79e5fa211d05d37cfa9280ad0ff790448c342d8e77";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"4d5385cfda243953db44b97213a5446ce91bf6a4b21b27824aa5c240e845cd215dd34c3800a11e9604a2a177bae634b8f7a7c810234fd1d3a367b6c8b65a76651c";

    function complianceInstance() internal pure returns (Compliance.Instance memory instance) {
        instance = Compliance.Instance({
            consumed: Compliance.ConsumedRefs({
                nullifier: _CONSUMED_NULLIFIER,
                commitmentTreeRoot: SHA256Utils.EMPTY_HASH,
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
                blob: hex"34c7de7531d47a21c896ca0dc719e3b4c525c26d8f56034517bc2bf7edfb80f50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"34c7de7531d47a21c896ca0dc719e3b4c525c26d8f56034517bc2bf7edfb80f50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f292587283297a74fc74b804fdd870b9111232a6cd5afcc712ed45579b399c6f68a50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        }

        appData.discoveryPayload[0] = Logic.ExpirableBlob({
            blob: hex"1100000000000000f0c0b927309ac95aa60eb8e4fc95095d980000000000000000000000000100000000000000000000",
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
