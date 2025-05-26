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
    bytes32 internal constant _CONSUMED_NULLIFIER = 0x47d140b002864789e014b2dbc222d2bce62a6ef80f0eb1995c758dffb88dbe32;
    bytes32 internal constant _CREATED_COMMITMENT = 0x0b7059ca4344dc9ebb69f668044c60241e2302cd42122f049a82dfdc539b4aa0;
    bytes32 internal constant _ACTION_TREE_ROOT = 0xab82530843896e639200bad250cbef46f7f2fae9115ba14958076768c167e342;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x009962e2c1c0ac9106f612ed26169335b7f304e3640dfd20c52821aaa71cd2db;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"9f39696c07babbd484e959b96e8946e5633c5f3eb3c89dac5b7b8e872ccf0955175a786d2bbe51eddc10c60540a3e02df36d9e29f0c70581a0c6522329350a2ac34087412883b8247d7e60261ec73c8062edda070660e4865e46a8985a5a02d9a63220c624126a44df3ba75b25905361429104e4b70f14dccf8f3b76f0ee51c38971481809922efd089d96ca9e5b9be91a53a0e6893ab8da5f4ed7209ae0e305c83630600c5ec00c593fc88a5ea809485e73f7a6b081304837e071f22d08b1cc1392b13b24f5710a8ac92feeb61891a20cf8b972a1a87c475d800e72b60f6e26d719a820281d892c92f90d00b1303a7a0f795db30576b163093d86eb3522395a8f6f75d6";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"9f39696c2ecefc878b7edd6ac0482898e0f595d52f274da835f2ab49598279eaf4543ee206b4021f277e3bca871a5b515137049dfee5832f9ba67faca8fb068551a637b70215ed13c52838310c841e2a51e1545051a7151ecc2b63086e7bd7171f09e0752ffa224012a81a4c6414d65af28a6b6265e26653b360c13c01e19ea075e17cbb2d560d81fc26ea3e51f40c84378f69256068c2711ba805f84fbb2b491d22642919a363cd185ef0a2b8ab6e9b72c6e39a714294ea1e0cb7256af23c7faf7bbfe41de1bf7c98ec70dcf0ffa2f293d11f77ab3b2ad4513e278b5ec6c3a326d164c01330ff82fa8d0addf12c939cc15c90fb2471c87c2e659f70d8d913dfdc9fcb88";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"9f39696c13644e07f84dbbf45f1ebe7e363de1ae8241c0001e592f96bf808c5d20ca9a981b9fa23b60c7c0d02736d9c9c4fc6c47eafcc84d14cb0abb612be42501ef13a50af3a6550dd6eeab4739d7ecc436f10b8e605aab1c12a8b23d6d81bc040ec8812987ae0df60cf05f7f595b96a53ef550f26d756837ca214da93d499167219d5e1145d36b5b53063e41a9b303b9bebcaec8bafaea6cc051c12d8985ff28aa1e4b0d1b35e913fb8370749384769e9f568498c735b7ae94f93d7aa667145378f29b1684ae6fae6b51e1d415319b7ffac7c8473514ae6656aee9fc0b0b43bf46c6de0e8abc9a8eabb3e038e485fb18460ece7578c8e87c143eabdd7dc6a2bc74ac89";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"2f87f84992b94ce2cd69e2c9540e4b3c0f383ee6b7639344fe97697ce64d23e2091d33efb675348ddede05dc45c3158885bfccec1bcb4e84c5401917a3f353e91c";

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

