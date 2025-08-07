// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Compliance} from "../../src/proving/Compliance.sol";
import {Logic} from "../../src/proving/Logic.sol";
import {Transaction, /*ResourceForwarderCalldataPair,*/ Action} from "../../src/Types.sol";

import {INITIAL_COMMITMENT_TREE_ROOT} from "../state/CommitmentAccumulator.t.sol";

library TransactionExample {
    bytes32 internal constant _CONSUMED_NULLIFIER = 0x474929d680c65076fd67caa49ab26818a81f8cbc46ed1f0a76a82fd2adf29cf9;
    bytes32 internal constant _CREATED_COMMITMENT = 0xa8099e1e6c79588c1cb183d8beb03639d231211ad7bc4fc60f197356785fde2a;
    bytes32 internal constant _ACTION_TREE_ROOT = 0x88c6a6f85f4aea9dc3b08a854e7fb93f24f84a3a571c7aa19fa3bf7a16fc16a5;
    bytes32 internal constant _CONSUMED_LOGIC_REF = 0xe489de844774110a58e0f242739ac293b248a99df43d9c7e4f48721c24ec8942;
    bytes32 internal constant _CREATED_LOGIC_REF = _CONSUMED_LOGIC_REF;

    bytes internal constant _CONSUMED_LOGIC_PROOF =
        hex"bb001d442590bf80cb78584c417845d87da8169263e93b268e853abd116f6fc0c04edaeb0d4753c6b3ebb90d073bfe741303885deed510bb6a2a2a9fbaaf0ad37d6d11b31d8839fa04ef7f59430b52861b3b1437580ba104d88cfca4a85e7c2b6e98b82f0d9035a227be945d89d28b11a6be37dd1cc7bf17f1b28cd6e2fe9123629ece4007812aa3201dedc384b527a50218d07d15c9f6d3889eeb1dad2d907b3673201e127f7a980a62820f66517c3cd14ebdcb112f3b4d2d198ee58628dd89a3c2dd28049a4c4b0a721e2b7caa7a770b2beb24ed09af2134b957b849710f5e056491c51cb00e2ce7f46357d5d70b8b00dd3b999e81b6f6f68422aa1833f7031456ebb1";

    bytes internal constant _CREATED_LOGIC_PROOF =
        hex"bb001d440b1f6be1d5cb730546e062964f93f7e563dcb108dff96c3d76e9bdc5b629158a269f124a6d6f9aa249d0d6df6447fbdd3ed53680edf1ee33975ad61dc9750be417b21f84e3b235d18968db6fa15a4fa3f855fae34290d24c2840c72167cb95c120949c98091ac494d04afcf461840f96da2bf34fd3cf6185190b2387eb8e6d471ff4e20a598d7ad477bf62c134e28c4f0f926384f57508c4cbf9fc3d1aca74910cae484e2c0d3a502a6f17e4f45aea280cf327461b9b3d83c34b6d97883c226e2e0ba621b256c672c755c791e9e9ac40c5c5006ea3f00f3309af84037463cf88262385399be42860b1fcfeeb89b8f543a1870a00bec526bb5b50ee22d1faaea4";

    bytes internal constant _COMPLIANCE_PROOF =
        hex"bb001d441f6df51306b1ceee4e9a9ce97f088e249ce7392755f19f4b9fe0ce99aaf980602f79125ef3f192592a3c2f26af919c39ad945b65001db11d594c17ddf7a4e7fc1ffd0a5f2474f4c55adafaa7f4bf6317568cd8c07b0931cd54f81bbbfb856de010f36ed77a9af9c91bdfe4de4180c16fe80d0ec59410956610f6eacf9ca58e4230046c7c14ddccd20bc5a8c07e6c0e9c1f727d7be4b502e26e76d83e6685d69b0c0a2a243473a1d4f0eeac5a44bdb22249078ed12db48e71d1ad897a05815aaa1ec988d321e853a26f040847a1491b90de335082c0ef8fe8d05c18fe196779a9121ee33e74f301c5a5392fac9d2042433eff66faf968ca3935dc275901035350";

    bytes32 internal constant _UNIT_DELTA_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
    bytes32 internal constant _UNIT_DELTA_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    bytes internal constant _DELTA_PROOF =
        hex"b92d4cd51328af3d3bf5f2a5bf213d0e21bf39889ae2bf439796b86ac2e821e05612ed0b94204d4feb0913924dca423bed52e823dc6a9277f033546af8ebc3b81b";

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
            ciphertext: bytes(""), //ciphertext(),
            appData: new Logic.ExpirableBlob[](0) //expirableBlobs()
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
        //ResourceForwarderCalldataPair[] memory emptyForwarderCallData = new ResourceForwarderCalldataPair[](0);

        Logic.VerifierInput[] memory logicVerifierInputs = new Logic.VerifierInput[](2);
        logicVerifierInputs[0] = logicVerifierInput({isConsumed: true});
        logicVerifierInputs[1] = logicVerifierInput({isConsumed: false});

        Compliance.VerifierInput[] memory complianceVerifierInputs = new Compliance.VerifierInput[](1);
        complianceVerifierInputs[0] = complianceVerifierInput();

        Action[] memory actions = new Action[](1);
        actions[0] =
            Action({logicVerifierInputs: logicVerifierInputs, complianceVerifierInputs: complianceVerifierInputs});
        // TODO! resourceCalldataPairs: emptyForwarderCallData

        txn = Transaction({actions: actions, deltaProof: _DELTA_PROOF});
    }
}
