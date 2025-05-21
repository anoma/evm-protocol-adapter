// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {IRiscZeroVerifier, VerificationFailed} from "@risc0-ethereum/IRiscZeroVerifier.sol";

import {Test} from "forge-std/Test.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {Example} from "./mocks/Example.sol";

contract ProtocolAdapterTest is Test {
    IRiscZeroVerifier internal _sepoliaVerifier;
    bytes32 internal _complianceCircuitID;
    uint8 internal _commitmentTreeDepth;

    uint8 internal _actionTreeDepth;

    ProtocolAdapter internal _pa;

    function setUp() public {
        // Fork Sepolia
        vm.selectFork(vm.createFork("sepolia"));

        string memory path = "./script/constructor-args.txt";

        _sepoliaVerifier = IRiscZeroVerifier(vm.parseAddress(vm.readLine(path)));
        _complianceCircuitID = vm.parseBytes32(vm.readLine(path));
        _commitmentTreeDepth = uint8(vm.parseUint(vm.readLine(path)));
        _actionTreeDepth = uint8(vm.parseUint(vm.readLine(path)));

        _pa = new ProtocolAdapter({
            riscZeroVerifier: _sepoliaVerifier,
            complianceCircuitID: _complianceCircuitID,
            commitmentTreeDepth: _commitmentTreeDepth,
            actionTreeDepth: _actionTreeDepth
        });
    }

    function test_verify() public {
        vm.expectRevert(VerificationFailed.selector);
        _pa.verify(Example.transaction());

        // solhint-disable-next-line gas-custom-errors
        revert("The above should NOT revert. PA MUST FIRST BE REDEPLOYED");
    }

    function test_execute() public {
        vm.expectRevert(VerificationFailed.selector);
        _pa.execute(Example.transaction());

        // solhint-disable-next-line gas-custom-errors
        revert("The above should NOT revert. PA MUST FIRST BE REDEPLOYED");
    }

    /*function test_verifyEmptyTx() public view {
        Transaction memory txn = MockTypes.mockTransaction({
            mockVerifier: _mockVerifier,
            root: _pa.latestRoot(),
            consumed: new Resource[](0),
            created: new Resource[](0)
        });

        _pa.verify(txn);
    }*/
}
