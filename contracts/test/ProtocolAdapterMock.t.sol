// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import {RiscZeroMockVerifier} from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";
import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {IProtocolAdapter} from "./../src/interfaces/IProtocolAdapter.sol";
import {MerkleTree} from "./../src/libs/MerkleTree.sol";
import {RiscZeroUtils} from "./../src/libs/RiscZeroUtils.sol";
import {ProtocolAdapter} from "./../src/ProtocolAdapter.sol";
import {Compliance} from "./../src/proving/Compliance.sol";
import {Logic} from "./../src/proving/Logic.sol";
import {NullifierSet} from "./../src/state/NullifierSet.sol";
import {Transaction, Action} from "./../src/Types.sol";
import {ForwarderExample} from "./examples/Forwarder.e.sol";
import {INPUT, EXPECTED_OUTPUT} from "./examples/ForwarderTarget.e.sol";
import {TxGen} from "./libs/TxGen.sol";
import {DeployRiscZeroContractsMock} from "./script/DeployRiscZeroContractsMock.s.sol";

struct ProtocolAdapterTestArgs {
    RiscZeroVerifierRouter router;
    RiscZeroVerifierEmergencyStop emergencyStop;
    RiscZeroMockVerifier verifier;
}

contract ProtocolAdapterMockVerifierTest is Test, ProtocolAdapter {
    using MerkleTree for bytes32[];
    using TxGen for Action[];
    using TxGen for Action;
    using TxGen for Vm;
    using RiscZeroUtils for Logic.VerifierInput;

    /// @notice The parameters necessary to make a failing mutation to a transaction
    /// @param The index of the action to mutate
    /// @param The index of the compliance verifier input of the action to mutate
    /// @param The value to mutate the action tree root to
    struct NonExistingRootFailsParams {
        uint256 actionIdx;
        uint256 inputIdx;
        bytes32 commitmentTreeRoot;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    /// @param The index of the action to mutate
    /// @param The index of the compliance verifier input of the action to mutate
    struct ShortProofFailsParams {
        uint256 actionIdx;
        uint256 inputIdx;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    /// @param The index of the action to mutate
    /// @param The index of the compliance verifier input of the action to mutate
    /// @param The proof to overwrite with
    struct UnknownSelectorFailsParams {
        uint256 actionIdx;
        uint256 inputIdx;
        bytes proof;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    /// @param The index of the action to mutate
    /// @param The index of the compliance verifier input of the action to mutate
    /// @param The tag to overwrite with
    struct UnknownTagFailsParams {
        uint256 actionIdx;
        uint256 inputIdx;
        bytes32 tag;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    /// @param The index of the action to mutate
    /// @param The index of the compliance verifier input of the action to mutate
    struct MismatchingResourcesFailParams {
        uint256 actionIdx;
        uint256 inputIdx;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    /// @param The index of the action to mutate
    /// @param The index of the logic verifier input of the action to mutate
    /// @param The logic reference to overwrite with
    struct MismatchingLogicRefsFailParams {
        uint256 actionIdx;
        uint256 inputIdx;
        bytes32 logicRef;
    }

    /// @notice The parameters necessary to make a failing mutation to a transaction
    /// @param The index of the action to mutate
    /// @param The index of the logic verifier input of the action to mutate
    /// @param The index of the external payload to mutate
    /// @param The output to overwrite with
    struct MismatchingForwarderCallOutputsFailParams {
        uint256 actionIdx;
        uint256 inputIdx;
        uint256 payloadIdx;
        bytes output;
    }

    bytes32 internal constant _CARRIER_LOGIC_REF = bytes32(uint256(123));

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _mockPa;
    bytes4 internal _verifierSelector;
    RiscZeroMockVerifier internal _mockVerifier;
    address internal _fwd;
    address[] internal _fwdList;

    bytes32 internal _carrierLabelRef;

    constructor(ProtocolAdapterTestArgs memory args) ProtocolAdapter(args.router, args.verifier.SELECTOR()) {
        _router = args.router;
        _emergencyStop = args.emergencyStop;
        _mockVerifier = args.verifier;
        _verifierSelector = args.verifier.SELECTOR();
        _mockPa = new ProtocolAdapter({riscZeroVerifierRouter: _router, riscZeroVerifierSelector: _verifierSelector});
    }

    function setUp() public {
        _fwd = address(
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: _CARRIER_LOGIC_REF})
        );

        _fwdList = new address[](1);
        _fwdList[0] = _fwd;

        _carrierLabelRef = sha256(abi.encode(_fwd));
    }

    function testFuzz_execute_emits_the_TransactionExecuted_event(uint8 nActions, uint8 nCUs) public {
        nActions = uint8(bound(nActions, 0, 10));
        nCUs = uint8(bound(nCUs, 0, 10));

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({nActions: nActions, nCUs: nCUs})
        });

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.TransactionExecuted({
            tags: txn.actions.collectTags(),
            logicRefs: txn.actions.collectLogicRefs()
        });
        _mockPa.execute(txn);
    }

    function testFuzz_execute_emits_ActionExecuted_events_for_each_action(uint8 nActions, uint8 nCUs) public {
        nActions = uint8(bound(nActions, 0, 10));
        nCUs = uint8(bound(nCUs, 0, 10));

        (Transaction memory txn,) = vm.transaction({
            mockVerifier: _mockVerifier,
            nonce: 0,
            configs: TxGen.generateActionConfigs({nActions: nActions, nCUs: nCUs})
        });

        for (uint256 i = 0; i < nActions; ++i) {
            vm.expectEmit(address(_mockPa));
            emit IProtocolAdapter.ActionExecuted({
                actionTreeRoot: txn.actions[i].collectTags().computeRoot(),
                tagsCount: nCUs * 2
            });
        }
        _mockPa.execute(txn);
    }

    function test_execute_emits_the_ForwarderCallExecuted_event_on_created_carrier_resource() public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: _fwdList});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });
        _mockPa.execute(txn);
    }

    function test_execute_emits_the_ForwarderCallExecuted_event_on_consumed_carrier_resource() public {
        TxGen.ResourceAndAppData[] memory consumed = _exampleCarrierResourceAndAppData({nonce: 0, fwdList: _fwdList});
        TxGen.ResourceAndAppData[] memory created = _exampleResourceAndEmptyAppData({nonce: 1});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });

        _mockPa.execute(txn);
    }

    function test_execute_emits_all_ForwarderCallExecuted_events() public {
        address fwd2 = address(
            new ForwarderExample({protocolAdapter: address(_mockPa), calldataCarrierLogicRef: _CARRIER_LOGIC_REF})
        );
        assertNotEq(_fwd, fwd2);

        address[] memory fwdList = new address[](2);
        fwdList[0] = _fwd;
        fwdList[1] = fwd2;

        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: fwdList});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(_fwd),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });

        vm.expectEmit(address(_mockPa));
        emit IProtocolAdapter.ForwarderCallExecuted({
            untrustedForwarder: address(fwd2),
            input: INPUT,
            output: EXPECTED_OUTPUT
        });

        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_2_action_with_1_and_0_cus() public {
        TxGen.ActionConfig[] memory configs = new TxGen.ActionConfig[](2);
        configs[0] = TxGen.ActionConfig({nCUs: 1});
        configs[1] = TxGen.ActionConfig({nCUs: 0});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});

        _mockPa.execute(txn);
    }

    function test_execute_1_txn_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        _mockPa.execute(txn);
    }

    function test_execute_2_txns_with_n_actions_and_n_cus(uint8 nActions, uint8 nCUs) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 0, 5)), nCUs: uint8(bound(nCUs, 0, 5))});

        (Transaction memory txn, bytes32 updatedNonce) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        _mockPa.execute(txn);

        (txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: updatedNonce, configs: configs});
        _mockPa.execute(txn);
    }

    function test_execute_reverts_on_pre_existing_nullifier() public {
        TxGen.ActionConfig[] memory configs = TxGen.generateActionConfigs({nActions: 1, nCUs: 1});

        (Transaction memory tx1, bytes32 updatedNonce) =
            vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        bytes32 preExistingNf = tx1.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;
        _mockPa.execute(tx1);

        (Transaction memory tx2,) = vm.transaction({mockVerifier: _mockVerifier, nonce: updatedNonce, configs: configs});
        tx2.actions[0].complianceVerifierInputs[0].instance.consumed.nullifier = preExistingNf;
        vm.expectRevert(
            abi.encodeWithSelector(NullifierSet.PreExistingNullifier.selector, preExistingNf), address(_mockPa)
        );
        _mockPa.execute(tx2);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by giving one of its compliance verifier inputs an incorrect
    /// commitment tree root.
    /// @param transaction A successful transaction
    /// @param params A failure inducing modification
    function mutationTestExecuteNonExistingRootFails(
        Transaction memory transaction,
        NonExistingRootFailsParams memory params
    ) public {
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Assume the proposed commitment tree root is not already contained
        vm.assume(!_containsRoot(params.commitmentTreeRoot));
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally assign the proposed commitment tree root into the transaction
        complianceVerifierInputs[params.inputIdx].instance.consumed.commitmentTreeRoot = params.commitmentTreeRoot;
        // With an incorrect commitment tree root, we expect failure
        vm.expectRevert(abi.encodeWithSelector(NonExistingRoot.selector, params.commitmentTreeRoot));
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with nonexistent rotts fail
    function testFuzz_execute_non_existing_root_fails(
        uint8 nActions,
        uint8 nCUs,
        NonExistingRootFailsParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutationTestExecuteNonExistingRootFails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by giving one of its compliance verifier inputs a proof that's too
    /// short.
    /// @param transaction A successful transaction
    /// @param params A failure inducing modification
    function mutationTestExecuteShortProofFails(Transaction memory transaction, ShortProofFailsParams memory params)
        public
    {
        uint256 minProofLen = 4;
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally truncate the compliance proof to below the minimum
        bytes memory proof = complianceVerifierInputs[params.inputIdx].proof;
        bytes memory truncatedProof = new bytes(proof.length % minProofLen);
        for (uint256 k = 0; k < truncatedProof.length; k++) {
            truncatedProof[k] = proof[k];
        }
        complianceVerifierInputs[params.inputIdx].proof = truncatedProof;
        // With a short proof, we expect failure
        vm.expectRevert(address(_router));
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with short proofs fail
    function testFuzz_execute_short_proof_fails(uint8 nActions, uint8 nCUs, ShortProofFailsParams memory params)
        public
    {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutationTestExecuteShortProofFails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by giving one of its compliance verifier inputs a proof with an
    /// unknown selector.
    /// @param transaction A successful transaction
    /// @param params A failure inducing modification
    function mutationTestExecuteUnknownSelectorFails(
        Transaction memory transaction,
        UnknownSelectorFailsParams memory params
    ) public {
        // Make sure that the chosen verifier selector does not exist
        uint256 minProofLen = 4;
        vm.assume(params.proof.length >= minProofLen);
        vm.assume(address(_router.verifiers(bytes4(params.proof))) == address(0));
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Finally, corrupt the verifier selector
        complianceVerifierInputs[params.inputIdx].proof = params.proof;
        // With an unknown selector, we expect failure
        vm.expectRevert(
            abi.encodeWithSelector(RiscZeroVerifierRouter.SelectorUnknown.selector, bytes4(params.proof)),
            address(_router)
        );
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with unknown selectors fail
    function testFuzz_execute_unknown_selector_fails(
        uint8 nActions,
        uint8 nCUs,
        UnknownSelectorFailsParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutationTestExecuteUnknownSelectorFails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that the nullifier of one of its compliance verifier
    /// inputs is not found in the logic verifier inputs.
    /// @param transaction A successful transaction
    /// @param params A failure inducing modification
    function mutationTestExecuteUnknownNullifierTagFails(
        Transaction memory transaction,
        UnknownTagFailsParams memory params
    ) public {
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        Compliance.VerifierInput memory complianceVerifierInput = complianceVerifierInputs[params.inputIdx];
        // Make sure that the planned corruption will change something
        vm.assume(complianceVerifierInput.instance.consumed.nullifier != params.tag);
        // Finally, corrupt the corresponding logic verifier input tag
        Logic.VerifierInput[] memory logicVerifierInputs = transaction.actions[params.actionIdx].logicVerifierInputs;
        // Do a linear search to identify the corresponding logic verifier input
        for (uint256 i = 0; i < logicVerifierInputs.length; i++) {
            // Select the logic verifier input with a tag matching the nullifier
            if (logicVerifierInputs[i].tag == complianceVerifierInput.instance.consumed.nullifier) {
                // Finally, corrupt the logic verifier input tag so it can no longer be found
                logicVerifierInputs[i].tag = params.tag;
            }
        }
        // With an unknown tag, we expect failure
        vm.expectRevert(
            abi.encodeWithSelector(
                Logic.TagNotFound.selector, complianceVerifierInputs[params.inputIdx].instance.consumed.nullifier
            )
        );
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with unknown nullifier tags fail
    function testFuzz_execute_unknown_nullifier_tag_fails(
        uint8 nActions,
        uint8 nCUs,
        UnknownTagFailsParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutationTestExecuteUnknownNullifierTagFails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that the commitment of one of its compliance verifier
    /// inputs is not found in the logic verifier inputs.
    /// @param transaction A successful transaction
    /// @param params A failure inducing modification
    function mutationTestExecuteUnknownCommitmentTagFails(
        Transaction memory transaction,
        UnknownTagFailsParams memory params
    ) public {
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Compliance.VerifierInput[] memory complianceVerifierInputs =
            transaction.actions[params.actionIdx].complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        Compliance.VerifierInput memory complianceVerifierInput = complianceVerifierInputs[params.inputIdx];
        // Make sure that the planned corruption will change something
        vm.assume(complianceVerifierInput.instance.created.commitment != params.tag);
        // Finally, corrupt the corresponding logic verifier input tag
        Logic.VerifierInput[] memory logicVerifierInputs = transaction.actions[params.actionIdx].logicVerifierInputs;
        // Do a linear search to identify the corresponding logic verifier input
        for (uint256 i = 0; i < logicVerifierInputs.length; i++) {
            // Select the logic verifier input with a tag matching the commitment
            if (logicVerifierInputs[i].tag == complianceVerifierInput.instance.created.commitment) {
                // Finally, corrupt the logic verifier input tag so it can no longer be found
                logicVerifierInputs[i].tag = params.tag;
            }
        }
        // With an unknown tag, we expect failure
        vm.expectRevert(
            abi.encodeWithSelector(
                Logic.TagNotFound.selector, complianceVerifierInputs[params.inputIdx].instance.created.commitment
            )
        );
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with unknown commitment tags fail
    function testFuzz_execute_unknown_commitment_tag_fails(
        uint8 nActions,
        uint8 nCUs,
        UnknownTagFailsParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutationTestExecuteUnknownCommitmentTagFails(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that it has less compliance verifier inputs than half
    /// the logic verifier inputs.
    /// @param transaction A successful transaction
    /// @param params A failure inducing modification
    function mutationTestExecuteMissingComplianceVerifierInputFail(
        Transaction memory transaction,
        MismatchingResourcesFailParams memory params
    ) public {
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Action memory action = transaction.actions[params.actionIdx];
        Compliance.VerifierInput[] memory complianceVerifierInputs = action.complianceVerifierInputs;
        // Wrap the compliance verifier input index into range
        params.inputIdx = params.inputIdx % complianceVerifierInputs.length;
        // Now delete the array entry
        // Replace the target position with the last element
        complianceVerifierInputs[params.inputIdx] = complianceVerifierInputs[complianceVerifierInputs.length - 1];
        // Then make a shorter array of compliance verifier inputs
        Compliance.VerifierInput[] memory shorter = new Compliance.VerifierInput[](complianceVerifierInputs.length - 1);
        for (uint256 i = 0; i < shorter.length; i++) {
            shorter[i] = complianceVerifierInputs[i];
        }
        // Finally, replace the compliance verifier inputs with the shorter array
        transaction.actions[params.actionIdx].complianceVerifierInputs = shorter;
        // With mismatching resource counts, we expect failure
        vm.expectRevert(
            abi.encodeWithSelector(ResourceCountMismatch.selector, action.logicVerifierInputs.length, shorter.length)
        );
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with a missing compliance verifier input fail
    function testFuzz_execute_missing_compliance_verifier_input_fail(
        uint8 nActions,
        uint8 nCUs,
        MismatchingResourcesFailParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutationTestExecuteMissingComplianceVerifierInputFail(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that it has less logic verifier inputs than the number
    /// of compliance verifier inputs doubled.
    /// @param transaction A successful transaction
    /// @param params A failure inducing modification
    function mutationTestExecuteMissingLogicVerifierInputFail(
        Transaction memory transaction,
        MismatchingResourcesFailParams memory params
    ) public {
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Action memory action = transaction.actions[params.actionIdx];
        Logic.VerifierInput[] memory logicVerifierInputs = action.logicVerifierInputs;
        // Wrap the logic verifier input index into range
        params.inputIdx = params.inputIdx % logicVerifierInputs.length;
        // Now delete the array entry
        // Replace the target position with the last element
        logicVerifierInputs[params.inputIdx] = logicVerifierInputs[logicVerifierInputs.length - 1];
        // Then make a shorter array of logic verifier inputs
        Logic.VerifierInput[] memory shorter = new Logic.VerifierInput[](logicVerifierInputs.length - 1);
        for (uint256 i = 0; i < shorter.length; i++) {
            shorter[i] = logicVerifierInputs[i];
        }
        // Finally, replace the logic verifier inputs with the shorter array
        transaction.actions[params.actionIdx].logicVerifierInputs = shorter;
        // With mismatching resource counts, we expect failure
        vm.expectRevert(
            abi.encodeWithSelector(
                ResourceCountMismatch.selector, shorter.length, action.complianceVerifierInputs.length
            )
        );
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with a missing logic verifier input fail
    function testFuzz_execute_missing_logic_verifier_input_fail(
        uint8 nActions,
        uint8 nCUs,
        MismatchingResourcesFailParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutationTestExecuteMissingLogicVerifierInputFail(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that the verifying key of one of its logic verifier
    /// inputs does not match the nullifier or commitment in the corresponding
    /// compliance verifier input.
    /// @param transaction A successful transaction
    /// @param params A failure inducing modification
    function mutationTestExecuteMismatchingLogicRefsFail(
        Transaction memory transaction,
        MismatchingLogicRefsFailParams memory params
    ) public {
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Logic.VerifierInput[] memory logicVerifierInputs = transaction.actions[params.actionIdx].logicVerifierInputs;
        // Wrap the logic verifier input index into range
        params.inputIdx = params.inputIdx % logicVerifierInputs.length;
        // Now corrupt the logic reference
        vm.assume(logicVerifierInputs[params.inputIdx].verifyingKey != params.logicRef);
        logicVerifierInputs[params.inputIdx].verifyingKey = params.logicRef;
        // With mismatching logic references, we expect failure
        vm.expectPartialRevert(LogicRefMismatch.selector);
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with mismatching logic references fail
    function testFuzz_execute_mismatching_logic_refs_fail(
        uint8 nActions,
        uint8 nCUs,
        MismatchingLogicRefsFailParams memory params
    ) public {
        TxGen.ActionConfig[] memory configs =
            TxGen.generateActionConfigs({nActions: uint8(bound(nActions, 1, 5)), nCUs: uint8(bound(nCUs, 1, 5))});

        (Transaction memory txn,) = vm.transaction({mockVerifier: _mockVerifier, nonce: 0, configs: configs});
        mutationTestExecuteMismatchingLogicRefsFail(txn, params);
    }

    /// @notice Take a transaction that would execute successfully and make it
    /// fail by ensuring that one of its forwarder call outputs mismatch.
    /// @param transaction A successful transaction
    /// @param params A failure inducing modification
    function mutationTestExecuteMismatchingForwarderCallOutputsFail(
        Transaction memory transaction,
        MismatchingForwarderCallOutputsFailParams memory params
    ) public {
        // Wrap the action index into range
        params.actionIdx = params.actionIdx % transaction.actions.length;
        Action memory action = transaction.actions[params.actionIdx];
        Logic.VerifierInput[] memory logicVerifierInputs = action.logicVerifierInputs;
        // Wrap the logic verifier input index into range
        params.inputIdx = params.inputIdx % logicVerifierInputs.length;
        Logic.VerifierInput memory logicVerifierInput = logicVerifierInputs[params.inputIdx];
        Logic.ExpirableBlob[] memory externalPayloads = logicVerifierInput.appData.externalPayload;
        // Cannot do the mutation if transaction has no external payloads
        vm.assume(externalPayloads.length > 0);
        // Wrap the external payload index into range
        params.payloadIdx = params.payloadIdx % externalPayloads.length;
        // Now corrupt the calldata output
        (address untrustedForwarder, bytes memory input, bytes memory expectedOutput) =
            abi.decode(externalPayloads[params.payloadIdx].blob, (address, bytes, bytes));
        vm.assume(
            expectedOutput.length != params.output.length || keccak256(expectedOutput) != keccak256(params.output)
        );
        // Re-encode the calldata and replace the value in the external payloads
        externalPayloads[params.payloadIdx].blob = abi.encode(untrustedForwarder, input, params.output);
        // Now determine whether the current resource is being created or consumed
        Compliance.VerifierInput[] memory complianceVerifierInputs = action.complianceVerifierInputs;
        bool isConsumed;
        for (uint256 i = 0; i < complianceVerifierInputs.length; i++) {
            if (complianceVerifierInputs[i].instance.consumed.nullifier == logicVerifierInput.tag) {
                isConsumed = true;
            } else if (
                complianceVerifierInputs[i].instance.created.commitment == logicVerifierInputs[params.inputIdx].tag
            ) {
                isConsumed = false;
            }
        }
        // Compute the action tree root
        bytes32 actionTreeRoot = _computeActionTreeRoot_memory(action, action.complianceVerifierInputs.length);
        // Recompute the logic verifier input proof
        logicVerifierInputs[params.inputIdx].proof = _mockVerifier.mockProve({
            imageId: logicVerifierInputs[params.inputIdx].verifyingKey,
            journalDigest: logicVerifierInputs[params.inputIdx].toJournalDigest(actionTreeRoot, isConsumed)
        }).seal;
        // With mismatching forwarder call outputs, we expect failure
        vm.expectRevert(abi.encodeWithSelector(ForwarderCallOutputMismatch.selector, params.output, expectedOutput));
        // Finally, execute the transaction to make sure that it fails
        this.execute(transaction);
    }

    /// @notice Test that transactions with mismatching forwarder call outputs fails
    function testFuzz_execute_mismatching_forwarder_call_outputs_fail(
        MismatchingForwarderCallOutputsFailParams memory params
    ) public {
        bytes32 carrierLogicRef = bytes32(uint256(123));
        address fwd =
            address(new ForwarderExample({protocolAdapter: address(this), calldataCarrierLogicRef: carrierLogicRef}));
        address fwd2 =
            address(new ForwarderExample({protocolAdapter: address(this), calldataCarrierLogicRef: carrierLogicRef}));
        assertNotEq(fwd, fwd2);

        address[] memory fwdList = new address[](2);
        fwdList[0] = fwd;
        fwdList[1] = fwd2;

        TxGen.ResourceAndAppData[] memory consumed = _exampleResourceAndEmptyAppData({nonce: 0});
        TxGen.ResourceAndAppData[] memory created = _exampleCarrierResourceAndAppData({nonce: 1, fwdList: fwdList});

        TxGen.ResourceLists[] memory resourceLists = new TxGen.ResourceLists[](1);
        resourceLists[0] = TxGen.ResourceLists({consumed: consumed, created: created});
        Transaction memory txn = vm.transaction(_mockVerifier, resourceLists);
        mutationTestExecuteMismatchingForwarderCallOutputsFail(txn, params);
    }

    /// @notice Computes the action tree root of an action constituted by all its nullifiers and commitments.
    /// @param action The action whose root we compute.
    /// @param nCUs The number of compliance units in the action.
    /// @return root The root of the corresponding tree.
    function _computeActionTreeRoot_memory(Action memory action, uint256 nCUs) internal pure returns (bytes32 root) {
        bytes32[] memory actionTreeTags = new bytes32[](nCUs * 2);

        // The order in which the tags are added to the tree are provided by the compliance units
        for (uint256 j = 0; j < nCUs; ++j) {
            Compliance.VerifierInput memory complianceVerifierInput = action.complianceVerifierInputs[j];

            actionTreeTags[2 * j] = complianceVerifierInput.instance.consumed.nullifier;
            actionTreeTags[(2 * j) + 1] = complianceVerifierInput.instance.created.commitment;
        }

        root = actionTreeTags.computeRoot();
    }

    function _exampleResourceAndEmptyAppData(uint256 nonce)
        private
        view
        returns (TxGen.ResourceAndAppData[] memory data)
    {
        data = new TxGen.ResourceAndAppData[](1);

        data[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({
                nonce: bytes32(nonce),
                logicRef: _CARRIER_LOGIC_REF,
                labelRef: _carrierLabelRef,
                quantity: 1
            }),
            appData: Logic.AppData({
                discoveryPayload: new Logic.ExpirableBlob[](0),
                resourcePayload: new Logic.ExpirableBlob[](0),
                externalPayload: new Logic.ExpirableBlob[](0),
                applicationPayload: new Logic.ExpirableBlob[](0)
            })
        });
    }

    function _exampleCarrierResourceAndAppData(uint256 nonce, address[] memory fwdList)
        private
        view
        returns (TxGen.ResourceAndAppData[] memory data)
    {
        data = new TxGen.ResourceAndAppData[](1);
        uint256 nCalls = fwdList.length;

        data[0] = TxGen.ResourceAndAppData({
            resource: TxGen.mockResource({
                nonce: bytes32(nonce),
                logicRef: _CARRIER_LOGIC_REF,
                labelRef: _carrierLabelRef,
                quantity: 1
            }),
            appData: Logic.AppData({
                discoveryPayload: new Logic.ExpirableBlob[](0),
                resourcePayload: new Logic.ExpirableBlob[](0),
                externalPayload: new Logic.ExpirableBlob[](nCalls),
                applicationPayload: new Logic.ExpirableBlob[](0)
            })
        });

        Logic.ExpirableBlob[] memory externalBlobs = new Logic.ExpirableBlob[](nCalls);
        for (uint256 i = 0; i < nCalls; ++i) {
            externalBlobs[i] = Logic.ExpirableBlob({
                deletionCriterion: Logic.DeletionCriterion.Never,
                blob: abi.encode(address(fwdList[i]), INPUT, EXPECTED_OUTPUT)
            });
        }
        data[0].appData.externalPayload = externalBlobs;
    }
}

contract ProtocolAdapterTest is ProtocolAdapterMockVerifierTest {
    constructor() ProtocolAdapterMockVerifierTest(baseArgs()) {}

    function baseArgs() public returns (ProtocolAdapterTestArgs memory args) {
        RiscZeroVerifierRouter router;
        RiscZeroVerifierEmergencyStop emergencyStop;
        RiscZeroMockVerifier verifier;
        (router, emergencyStop, verifier) = new DeployRiscZeroContractsMock().run();
        return ProtocolAdapterTestArgs({router: router, emergencyStop: emergencyStop, verifier: verifier});
    }
}
