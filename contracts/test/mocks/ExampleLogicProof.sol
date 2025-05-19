// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library ExampleLogicProof {
    bytes internal constant SEAL = hex"70D0";

    bytes32 internal constant LOGIC_CIRCUIT_ID = hex"70D0";

    bytes32 internal constant JOURNAL_DIGEST = sha256(hex"70D0");
}
