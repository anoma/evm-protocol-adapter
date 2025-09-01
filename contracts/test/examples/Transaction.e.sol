// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {Compliance} from "../../src/proving/Compliance.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {Transaction, Action} from "../../src/Types.sol";

library TransactionExample {
    using MerkleTree for bytes32[];

    bytes32 internal constant _CONSUMED_NULLIFIER = 0xaf54af132b0e1c0df591d3b8096ba5a686c0b69447885a29fbf97627cee1a8e3;
    bytes32 internal constant _CREATED_COMMITMENT = 0x4734b9228c0a75aea9ba88b7a48be25ce99a38bc8fab4fde34a87159aa63e3de;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x39060282dd7b47c5dcc824f1f52b5f832f5943d1a4b269de95d9e2c84c82222a;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"bb001d4401e4c7dbb62425ca9936ba7cd1d7a0198af4165453d36960e58e4ff53b4dcff3120cade1809eaa4086099ce96dcc0998e9a771e1fe390e092b0f7dce1b08299507b16e184618b0477f8da82bc5c7822e958b2010ba7fb68ae76429c010a7e5d8027d681262e56258ab85a44d4d12dfc81c3cac41b4fd4d4ee7237e1486006678199d2e853108a100ac13a248a8c1dc6c7bb324178da176029bd61c12eda74bf71277ca0b3bb55bd804786e85c8253d47ba8dd6bea2efc9f0accd8e1a757996a22db3aac247731ba72fe6b441acb3a200a2bf76c4054c4943a5016963df0ca3382b8ed7d3dbb5dac9fd349123fe32952247ab237c5e57cb6a25cbeb0750036c77";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"bb001d441c91cef0d36b5b5f442a8905cc8198093827bc6c6299e25897d2450135c0d7091c87200b3a229b8815381d39cea9bf692c55dad8c0e54541216083b5f3d2bc9919eb94164f1c033367e26d4a40e402d15263bd1f802063a8c41492e10b123b25301ecce7f47ec58c83b51418036c7bca1b95cad299e004a9d001ed10200274f308018275d1373a5ff649485fe534dc7b76ddd894cfe770fe4d1920684ad214ac0e2c9bd42fb9d17fa6d44dd78cb9aa99499b785463915397c7d4f523a1fbdd0c0e3ff43e27bb53395c31fb7c54cc83b24ee0c96df90cbae3e52dc767d01d28bd0dfb5ba2e63b3b9b2ea7c11a434fd4fc458d194d6a64a5e2f813ad72bb9f8cab";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"bb001d440009074463c09e180438eeeff09b2784731b52cfb38c92a363225a38c5c885d51b1a50051019e848166ee7ba17402bd303a44b2a24ccc5f3271326fb4a81ee0112e99c3a7c051760210c6f4c97f8d128eb7992f524665203d70445e6deb79e9a28262cd253e2f43590e27ac321bd710ff3da8b60b555e6f3bcf3563b857675b52b74c4bd28b315bf9db72c5658687e2d5e9112f7d046e1362fa92e69d43232fb0fa4a090740d72ffbe22c58edd1557fa7db2d5bf617af9281f9450d6e9dc86680322e3b3a0fd511146f5702c77e3e47d6d7d5d8578cbfad95395593566409ae5006c89486ec76307ae7d9154560e7d86963c05c3322b83e55eca9c8c44f06067";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"b6ac6c3dd9976f792533ebbc82fb0145cf538b8eb63b332a9778bd7859c41a045ea31562bea4ca203ba19b1f05c870e5b20fe42852cd317bac3769c645b071241c";

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
                blob: hex"39060282dd7b47c5dcc824f1f52b5f832f5943d1a4b269de95d9e2c84c82222a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f29250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
            appData.resourcePayload[1] = Logic.ExpirableBlob({
                blob: hex"0000000000000000000000000000000000000000000000000000000000000000",
                deletionCriterion: Logic.DeletionCriterion.Never
            });
        } else {
            appData.resourcePayload[0] = Logic.ExpirableBlob({
                blob: hex"39060282dd7b47c5dcc824f1f52b5f832f5943d1a4b269de95d9e2c84c82222a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925af54af132b0e1c0df591d3b8096ba5a686c0b69447885a29fbf97627cee1a8e3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001",
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

        txn = Transaction({actions: actions, deltaProof: _DELTA_PROOF});
    }

    function treeRoot() internal pure returns (bytes32 root) {
        bytes32[] memory leaves = new bytes32[](2);
        leaves[0] = _CONSUMED_NULLIFIER;
        leaves[1] = _CREATED_COMMITMENT;

        root = leaves.computeRoot();
    }
}
