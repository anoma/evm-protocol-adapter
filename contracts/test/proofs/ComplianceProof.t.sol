// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroVerifierEmergencyStop} from "@risc0-ethereum/RiscZeroVerifierEmergencyStop.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {Compliance} from "../../src/libs/proving/Compliance.sol";
import {RiscZeroUtils} from "../../src/libs/utils/RiscZeroUtils.sol";
import {TransactionExample} from "../examples/transactions/Transaction.e.sol";
import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

contract ComplianceProofTest is Test {
    using RiscZeroUtils for Compliance.Instance;

    RiscZeroVerifierRouter internal _router;
    RiscZeroVerifierEmergencyStop internal _emergencyStop;

    function setUp() public {
        (_router, _emergencyStop,) = new DeployRiscZeroContracts().run();
    }

    function test_verify_example_compliance_proof() public view {
        Compliance.VerifierInput memory cu = TransactionExample.complianceVerifierInput();

        _router.verify({
            seal: cu.proof,
            imageId: Compliance._VERIFYING_KEY,
            journalDigest: sha256(cu.instance.toJournal())
        });
    }

    function test_compliance_instance_encoding() public pure {
        Compliance.Instance memory instance = TransactionExample.complianceInstance();

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
            )
        );
    }
}
