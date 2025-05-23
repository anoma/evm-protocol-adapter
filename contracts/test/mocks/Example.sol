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
    bytes32 internal constant _CONSUMED_NULLIFIER = 0x81df30066f64e51cfade805b17718be06eb34aeb3839177dc0a26f470de4a5f1;
    bytes32 internal constant _CREATED_COMMITMENT = 0x38507f7ea10368b792c09076b6514dfa3a2d8f809f5a86f62c8b5d7df04f58dd;

    bytes32 internal constant _ACTION_TREE_ROOT = 0x7fead92317c3b897d1f4326a58d7be17e6f6cccaaeb3f4f1a8d478b3a04b641d;

    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x67cba0b4837042068f17ce54ca69f481686b8d98bf8ca6b575f61064afb7e7af;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _COMPLIANCE_PROOF =
        hex"9f39696c1409d4184b5f8217bb9d32ae6f24755e32c307f78ef357c8c656dfe3a3cb40a60a39bf1fc9a38b11aa506a27a59a57a78358f02a750ba62ee2196d2b9e2d5d87108dbc0d558211f9afc1a01b78536a5a073df0ed360ff8a6777280c31066ef6602e91c67e48ab76f67a27072ce47a9a256edde35c6ab9e4ee8c7e92dc95b364511eb207fd20be212ca7200bc71736ae499037d35279d3728912e696bac380c600b146e6dc7768e14fc121391032e6422a5dafd5eac4710a80f05474eb02d5b320ee1a7eef75ed1c84e424ac16192d91589c099f53d235e9d7de9fa637c79d6cf11135489abf2d57f9dc2d9d13a489da18fabebfb435e99489ef6fb7ff3f85f3f";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"9f39696c2528c347e86ed3589c25d2982e45c3d380a8bbd498a4a948df7bd0afd14b30d127206578495ceea33a6155532836a2af6623e9be3de60340a0f36bb3e7ad76480095cc0c40c20f6adf9f23bcf6268b872569b7b87ce2d9dbf3a8ea1d42fe868408fa2cc6af37179002346c1605c47fabc3f13a43c22009896eb5c05a71de3e682e3a4d9f68de0e901006be7dd3ba12a6f60481726cdb9987cbb290fd8ed317151f0abdbd39325824c451180a1479fd0dbc3213a9d7b339baa624cec56703d03417627befedc84557ea8a53a6669db078077e7c98e1aa3f7531bdcd4e07ba0abc04db292a66fa3ec2faa8a717a959da5fe4b3bfbc1de614b67f039953dd1401d1";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"9f39696c020afc48f494e99955ddacf3e03af85ed9794bf8e8a8598394925f108b00659223f46287268e833fee127f94e94c6692e5c4ecc3ec3d53b094fa136a551a637904f2696a1d61819d677e842133f3fde23b171980d849278c72af2df585cc2dec12dddb29b3a69db5ea95c86acb8c4b9c7c94bcad34adeb1edf167ce70b15d56f1012594bba5a406c2c3da7e4479f8a07b83c662ba0995ac75a442bc4e69fcdd72ab16cc74b5d80bdf269e937e9e6b4abe8a23395609f7fa08fd00b577618a73420b37ff6c37a480b02612b90bc6a282e3f94c60605f463b8bf2fe763eab9c70d1dc50ec078e986fcdeba2222fb2000c09dc8d25228be96364fe44d8c0bcb579e";

    bytes internal constant _DELTA_PROOF =
        hex"f494b59af684e3edc3a56c800387042608c6856ab8445755b4a5325f26b9140b55a412e72b4510981a383e1d0f1ef4c1bfcf3dd43ca7658780daedf7fbbe72591c";

    function complianceInstance() internal pure returns (ComplianceInstance memory instance) {
        instance = ComplianceInstance({
            consumed: ConsumedRefs({
                nullifier: _CONSUMED_NULLIFIER,
                commitmentTreeRoot: INITIAL_COMMITMENT_TREE_ROOT,
                logicRef: _CONSUMED_LOGIC_REF
            }),
            created: CreatedRefs({commitment: _CREATED_COMMITMENT, logicRef: _CREATED_LOGIC_REF}),
            unitDeltaX: _UNIT_DELTA_X,
            unitDeltaY: _UNIT_DELTA_Y
        });
    }

    function complianceUnit() internal pure returns (ComplianceUnit memory unit) {
        unit = ComplianceUnit({proof: _COMPLIANCE_PROOF, instance: complianceInstance()});
    }

    function logicInstance(bool isConsumed) internal pure returns (LogicInstance memory instance) {
        ExpirableBlob[] memory emptyAppData = new ExpirableBlob[](0);
        bytes[] memory emptyCiphertexts = new bytes[](0);

        instance = LogicInstance({
            tag: isConsumed ? _CONSUMED_NULLIFIER : _CREATED_COMMITMENT,
            isConsumed: isConsumed,
            actionTreeRoot: _ACTION_TREE_ROOT,
            ciphertexts: emptyCiphertexts,
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

        LogicProof[] memory logicProofs = new LogicProof[](2);
        logicProofs[0] = logicProof({isConsumed: true});
        logicProofs[1] = logicProof({isConsumed: false});

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
