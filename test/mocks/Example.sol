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

import {INITIAL_COMMITMENT_TREE_ROOT} from "../state/CommitmentAccumulator.t.sol";

library Example {
    bytes32 public constant _CONSUMED_NULLIFIER = 0x81df30066f64e51cfade805b17718be06eb34aeb3839177dc0a26f470de4a5f1;
    bytes32 public constant _CREATED_COMMITMENT = 0x38507f7ea10368b792c09076b6514dfa3a2d8f809f5a86f62c8b5d7df04f58dd;

    bytes32 public constant _ACTION_TREE_ROOT = 0x7fead92317c3b897d1f4326a58d7be17e6f6cccaaeb3f4f1a8d478b3a04b641d;

    bytes32 public constant _CONSUMED_LOGIC_REF = 0x67cba0b4837042068f17ce54ca69f481686b8d98bf8ca6b575f61064afb7e7af;
    bytes32 public constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _COMPLIANCE_PROOF =
        hex"9f39696c08d1d2f3ea7ef7579325a142137f0e150c103bc027ffb2e590eeaa3027021806223720c18ef9ae310144637ca35b9c02e2449925637a5901bfc25d6b6da8865d13be49485aa584633057d7db278f282d36cc550faba644c69e50cd1a1726b910248415fc47253a89ab12e1c0ec3ded908cbd5895e8154dab239f209c2bf17e2b058f9af5ed6cc9dde5f1ce607fc5c931a402e7497f078a23247617e4f1c6de1114948f3d6d9eca0a1dd4a58525492e8eeb0ade74078aec35e3411937e9c17b0f18ea0a6b3fa9ce6902a95a7381c34c81ce5ab07f054b7e0a7081803c667203a72fd367123cc034eba695b14b6e1f4c04e5b973dfdb56ffa204f4e2d3d54cb180";

    bytes32 public constant unitDeltaX = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 public constant unitDeltaY = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"9f39696c1a34d41dc233a6418070ba23b7fe95ca6791925db284eda01fe7eae73dbfa4862ef5ec07d2beb53206ad120fc0d2131391ade3c7873b39f1466a15b90835c9421c0d453b4b3dc0996e6e0d4a22b487ce89ce30ec559b56cbf056f3787e6a1041159ccec9cc365c282537cefc06625733068b5743dc83dcbff3b8d83b3c0e0cc41f0814eefc547ae84857fe25f9aff6c2d76bb475593b7352488cc9d9f10e54461463c95242f94dc9708c29d70c8930f965fa8d4731cc8d99156bfdbe1357df072de9413d3b036d85636a81718f92f2b34162af929c48a47597e7b72fb84c4feb0f677ba14e174796edc4dd33f386621aace3e64072f8beb845f1b78a37ddd250";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"9f39696c042ed8271e1500bb567e8c3f9654e698140d44593b8d6a3e80e6e283fcc1b9d71c14a54fbdea6c40b4418582c557c9301797881ee5172f4ffe73f3843713303b1b023a927e2838eb7fff5f843abc60112a051f1571cef24775d85d90e78d68db259deef536614a32e30fae75bcce1e08eeaf7ca785bf72c041250fa35b803ea70712c7a0c32f0404dd53a5352c60fa576221c7b6bbc063161bbee3a161a416272fdea5ba19d552044333e75cc5dfb6059318e187c21d9e2428a1ed82efe737382afde8fef4fb26891ee21d3952608965429c693d0864311660a2a10fa2973e680713fd94d5424c41a3eee611cf23b87f44b738638afdfbc38d620c11172d7d47";

    bytes internal constant _DELTA_PROOF =
        hex"123a22835a9c52e312a84caf34426fc1ed03529174f7854d6ba5db658a4935675669bb580efa6659b44528ada85cb86312f57caee0a3ffb6babd27de82122e8e00";

    function complianceInstance() internal pure returns (ComplianceInstance memory instance) {
        instance = ComplianceInstance({
            consumed: ConsumedRefs({
                nullifier: _CONSUMED_NULLIFIER,
                commitmentTreeRoot: INITIAL_COMMITMENT_TREE_ROOT,
                logicRef: _CONSUMED_LOGIC_REF
            }),
            created: CreatedRefs({commitment: _CREATED_COMMITMENT, logicRef: _CREATED_LOGIC_REF}),
            unitDeltaX: unitDeltaX,
            unitDeltaY: unitDeltaY
        });
    }

    function complianceUnit() internal pure returns (ComplianceUnit memory unit) {
        unit = ComplianceUnit({proof: _COMPLIANCE_PROOF, instance: complianceInstance()});
    }

    function logicInstance(bool isConsumed) internal pure returns (LogicInstance memory instance) {
        ExpirableBlob[] memory emptyAppData = new ExpirableBlob[](0);
        bytes memory emptyCiphertext = "";

        instance = LogicInstance({
            tag: isConsumed ? _CONSUMED_NULLIFIER : _CREATED_COMMITMENT,
            isConsumed: isConsumed,
            actionTreeRoot: _ACTION_TREE_ROOT,
            ciphertext: emptyCiphertext,
            appData: emptyAppData
        });
    }

    function logicProof(bool isConsumed) internal pure returns (LogicProof memory data) {
        data = LogicProof({
            proof: isConsumed ? _CONSUMED_LOGIC_PROOF : _CREATED_LOGIC_PROOF,
            instance: logicInstance(isConsumed),
            logicRef: isConsumed ? _CONSUMED_LOGIC_REF : _CREATED_LOGIC_REF
        });
    }

    function transaction() internal pure returns (Transaction memory txn) {
        ResourceForwarderCalldataPair[] memory emptyForwarderCallData = new ResourceForwarderCalldataPair[](0);

        LogicInstance[] memory logicInstances = new LogicInstance[](2);
        logicInstances[0] = logicInstance({isConsumed: true});
        logicInstances[1] = logicInstance({isConsumed: false});

        LogicProof[] memory logicProofs = new LogicProof[](2);
        logicProofs[0] = logicProof({isConsumed: true});
        logicProofs[1] = logicProof({isConsumed: true});

        ComplianceUnit[] memory complianceUnits = new ComplianceUnit[](1);
        complianceUnits[0] = complianceUnit();

        Action[] memory actions = new Action[](1);
        actions[0] = Action({
            logicProofs: logicProofs,
            complianceUnits: complianceUnits,
            resourceCalldataPairs: emptyForwarderCallData
        });

        txn = Transaction({actions: actions, deltaProof: _DELTA_PROOF});
    }
}

