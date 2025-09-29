// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../../src/libs/MerkleTree.sol";
import {SHA256} from "../../../src/libs/SHA256.sol";
import {Compliance} from "../../../src/proving/Compliance.sol";
import {Logic} from "../../../src/proving/Logic.sol";
import {Transaction, Action} from "../../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0xbce3179e16ce5344b0f8afdac37c33fc689e1adf78b2eb232dd91369865c2cc8;
    bytes32 internal constant _CREATED_COMMITMENT = 0x82b0a432379e56df9423d3cdd6342a3849df114c7c0646b869b3302beec52ddd;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x159df7d62a1ae65876e4c291a90f4e9d1456c024be5674f61840b6b8c52df319;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"73c457ba235a4fba23cf192167dabc4d92bcd9f0ae282dfe6f97d5faabc0bc7a376cbfcf1ccb85289d1ada8f899ef160a9af5e32fb125b52dac406baa8ecb04f388847421e2fbf629ac45e1c6724493935ebbf98cd31faf69b3c15f1fd47a0564e470eb41223619a04e6516ca0984e1f98a0593a5e1ade6e8c31e5232731b01a79b5cfc424c7de381638ae9c7bb970f63da54c30f02e2fda130faee19135a4ef601a49d508577f28be4fdc710ac9d13476b9015d22fa0ce35190c89b98c408045ffd66b12ae70b7c854b9529b162c964a47369df6548abe1779b39a8e0ab24ae1cc039620f4d1b09863c4fb143dd43eb9b9d00e6a27723447a5521854f3713f1855e455c";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"73c457ba2902f8ccfd40a2de5c738af330acfb0bcdee406540f16707dd0e3a605db27b6f27db74ba617bf5ad555730cabebeaba2aab169b030098bfea65739bb86c6f2ad3016fdd9e740c7ca8f2df8acc6c7b2932480f22d06944a779399727c7b5085ab2efa161d1563dfcbd464de20961938e21484d730d1af6af27aa125a5e0427b162c6370dd5c7a47fd7e32a604093577f6b0647bc3b595f40a57e1511be7b6fe5f2e0f0089eaa6729473d090225c675f5c3ac9338a05a75ac92ee9e5ff42dad7df2f1dd3048a2b5f9cb3a2f04bef7a2c2ccb0947c79afec12a10f1cb0a231c8dc816c1c88ba7b926da8c27b966ca08ba707ce35f157c105749200c541125994841";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"73c457ba10ede53ce450bcbbc7f0afd6da1942ffc684eb598aa29ab694e2ff5eed17d873188cd1c3bdb31ecf00424005fbae823603e843abcee32d8a5249540475f2dc9b27863117b53e23e393fb347276f6accf6aee40f8117f2ecf74151695e9a2f46a1e0e793abfcbe0182b1475b450f00c9fca65f05516a160ff921b64401aedb8041826d31a44924c4a2931b716b8b42c434bec56bd68b561ae5ab0cd466ae46f8429a2f3e2f60a46a73984511a08ef47a7dd55cd9df940aaf47715e965727f5fa3191786e8f4804b7719994aa1a5b6b4acb6acb8cc7f58032bcfd56d0cc900d68815d683519843caa52b58d608f7d00c4964792de65ab259847bf662db818c2e55";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"25c7a9c2c50d30cbe981941a81b4f5b22c46b5258af75767f62be30a7418098d6eeeefb58ca02f33c235afa2a4e13f4bf31dcae989e36e290ff2829639748eb81b";

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
                blob: hex"159df7d62a1ae65876e4c291a90f4e9d1456c024be5674f61840b6b8c52df3190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"159df7d62a1ae65876e4c291a90f4e9d1456c024be5674f61840b6b8c52df3190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925bce3179e16ce5344b0f8afdac37c33fc689e1adf78b2eb232dd91369865c2cc8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
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

        txn = Transaction({actions: actions, deltaProof: _DELTA_PROOF, aggregationProof: ""});
    }

    function commitmentTreeRoot() internal pure returns (bytes32 root) {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = _CONSUMED_NULLIFIER;
        leaves[1] = _CREATED_COMMITMENT;

        root = leaves.computeRoot();
    }
}
