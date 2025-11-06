// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";
import {VmSafe} from "forge-std/Vm.sol";
import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {Aggregation} from "../../src/libs/proving/Aggregation.sol";
import {Compliance} from "../../src/libs/proving/Compliance.sol";
import {Delta} from "../../src/libs/proving/Delta.sol";
import {Logic} from "../../src/libs/proving/Logic.sol";
import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {Transaction, Action, Resource} from "./../../src/Types.sol";
import {DeltaGen} from "./../proofs/DeltaProof.t.sol";

library TxGen {
    using MerkleTree for bytes32[];
    using RiscZeroUtils for Aggregation.Instance;
    using RiscZeroUtils for Compliance.Instance;
    using RiscZeroUtils for Logic.Instance;
    using Logic for Logic.VerifierInput[];
    using Logic for Logic.VerifierInput;

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

    error ConsumedCreatedCountMismatch(uint256 nConsumed, uint256 nCreated);
    error NonExistingTag(bytes32 tag);
    error TransactionTagCountMismatch();

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
        Delta.Point memory unitDelta = DeltaGen.generateInstance(
            vm,
            DeltaGen.InstanceInputs({
                kind: kind(consumed), quantity: consumed.quantity, consumed: true, valueCommitmentRandomness: 1
            })
        );
        // Construct the delta for creation based on kind and quantity
        unitDelta = Delta.add(
            unitDelta,
            DeltaGen.generateInstance(
                vm,
                DeltaGen.InstanceInputs({
                    kind: kind(created), quantity: created.quantity, consumed: false, valueCommitmentRandomness: 1
                })
            )
        );

        Compliance.Instance memory instance = Compliance.Instance({
            consumed: Compliance.ConsumedRefs({
                nullifier: nf, commitmentTreeRoot: commitmentTreeRoot, logicRef: consumed.logicRef
            }),
            created: Compliance.CreatedRefs({commitment: cm, logicRef: created.logicRef}),
            unitDeltaX: bytes32(unitDelta.x),
            unitDeltaY: bytes32(unitDelta.y)
        });

        unit = Compliance.VerifierInput({
            proof: mockVerifier.mockProve({
                imageId: Compliance._VERIFYING_KEY, journalDigest: sha256(instance.toJournal())
            }).seal,
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
            uint256 index = (i * Compliance._RESOURCES_PER_COMPLIANCE_UNIT);

            actionTreeTags[index] = nullifier(consumed[i].resource, 0);
            actionTreeTags[index + 1] = commitment(created[i].resource);
        }

        bytes32 actionTreeRoot = actionTreeTags.computeRoot();

        for (uint256 i = 0; i < complianceUnitCount; ++i) {
            uint256 index = i * Compliance._RESOURCES_PER_COMPLIANCE_UNIT;

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

    function transaction(
        VmSafe vm,
        RiscZeroMockVerifier mockVerifier,
        ResourceLists[] memory actionResources,
        bool isProofAggregated
    ) internal returns (Transaction memory txn) {
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
                    valueCommitmentRandomness: tags.length, verifyingKey: Delta.computeVerifyingKey(tags)
                })
            );
        }
        txn = Transaction({actions: actions, deltaProof: proof, aggregationProof: ""});

        if (isProofAggregated) {
            txn = transactionAggregation(mockVerifier, txn);
        }
    }

    function transaction(
        VmSafe vm,
        RiscZeroMockVerifier mockVerifier,
        bytes32 nonce,
        ActionConfig[] memory configs,
        bool isProofAggregated
    ) internal returns (Transaction memory txn, bytes32 updatedNonce) {
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
                    valueCommitmentRandomness: tags.length, verifyingKey: Delta.computeVerifyingKey(tags)
                })
            );
        }
        txn = Transaction({actions: actions, deltaProof: proof, aggregationProof: ""});

        if (isProofAggregated) {
            txn = transactionAggregation(mockVerifier, txn);
        }
    }

    function transactionAggregation(RiscZeroMockVerifier mockVerifier, Transaction memory txn)
        internal
        view
        returns (Transaction memory aggregatedTxn)
    {
        aggregatedTxn = txn;

        aggregatedTxn.aggregationProof = mockVerifier.mockProve({
            imageId: Aggregation._VERIFYING_KEY, journalDigest: sha256(aggregatedInstanceGeneration(txn).toJournal())
        }).seal;
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
            imageId: resource.logicRef, journalDigest: sha256(input.toInstance(actionTreeRoot, isConsumed).toJournal())
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
        tags = new bytes32[](countComplianceUnits(actions) * Compliance._RESOURCES_PER_COMPLIANCE_UNIT);

        uint256 n = 0;
        for (uint256 i = 0; i < actions.length; ++i) {
            bytes32[] memory actionTags = collectTags(actions[i]);

            for (uint256 j = 0; j < actionTags.length; ++j) {
                tags[n++] = actionTags[j];
            }
        }
    }

    /// @dev This function is a duplicated from `TagUtils.sol` with the difference that it uses `memory`.
    function collectTags(Action memory action) internal pure returns (bytes32[] memory tags) {
        uint256 complianceUnitCount = action.complianceVerifierInputs.length;

        tags = new bytes32[](complianceUnitCount * Compliance._RESOURCES_PER_COMPLIANCE_UNIT);

        for (uint256 i = 0; i < complianceUnitCount; ++i) {
            Compliance.Instance memory instance = action.complianceVerifierInputs[i].instance;
            tags[(i * Compliance._RESOURCES_PER_COMPLIANCE_UNIT)] = instance.consumed.nullifier;
            tags[(i * Compliance._RESOURCES_PER_COMPLIANCE_UNIT) + 1] = instance.created.commitment;
        }
    }

    function collectNullifiers(Transaction memory txn) internal pure returns (bytes32[] memory nullifiers) {
        nullifiers = new bytes32[](countComplianceUnits(txn.actions));
        bytes32[] memory tagList = collectTags(txn.actions);

        for (uint256 i = 0; i < nullifiers.length; ++i) {
            nullifiers[i] = tagList[i * Compliance._RESOURCES_PER_COMPLIANCE_UNIT];
        }
    }

    function collectCommitments(Transaction memory txn) internal pure returns (bytes32[] memory commitments) {
        commitments = new bytes32[](countComplianceUnits(txn.actions));
        bytes32[] memory tagList = collectTags(txn.actions);

        for (uint256 i = 0; i < commitments.length; ++i) {
            commitments[i] = tagList[(i * Compliance._RESOURCES_PER_COMPLIANCE_UNIT) + 1];
        }
    }

    function collectLogicRefs(Action[] memory actions) internal pure returns (bytes32[] memory logicRefs) {
        logicRefs = new bytes32[](countComplianceUnits(actions) * Compliance._RESOURCES_PER_COMPLIANCE_UNIT);

        uint256 n = 0;
        for (uint256 i = 0; i < actions.length; ++i) {
            uint256 complianceUnitCount = actions[i].complianceVerifierInputs.length;

            for (uint256 j = 0; j < complianceUnitCount; ++j) {
                logicRefs[n++] = actions[i].complianceVerifierInputs[j].instance.consumed.logicRef;
                logicRefs[n++] = actions[i].complianceVerifierInputs[j].instance.created.logicRef;
            }
        }
    }

    function aggregatedInstanceGeneration(Transaction memory txn)
        internal
        pure
        returns (Aggregation.Instance memory aggregationInstance)
    {
        uint256 n = 0;
        bytes32[] memory logicRefs = collectLogicRefs(txn.actions);

        if (countComplianceUnits(txn.actions) * Compliance._RESOURCES_PER_COMPLIANCE_UNIT != logicRefs.length) {
            revert TransactionTagCountMismatch();
        }

        Compliance.Instance[] memory complianceInstances = new Compliance.Instance[](logicRefs.length / 2);
        Logic.Instance[] memory logicInstances = new Logic.Instance[](logicRefs.length);
        for (uint256 i = 0; i < txn.actions.length; ++i) {
            for (uint256 j = 0; j < txn.actions[i].complianceVerifierInputs.length; ++j) {
                Compliance.VerifierInput memory complianceUnit = txn.actions[i].complianceVerifierInputs[j];
                complianceInstances[n / 2] = complianceUnit.instance;
                bytes32 actionTreeRoot = computeActionTreeRoot(txn.actions[i]);

                {
                    uint256 nullifierIndex = getTagIndex(txn.actions[i], complianceUnit.instance.consumed.nullifier);
                    logicInstances[n++] =
                        Logic.toInstance(txn.actions[i].logicVerifierInputs[nullifierIndex], actionTreeRoot, true);
                }

                {
                    uint256 commitmentIndex = getTagIndex(txn.actions[i], complianceUnit.instance.created.commitment);
                    logicInstances[n++] =
                        Logic.toInstance(txn.actions[i].logicVerifierInputs[commitmentIndex], actionTreeRoot, false);
                }
            }
        }

        aggregationInstance = Aggregation.Instance({
            logicRefs: logicRefs, complianceInstances: complianceInstances, logicInstances: logicInstances
        });
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

    function getTagIndex(Action memory action, bytes32 tag) internal pure returns (uint256 index) {
        uint256 logicVerifierInputCount = action.logicVerifierInputs.length;

        for (uint256 i = 0; i < logicVerifierInputCount; ++i) {
            if (tag == action.logicVerifierInputs[i].tag) {
                return (index = i);
            }
        }

        revert NonExistingTag(tag);
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
            blob: hex"1f0000003f0000005f0000007f000000", deletionCriterion: Logic.DeletionCriterion.Immediately
        });
        blobs[1] = Logic.ExpirableBlob({
            blob: hex"9f000000bf000000df000000ff000000", deletionCriterion: Logic.DeletionCriterion.Never
        });
    }

    function initialRoot() internal pure returns (bytes32 root) {
        root = SHA256.EMPTY_HASH;
    }

    function computeActionTreeRoot(Action memory action) internal pure returns (bytes32 root) {
        uint256 complianceUnitCount = action.complianceVerifierInputs.length;

        bytes32[] memory actionTreeTags = new bytes32[](complianceUnitCount * Compliance._RESOURCES_PER_COMPLIANCE_UNIT);

        // The order in which the tags are added to the tree is provided by the compliance units.
        for (uint256 j = 0; j < complianceUnitCount; ++j) {
            Compliance.VerifierInput memory complianceUnit = action.complianceVerifierInputs[j];

            actionTreeTags[2 * j] = complianceUnit.instance.consumed.nullifier;
            actionTreeTags[(2 * j) + 1] = complianceUnit.instance.created.commitment;
        }

        root = actionTreeTags.computeRoot();
    }
}
