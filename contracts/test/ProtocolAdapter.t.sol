// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Pausable} from "@openzeppelin-contracts/utils/Pausable.sol";

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {IProtocolAdapter} from "../src/interfaces/IProtocolAdapter.sol";
import {TagLookup} from "../src/libs/TagLookup.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Compliance} from "../src/proving/Compliance.sol";
import {Logic} from "../src/proving/Logic.sol";
import {Transaction, Action, ResourceForwarderCalldataPair} from "../src/Types.sol";
import {Example} from "./mocks/Example.sol";

contract ProtocolAdapterTest is Test {
    uint256 internal constant _SEPOLIA_EMERGENCY_STOP_TIME = 8577299;

    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;

    function test_constructor_reverts_on_vulnerable_risc_zero_verifier() public {
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";
        RiscZeroVerifierRouter sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));
        uint8 commitmentTreeDepth = uint8(vm.parseUint(vm.readLine(path)));
        uint8 actionTagTreeDepth = uint8(vm.parseUint(vm.readLine(path)));

        vm.expectRevert(ProtocolAdapter.RiscZeroVerifierStopped.selector);
        new ProtocolAdapter({
            riscZeroVerifierRouter: sepoliaVerifierRouter,
            commitmentTreeDepth: commitmentTreeDepth,
            actionTagTreeDepth: actionTagTreeDepth
        });
    }

    function test_verify_reverts_on_vulnerable_risc_zero_verifier() public {
        ProtocolAdapter pa = _vulnerableSepoliaProtocolAdapter();
        RiscZeroVerifierEmergencyStop riscZeroEmergencyStop =
            RiscZeroVerifierEmergencyStop(address(_sepoliaVerifierRouter.getVerifier(pa.getRiscZeroVerifierSelector())));

        vm.prank(riscZeroEmergencyStop.owner());
        riscZeroEmergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(riscZeroEmergencyStop));
        pa.verify(Example.transaction());
    }

    function test_execute_reverts_on_vulnerable_risc_zero_verifier() public {
        ProtocolAdapter pa = _vulnerableSepoliaProtocolAdapter();
        RiscZeroVerifierEmergencyStop riscZeroEmergencyStop =
            RiscZeroVerifierEmergencyStop(address(_sepoliaVerifierRouter.getVerifier(pa.getRiscZeroVerifierSelector())));

        vm.prank(riscZeroEmergencyStop.owner());
        riscZeroEmergencyStop.estop();

        vm.expectRevert(Pausable.EnforcedPause.selector, address(riscZeroEmergencyStop));
        pa.execute(Example.transaction());
    }

    function test_execute() public {
        ProtocolAdapter pa = _vulnerableSepoliaProtocolAdapter();
        pa.execute(Example.transaction());
    }

    function test_execute_empty_tx() public {
        ProtocolAdapter pa = _vulnerableSepoliaProtocolAdapter();
        Transaction memory txn = Transaction({actions: new Action[](0), deltaProof: ""});
        pa.execute(txn);
    }

    function test_verify() public {
        ProtocolAdapter pa = _vulnerableSepoliaProtocolAdapter();
        pa.verify(Example.transaction());
    }

    function test_execute_emits_the_Blob_event() public {
        ProtocolAdapter pa = _vulnerableSepoliaProtocolAdapter();

        Transaction memory txn = Example.transaction();
        vm.expectEmit(address(pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[0].instance.appData[0]);

        vm.expectEmit(address(pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[0].instance.appData[1]);

        vm.expectEmit(address(pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[1].instance.appData[0]);

        vm.expectEmit(address(pa));
        emit IProtocolAdapter.Blob(txn.actions[0].logicVerifierInputs[1].instance.appData[1]);

        pa.execute(txn);
    }

    function test_verify_empty_tx() public {
        ProtocolAdapter pa = _vulnerableSepoliaProtocolAdapter();

        Transaction memory txn = Transaction({actions: new Action[](0), deltaProof: ""});
        pa.verify(txn);
    }

    function test_verify_reverts_on_action_with_duplicated_nullifiers() public {
        ProtocolAdapter pa = _vulnerableSepoliaProtocolAdapter();

        Action[] memory actions = new Action[](1);
        actions[0] = _actionWithDuplicatedComplianceUnit();

        bytes32 duplicatedNullifier = actions[0].complianceVerifierInputs[0].instance.consumed.nullifier;

        Transaction memory txn = Transaction({actions: actions, deltaProof: ""});

        vm.expectRevert(
            abi.encodeWithSelector(TagLookup.NullifierDuplicated.selector, duplicatedNullifier), address(pa)
        );
        pa.verify(txn);
    }

    function test_verify_reverts_on_action_with_duplicated_commitments() public {
        ProtocolAdapter pa = _vulnerableSepoliaProtocolAdapter();

        Action[] memory actions = new Action[](1);
        actions[0] = _actionWithDuplicatedComplianceUnit();

        bytes32 duplicatedCommitment = actions[0].complianceVerifierInputs[0].instance.created.commitment;
        actions[0].complianceVerifierInputs[1].instance.consumed.nullifier = keccak256("Not a duplicate");

        Transaction memory txn = Transaction({actions: actions, deltaProof: ""});

        vm.expectRevert(
            abi.encodeWithSelector(TagLookup.CommitmentDuplicated.selector, duplicatedCommitment), address(pa)
        );
        pa.verify(txn);
    }

    // solhint-disable-next-line no-empty-blocks
    function test_tx_with_cu_mismatch_fails() public view {
        // TODO: create a transaction with no compliance units and two trivial resources
        //       in the action
    }

    function _vulnerableSepoliaProtocolAdapter() internal returns (ProtocolAdapter pa) {
        /* NOTE:
             * Here we fork sepolia before emergency stop was called on the `RiscZeroVerifierEmergencyStop` contract for v2.0.0
             * See
             * - https://sepolia.etherscan.io/address/0x8A8023bf44CABa343CEef3b06A4639fc8EBeE629
             * - https://github.com/risc0/risc0/security/advisories/GHSA-g3qg-6746-3mg9
             * for the details.
             */
        vm.selectFork(vm.createFork("sepolia", _SEPOLIA_EMERGENCY_STOP_TIME - 1));

        string memory path = "./script/constructor-args.txt";

        _sepoliaVerifierRouter = RiscZeroVerifierRouter(vm.parseAddress(vm.readLine(path)));

        pa = new ProtocolAdapter({
            riscZeroVerifierRouter: _sepoliaVerifierRouter, // Sepolia verifier
            commitmentTreeDepth: uint8(vm.parseUint(vm.readLine(path))),
            actionTagTreeDepth: uint8(vm.parseUint(vm.readLine(path)))
        });
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
