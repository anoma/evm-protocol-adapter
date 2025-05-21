// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {
    Transaction,
    Action,
    LogicProof,
    LogicInstance,
    ExpirableBlob,
    ComplianceUnit,
    ComplianceInstance,
    ConsumedRefs,
    CreatedRefs,
    ResourceForwarderCalldataPair
} from "../../src/Types.sol";

library Example {
    bytes32 constant initialRoot = 0x7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3;

    bytes32 constant consumedNullifier = 0x8908b8d4641b053566380a6b900c07a1c6634ba1992bcedc30cc4f1e586b95f8;
    bytes32 constant createdCommitment = 0x676f9cd10e72f99d2416ecc268dd7a6a2e5613085d471bd62d2685f977c7b55d;

    bytes32 constant actionTreeRoot = 0x68da5e3c22df2b64a6473cfc91614246e0cfdee6bb1f17258d887ce7af566170;

    bytes32 constant logicRef = 0xb3efbbc411861566d8a690717f3beb93b6496b3f4d6659f6c0237713508a8a86;

    bytes internal constant complianceProof =
        hex"9f39696c2dd1fbd565ac40e07f352a2fb4713312379173ec141e05b5789d60243492a230089b517d8d7a4580ea86169ecabcede62833820f8a471e2217bc7ecb4fe960e401314c83607fdad82d12106057db17bc2ceb1d9f869d72dec7a8b6922a075be5302df3cd68c807ae71801b47ba636211c82dd4a74bd380ded4f8d6e40fd4f1990a63285fa5ef55f1c8a9a691d582930ecb6257d1beb6db275031abeb24fc39ee1a7df299f0d5621e766839e0d3e24decd5ffe6c4c471a58cca2c2421ffba1df71cc41cb5c9f5af6dc8fe637be7557ec531d3e6cf5961977eee3877694c8b47e30b94207c2973d4bff6a5a12ae10aaf567aabcf2cca4d31c3017b50b152483232";

    uint256 constant unitDeltaX = 55066263022277343669578718895168534326250603453777594175500187360389116729240;
    uint256 constant unitDeltaY = 32670510020758816978083085130507043184471273380659243275938904335757337482424;

    function complianceInstance() internal pure returns (ComplianceInstance memory instance) {
        instance = ComplianceInstance({
            consumed: ConsumedRefs({nullifier: consumedNullifier, commitmentTreeRoot: initialRoot, logicRef: logicRef}),
            created: CreatedRefs({commitment: createdCommitment, logicRef: logicRef}),
            unitDelta: [unitDeltaX, unitDeltaY]
        });
    }

    function complianceUnit() internal pure returns (ComplianceUnit memory unit) {
        unit = ComplianceUnit({proof: complianceProof, instance: complianceInstance()});
    }

    function transaction() internal pure returns (Transaction memory txn) {
        ExpirableBlob[] memory emptyAppData = new ExpirableBlob[](0);
        bytes memory emptyCiphertext = "";
        ResourceForwarderCalldataPair[] memory emptyForwarderCallData = new ResourceForwarderCalldataPair[](0);

        LogicInstance[] memory logicInstances = new LogicInstance[](2);
        logicInstances[0] = LogicInstance({
            tag: consumedNullifier,
            isConsumed: true,
            actionTreeRoot: actionTreeRoot,
            ciphertext: emptyCiphertext,
            appData: emptyAppData
        });
        logicInstances[1] = LogicInstance({
            tag: createdCommitment,
            isConsumed: false,
            actionTreeRoot: actionTreeRoot,
            ciphertext: emptyCiphertext,
            appData: emptyAppData
        });

        LogicProof[] memory logicProofs = new LogicProof[](2);
        logicProofs[0] = LogicProof({
            proof: hex"9f39696c08ee3469f47c668134db6ddbcfafbc13ec17929a06e68827216bbc75928b8301120c3d1b67ad0911b179592c605e79dd1d387e61a34393536a979055198b3d9414c1c8f3bace3741178c875880571bfb0e1009fdc1ad954dba84fd0d92f8a790244a9f232c269cfdd99f3aa86226288fe38c927a91fff1d61c4a37e5e0223af02c1f8fa9be8c76e84c5c2469d65497daaf99940ff5def97adaefece2aa6049bd15d84e0cf5a366c65396c13fe32a63c0e4b7dfc25e6ad86442ff6d87f5beea6f23480b31af7e89304d309b742a306161ddfd6cc566f5249f5d8d039e892f44dc2be9e484cc4ff25a088a17f3cdf08081a30d29d84b340400af694372431c60fc",
            instance: logicInstances[0],
            logicRef: logicRef
        });

        logicProofs[1] = LogicProof({
            proof: hex"9f39696c1645871ff781db18c449aafe14c58f983b0637919850940816430a08ae95c53e17c464b7e3826d9fb45f3c2a04570b783e613969fb2f18b24766cc381e046e6b04b069b8b1ea645425c1d54cbfc633c646472c0d1c61b31fdb0a5595479cbc6828fd9e02a41be05d40938af1fbeee0e0c88aa5034d9d44d0452976b02ab27f7b1d71124248f798660f89c7e1a9a2d7d60f79b09099bcbe029e051bbb6569c5be1c955db6e937a62fec04f87397fb7d94150499f97f3bf61ecc1c76ac20dfffdb0409659b7a7f29d81cf9eacf04a5242d5ea9725e895cdb6079d45a9c9e0eee2d12092655f7dd0f135c086adebf4aa672ccbecb9386d3f56d5e474bd79154b69f",
            instance: logicInstances[1],
            logicRef: logicRef
        });

        ComplianceUnit[] memory complianceUnits = new ComplianceUnit[](1);
        complianceUnits[0] = complianceUnit();

        Action[] memory actions = new Action[](1);
        actions[0] = Action({
            logicProofs: logicProofs,
            complianceUnits: complianceUnits,
            resourceCalldataPairs: emptyForwarderCallData
        });

        txn = Transaction({
            actions: actions,
            deltaProof: hex"123a22835a9c52e312a84caf34426fc1ed03529174f7854d6ba5db658a4935675669bb580efa6659b44528ada85cb86312f57caee0a3ffb6babd27de82122e8e00"
        });
    }
}

