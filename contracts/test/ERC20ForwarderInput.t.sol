// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20Errors} from "@openzeppelin-contracts/interfaces/draft-IERC6093.sol";
import {ERC20} from "@openzeppelin-contracts/token/ERC20/ERC20.sol";
import {Time} from "@openzeppelin-contracts/utils/types/Time.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, stdError, console} from "forge-std/Test.sol";

import {ERC20ForwarderInput} from "../src/forwarders/ERC20ForwarderInput.sol";

contract ERC20ForwarderInputTest is Test, ERC20ForwarderInput {
    address internal constant _ALICE = address(uint160(1));
    address internal constant _ERC20 = address(uint160(2));
    uint256 internal constant _TRANSFER_AMOUNT = 1 * 10 ** 18;

    uint8 internal constant _MAX_CALL_TYPE = uint8(type(ERC20ForwarderInput.CallType).max);

    bytes internal constant _EXPECTED_OUTPUT = abi.encode(true);
    bytes32 internal constant _ACTION_TREE_ROOT = bytes32(type(uint256).max);

    // Copied since we can't `import {SignatureExpired, InvalidNonce} from "@permit2/src/PermitErrors.sol";`
    // because of the incompatible solc pragma.
    error SignatureExpired(uint256 signatureDeadline);
    error InvalidNonce();

    function test_decodeTransfer_reverts_on_invalid_calltype() public {
        bytes memory input = encodeTransfer({to: _ALICE, value: _TRANSFER_AMOUNT});
        _replaceFirst32Bytes(input, bytes32(uint256(_MAX_CALL_TYPE)));

        vm.expectRevert(CallTypeInvalid.selector, address(this));
        decodeTransfer(input);
    }

    function test_decodeTransferFrom_reverts_on_invalid_calltype() public {
        bytes memory input = encodeTransferFrom({from: _ALICE, value: _TRANSFER_AMOUNT});
        _replaceFirst32Bytes(input, bytes32(uint256(_MAX_CALL_TYPE)));

        vm.expectRevert(CallTypeInvalid.selector, address(this));
        decodeTransferFrom(input);
    }

    function test_decodePermitWitnessTransferFrom_reverts_on_invalid_calltype() public {
        bytes memory input = encodePermitWitnessTransferFrom({
            from: _ALICE,
            value: _TRANSFER_AMOUNT,
            permit: ISignatureTransfer.PermitTransferFrom({
                permitted: ISignatureTransfer.TokenPermissions({token: _ERC20, amount: _TRANSFER_AMOUNT}),
                nonce: 0,
                deadline: Time.timestamp() + 5 minutes
            }),
            witness: bytes32(0),
            signature: abi.encode(bytes32(0), bytes32(0), uint8(0))
        });

        _replaceFirst32Bytes(input, bytes32(uint256(_MAX_CALL_TYPE)));

        vm.expectRevert(CallTypeInvalid.selector, address(this));
        decodeTransferFrom(input);
    }

    function _replaceFirst32Bytes(bytes memory input, bytes32 newValue) private pure {
        assembly {
            // Skip the length slot, go to data
            let dataPtr := add(input, 32)
            mstore(dataPtr, newValue)
        }
    }
}
