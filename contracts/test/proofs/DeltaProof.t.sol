// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ECDSA} from "@openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import {Test} from "forge-std/Test.sol";

import {Delta} from "../../src/proving/Delta.sol";
import {Transaction} from "../../src/Types.sol";
import {Example} from "../mocks/Example.sol";
import {MockDelta} from "../mocks/MockDelta.sol";

contract DeltaProofTest is Test {
    function test_signatureIntegrity() public pure {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(MockDelta.SIGNER_PRIVATE_KEY, MockDelta.MESSAGE_HASH);
        assertEq(r, MockDelta.R);
        assertEq(s, MockDelta.S);
        assertEq(v, MockDelta.V);
    }

    function test_signatureRecovery() public pure {
        address recovered = ECDSA.recover({hash: MockDelta.MESSAGE_HASH, signature: MockDelta.PROOF});
        assertEq(recovered, MockDelta.SIGNER_ACCOUNT);
    }

    function test_verify_mock_delta_proof() public pure {
        Delta.verify({
            proof: MockDelta.PROOF,
            instance: MockDelta.transactionDelta(),
            verifyingKey: MockDelta.MESSAGE_HASH
        });
    }

    function test_verify_example_delta_proof() public pure {
        bytes32[] memory tags = new bytes32[](2);
        tags[0] = Example._CONSUMED_NULLIFIER;
        tags[1] = Example._CREATED_COMMITMENT;

        Transaction memory txn = Example.transaction();

        uint256[2] memory transactionDelta = [
            uint256(txn.actions[0].complianceVerifierInputs[0].instance.unitDeltaX),
            uint256(txn.actions[0].complianceVerifierInputs[0].instance.unitDeltaY)
        ];

        Delta.verify({proof: txn.deltaProof, instance: transactionDelta, verifyingKey: Delta.computeVerifyingKey(tags)});
    }
}
