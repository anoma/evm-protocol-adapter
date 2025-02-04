// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import {Test} from "forge-std/src/Test.sol";
import {console2} from "forge-std/src/console2.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract ProtocolAdapterTest is Test {
    uint256 internal testNumber;
    ProtocolAdapter internal protocolAdapter;

    uint8 internal constant TREE_DEPTH = 2; // NOTE: 2^2 = 4 nodes are possible.

    function setUp() public {
        protocolAdapter = new ProtocolAdapter({
            logicCircuitID: bytes32(0),
            complianceCircuitID: bytes32(0),
            wrapperLogicRef: bytes32(0),
            riscZeroVerifier: address(0), // TODO: Fork sepolia/mainnet https://dev.risczero.com/api/blockchain-integration/contracts/verifier
            treeDepth: TREE_DEPTH
        });
    }
}