/*
Transaction {
    actions: [
        Action {
            logicProofs: [
                LogicProof {
                    proof: 0x9f39696c124d86bf02961a1a31ec9fe47dd11a489dee18726cb1279da1459bd7b8226423160c995cff4d4a88409ca94fcd598b25146cc34bfd3594961e9d7d05e064681311d2e3dc2f8ca0fbebb71a6353e11fea5bb4db4b4a0b265c670408a9b0b7668d20dd022e2e44c76cf6e682e15e1778f0804bed3177cf849865b23091a8c000642ded57f8aaa8faae6feb4a2d12805b23712712e9926f736506242d230614e61121d20a3565cdd6121cc5ef0736c31fe4fabc2733bdc7c20eace81d6afacedbd50cb36f2a20f93e0813a63b60a1ad4be7f795a499ed7d92b316d7ab3a477b215e2af189a19fb27b231d584e6075825a86ea8f49f1440ba14114d35c63aa3aaf7e,
                    instance: LogicInstance {
                        tag: 0x8908b8d4641b053566380a6b900c07a1c6634ba1992bcedc30cc4f1e586b95f8,
                        isConsumed: true,
                        actionTreeRoot: 0x68da5e3c22df2b64a6473cfc91614246e0cfdee6bb1f17258d887ce7af566170,
                        ciphertext: 0x,
                        appData: [],
                    },
                    logicRef: 0xb3efbbc411861566d8a690717f3beb93b6496b3f4d6659f6c0237713508a8a86,
                },
                LogicProof {
                    proof: 0x9f39696c073e0e1c246ff363da18bde2cf1d9cd2cce4a2b49c094316b961ff52fe80f75322e50a256320ccade7d82b5cff66470dde34f8f782f03589b0f40137d859059d0ac40deeaa9234e7b53ed80380b3cdee501b6fff1ab0d7c1f4ec8c391498f96e2b0fcc8bb52234ed057c142d2e6d47976ffe9aba2eaf427b991325926548192c22122a2f7cf1dc3822235514d85c71d26a8fe30fa4e143f5326be46048f780a13038f5b08878cfecc1ae9830094d06e6744a05fbddfcd1f61a2a061076f78cc70c6a69d7ecf08e7f5c883cd41efddcc4a26ff3ba4fb7f532aa95347b608552ef154db314f8c568eb88510320ae3356d1c5f7cb82a72b9945fcaf799240d14b8b,
                    instance: LogicInstance {
                        tag: 0x676f9cd10e72f99d2416ecc268dd7a6a2e5613085d471bd62d2685f977c7b55d,
                        isConsumed: false,
                        actionTreeRoot: 0x68da5e3c22df2b64a6473cfc91614246e0cfdee6bb1f17258d887ce7af566170,
                        ciphertext: 0x,
                        appData: [],
                    },
                    logicRef: 0xb3efbbc411861566d8a690717f3beb93b6496b3f4d6659f6c0237713508a8a86,
                },
            ],
            complianceUnits: [
                ComplianceUnit {
                    proof: 0x9f39696c03fc8bffe69dc33db7f3d2dd43788ef5f6950e6cb14b7131bc7e36c58046f5e7122418311487f2e07f4ae1cd7964f640ec87c21518f5b55bd00e0ba7f7eccd2e2736e29168bd5c69762bae7f69ee778e221b536b8c5a45bae008634f5770caac277eb5a8db96df2215d0cae2e51c8ac1d5973759b9e13efb33e32b0aece67a8e00ec3557a04dc7187b50276c95c8014d75dd498b0beb8a5c1d773fb822f4fcdb026a0513ef8847dcd1e9f95c0b55710ca3fb2f7d3ee983821ca7f2c8285b162e1aecbaab6986745930b5427fd78bd2841d81c68fc129795ce85c05ad2c73d2fa2f763dc7d19733313b13c82235f0332cb8358bf31ca4389b43805a729dedef65,
                    instance: ComplianceInstance {
                        consumed: ConsumedRefs {
                            nullifier: 0x8908b8d4641b053566380a6b900c07a1c6634ba1992bcedc30cc4f1e586b95f8,
                            commitmentTreeRoot: 0x7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3,
                            logicRef: 0xb3efbbc411861566d8a690717f3beb93b6496b3f4d6659f6c0237713508a8a86,
                        },
                        created: CreatedRefs {
                            commitment: 0x676f9cd10e72f99d2416ecc268dd7a6a2e5613085d471bd62d2685f977c7b55d,
                            logicRef: 0xb3efbbc411861566d8a690717f3beb93b6496b3f4d6659f6c0237713508a8a86,
                        },
                        unitDelta: [
                            55066263022277343669578718895168534326250603453777594175500187360389116729240,
                            32670510020758816978083085130507043184471273380659243275938904335757337482424,
                        ],
                    },
                },
            ],
            resourceCalldataPairs: [],
        },
    ],
    deltaProof: 0xf90921c5ea7492c43839366218ff6d7399dd254f6fafa929347411c8a9054b6d330ae5b7e905d95188d9ad1474c96614da3ffdce4f492b78d5dfa73716de609301,
}
*/

