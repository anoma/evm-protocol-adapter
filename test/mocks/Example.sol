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
    bytes32 internal constant initialCommitmentTreeRoot =
        0x7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3;

    bytes32 internal constant consumedNullifier = 0x81df30066f64e51cfade805b17718be06eb34aeb3839177dc0a26f470de4a5f1;
    bytes32 internal constant createdCommitment = 0x38507f7ea10368b792c09076b6514dfa3a2d8f809f5a86f62c8b5d7df04f58dd;

    bytes32 internal constant actionTreeRoot = 0x68da5e3c22df2b64a6473cfc91614246e0cfdee6bb1f17258d887ce7af566170;

    bytes32 internal constant logicRef = 0x67cba0b4837042068f17ce54ca69f481686b8d98bf8ca6b575f61064afb7e7af;

    bytes internal constant complianceProof =
        hex"9f39696c08d1d2f3ea7ef7579325a142137f0e150c103bc027ffb2e590eeaa3027021806223720c18ef9ae310144637ca35b9c02e2449925637a5901bfc25d6b6da8865d13be49485aa584633057d7db278f282d36cc550faba644c69e50cd1a1726b910248415fc47253a89ab12e1c0ec3ded908cbd5895e8154dab239f209c2bf17e2b058f9af5ed6cc9dde5f1ce607fc5c931a402e7497f078a23247617e4f1c6de1114948f3d6d9eca0a1dd4a58525492e8eeb0ade74078aec35e3411937e9c17b0f18ea0a6b3fa9ce6902a95a7381c34c81ce5ab07f054b7e0a7081803c667203a72fd367123cc034eba695b14b6e1f4c04e5b973dfdb56ffa204f4e2d3d54cb180";

    bytes32 internal constant unitDeltaX = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant unitDeltaY = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    function complianceInstance() internal pure returns (ComplianceInstance memory instance) {
        instance = ComplianceInstance({
            consumed: ConsumedRefs({
                nullifier: consumedNullifier,
                commitmentTreeRoot: initialCommitmentTreeRoot,
                logicRef: logicRef
            }),
            created: CreatedRefs({commitment: createdCommitment, logicRef: logicRef}),
            unitDeltaX: unitDeltaX,
            unitDeltaY: unitDeltaY
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
