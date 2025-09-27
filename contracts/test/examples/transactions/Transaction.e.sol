// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../../src/libs/MerkleTree.sol";
import {SHA256} from "../../../src/libs/SHA256.sol";
import {Compliance} from "../../../src/proving/Compliance.sol";
import {Logic} from "../../../src/proving/Logic.sol";
import {Transaction, Action} from "../../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0xd39478b3315e2800ad9148dae510ffb98964a0a25bea84ce314ae5a1665bb3be;
    bytes32 internal constant _CREATED_COMMITMENT = 0x7ff6de5474c7a34da400e33f9027f23bb5be7b34d6e7be21b0f880e941bf31bd;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x7287d95884c06ab32a2c24f677c1852c51b57504a415291429131b2e421eeefa;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"73c457ba24d534dd5f4a36bc7fc80d4ea6931e59b70cb9e4e49b3d9cf5431ba20cad64d512355ba5c73e603305f99d31f5734b46f6ff2cfe7a452d43403a06ae2d8b3d7a2f4db867a6344bac0218a28d35f23f3b82d1ba8278f8e52c8f712dad4bf8fff509e3959bb466d52611a3ae4e44a47b01f6b5e3d4696eb614b4ce3d3b141863231fecf17cfe2baf3587becc35febc90d0aff6178652221b54d08ef34681330c662a2b21d7da2702c68dab0697a9fe46531d1d7389f6143ea027eb84ed286d31242ea5cf93517a949bfceaaf0d561299177aea039b4787e1e2324e97bf2a0530552423182d07cdb01538cb68ab8fceaff0961cc8716589bb6886addf9d7bad966c";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"73c457ba2fb8cc03152a143c1f17852015a9e0f17e27b5849637bb81fbbe6e528db0e6e6299cf98f186383a70b9341889efb492ebb0420b2dc464d8a8b11fe4443c1302e1300f8f5cbfe92316d2a71ddbc9012feffe5e1fe15e925af9621244d7487737d029fa78634bb4ee75b010a38fb53998117d2be0adc4dbef72357d2d86f4f4aff0515e608e9e9f3185a28bd17c715603466fd2ce39fa290550842ae17768d73bd215fab1e1b59c001d7bd5790438524daaf36b5d614e38af30d31498474d7ea361365ab2f40fe49449aed6701bb74182a11228ec6d24018a77201a4ab77ebee8907adc3cc090af0a36bb0f2bdfe873140084afeb61057bb90372fdc776a6da694";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"73c457ba21d61c094ea2c29601419b1d9213ce1a74b3402d5563148e01b99398f763df7323d3380b77441404f7030b9afe0edb6bcc156482a3d35359dd4d6d8e5e34e0c72500b2aeb80ae4ae29aa5217c0091d8af511d8c62d98c31fd817a5ac42fbfd1d242afceed97afaac7ee4e396d8cb0193d817d768112b1525cc0efdc4bffcf15d1f708749d0a7a736454f64f009f5ba1f437ed66eb209b3294002d08b9d44edc4227610281642542ae594ea4b4b805364eb20cd0e6236e77474a83f582b3e4c6f1f9cd96b420e8c7bd97c64d65163e1a0e50688e75dad2737e5879ecd4244c8c202a8e91d2ef2f8e15956453bd6be5e3913fc54b90bb8abe0775c4d274b4db15a";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"b91ec8ea76d57a4a370d4fcff04f8d6f178dc0e370dfd9573ba5638c10c06bb705cf39747cbefa0f2e14bd44d9b7b1542d033b5b6ecf6017fb08f0b7c5c1cbb41c";

    function treeRoot() internal view returns (bytes32 root) {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = _CONSUMED_NULLIFIER;
        leaves[1] = _CREATED_COMMITMENT;

        root = leaves.computeRoot();
    }

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
                blob: hex"7287d95884c06ab32a2c24f677c1852c51b57504a415291429131b2e421eeefa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"7287d95884c06ab32a2c24f677c1852c51b57504a415291429131b2e421eeefa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925d39478b3315e2800ad9148dae510ffb98964a0a25bea84ce314ae5a1665bb3be000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
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
}