// Run 2:
// 0x9f39696c2dd1fbd565ac40e07f352a2fb4713312379173ec141e05b5789d60243492a230089b517d8d7a4580ea86169ecabcede62833820f8a471e2217bc7ecb4fe960e401314c83607fdad82d12106057db17bc2ceb1d9f869d72dec7a8b6922a075be5302df3cd68c807ae71801b47ba636211c82dd4a74bd380ded4f8d6e40fd4f1990a63285fa5ef55f1c8a9a691d582930ecb6257d1beb6db275031abeb24fc39ee1a7df299f0d5621e766839e0d3e24decd5ffe6c4c471a58cca2c2421ffba1df71cc41cb5c9f5af6dc8fe637be7557ec531d3e6cf5961977eee3877694c8b47e30b94207c2973d4bff6a5a12ae10aaf567aabcf2cca4d31c3017b50b152483232

// Run 3:
// 0x9f39696c2c12dc8f53faf79c7b1ac04f8446e23ce08a1232ae16ce4fe3a26ecc83e263cb208ba7e512e4a9ea1411a20ea6f8e77548a73254f717991fa7cf82381e7a8f9f0f7c0b7f80f6bb3778770798bdaf42adc67b4ca8c24dd5745b3aad13c386ee810d40b272b0057ccf2c78d6b0e159caffcf38615eb3fc7a2d624eb0e7492b25b4066712abdcfcc89a6292851022628dd8b2b261fa0fc907f722de91c28fef7c7b1a61fe92d2f4f66488f3863e7da8a7f044d153ec20c249fa058d769510d8c9710181c5f9e2d182c0ba5c320f9f2a3ef3ae2703002717b46596e99b41e5ff03e60ee1121cc02e055fba7f1d211d96ce88295cbe01e87eaca4d325893fed6c381f
