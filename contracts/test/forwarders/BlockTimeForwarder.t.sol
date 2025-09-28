// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {RiscZeroGroth16Verifier} from "@risc0-ethereum/groth16/RiscZeroGroth16Verifier.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {BlockTimeForwarder} from "../../src/forwarders/BlockTimeForwarder.sol";
import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";

import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

/// @title ForwarderBase
/// @author Anoma Foundation, 2025
/// @notice The forwarder contract returning whether a specific block time has passed.
/// @custom:security-contact security@anoma.foundation

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

    function test_forwardCall_returns_true_if_timestamp_is_in_the_past() public view {
        // solhint-disable-next-line not-rely-on-time
        bytes memory passedTimestampBytes = abi.encode(uint248(block.timestamp - 1));
        bytes memory output = _fwd.forwardCall("", passedTimestampBytes);

        assert(abi.decode(output, (bool)));
    }

    function test_forwardCall_returns_false_if_timestamp_is_in_the_future() public view {
        bytes memory futureTimestampBytes = abi.encode(type(uint248).max);
        bytes memory output = _fwd.forwardCall("", futureTimestampBytes);

        assert(!abi.decode(output, (bool)));
    }

    function test_forwardCall_returns_false_if_timestamp_is_in_the_present() public view {
        // solhint-disable-next-line not-rely-on-time
        bytes memory presentTimestampBytes = abi.encode(uint248(block.timestamp));
        bytes memory output = _fwd.forwardCall("", presentTimestampBytes);

        assert(!abi.decode(output, (bool)));
    }

    function testFuzz_forwardCall_accepts_arbitrary_logic(bytes32 logicRef) public view {
        _fwd.forwardCall(logicRef, abi.encode(1));
    }
}
