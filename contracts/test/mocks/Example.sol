// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "../../src/proving/Compliance.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {Transaction, ResourceForwarderCalldataPair, Action} from "../../src/Types.sol";

import {INITIAL_COMMITMENT_TREE_ROOT} from "../state/CommitmentAccumulator.t.sol";

library Example {
    bytes32 internal constant _CONSUMED_NULLIFIER = 0x155d957de29e96a50517f3c033e1c618e697795e6853a5dc18ce684289d25497;
    bytes32 internal constant _CREATED_COMMITMENT = 0x9c590db144abb0434267475ac46554bc71377b1e678a6ce7dd86c8559b97cf1c;
    bytes32 internal constant _ACTION_TREE_ROOT = 0x190745ccc5568e6501a640df6f543b178b1bd4a058b6e7fea993e6697459e2d8;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x6d49f043c79b753b897d478c617e06babc70c52259097b46ba618be8cb4a9e9b;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"9f39696c24c6a045434845e665d1cd7325abce657a45003425d3bebaaf347bdebd2752f91c2f06486cde04831ff104155a642fddcbe07a35a0d83b400750d0bee0acf87204eefa9b76b3c8791ccc01b91686eb7a9048db4aa2e0b0b1a3fc4adc0788dd5020115960eade78cea820986670850b8082f4be1ddfdff60db1109000d27e44ac0bb99bfab335ed477821f0a6db3b956cf8e1a3f234159fa9e042fbb7f7dc17ca18e46803044eb427809071feb7c26f31760f0e48ca388d1992e47e98c0c494cc207ab9c4b136e9e5fad22d0a94a2b2f28abf058976aacddccbcd182c1671b0ea1d35b4783abce8962ff9e0cf42642227967d1f1cae1fa5f42812c20d5060313a";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"9f39696c0612ea1f1256d124c5ced3413a8c4aec16b1661d3a5d46c5f7d3d3fbdd67b6401caf702e3a413fc79ff88d9413aceee2e182bfc7712d09660a5000b631528f5c0144d6d194ccbd374b2fa79266ecbb82cd66587fd977aaa3652a064d0787bf850fa6c894b142ec32804e0472d80a5b80159c97b72ede655773bf78cf864dc3b61e0a0e0a24b40a8ce7b150ef9e6413460b1c4e1775ca995b6f7dace7c3a3cad020da0e8fffbb0424932619bee3271af61feb9e5e67b46e616659bf33cfd534ae2f9399f8ece74d547385c7d2268cae88642569c3cd13da05974789de006972640bbb4d015f227eb50e3af6d4d66129b21327ff6326937f482284e462568ca996";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"9f39696c01b0e820d71779adfba58629aa41183cb48920c5b6a3631feacd50e535344b8103f73f02b368493947c8a1cec8fd6d6a3e342d9e3b6c5f17f5a9cf8bc34105050ca5dcdb85dea315fb4d0937b4eef77901b9b728cf983a86aeca8f8385aa187102c6cac99c63b4373cdbebb8531b0bc1791a3d7a4ba0e6414bfda91163f518c806e97ad945ff7a0be2234b29ba3c20d10bec83c84ac38cdf701ffee01932f32c1b210559fbe7f9b838cfe32bf274f0cfcc220ecad0d8bcee1f39330f43106dbd268d0ef44565e3864173ecb2c893ec4ff673ea47ac48dd074cca455f380470580ad948d4f8516ad29f9b42d9f2d7a6412f43e4dc2811256d40a6fe7b102bf508";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"f464b94a2c5729fc15bc6ffe88a2ec3ee37d9f443f3598fb0d4a57de982e04802c57e886e5bf651e44e46c7038fb5d6ddec7bdd6ed7e0f67f9b481fd5711f7821b";

    function ciphertext() internal pure returns (bytes memory cipher) {
        cipher = hex"3f0000007f000000bf000000ff000000";
    }

    function expirableBlobs() internal pure returns (Logic.ExpirableBlob[] memory blobs) {
        blobs = new Logic.ExpirableBlob[](2);
        blobs[0] = Logic.ExpirableBlob({
            blob: hex"1f0000003f0000005f0000007f000000",
            deletionCriterion: Logic.DeletionCriterion.Immediately
        });
        blobs[1] = Logic.ExpirableBlob({
            blob: hex"9f000000bf000000df000000ff000000",
            deletionCriterion: Logic.DeletionCriterion.Never
        });
    }

    function complianceInstance() internal pure returns (Compliance.Instance memory instance) {
        instance = Compliance.Instance({
            consumed: Compliance.ConsumedRefs({
                nullifier: _CONSUMED_NULLIFIER,
                commitmentTreeRoot: INITIAL_COMMITMENT_TREE_ROOT,
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

    function logicInstance(bool isConsumed) internal pure returns (Logic.Instance memory instance) {
        instance = Logic.Instance({
            tag: isConsumed ? _CONSUMED_NULLIFIER : _CREATED_COMMITMENT,
            isConsumed: isConsumed,
            actionTreeRoot: _ACTION_TREE_ROOT,
            ciphertext: ciphertext(),
            appData: expirableBlobs()
        });
    }

    function logicVerifierInput(bool isConsumed) internal pure returns (Logic.VerifierInput memory input) {
        input = Logic.VerifierInput({
            proof: isConsumed ? _CONSUMED_LOGIC_PROOF : _CREATED_LOGIC_PROOF,
            instance: logicInstance(isConsumed),
            verifyingKey: isConsumed ? _CONSUMED_LOGIC_REF : _CREATED_LOGIC_REF
        });
    }

    function transaction() internal pure returns (Transaction memory txn) {
        ResourceForwarderCalldataPair[] memory emptyForwarderCallData = new ResourceForwarderCalldataPair[](0);

        Logic.VerifierInput[] memory logicVerifierInputs = new Logic.VerifierInput[](2);
        logicVerifierInputs[0] = logicVerifierInput({isConsumed: true});
        logicVerifierInputs[1] = logicVerifierInput({isConsumed: false});

        Compliance.VerifierInput[] memory complianceVerifierInputs = new Compliance.VerifierInput[](1);
        complianceVerifierInputs[0] = complianceVerifierInput();

        Action[] memory actions = new Action[](1);
        actions[0] = Action({
            logicVerifierInputs: logicVerifierInputs,
            complianceVerifierInputs: complianceVerifierInputs,
            resourceCalldataPairs: emptyForwarderCallData
        });

        txn = Transaction({actions: actions, deltaProof: _DELTA_PROOF});
    }
}
