// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";
import {VmSafe} from "forge-std/Vm.sol";
import {MerkleTree} from "./../../src/libs/MerkleTree.sol";
import {RiscZeroUtils} from "./../../src/libs/RiscZeroUtils.sol";
import {SHA256} from "./../../src/libs/SHA256.sol";
import {Compliance} from "./../../src/proving/Compliance.sol";
import {Delta} from "./../../src/proving/Delta.sol";
import {Logic} from "./../../src/proving/Logic.sol";
import {Transaction, Action, Resource} from "./../../src/Types.sol";
import {DeltaGen} from "./../proofs/DeltaProof.t.sol";

library TxGen {
    using MerkleTree for bytes32[];
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.VerifierInput;
    using Logic for Logic.VerifierInput[];
    using Delta for uint256[2];

    uint256 public constant MAX_ACTIONS = 4;
    uint256 public constant MAX_RESOURCES = 5;
    // The order of the secp256k1 curve.
    uint256 internal constant SECP256K1_ORDER =
        115792089237316195423570985008687907852837564279074904382605163141518161494337;

    struct ActionConfig {
        uint256 complianceUnitCount;
    }

    struct ResourceAndAppData {
        Resource resource;
        Logic.AppData appData;
    }

    struct ResourceLists {
        ResourceAndAppData[] consumed;
        ResourceAndAppData[] created;
    }

    struct ActionParams {
        Resource[2][MAX_RESOURCES] resources;
        uint256[MAX_RESOURCES] bijection;
        uint256 targetResourcesLen;
        uint256[2][MAX_RESOURCES] valueCommitmentRandomness;
    }

    struct TransactionParams {
        ActionParams[MAX_ACTIONS] actionParams;
        uint256 targetActionsLen;
    }

    error ConsumedCreatedCountMismatch(uint256 nConsumed, uint256 nCreated);

    function complianceVerifierInput(
        VmSafe vm,
        RiscZeroMockVerifier mockVerifier,
        bytes32 commitmentTreeRoot, // historical root
        Resource memory consumed,
        Resource memory created
    ) internal returns (Compliance.VerifierInput memory unit) {
        bytes32 nf = nullifier(consumed, 0);
        bytes32 cm = commitment(created);

        // Construct the delta for consumption based on kind and quantity
        uint256[2] memory unitDelta = DeltaGen.generateInstance(
            vm,
            DeltaGen.InstanceInputs({
                kind: kind(consumed),
                quantity: consumed.quantity,
                consumed: true,
                valueCommitmentRandomness: 1
            })
        );
        // Construct the delta for creation based on kind and quantity
        unitDelta = Delta.add(
            unitDelta,
            DeltaGen.generateInstance(
                vm,
                DeltaGen.InstanceInputs({
                    kind: kind(created),
                    quantity: created.quantity,
                    consumed: false,
                    valueCommitmentRandomness: 1
                })
            )
        );

        Compliance.Instance memory instance = Compliance.Instance({
            consumed: Compliance.ConsumedRefs({
                nullifier: nf,
                commitmentTreeRoot: commitmentTreeRoot,
                logicRef: consumed.logicRef
            }),
            created: Compliance.CreatedRefs({commitment: cm, logicRef: created.logicRef}),
            unitDeltaX: bytes32(unitDelta[0]),
            unitDeltaY: bytes32(unitDelta[1])
        });

        unit = Compliance.VerifierInput({
            proof: mockVerifier.mockProve({imageId: Compliance._VERIFYING_KEY, journalDigest: instance.toJournalDigest()})
                .seal,
            instance: instance
        });
    }

    function createAction(
        VmSafe vm,
        RiscZeroMockVerifier mockVerifier,
        ResourceAndAppData[] memory consumed,
        ResourceAndAppData[] memory created
    ) internal returns (Action memory action) {
        if (consumed.length != created.length) {
            revert ConsumedCreatedCountMismatch({nConsumed: consumed.length, nCreated: created.length});
        }
        uint256 complianceUnitCount = consumed.length;

        Logic.VerifierInput[] memory logicVerifierInputs = new Logic.VerifierInput[](2 * complianceUnitCount);
        Compliance.VerifierInput[] memory complianceVerifierInputs = new Compliance.VerifierInput[](complianceUnitCount);

        bytes32[] memory actionTreeTags = new bytes32[](2 * complianceUnitCount);
        for (uint256 i = 0; i < complianceUnitCount; ++i) {
            uint256 index = (i * 2);

            actionTreeTags[index] = nullifier(consumed[i].resource, 0);
            actionTreeTags[index + 1] = commitment(created[i].resource);
        }

        bytes32 actionTreeRoot = actionTreeTags.computeRoot();

        for (uint256 i = 0; i < complianceUnitCount; ++i) {
            uint256 index = i * 2;

            logicVerifierInputs[index] = logicVerifierInput({
                mockVerifier: mockVerifier,
                actionTreeRoot: actionTreeRoot,
                resource: consumed[i].resource,
                isConsumed: true,
                appData: consumed[i].appData
            });

            logicVerifierInputs[index + 1] = logicVerifierInput({
                mockVerifier: mockVerifier,
                actionTreeRoot: actionTreeRoot,
                resource: created[i].resource,
                isConsumed: false,
                appData: created[i].appData
            });

            complianceVerifierInputs[i] = complianceVerifierInput({
                vm: vm,
                mockVerifier: mockVerifier,
                commitmentTreeRoot: initialRoot(),
                consumed: consumed[i].resource,
                created: created[i].resource
            });
        }
        action = Action({logicVerifierInputs: logicVerifierInputs, complianceVerifierInputs: complianceVerifierInputs});
    }

    function createDefaultAction(
        VmSafe vm,
        RiscZeroMockVerifier mockVerifier,
        bytes32 nonce,
        uint256 complianceUnitCount
    ) internal returns (Action memory action, bytes32 updatedNonce) {
        updatedNonce = nonce;

        ResourceAndAppData[] memory consumed = new ResourceAndAppData[](complianceUnitCount);
        ResourceAndAppData[] memory created = new ResourceAndAppData[](complianceUnitCount);

        for (uint256 i = 0; i < complianceUnitCount; ++i) {
            consumed[i] = ResourceAndAppData({
                resource: TxGen.mockResource({
                    nonce: updatedNonce,
                    logicRef: bytes32(i),
                    labelRef: bytes32(i),
                    quantity: uint128(1 + uint256(nonce))
                }),
                appData: Logic.AppData({
                    discoveryPayload: new Logic.ExpirableBlob[](0),
                    resourcePayload: new Logic.ExpirableBlob[](0),
                    externalPayload: new Logic.ExpirableBlob[](0),
                    applicationPayload: new Logic.ExpirableBlob[](0)
                })
            });
            updatedNonce = bytes32(uint256(updatedNonce) + 1);
            created[i] = ResourceAndAppData({
                resource: TxGen.mockResource({
                    nonce: updatedNonce,
                    logicRef: bytes32(i),
                    labelRef: bytes32(i),
                    quantity: uint128(1 + uint256(nonce))
                }),
                appData: Logic.AppData({
                    discoveryPayload: new Logic.ExpirableBlob[](0),
                    resourcePayload: new Logic.ExpirableBlob[](0),
                    externalPayload: new Logic.ExpirableBlob[](0),
                    applicationPayload: new Logic.ExpirableBlob[](0)
                })
            });
            updatedNonce = bytes32(uint256(updatedNonce) + 1);
        }

        action = createAction({vm: vm, mockVerifier: mockVerifier, consumed: consumed, created: created});
    }

    function transaction(VmSafe vm, RiscZeroMockVerifier mockVerifier, ResourceLists[] memory actionResources)
        internal
        returns (Transaction memory txn)
    {
        Action[] memory actions = new Action[](actionResources.length);

        for (uint256 i = 0; i < actionResources.length; ++i) {
            if (actionResources[i].consumed.length != actionResources[i].created.length) {
                revert ConsumedCreatedCountMismatch(
                    actionResources[i].consumed.length, actionResources[i].created.length
                );
            }

            actions[i] = createAction({
                vm: vm,
                mockVerifier: mockVerifier,
                consumed: actionResources[i].consumed,
                created: actionResources[i].created
            });
        }

        // Grab the tags that will be signed over
        bytes32[] memory tags = TxGen.collectTags(actions);
        // Generate a proof over the tags where valueCommitmentRandomness value is the expected total
        bytes memory proof = "";
        if (tags.length != 0) {
            proof = DeltaGen.generateProof(
                vm,
                DeltaGen.ProofInputs({
                    valueCommitmentRandomness: tags.length,
                    verifyingKey: Delta.computeVerifyingKey(tags)
                })
            );
        }
        txn = Transaction({actions: actions, deltaProof: proof});
    }

    function transaction(VmSafe vm, RiscZeroMockVerifier mockVerifier, bytes32 nonce, ActionConfig[] memory configs)
        internal
        returns (Transaction memory txn, bytes32 updatedNonce)
    {
        updatedNonce = nonce;

        Action[] memory actions = new Action[](configs.length);
        for (uint256 i = 0; i < configs.length; ++i) {
            (actions[i], updatedNonce) = createDefaultAction({
                vm: vm,
                mockVerifier: mockVerifier,
                nonce: updatedNonce,
                complianceUnitCount: configs[i].complianceUnitCount
            });
        }

        // Grab the tags that will be signed over
        bytes32[] memory tags = TxGen.collectTags(actions);
        // Generate a proof over the tags where valueCommitmentRandomness value is the expected total
        bytes memory proof = "";
        if (tags.length != 0) {
            proof = DeltaGen.generateProof(
                vm,
                DeltaGen.ProofInputs({
                    valueCommitmentRandomness: tags.length,
                    verifyingKey: Delta.computeVerifyingKey(tags)
                })
            );
        }
        txn = Transaction({actions: actions, deltaProof: proof});
    }

    function generateAction(VmSafe vm, RiscZeroMockVerifier mockVerifier, ActionParams memory params)
        internal
        returns (Action memory action, uint256 totalValueCommitmentRandomness)
    {
        Resource[2][] memory truncatedResources =
            truncateResources(params.resources, params.targetResourcesLen % MAX_RESOURCES);
        action.logicVerifierInputs = new Logic.VerifierInput[](truncatedResources.length * 2);
        action.complianceVerifierInputs = new Compliance.VerifierInput[](truncatedResources.length);
        // Created empty app data for all the resources
        Logic.AppData memory appData = Logic.AppData({
            resourcePayload: new Logic.ExpirableBlob[](0),
            discoveryPayload: new Logic.ExpirableBlob[](0),
            externalPayload: new Logic.ExpirableBlob[](0),
            applicationPayload: new Logic.ExpirableBlob[](0)
        });
        // Match the created and consumed resources
        uint256[] memory bijection = generateBijection(params.bijection, truncatedResources.length);
        for (uint256 i = 0; i < truncatedResources.length; ++i) {
            truncatedResources[bijection[i]][1].quantity = truncatedResources[i][0].quantity;
            truncatedResources[bijection[i]][1].logicRef = truncatedResources[i][0].logicRef;
            truncatedResources[bijection[i]][1].labelRef = truncatedResources[i][0].labelRef;
        }
        // Compute action tree tags and action tree root
        bytes32[] memory actionTreeTags = new bytes32[](2 * truncatedResources.length);
        totalValueCommitmentRandomness = 0;
        for (uint256 i = 0; i < truncatedResources.length; ++i) {
            uint256 index = (i * 2);

            actionTreeTags[index] = nullifier(truncatedResources[i][0], 0);
            actionTreeTags[index + 1] = commitment(truncatedResources[i][1]);
            // Adjust and accumulate the value randomness commitments
            params.valueCommitmentRandomness[i][0] =
                1 + (params.valueCommitmentRandomness[i][0] % (SECP256K1_ORDER - 1));
            params.valueCommitmentRandomness[i][1] =
                1 + (params.valueCommitmentRandomness[i][1] % (SECP256K1_ORDER - 1));
            totalValueCommitmentRandomness =
                addmod(totalValueCommitmentRandomness, params.valueCommitmentRandomness[i][0], SECP256K1_ORDER);
            totalValueCommitmentRandomness =
                addmod(totalValueCommitmentRandomness, params.valueCommitmentRandomness[i][1], SECP256K1_ORDER);
        }
        bytes32 actionTreeRoot = actionTreeTags.computeRoot();
        // Create logic and compliance verifier inputs
        for (uint256 i = 0; i < truncatedResources.length; i++) {
            Resource memory consumedResource = truncatedResources[i][0];
            Resource memory createdResource = truncatedResources[i][1];
            bytes32 nf = nullifier(consumedResource, 0);
            bytes32 cm = commitment(createdResource);

            // Created logic verifier input for a consumed resource
            action.logicVerifierInputs[2 * i] =
                Logic.VerifierInput({tag: nf, verifyingKey: consumedResource.logicRef, proof: "", appData: appData});
            action.logicVerifierInputs[2 * i].proof = mockVerifier.mockProve({
                imageId: consumedResource.logicRef,
                journalDigest: action.logicVerifierInputs[2 * i].toJournalDigest(actionTreeRoot, true)
            }).seal;
            // Create logic verifier input for a created resource
            action.logicVerifierInputs[2 * i + 1] =
                Logic.VerifierInput({tag: cm, verifyingKey: createdResource.logicRef, proof: "", appData: appData});
            action.logicVerifierInputs[2 * i + 1].proof = mockVerifier.mockProve({
                imageId: createdResource.logicRef,
                journalDigest: action.logicVerifierInputs[2 * i + 1].toJournalDigest(actionTreeRoot, false)
            }).seal;
            // Create the delta for the consumed resource
            uint256[2] memory unitDelta = DeltaGen.generateInstance(
                vm,
                DeltaGen.InstanceInputs({
                    kind: kind(consumedResource),
                    quantity: consumedResource.quantity,
                    consumed: true,
                    valueCommitmentRandomness: params.valueCommitmentRandomness[i][0]
                })
            );

            // Add the delta for the created resource
            unitDelta = Delta.add(
                unitDelta,
                DeltaGen.generateInstance(
                    vm,
                    DeltaGen.InstanceInputs({
                        kind: kind(createdResource),
                        quantity: createdResource.quantity,
                        consumed: false,
                        valueCommitmentRandomness: params.valueCommitmentRandomness[i][1]
                    })
                )
            );
            // Create the compliance verifier input
            Compliance.Instance memory instance = Compliance.Instance({
                unitDeltaX: bytes32(unitDelta[0]),
                unitDeltaY: bytes32(unitDelta[1]),
                consumed: Compliance.ConsumedRefs({
                    nullifier: nf,
                    logicRef: consumedResource.logicRef,
                    commitmentTreeRoot: initialRoot()
                }),
                created: Compliance.CreatedRefs({commitment: cm, logicRef: createdResource.logicRef})
            });
            action.complianceVerifierInputs[i] = Compliance.VerifierInput({
                instance: instance,
                proof: mockVerifier.mockProve({
                    imageId: Compliance._VERIFYING_KEY,
                    journalDigest: instance.toJournalDigest()
                }).seal
            });
        }
    }

    function transaction(VmSafe vm, RiscZeroMockVerifier mockVerifier, TransactionParams memory params)
        internal
        returns (Transaction memory txn)
    {
        // Generate actions
        Action[] memory actions = new Action[](params.targetActionsLen % MAX_ACTIONS);
        uint256 totalValueCommitmentRandomness = 0;
        for (uint256 i = 0; i < actions.length; i++) {
            uint256 valueCommitmentRandomness;
            (actions[i], valueCommitmentRandomness) = generateAction(vm, mockVerifier, params.actionParams[i]);
            totalValueCommitmentRandomness =
                addmod(totalValueCommitmentRandomness, valueCommitmentRandomness, SECP256K1_ORDER);
        }
        // Generate delta proof
        bytes memory proof = "";
        bytes32[] memory tags = TxGen.collectTags(actions);
        if (tags.length != 0) {
            proof = DeltaGen.generateProof(
                vm,
                DeltaGen.ProofInputs({
                    valueCommitmentRandomness: totalValueCommitmentRandomness,
                    verifyingKey: Delta.computeVerifyingKey(tags)
                })
            );
        }
        // Generate transaction
        txn = Transaction({actions: actions, deltaProof: proof});
    }

    function logicVerifierInput(
        RiscZeroMockVerifier mockVerifier,
        bytes32 actionTreeRoot,
        Resource memory resource,
        bool isConsumed,
        Logic.AppData memory appData
    ) internal view returns (Logic.VerifierInput memory input) {
        input = Logic.VerifierInput({
            tag: isConsumed ? nullifier(resource, 0) : commitment(resource),
            verifyingKey: resource.logicRef,
            appData: appData,
            proof: ""
        });

        input.proof = mockVerifier.mockProve({
            imageId: resource.logicRef,
            journalDigest: input.toJournalDigest(actionTreeRoot, isConsumed)
        }).seal;
    }

    function generateActionConfigs(uint256 actionCount, uint256 complianceUnitCount)
        internal
        pure
        returns (ActionConfig[] memory configs)
    {
        configs = new TxGen.ActionConfig[](actionCount);
        for (uint256 i = 0; i < actionCount; ++i) {
            configs[i] = TxGen.ActionConfig({complianceUnitCount: complianceUnitCount});
        }
    }

    function countComplianceUnits(Action[] memory actions) internal pure returns (uint256 complianceUnitCount) {
        complianceUnitCount = 0;

        for (uint256 i = 0; i < actions.length; ++i) {
            complianceUnitCount += actions[i].complianceVerifierInputs.length;
        }
    }

    function collectTags(Action[] memory actions) internal pure returns (bytes32[] memory tags) {
        tags = new bytes32[](countComplianceUnits(actions) * 2);

        uint256 n = 0;
        for (uint256 i = 0; i < actions.length; ++i) {
            bytes32[] memory actionTags = collectTags(actions[i]);

            for (uint256 j = 0; j < actionTags.length; ++j) {
                tags[n++] = actionTags[j];
            }
        }
    }

    function collectTags(Action memory action) internal pure returns (bytes32[] memory tags) {
        uint256 complianceUnitCount = action.complianceVerifierInputs.length;

        tags = new bytes32[](complianceUnitCount * 2);

        for (uint256 i = 0; i < complianceUnitCount; ++i) {
            tags[i * 2] = action.complianceVerifierInputs[i].instance.consumed.nullifier;
            tags[(i * 2) + 1] = action.complianceVerifierInputs[i].instance.created.commitment;
        }
    }

    function collectLogicRefs(Action[] memory actions) internal pure returns (bytes32[] memory logicRefs) {
        logicRefs = new bytes32[](countComplianceUnits(actions) * 2);

        uint256 n = 0;
        for (uint256 i = 0; i < actions.length; ++i) {
            uint256 complianceUnitCount = actions[i].complianceVerifierInputs.length;

            for (uint256 j = 0; j < complianceUnitCount; ++j) {
                logicRefs[n++] = actions[i].complianceVerifierInputs[j].instance.consumed.logicRef;
                logicRefs[n++] = actions[i].complianceVerifierInputs[j].instance.created.logicRef;
            }
        }
    }

    function mockResource(bytes32 nonce, bytes32 logicRef, bytes32 labelRef, uint128 quantity)
        internal
        pure
        returns (Resource memory mock)
    {
        mock = Resource({
            logicRef: logicRef,
            labelRef: labelRef,
            valueRef: bytes32(0),
            nullifierKeyCommitment: bytes32(0),
            quantity: quantity,
            nonce: nonce,
            randSeed: 0,
            ephemeral: true
        });
    }

    function commitment(Resource memory resource) internal pure returns (bytes32 hash) {
        hash = sha256(abi.encode(resource));
    }

    function nullifier(Resource memory resource, bytes32 nullifierKey) internal pure returns (bytes32 hash) {
        hash = sha256(abi.encode(resource, nullifierKey));
    }

    function kind(Resource memory resource) internal pure returns (uint256 hash) {
        hash = uint256(sha256(abi.encode(resource.logicRef, resource.labelRef)));
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

    function initialRoot() internal pure returns (bytes32 root) {
        root = SHA256.EMPTY_HASH;
    }

    function truncateResources(Resource[2][MAX_RESOURCES] memory resources, uint256 len)
        internal
        pure
        returns (Resource[2][] memory truncatedResources)
    {
        truncatedResources = new Resource[2][](len);
        for (uint256 i = 0; i < len; i++) {
            truncatedResources[i][0] = resources[i][0];
            truncatedResources[i][1] = resources[i][1];
        }
    }

    function generateBijection(uint256[MAX_RESOURCES] memory input, uint256 len)
        internal
        pure
        returns (uint256[] memory output)
    {
        output = new uint256[](len);
        uint256[] memory duplicates = new uint256[](len);
        uint256 duplicateCount = 0;
        for (uint256 i = 0; i < len; i++) {
            output[i] = duplicates[i] = len;
            input[i] %= len;
        }
        for (uint256 i = 0; i < len; i++) {
            if (output[input[i]] == len) {
                output[input[i]] = i;
            } else {
                duplicates[duplicateCount++] = i;
            }
        }
        duplicateCount = 0;
        for (uint256 i = 0; i < len; i++) {
            if (output[i] == len) {
                output[i] = duplicates[duplicateCount++];
            }
        }
    }
}