/*
Transaction {
    actions: [
        Action {
            logicProofs: [
                LogicProof {
                    proof: 0x9f39696c07babbd484e959b96e8946e5633c5f3eb3c89dac5b7b8e872ccf0955175a786d2bbe51eddc10c60540a3e02df36d9e29f0c70581a0c6522329350a2ac34087412883b8247d7e60261ec73c8062edda070660e4865e46a8985a5a02d9a63220c624126a44df3ba75b25905361429104e4b70f14dccf8f3b76f0ee51c38971481809922efd089d96ca9e5b9be91a53a0e6893ab8da5f4ed7209ae0e305c83630600c5ec00c593fc88a5ea809485e73f7a6b081304837e071f22d08b1cc1392b13b24f5710a8ac92feeb61891a20cf8b972a1a87c475d800e72b60f6e26d719a820281d892c92f90d00b1303a7a0f795db30576b163093d86eb3522395a8f6f75d6,
                    instance: LogicInstance {
                        tag: 0x47d140b002864789e014b2dbc222d2bce62a6ef80f0eb1995c758dffb88dbe32,
                        isConsumed: true,
                        actionTreeRoot: 0xab82530843896e639200bad250cbef46f7f2fae9115ba14958076768c167e342,
                        ciphertext: 0x3f0000007f000000bf000000ff000000,
                        appData: [
                            ExpirableBlob {
                                deletionCriterion: 0,
                                blob: 0x1f0000003f0000005f0000007f000000,
                            },
                            ExpirableBlob {
                                deletionCriterion: 1,
                                blob: 0x9f000000bf000000df000000ff000000,
                            },
                        ],
                    },
                    logicRef: 0x009962e2c1c0ac9106f612ed26169335b7f304e3640dfd20c52821aaa71cd2db,
                },
                LogicProof {
                    proof: 0x9f39696c2ecefc878b7edd6ac0482898e0f595d52f274da835f2ab49598279eaf4543ee206b4021f277e3bca871a5b515137049dfee5832f9ba67faca8fb068551a637b70215ed13c52838310c841e2a51e1545051a7151ecc2b63086e7bd7171f09e0752ffa224012a81a4c6414d65af28a6b6265e26653b360c13c01e19ea075e17cbb2d560d81fc26ea3e51f40c84378f69256068c2711ba805f84fbb2b491d22642919a363cd185ef0a2b8ab6e9b72c6e39a714294ea1e0cb7256af23c7faf7bbfe41de1bf7c98ec70dcf0ffa2f293d11f77ab3b2ad4513e278b5ec6c3a326d164c01330ff82fa8d0addf12c939cc15c90fb2471c87c2e659f70d8d913dfdc9fcb88,
                    instance: LogicInstance {
                        tag: 0x0b7059ca4344dc9ebb69f668044c60241e2302cd42122f049a82dfdc539b4aa0,
                        isConsumed: false,
                        actionTreeRoot: 0xab82530843896e639200bad250cbef46f7f2fae9115ba14958076768c167e342,
                        ciphertext: 0x3f0000007f000000bf000000ff000000,
                        appData: [
                            ExpirableBlob {
                                deletionCriterion: 0,
                                blob: 0x1f0000003f0000005f0000007f000000,
                            },
                            ExpirableBlob {
                                deletionCriterion: 1,
                                blob: 0x9f000000bf000000df000000ff000000,
                            },
                        ],
                    },
                    logicRef: 0x009962e2c1c0ac9106f612ed26169335b7f304e3640dfd20c52821aaa71cd2db,
                },
            ],
            complianceUnits: [
                ComplianceUnit {
                    proof: 0x9f39696c13644e07f84dbbf45f1ebe7e363de1ae8241c0001e592f96bf808c5d20ca9a981b9fa23b60c7c0d02736d9c9c4fc6c47eafcc84d14cb0abb612be42501ef13a50af3a6550dd6eeab4739d7ecc436f10b8e605aab1c12a8b23d6d81bc040ec8812987ae0df60cf05f7f595b96a53ef550f26d756837ca214da93d499167219d5e1145d36b5b53063e41a9b303b9bebcaec8bafaea6cc051c12d8985ff28aa1e4b0d1b35e913fb8370749384769e9f568498c735b7ae94f93d7aa667145378f29b1684ae6fae6b51e1d415319b7ffac7c8473514ae6656aee9fc0b0b43bf46c6de0e8abc9a8eabb3e038e485fb18460ece7578c8e87c143eabdd7dc6a2bc74ac89,
                    instance: ComplianceInstance {
                        consumed: ConsumedRefs {
                            nullifier: 0x47d140b002864789e014b2dbc222d2bce62a6ef80f0eb1995c758dffb88dbe32,
                            logicRef: 0x009962e2c1c0ac9106f612ed26169335b7f304e3640dfd20c52821aaa71cd2db,
                            commitmentTreeRoot: 0x7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3,
                        },
                        created: CreatedRefs {
                            commitment: 0x0b7059ca4344dc9ebb69f668044c60241e2302cd42122f049a82dfdc539b4aa0,
                            logicRef: 0x009962e2c1c0ac9106f612ed26169335b7f304e3640dfd20c52821aaa71cd2db,
                        },
                        unitDeltaX: 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
                        unitDeltaY: 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8,
                    },
                },
            ],
            resourceCalldataPairs: [],
        },
    ],
    deltaProof: 0x2f87f84992b94ce2cd69e2c9540e4b3c0f383ee6b7639344fe97697ce64d23e2091d33efb675348ddede05dc45c3158885bfccec1bcb4e84c5401917a3f353e91c,
}
*/
