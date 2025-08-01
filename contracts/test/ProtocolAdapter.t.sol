// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {DeployRiscZeroVerifierRouter} from "../script/DeployRiscZeroVerifierRouter.s.sol";

import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {Parameters} from "../src/libs/Parameters.sol";
import {TagLookup} from "../src/libs/TagLookup.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Compliance} from "../src/proving/Compliance.sol";
import {Logic} from "../src/proving/Logic.sol";
import {Transaction, Action, ResourceForwarderCalldataPair} from "../src/Types.sol";
import {Example} from "./mocks/Example.sol";

contract ProtocolAdapterTest is Test {
    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;
    ProtocolAdapter internal _pa;

    function setUp() public {
        bytes4 selector;
        (_router, selector) = (new DeployRiscZeroVerifierRouter()).run();
        _emergencyStop = RiscZeroVerifierEmergencyStop(address(_router.getVerifier(selector)));

        _pa = new ProtocolAdapter({
            riscZeroVerifierRouter: _router,
            commitmentTreeDepth: Parameters.COMMITMENT_TREE_DEPTH,
            actionTagTreeDepth: Parameters.ACTION_TAG_TREE_DEPTH
        });
    }

    function test_constructor_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(ProtocolAdapter.RiscZeroVerifierStopped.selector);
        new ProtocolAdapter({riscZeroVerifierRouter: _router, commitmentTreeDepth: 32, actionTagTreeDepth: 4});
    }

    function test_verify_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(_emergencyStop));
        _pa.verify(Example.transaction());
    }

    function test_execute_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.prank(_emergencyStop.owner());
        _emergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(_emergencyStop));
        _pa.execute(Example.transaction());
    }

    function test_execute() public {
        _pa.execute(Example.transaction());
    }

    function test_execute_empty_tx() public {
        Transaction memory txn = Transaction({actions: new Action[](0), deltaProof: ""});
        _pa.execute(txn);
    }

    function test_execute_emits_the_Blob_event() public {
        Transaction memory txn = Example.transaction();
        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[0].instance.appData[0]);

        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[0].instance.appData[1]);

        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[1].instance.appData[0]);

        vm.expectEmit(address(_pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[1].instance.appData[1]);

        _pa.execute(txn);
    }

    function test_verify_reverts_on_action_with_duplicated_nullifiers() public {
        Action[] memory actions = new Action[](1);
        actions[0] = _actionWithDuplicatedComplianceUnit();

        bytes32 duplicatedNullifier = actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;

        Transaction memory txn = Transaction({actions: actions, deltaProof: ""});

        vm.expectRevert(
            abi.encodeWithSelector(TagLookup.NullifierDuplicated.selector, duplicatedNullifier), address(_pa)
        );
        _pa.verify(txn);
    }

    function test_verify_reverts_on_action_with_duplicated_commitments() public {
        Action[] memory actions = new Action[](1);
        actions[0] = _actionWithDuplicatedComplianceUnit();

        bytes32 duplicatedCommitment = actions[0].complianceVerifierInputs[0].instance.created.commitment;
        actions[0].complianceVerifierInputs[1].instance.consumed.nullifier = keccak256("Not a duplicate");

        Transaction memory txn = Transaction({actions: actions, deltaProof: ""});

        vm.expectRevert(
            abi.encodeWithSelector(TagLookup.CommitmentDuplicated.selector, duplicatedCommitment), address(_pa)
        );
        _pa.verify(txn);
    }

    function test_verify_empty_tx() public view {
        Transaction memory txn = Transaction({actions: new Action[](0), deltaProof: ""});
        _pa.verify(txn);
    }

    function test_verify() public view {
        _pa.verify(Example.transaction());
    }

    // solhint-disable-next-line no-empty-blocks
    function test_tx_with_cu_mismatch_fails() public view {
        // TODO: create a transaction with no compliance units and two trivial resources
        //       in the action
    }

    function _actionWithDuplicatedComplianceUnit() internal pure returns (Action memory action) {
        Compliance.VerifierInput[] memory complianceVerifierInputs = new Compliance.VerifierInput[](2);
        complianceVerifierInputs[0] = Example.complianceVerifierInput();
        complianceVerifierInputs[1] = Example.complianceVerifierInput();

        Logic.VerifierInput[] memory logicVerifierInputs = new Logic.VerifierInput[](4);
        logicVerifierInputs[0] = Example.logicVerifierInput({isConsumed: true});
        logicVerifierInputs[1] = Example.logicVerifierInput({isConsumed: false});
        logicVerifierInputs[2] = Example.logicVerifierInput({isConsumed: true});
        logicVerifierInputs[3] = Example.logicVerifierInput({isConsumed: false});

        action = Action({
            logicVerifierInputs: logicVerifierInputs,
            complianceVerifierInputs: complianceVerifierInputs,
            resourceCalldataPairs: new ResourceForwarderCalldataPair[](0)
        });
    }
}
