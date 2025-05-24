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
        hex"9f39696c26f5ae5e2f1c5ece7cc3e652b9dd1ba4e500b9f56aebd3fae8f95da8babbdd9f1be7a0e67991fedd2dcb89d46b958aa0e4e902bc3a180492963441d37f49a8322c2b2eafd9f64efd9262c926e2cab478bac988d7215a4cedc15e3c87203639e404a84115ef2c516422f4880e963f1153a0e30f5100147e9049a4badce857abe52d16f30980cf79c8c83688524cc0e4b0b90ff52fcc6df8dd57cef403c750991b26c5cfdd9e02844fce789f4c7f6c1bcf48127a79fe95bc5d0ac421330f0748b32cc534d7a02204bebfc1da5551fdf08b4e5d2406994870ae0eec1da1cbaa359524faa1cfb89abd10c94ee76fbd8ad334a579fa60297536ea523943515476e982";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"9f39696c2c7ee5c095e48e28139b47814e713bd8fc92bcd452fb3e2f54fa58d5651ab4131d175c5f8e48fe47c9d255c5335e919df1d4451dcf94580cbd684833ceeaa0e3006bf6f4b8064cbafd58d64142d63c7ca745b0c58b9a0300b8ca689c9be8d7d7242c4d13c6c54087969f95645c771b058fe89698d685222a7406fb366d291f2e2b9aa8670c3ed42f0e8f0af50071d7fe39501394495d2b6b2b2ffeb7cb6768ca2a292124aaaf31a4a24d118ba4741008c233691e6d378ef4ee66d20dc9af5e6c2a3c18aecbe0f9ff0e05c29e4087c086566e66c79b9a637d1f34452c5868edcd287694769283bd0904f2d170a07dbb940d7d098fe4854b9c108575672f09c8b4";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"9f39696c0b109d8fab21ddc35b63ce485454b929ed0ccfc7db51cb317256ca3ad8f183b30428cfcb2f6dbd9393ba36a58e57774d53281f5439fb6c251b827064f2b5f10810b0a84c089cf81b417848d4056cabf17f026b560faa470a25590fdf4422992c2a492b163dfa11bb2c323eba94d85550ae46c5da1908c8d32fde8d7a03e762bf1c96c75d8b5a401366aa2a9f530fd8508a9ed5acc2a6abf1193a3ec3a1b04bc82f2c907094a96807e05777da6bae40a4bd9f1874e712aacaa2c36348876715f80e29d4ee3de142aea511b8eba6d12302ea3506089d02dcc786fa8e0492f6afc90597d1a3a3f34c90cbe94f85b457b3e8c75be016cf11d881960d011aebe7d9b0";

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
EVM Tx:
Transaction {
    actions: [
        Action {
            logicProofs: [
                LogicProof {
                    proof: 0x9f39696c26f5ae5e2f1c5ece7cc3e652b9dd1ba4e500b9f56aebd3fae8f95da8babbdd9f1be7a0e67991fedd2dcb89d46b958aa0e4e902bc3a180492963441d37f49a8322c2b2eafd9f64efd9262c926e2cab478bac988d7215a4cedc15e3c87203639e404a84115ef2c516422f4880e963f1153a0e30f5100147e9049a4badce857abe52d16f30980cf79c8c83688524cc0e4b0b90ff52fcc6df8dd57cef403c750991b26c5cfdd9e02844fce789f4c7f6c1bcf48127a79fe95bc5d0ac421330f0748b32cc534d7a02204bebfc1da5551fdf08b4e5d2406994870ae0eec1da1cbaa359524faa1cfb89abd10c94ee76fbd8ad334a579fa60297536ea523943515476e982,
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
                    proof: 0x9f39696c2c7ee5c095e48e28139b47814e713bd8fc92bcd452fb3e2f54fa58d5651ab4131d175c5f8e48fe47c9d255c5335e919df1d4451dcf94580cbd684833ceeaa0e3006bf6f4b8064cbafd58d64142d63c7ca745b0c58b9a0300b8ca689c9be8d7d7242c4d13c6c54087969f95645c771b058fe89698d685222a7406fb366d291f2e2b9aa8670c3ed42f0e8f0af50071d7fe39501394495d2b6b2b2ffeb7cb6768ca2a292124aaaf31a4a24d118ba4741008c233691e6d378ef4ee66d20dc9af5e6c2a3c18aecbe0f9ff0e05c29e4087c086566e66c79b9a637d1f34452c5868edcd287694769283bd0904f2d170a07dbb940d7d098fe4854b9c108575672f09c8b4,
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
                    proof: 0x9f39696c0b109d8fab21ddc35b63ce485454b929ed0ccfc7db51cb317256ca3ad8f183b30428cfcb2f6dbd9393ba36a58e57774d53281f5439fb6c251b827064f2b5f10810b0a84c089cf81b417848d4056cabf17f026b560faa470a25590fdf4422992c2a492b163dfa11bb2c323eba94d85550ae46c5da1908c8d32fde8d7a03e762bf1c96c75d8b5a401366aa2a9f530fd8508a9ed5acc2a6abf1193a3ec3a1b04bc82f2c907094a96807e05777da6bae40a4bd9f1874e712aacaa2c36348876715f80e29d4ee3de142aea511b8eba6d12302ea3506089d02dcc786fa8e0492f6afc90597d1a3a3f34c90cbe94f85b457b3e8c75be016cf11d881960d011aebe7d9b0,
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

/*
Transaction {
    actions: [
        Action {
            logicProofs: [
                LogicProof {
                    proof: 0x9f39696c02c0e53aa2dd94e48aa2ff0a438835214e1b944551b87e8d3378003c23dc9db816a7c651cad325e66615baa33cacb34ce7ce4c8365fed8d14b946238ac9abb352e318650ec42894e88f8dc94633bdb0d17d55395f3240fdbcbaecafceb0d52501b0b920fea6fb3d3c2fd834c7b1a53c97ec360752bc6d0addccb919854206ca224ce1761be1ecacaa40a34f0a80b44819f19c6c5feb10553bf1d6d411f5c29ca0e4441ae263e2ec3ccccc2c71e3ddc8adae5ce5358ef6256baff03d3aa5f8f110d624503211748159ecb196fdb41ee1d46e7ded43f093eec622e0d530f2d48241937ef1664969ce4a0c934f30f9b4b853e74293af1ad245838acf2a0f8eae05a,
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
                    proof: 0x9f39696c21d20adc8f1cff2dfc24e31a28460985fa645c79859e2446a66b9268b8bd77360fc0f05ca556e9f2782a175a7f9f18015d9903bc4f473d6e108a6dbcd20834aa16065240e7a2fd7d8087912161ca1ed0753007cd63d3bb70b9e368998ad2ac830fec23b700c6d002f3429b4fb5b0f683490935d5c3b212b0fdb259623051849f202ebb36cdd80640ee82d648814ef260516d72269706af40006ccc64511758921af07aa78e0ccd27a19216fff015a1aa18f80253ccae990fae550858b2368dc306d18f43c4bbdea431e9eb43c03834d564156d44d97e73b071d47686311894c80b23ee8695478fe762c06f1c8e40b4c7e0d2fc2deac47861007f4e68904eadff,
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
                    proof: 0x9f39696c2b52b86d30a989425c95ee530c4d70015afbcc9e2036bbbbbe32f22139d7a5001c15d06cbdd63c07bcda429df84cf6dc13191c010270452583c4205d49dec0002113e68ef521e279f5d35249762e73b378b0146be0031d89f4f3759a51bcf56e027aacb55597227cdb10387f03e66c310182569d93f5889f66b4331cf75924c02534b4e6a32901965bb62ddf400de2cf5c02fe2c3e94f6f79a92a9a2298123a30caf2d028ab1e38d4d5c5b0e337709ad9fa52cc592c324bfc396ce3a71540ca108acc378ebfca12dab204ede492d43d437d8ee1893c897152372fc9d0b176bcd287d7272ce7897ff39fc0d16678beae5035a67eb40aa7510417da19d357e4548,
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

/*

EVM Tx:
AdapterTransaction {
    actions: [
        AdapterAction {
            compliance_units: [
                AdapterComplianceUnit {
                    proof: [ 159, 57, 105, 108, 7, 28, 33, 249, 111, 154, 215, 164, 75, 239, 204, 240, 183, 15, 223, 94, 57, 128, 253, 23, 208, 147, 127, 235, 172, 114, 73, 60, 233, 97, 247, 162, 46, 74, 46, 67, 84, 22, 52, 186, 16, 120, 73, 43, 119, 249, 230, 23, 207, 71, 252, 116, 38, 37, 228, 68, 105, 255, 145, 105, 43, 229, 240, 47, 12, 111, 159, 65, 6, 56, 86, 7, 96, 46, 143, 151, 194, 239, 246, 88, 18, 245, 6, 248, 85, 250, 194, 32, 139, 153, 105, 47, 173, 209, 48, 121, 9, 0, 120, 39, 55, 99, 130, 19, 158, 149, 3, 149, 215, 225, 105, 55, 138, 82, 177, 180, 85, 228, 50, 149, 253, 132, 64, 118, 50, 60, 75, 184, 43, 94, 147, 195, 2, 44, 101, 7, 174, 196, 4, 60, 251, 52, 7, 109, 115, 96, 32, 104, 80, 244, 221, 104, 201, 174, 242, 182, 66, 186, 4, 99, 18, 175, 100, 64, 253, 193, 79, 27, 69, 215, 100, 90, 111, 105, 240, 65, 171, 15, 251, 90, 244, 141, 169, 175, 37, 229, 207, 36, 229, 133, 207, 215, 28, 106, 80, 70, 24, 30, 155, 218, 27, 104, 164, 244, 216, 79, 38, 30, 83, 230, 253, 197, 40, 112, 231, 165, 49, 247, 95, 238, 34, 185, 87, 236, 16, 170, 174, 141, 251, 150, 181, 196, 15, 145, 238, 103, 229, 65, 220, 90, 93, 124, 154, 151, 56, 216, 188, 202, 241, 140, 31, 33, 64, 120, 254, 236,
                    ],
                    instance: ComplianceInstance {
                        consumed_nullifier: Digest(20439f8d30d860515d4ac2b35314e63823389d7af3f901dd0f3b8241134a0f99),
                        consumed_logic_ref: Digest(8035182c92dfbd6da397ac9826667b88cd98c7ea82ca2079c562f09ff0950329),
                        consumed_commitment_tree_root: Digest(7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3),
                        created_commitment: Digest(19e5ca72229a57cf2a60cb11c43b6b16a9246e26fed8303c5b4685458191c66d),
                        created_logic_ref: Digest(8035182c92dfbd6da397ac9826667b88cd98c7ea82ca2079c562f09ff0950329),
                        delta_x: Digest(79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798),
                        delta_y: Digest(483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8),
                    },
                },
            ],
            logic_proofs: [
                AdapterLogicProof {
                    verifying_key: Digest(8035182c92dfbd6da397ac9826667b88cd98c7ea82ca2079c562f09ff0950329),
                    proof: [ 159, 57, 105, 108, 1, 239, 83, 33, 11, 25, 215, 93, 46, 138, 173, 74, 146, 176, 84, 107, 141, 14, 163, 112, 34, 194, 73, 159, 190, 63, 215, 99, 20, 84, 99, 7, 27, 234, 245, 103, 170, 104, 65, 228, 168, 251, 92, 180, 3, 55, 39, 64, 21, 205, 209, 237, 120, 240, 37, 13, 19, 160, 76, 177, 56, 34, 30, 115, 46, 55, 227, 68, 170, 173, 5, 199, 64, 151, 38, 254, 4, 232, 187, 6, 91, 178, 195, 58, 156, 95, 57, 131, 148, 135, 194, 126, 145, 16, 244, 96, 23, 188, 169, 151, 65, 7, 156, 227, 189, 125, 17, 78, 220, 220, 176, 199, 104, 185, 40, 77, 55, 100, 226, 148, 176, 179, 155, 24, 2, 164, 89, 210, 46, 250, 187, 110, 21, 144, 42, 138, 122, 36, 254, 175, 206, 0, 247, 196, 100, 56, 25, 4, 195, 91, 197, 185, 168, 65, 181, 85, 187, 157, 119, 21, 35, 227, 234, 105, 225, 9, 85, 171, 80, 212, 162, 2, 181, 60, 47, 9, 104, 156, 96, 10, 187, 68, 29, 131, 25, 119, 56, 97, 53, 44, 67, 146, 23, 55, 87, 133, 213, 76, 20, 135, 48, 146, 29, 99, 46, 54, 11, 5, 68, 12, 47, 213, 29, 48, 29, 83, 203, 5, 255, 196, 225, 84, 153, 71, 13, 187, 38, 109, 224, 244, 70, 127, 172, 152, 87, 141, 140, 56, 45, 56, 141, 173, 15, 231, 209, 250, 15, 105, 159, 34, 199, 45, 53, 51, 179, 75,
                    ],
                    instance: AdapterLogicInstance {
                        tag: Digest(20439f8d30d860515d4ac2b35314e63823389d7af3f901dd0f3b8241134a0f99),
                        is_consumed: true,
                        root: Digest(9a7962edc0c80a321a76554ae7e9795081c4155873a98071d9bf262f522ef78a),
                        cipher: [
                             63, 0, 0, 0,
                            127, 0, 0, 0,
                            191, 0, 0, 0,
                            255, 0, 0, 0,
                        ],
                        app_data: [
                            AdapterExpirableBlob {
                                blob: [
                                     31, 0, 0, 0, 
                                     63, 0, 0, 0, 
                                     95, 0, 0, 0, 
                                    127, 0, 0, 0,
                                ],
                                deletion_criterion: 0,
                            },
                            AdapterExpirableBlob {
                                blob: [ 
                                    159, 0, 0, 0, 
                                    191, 0, 0, 0, 
                                    223, 0, 0, 0, 
                                    255, 0, 0, 0,
                                ],
                                deletion_criterion: 1,
                            },
                        ],
                    },
                },
                AdapterLogicProof {
                    verifying_key: Digest(8035182c92dfbd6da397ac9826667b88cd98c7ea82ca2079c562f09ff0950329),
                    proof: [ 159, 57, 105, 108, 30, 54, 31, 107, 217, 20, 190, 113, 24, 154, 33, 230, 249, 11, 110, 250, 93, 240, 79, 202, 96, 36, 216, 227, 193, 159, 64, 129, 11, 249, 146, 139, 1, 100, 65, 83, 209, 157, 235, 182, 145, 131, 225, 18, 5, 164, 152, 93, 212, 150, 253, 117, 224, 53, 192, 124, 57, 170, 88, 159, 162, 21, 115, 73, 41, 154, 2, 82, 49, 199, 35, 132, 205, 104, 104, 159, 55, 1, 250, 76, 52, 12, 68, 244, 129, 249, 146, 153, 176, 101, 159, 174, 192, 71, 231, 188, 41, 119, 175, 62, 202, 195, 145, 148, 16, 83, 223, 205, 98, 220, 18, 227, 64, 206, 158, 150, 227, 28, 197, 47, 25, 229, 188, 102, 245, 219, 96, 54, 43, 194, 106, 80, 132, 122, 51, 181, 71, 5, 133, 91, 191, 159, 6, 64, 157, 121, 109, 64, 19, 74, 72, 106, 68, 119, 13, 180, 242, 8, 216, 253, 23, 134, 145, 7, 91, 184, 162, 74, 115, 100, 121, 33, 207, 65, 242, 243, 106, 177, 202, 252, 202, 46, 152, 154, 199, 64, 105, 30, 254, 150, 114, 209, 15, 169, 76, 251, 208, 236, 239, 26, 22, 98, 84, 219, 2, 92, 188, 131, 213, 242, 113, 70, 93, 191, 110, 73, 235, 164, 227, 8, 72, 57, 231, 195, 16, 181, 116, 7, 169, 4, 102, 65, 207, 102, 139, 38, 79, 88, 210, 15, 181, 236, 43, 124, 98, 35, 201, 128, 183, 142, 208, 6, 107, 213, 242, 214,
                    ],
                    instance: AdapterLogicInstance {
                        tag: Digest(19e5ca72229a57cf2a60cb11c43b6b16a9246e26fed8303c5b4685458191c66d),
                        is_consumed: false,
                        root: Digest(9a7962edc0c80a321a76554ae7e9795081c4155873a98071d9bf262f522ef78a),
                        cipher: [
                             63, 0, 0, 0,
                            127, 0, 0, 0,
                            191, 0, 0, 0,
                            255, 0, 0, 0,
                        ],
                        app_data: [
                            AdapterExpirableBlob {
                                blob: [
                                     31, 0, 0, 0, 
                                     63, 0, 0, 0, 
                                     95, 0, 0, 0, 
                                    127, 0, 0, 0,
                                ],
                                deletion_criterion: 0,
                            },
                            AdapterExpirableBlob {
                                blob: [ 
                                    159, 0, 0, 0, 
                                    191, 0, 0, 0, 
                                    223, 0, 0, 0, 
                                    255, 0, 0, 0,
                                ],
                                deletion_criterion: 1,
                            },
                        ],
                    },
                },
            ],
        },
    ],
    delta_proof: [ 101, 118, 70, 61, 176, 226, 62, 150, 196, 80, 131, 239, 77, 64, 200, 133, 224, 92, 31, 237, 155, 180, 12, 186, 201, 114, 236, 162, 26, 83, 148, 158, 111, 193, 82, 54, 10, 181, 170, 121, 140, 76, 114, 218, 45, 205, 2, 245, 236, 118, 124, 169, 255, 151, 84, 132, 174, 64, 118, 161, 104, 168, 153, 149, 27,
    ],
}

*/
