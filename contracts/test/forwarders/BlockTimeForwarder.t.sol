// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Time} from "@openzeppelin-contracts/utils/types/Time.sol";
import {RiscZeroGroth16Verifier} from "@risc0-ethereum/groth16/RiscZeroGroth16Verifier.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {BlockTimeForwarder} from "../../src/examples/BlockTimeForwarder.sol";
import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";

import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

contract BlockTimeForwarderTest is Test {
    address internal constant _EMERGENCY_COMMITTEE = address(uint160(1));

    ProtocolAdapter internal _pa;
    BlockTimeForwarder internal _fwd;

    function setUp() public virtual {
        // Deploy RISC Zero contracts
        (RiscZeroVerifierRouter router,, RiscZeroGroth16Verifier verifier) = new DeployRiscZeroContracts().run();

        // Deploy the protocol adapter
        _pa = new ProtocolAdapter(router, verifier.SELECTOR(), _EMERGENCY_COMMITTEE);

        // Setup the block time forwarder
        _fwd = new BlockTimeForwarder();
    }

    function test_forwardCall_returns_LT_if_timestamp_is_in_the_past() public view {
        // solhint-disable-next-line not-rely-on-time
        bytes memory passedTimestampBytes = abi.encode(uint48(Time.timestamp() - 1));
        bytes memory output = _fwd.forwardCall("", passedTimestampBytes);

        BlockTimeForwarder.TimeComparison decodedOutput = abi.decode(output, (BlockTimeForwarder.TimeComparison));

        assertEq(uint8(decodedOutput), uint8(BlockTimeForwarder.TimeComparison.LT));
    }

    function test_forwardCall_returns_GT_if_timestamp_is_in_the_future() public view {
        bytes memory futureTimestampBytes = abi.encode(type(uint48).max);
        bytes memory output = _fwd.forwardCall("", futureTimestampBytes);

        BlockTimeForwarder.TimeComparison decodedOutput = abi.decode(output, (BlockTimeForwarder.TimeComparison));

        assertEq(uint8(decodedOutput), uint8(BlockTimeForwarder.TimeComparison.GT));
    }

    function test_forwardCall_returns_EQ_if_timestamp_is_in_the_present() public view {
        // solhint-disable-next-line not-rely-on-time
        bytes memory presentTimestampBytes = abi.encode(uint48(Time.timestamp()));
        bytes memory output = _fwd.forwardCall("", presentTimestampBytes);

        BlockTimeForwarder.TimeComparison decodedOutput = abi.decode(output, (BlockTimeForwarder.TimeComparison));

        assertEq(uint8(decodedOutput), uint8(BlockTimeForwarder.TimeComparison.EQ));
    }

    function testFuzz_forwardCall_accepts_arbitrary_logic(bytes32 logicRef) public view {
        _fwd.forwardCall(logicRef, abi.encode(1));
    }
}
