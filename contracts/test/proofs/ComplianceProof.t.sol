// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, Vm} from "forge-std-1.14.0/src/Test.sol";
import {
    RiscZeroVerifierEmergencyStop
} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "risc0-risc0-ethereum-3.0.1/contracts/src/RiscZeroVerifierRouter.sol";

import {Compliance} from "../../src/libs/proving/Compliance.sol";
import {RiscZeroUtils} from "../../src/libs/RiscZeroUtils.sol";
import {Transaction} from "../../src/Types.sol";
import {Parsing} from "../libs/Parsing.sol";
import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

contract ComplianceProofTest is Test {
    using Parsing for Transaction;
    using Parsing for Vm;
    using RiscZeroUtils for Compliance.Instance;

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;

    Transaction internal _exampleTx;

    function setUp() public {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run({admin: msg.sender, guardian: msg.sender});

        _exampleTx.toStorage(vm.parseTransaction("test/examples/transactions/test_tx_reg_01_01.bin"));
    }

    function test_verify_example_compliance_proof() public view {
        Compliance.VerifierInput memory cu = _exampleTx.actions[0].complianceVerifierInputs[0];

        _router.verify({
            seal: cu.proof, imageId: Compliance._VERIFYING_KEY, journalDigest: sha256(cu.instance.toJournal())
        });
    }

    function test_compliance_instance_encoding() public view {
        Compliance.Instance memory instance = _exampleTx.actions[0].complianceVerifierInputs[0].instance;

        assertEq(
            abi.encode(instance),
            abi.encodePacked(
                instance.consumed.nullifier,
                instance.consumed.logicRef,
                instance.consumed.commitmentTreeRoot,
                instance.created.commitment,
                instance.created.logicRef,
                instance.unitDeltaX,
                instance.unitDeltaY
            ),
            "compliance instance encoding should match packed encoding"
        );
    }
}