/*
Transaction {
    actions: [
        Action {
            logicProofs: [
                LogicProof {
                    proof: 0x9f39696c1a34d41dc233a6418070ba23b7fe95ca6791925db284eda01fe7eae73dbfa4862ef5ec07d2beb53206ad120fc0d2131391ade3c7873b39f1466a15b90835c9421c0d453b4b3dc0996e6e0d4a22b487ce89ce30ec559b56cbf056f3787e6a1041159ccec9cc365c282537cefc06625733068b5743dc83dcbff3b8d83b3c0e0cc41f0814eefc547ae84857fe25f9aff6c2d76bb475593b7352488cc9d9f10e54461463c95242f94dc9708c29d70c8930f965fa8d4731cc8d99156bfdbe1357df072de9413d3b036d85636a81718f92f2b34162af929c48a47597e7b72fb84c4feb0f677ba14e174796edc4dd33f386621aace3e64072f8beb845f1b78a37ddd250,
                    instance: LogicInstance {
                        tag: 0x81df30066f64e51cfade805b17718be06eb34aeb3839177dc0a26f470de4a5f1,
                        isConsumed: true,
                        _ACTION_TREE_ROOT: 0x7fead92317c3b897d1f4326a58d7be17e6f6cccaaeb3f4f1a8d478b3a04b641d,
                        ciphertext: 0x,
                        appData: [],
                    },
                    logicRef: 0x67cba0b4837042068f17ce54ca69f481686b8d98bf8ca6b575f61064afb7e7af,
                },
                LogicProof {
                    proof: 0x9f39696c042ed8271e1500bb567e8c3f9654e698140d44593b8d6a3e80e6e283fcc1b9d71c14a54fbdea6c40b4418582c557c9301797881ee5172f4ffe73f3843713303b1b023a927e2838eb7fff5f843abc60112a051f1571cef24775d85d90e78d68db259deef536614a32e30fae75bcce1e08eeaf7ca785bf72c041250fa35b803ea70712c7a0c32f0404dd53a5352c60fa576221c7b6bbc063161bbee3a161a416272fdea5ba19d552044333e75cc5dfb6059318e187c21d9e2428a1ed82efe737382afde8fef4fb26891ee21d3952608965429c693d0864311660a2a10fa2973e680713fd94d5424c41a3eee611cf23b87f44b738638afdfbc38d620c11172d7d47,
                    instance: LogicInstance {
                        tag: 0x38507f7ea10368b792c09076b6514dfa3a2d8f809f5a86f62c8b5d7df04f58dd,
                        isConsumed: false,
                        _ACTION_TREE_ROOT: 0x7fead92317c3b897d1f4326a58d7be17e6f6cccaaeb3f4f1a8d478b3a04b641d,
                        ciphertext: 0x,
                        appData: [],
                    },
                    logicRef: 0x67cba0b4837042068f17ce54ca69f481686b8d98bf8ca6b575f61064afb7e7af,
                },
            ],
            complianceUnits: [
                ComplianceUnit {
                    proof: 0x9f39696c2f86bf280c28d106e506743568544cffb61821c0d6d298a3cc3b93267b7f5876188a6f78487a3409927cddb6590aeb71780059f3763faae19aa5ae265258e3811e812dad801cddc573fa907ddc2e7b0fb76c64690b25a5cd5652c059e52590342a89a9f416e2bdd59d7b3e8bf42613339536ce32532d73eea5d2750c3275598a09933f49f4804fd3bd0bc020c236dbbea5e2443103c9d8534f9c81f79e06c1d00725b905b489b525c44404804d24c83fa2a2668682d1c16bfa461af54cf2ec391501de8124316e26ba4a0e6deba257a3b53204c8349711f26a2af4e8f9c0ee321c9a3199e246a7ccd0386af919c1b6168aa43d58ee496cec5468c997e693e3fc,
                    instance: ComplianceInstance {
                        consumed: ConsumedRefs {
                            nullifier: 0x81df30066f64e51cfade805b17718be06eb34aeb3839177dc0a26f470de4a5f1,
                            logicRef: 0x67cba0b4837042068f17ce54ca69f481686b8d98bf8ca6b575f61064afb7e7af,
                            commitmentTreeRoot: 0x7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3,
                        },
                        created: CreatedRefs {
                            commitment: 0x38507f7ea10368b792c09076b6514dfa3a2d8f809f5a86f62c8b5d7df04f58dd,
                            logicRef: 0x67cba0b4837042068f17ce54ca69f481686b8d98bf8ca6b575f61064afb7e7af,
                        },
                        unitDeltaX: 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
                        unitDeltaY: 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
                    },
                },
            ],
            resourceCalldataPairs: [],
        },
    ],
    deltaProof: 0xf494b59af684e3edc3a56c800387042608c6856ab8445755b4a5325f26b9140b55a412e72b4510981a383e1d0f1ef4c1bfcf3dd43ca7658780daedf7fbbe725901,
}
*/
