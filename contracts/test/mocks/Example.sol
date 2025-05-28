// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {
    ExpirableBlob,
    DeletionCriterion,
    ComplianceInstance,
    CreatedRefs,
    ConsumedRefs,
    ComplianceUnit,
    LogicInstance,
    LogicProof,
    Transaction,
    ResourceForwarderCalldataPair,
    Action
} from "../../src/Types.sol";
import {INITIAL_COMMITMENT_TREE_ROOT} from "../state/CommitmentAccumulator.t.sol";

library Example {
    bytes32 internal constant _CONSUMED_NULLIFIER = 0x155d957de29e96a50517f3c033e1c618e697795e6853a5dc18ce684289d25497;
    bytes32 internal constant _CREATED_COMMITMENT = 0x9c590db144abb0434267475ac46554bc71377b1e678a6ce7dd86c8559b97cf1c;
    bytes32 internal constant _ACTION_TREE_ROOT = 0x190745ccc5568e6501a640df6f543b178b1bd4a058b6e7fea993e6697459e2d8;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x6d49f043c79b753b897d478c617e06babc70c52259097b46ba618be8cb4a9e9b;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"9f39696c0e4275bf0e74b40f24a4cbcd4886f2fb867edc62d6149d3263701521a5f4a6d1227e9b1248f01724c1a7971d21e6273c92876cb65e25e41c5a3549e9d99be7ee05845bf68722c5e6fa008c5e83efa9b5fa9b7e857e2d1a89a5cddf7f43bc44601270355c20d30e3cc9de757cb68a458c075b3b86e0adc517adce4ed76e03123f09b880092909a330bb33fc889e33da4e0077222c2eb72dba741881f45d0680ad1a7e001d1a4c4676883417dcc8a33d45d8847d6a8c92ce72fdd27893fa0fe33b081ce1330e1540ab7fe6e1e9c7a1345f65d0421eb1f3d5bd2142c318e73e03da142acd1edd0c136610985f841326e500d9d086041817a4cf7b589c75d1f7bc64";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"9f39696c219fcb6d794c83af38145a0b250c6f9052246e67b88afe5106ba3b644141250d2937bcb3e72e533121d9f7da83b260f4f4cba417a3f5a00fde6cca2dc11b1d7027b6ae5b7cff23180ebf551d160820b4f07076a0047a78355ffcd7f89b6a4391023fe99c03fee1f7703646d5470bc1755ce33bdc12f6008ab2c322c816434ab31114eeeb889beb3bb4ae88de5fe3294a72f883a8a102d21aa2730701e00d0d6b2a0ebec932997568216d810d88470d8a690cfc730adb523759a28fcb16f04d14073781a4e4ddb86bbfa46e6a64dbb3edbadcc06f225ed4a0d23fba444938794607d6cc5219c088cc0b6b6e589f97ddaa437b2d5651628065943f0f5bbbbf6837";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"9f39696c11994744da34669c4800354d1637edfde4f62ab8e6c905b097d71c9a138d53e212213847f98ba06cbbc718558b0fa7c8383c9a4ef8a9b9fe3710d23422753bcb21db64a575c71b20b3f4698277d2b79568e8ded30da8061c1e3e1154fde6784b0f17f45ff729c609f9ee9dd2c4c85cfd200d0e7225cdbdfe50e6fdfb5eb06b8604d554b77cce45ec770ed852512731144ed94f6b059b930c6ec7c3244bf9090c200e515986412d5143aed4e9c21f949f3357e74c9240eb53f7f58479bf446cda0b47e56c92383239754e4d1310a1aa2f7f7d0ea06dda0b998a37d890dd45835a10abb5159c9c25d29575bb9346ed6c403a8a38a1496f8d321854b4aa89e969a1";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"f464b94a2c5729fc15bc6ffe88a2ec3ee37d9f443f3598fb0d4a57de982e04802c57e886e5bf651e44e46c7038fb5d6ddec7bdd6ed7e0f67f9b481fd5711f7821b";

    function ciphertext() internal pure returns (bytes memory cipher) {
        cipher = hex"3f0000007f000000bf000000ff000000";
    }

    function expirableBlobs() internal pure returns (ExpirableBlob[] memory blobs) {
        blobs = new ExpirableBlob[](2);
        blobs[0] = ExpirableBlob({
            blob: hex"1f0000003f0000005f0000007f000000",
            deletionCriterion: DeletionCriterion.Immediately
        });
        blobs[1] =
            ExpirableBlob({blob: hex"9f000000bf000000df000000ff000000", deletionCriterion: DeletionCriterion.Never});
    }

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
        instance = LogicInstance({
            tag: isConsumed ? _CONSUMED_NULLIFIER : _CREATED_COMMITMENT,
            isConsumed: isConsumed,
            actionTreeRoot: _ACTION_TREE_ROOT,
            ciphertext: ciphertext(),
            appData: expirableBlobs()
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
