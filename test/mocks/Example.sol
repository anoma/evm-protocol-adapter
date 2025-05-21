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
    function transaction() internal pure returns (Transaction memory txn) {
        bytes32 initialRoot = 0x7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3;

        bytes32 tagConsumed = 0x8ca5b7b5456e1e48fac6c88661a9c409dd537caac4d81243551fe76d699a6aa5;
        bytes32 tagCreated = 0x616840899b65b5d2892c40fd674a7d37e99b9909f608b8e5101e27496e0dcc87;

        bytes32 actionTreeRoot = 0x1126dde6b94ece75e1fc727acb0563dbc4798fdc10a221a45b66c84407f976f2;

        bytes32 logicRef = 0xd1a0f18cc81511743327437b2493ab70e578c5021c0e8178ec7fd4db90e60517;

        ExpirableBlob[] memory emptyAppData = new ExpirableBlob[](0);
        bytes memory emptyCiphertext = "";
        ResourceForwarderCalldataPair[] memory emptyForwarderCallData = new ResourceForwarderCalldataPair[](0);

        LogicInstance[] memory logicInstances = new LogicInstance[](2);
        logicInstances[0] = LogicInstance({
            tag: tagConsumed,
            isConsumed: true,
            root: actionTreeRoot,
            ciphertext: emptyCiphertext,
            appData: emptyAppData
        });
        logicInstances[1] = LogicInstance({
            tag: tagCreated,
            isConsumed: false,
            root: actionTreeRoot,
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

        ComplianceInstance[] memory complianceInstances = new ComplianceInstance[](1);
        complianceInstances[0] = ComplianceInstance({
            consumed: ConsumedRefs({nullifier: tagConsumed, root: initialRoot, logicRef: logicRef}),
            created: CreatedRefs({commitment: tagCreated, logicRef: logicRef}),
            unitDelta: [
                uint256(68345706717893827406938840812601435919927844687196557197887884363619078926895),
                uint256(44937362286900469409801668534830481434225669291263754075873431407733928972953)
            ]
        });

        ComplianceUnit[] memory complianceUnits = new ComplianceUnit[](1);
        complianceUnits[0] = ComplianceUnit({
            proof: hex"9f39696c163d5279493e547325e9337f3eaf8d96425ace7a0509cde270350e6e3a3cfef6056bce9ba069dfd94333e99b0c622f824999f7c76499eb0f85d6bbf601ae806e043d9a3925c5473eca054f748534f29b68e89327289c4a3f0fa9985bd7ff086e10a08a30adb6cca6bea3a4e3ffecf8b8a352f78b23650d2e39deff91834df0870f4704d34958a2869ee333a0c21d47143c633ec7c6e47e4ec8e9270d61b2835c065187483be18abe1f7c19df3682ca4c53a0e871787bc1cd4425e8e2c9470ea400fc4b336a2260ddef55067341cb35e9f5c030fb6a11420b9e0eaa094960c4691da8dc166fbb566ef0185bf46cef286bf6efcade40523718c665fee998a278dc",
            instance: complianceInstances[0]
        });

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
                    proof: 0x9f39696c08ee3469f47c668134db6ddbcfafbc13ec17929a06e68827216bbc75928b8301120c3d1b67ad0911b179592c605e79dd1d387e61a34393536a979055198b3d9414c1c8f3bace3741178c875880571bfb0e1009fdc1ad954dba84fd0d92f8a790244a9f232c269cfdd99f3aa86226288fe38c927a91fff1d61c4a37e5e0223af02c1f8fa9be8c76e84c5c2469d65497daaf99940ff5def97adaefece2aa6049bd15d84e0cf5a366c65396c13fe32a63c0e4b7dfc25e6ad86442ff6d87f5beea6f23480b31af7e89304d309b742a306161ddfd6cc566f5249f5d8d039e892f44dc2be9e484cc4ff25a088a17f3cdf08081a30d29d84b340400af694372431c60fc,
                    instance: LogicInstance {
                        tag: 0x8ca5b7b5456e1e48fac6c88661a9c409dd537caac4d81243551fe76d699a6aa5,
                        isConsumed: true,
                        root: 0x1126dde6b94ece75e1fc727acb0563dbc4798fdc10a221a45b66c84407f976f2,
                        ciphertext: 0x,
                        appData: [],
                    },
                    logicRef: 0xd1a0f18cc81511743327437b2493ab70e578c5021c0e8178ec7fd4db90e60517,
                },
                LogicProof {
                    proof: 0x9f39696c1645871ff781db18c449aafe14c58f983b0637919850940816430a08ae95c53e17c464b7e3826d9fb45f3c2a04570b783e613969fb2f18b24766cc381e046e6b04b069b8b1ea645425c1d54cbfc633c646472c0d1c61b31fdb0a5595479cbc6828fd9e02a41be05d40938af1fbeee0e0c88aa5034d9d44d0452976b02ab27f7b1d71124248f798660f89c7e1a9a2d7d60f79b09099bcbe029e051bbb6569c5be1c955db6e937a62fec04f87397fb7d94150499f97f3bf61ecc1c76ac20dfffdb0409659b7a7f29d81cf9eacf04a5242d5ea9725e895cdb6079d45a9c9e0eee2d12092655f7dd0f135c086adebf4aa672ccbecb9386d3f56d5e474bd79154b69f,
                    instance: LogicInstance {
                        tag: 0x616840899b65b5d2892c40fd674a7d37e99b9909f608b8e5101e27496e0dcc87,
                        isConsumed: false,
                        root: 0x1126dde6b94ece75e1fc727acb0563dbc4798fdc10a221a45b66c84407f976f2,
                        ciphertext: 0x,
                        appData: [],
                    },
                    logicRef: 0xd1a0f18cc81511743327437b2493ab70e578c5021c0e8178ec7fd4db90e60517,
                },
            ],
            complianceUnits: [
                ComplianceUnit {
                    proof: 0x9f39696c163d5279493e547325e9337f3eaf8d96425ace7a0509cde270350e6e3a3cfef6056bce9ba069dfd94333e99b0c622f824999f7c76499eb0f85d6bbf601ae806e043d9a3925c5473eca054f748534f29b68e89327289c4a3f0fa9985bd7ff086e10a08a30adb6cca6bea3a4e3ffecf8b8a352f78b23650d2e39deff91834df0870f4704d34958a2869ee333a0c21d47143c633ec7c6e47e4ec8e9270d61b2835c065187483be18abe1f7c19df3682ca4c53a0e871787bc1cd4425e8e2c9470ea400fc4b336a2260ddef55067341cb35e9f5c030fb6a11420b9e0eaa094960c4691da8dc166fbb566ef0185bf46cef286bf6efcade40523718c665fee998a278dc,
                    instance: ComplianceInstance {
                        consumed: ConsumedRefs {
                            nullifier: 0x8ca5b7b5456e1e48fac6c88661a9c409dd537caac4d81243551fe76d699a6aa5,
                            root: 0x7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3,
                            logicRef: 0xd1a0f18cc81511743327437b2493ab70e578c5021c0e8178ec7fd4db90e60517,
                        },
                        created: CreatedRefs {
                            commitment: 0x616840899b65b5d2892c40fd674a7d37e99b9909f608b8e5101e27496e0dcc87,
                            logicRef: 0xd1a0f18cc81511743327437b2493ab70e578c5021c0e8178ec7fd4db90e60517,
                        },
                        unitDelta: [
                            68345706717893827406938840812601435919927844687196557197887884363619078926895,
                            44937362286900469409801668534830481434225669291263754075873431407733928972953,
                        ],
                    },
                },
            ],
            resourceCalldataPairs: [],
        },
    ],
    deltaProof: 0x123a22835a9c52e312a84caf34426fc1ed03529174f7854d6ba5db658a4935675669bb580efa6659b44528ada85cb86312f57caee0a3ffb6babd27de82122e8e00,
}
*/
