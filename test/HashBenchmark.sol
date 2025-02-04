pragma solidity >=0.8.25 <0.9.0;

import {Test} from "forge-std/src/Test.sol";

import {SHA256} from "../src/libs/SHA256.sol";

import {Poseidon} from "../src/libs/Poseidon.sol";

contract PoseidonBenchmark is Test {
    bytes32 internal constant SOME_BYTES = 0x65a2f0bfdc75b4bf69f8f39db78498f05445a0160897c2b0107d29d9db4fd9f5;

    function test_sha256_1() public pure {
        SHA256.hash(SOME_BYTES);
    }

    function test_sha256_2() public pure {
        SHA256.hash(SOME_BYTES, SOME_BYTES);
    }

    function test_poseidon_1() public pure {
        Poseidon.hash(SOME_BYTES);
    }

    function test_poseidon_2() public pure {
        Poseidon.hash(SOME_BYTES, SOME_BYTES);
    }
}
