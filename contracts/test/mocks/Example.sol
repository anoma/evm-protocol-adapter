// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Compliance} from "../../src/proving/Compliance.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {BlobStorage} from "../../src/state/BlobStorage.sol";
import {Transaction, ResourceForwarderCalldataPair, Action} from "../../src/Types.sol";

import {INITIAL_COMMITMENT_TREE_ROOT} from "../state/CommitmentAccumulator.t.sol";

library Example {
    bytes32 internal constant _CONSUMED_NULLIFIER = 0x155d957de29e96a50517f3c033e1c618e697795e6853a5dc18ce684289d25497;
    bytes32 internal constant _CREATED_COMMITMENT = 0x9c590db144abb0434267475ac46554bc71377b1e678a6ce7dd86c8559b97cf1c;
    bytes32 internal constant _ACTION_TREE_ROOT = 0x190745ccc5568e6501a640df6f543b178b1bd4a058b6e7fea993e6697459e2d8;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0x6d49f043c79b753b897d478c617e06babc70c52259097b46ba618be8cb4a9e9b;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"9f39696c0f7ac40ba7f1dec4ed31054a2da7845e0f9f3585e7cda44a68b48089eebc4a372766c8c78c0dae25a56a36bc8a5663c49fc18e9883b988fd9e61982854f1cdb106c134f94fd25b3f414666627d44fe253207745ade08946e1020e6b4f8c5e23e1f39931fe5b46b3a5abae45c663142eb10fefeabaced1547205368a52e96d9391b5b52330c27606559c957d8b397dca3a7168618a24dc5ede669d7794354497d134e770918668d85698a1b4e6b8680c373fd634c2c5432d0e3037eb300313093023be3a9d8be3f94334dadeb4d05f78c2ed16604df418a86f937e01dc4ea3fc829b8bd9891a1748dac4d23a49d0cffd580405b95aee63a42469324dc805b4dca";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"9f39696c152bf7fcfde931d94860cf2e9f20aacbfb76016a248bbf9a90a14b13f426d18b094fb25cec09409027c492bfb6abf1aa5427748d2455510cde6d24bfd5d03330023762a169eeff0542411822c07a5b7fc9a02e44b442cd06f7694a13721b989d0afd5a1a1fd1e6a7291802f3d3bad090f04f490afb2706575ecdeb4c29ca4f5423c42aa7dc4095f07f5981351d2391296a7f58fb8cf525325cc1e62b2e7a00b722033e3f65c3a9e20d73607beca628ad736753e605e36a6131d06fecd6feca2b2a81548be4cbe82c03c70a641232e96449d47c38878a71382367dde92633beb819dd31c146885636e1dd222686900b85813e4645e0cdc40025a757797f14f456";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"9f39696c07fc1c92b6856d2d844514c9e560a126e3eee800f9f2411749004677b112fb651f2e79f3cfabeb4febb58f3c449291e36e5b24703e829508c1bb491d6b436e9711c4ae014a75cea484fd40816110a0de0e7107978b9e7e81555ef123c561985b1b1d3133119bf0ab5e4f12695c0fd7204186505f339dde5dad20ea0e8a01b18219f0ff783148b17ab5dd1b82fa78fd4f3c9306ca52922e1950089c4495545f4e16bdf388de7ed4bacc1fc6cbe59c90563de08fbe712f043881e8ef59b1658e9c2ce2529f12f3f6f17d6b48717390ccff559aa2eb6f317baee5ef41a7c651920323321f4e771cd4ab1975fe784f3ccfdfeeb46f95b3b78f7857fe3839f7073fd6";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"f464b94a2c5729fc15bc6ffe88a2ec3ee37d9f443f3598fb0d4a57de982e04802c57e886e5bf651e44e46c7038fb5d6ddec7bdd6ed7e0f67f9b481fd5711f7821b";

    function ciphertext() internal pure returns (bytes memory cipher) {
        cipher = hex"3f0000007f000000bf000000ff000000";
    }

    function expirableBlobs() internal pure returns (BlobStorage.ExpirableBlob[] memory blobs) {
        blobs = new BlobStorage.ExpirableBlob[](2);
        blobs[0] = BlobStorage.ExpirableBlob({
            blob: hex"1f0000003f0000005f0000007f000000",
            deletionCriterion: BlobStorage.DeletionCriterion.Immediately
        });
        blobs[1] = BlobStorage.ExpirableBlob({
            blob: hex"9f000000bf000000df000000ff000000",
            deletionCriterion: BlobStorage.DeletionCriterion.Never
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
