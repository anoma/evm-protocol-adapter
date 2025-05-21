// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ECDSA} from "@openzeppelin-contracts/utils/cryptography/ECDSA.sol";
import {Test, console} from "forge-std/Test.sol";

import {Delta} from "../../src/proving/Delta.sol";
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

    function test_deltaVerify() public pure {
        Delta.verify({
            tagsHash: MockDelta.MESSAGE_HASH,
            transactionDelta: MockDelta.transactionDelta(),
            deltaProof: MockDelta.PROOF
        });
    }

    function test_exmapleDeltaProof() public pure {
        revert("TODO");
    }
}
