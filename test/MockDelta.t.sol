// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.27;

import { Test } from "forge-std/Test.sol";
import { Delta } from "../src/proving/Delta.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import { MockDelta } from "./MockDelta.sol";

contract MockDeltaTest is Test {
    function setUp() internal pure { }

    function test_signature_integrity() public pure {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(MockDelta.SIGNER_PRIVATE_KEY, MockDelta.MESSAGE_HASH);
        assertEq(r, MockDelta.R);
        assertEq(s, MockDelta.S);
        assertEq(v, MockDelta.V);
    }

    function test_signature_recovery() public pure {
        address recovered = ECDSA.recover({ hash: MockDelta.MESSAGE_HASH, signature: MockDelta.PROOF });
        assertEq(recovered, MockDelta.SIGNER_ACCOUNT);
    }

    function test_delta_verify() public pure {
        Delta.verify({
            transactionHash: MockDelta.MESSAGE_HASH,
            transactionDelta: MockDelta.transactionDelta(),
            deltaProof: MockDelta.PROOF
        });
    }
}
