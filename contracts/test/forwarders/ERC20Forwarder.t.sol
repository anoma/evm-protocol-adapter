// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Time} from "@openzeppelin-contracts/utils/types/Time.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {PermitHash} from "@permit2/src/libraries/PermitHash.sol";
import {RiscZeroGroth16Verifier} from "@risc0-ethereum/groth16/RiscZeroGroth16Verifier.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, Vm, stdError} from "forge-std/Test.sol";

import {ERC20Forwarder} from "../../src/forwarders/ERC20Forwarder.sol";
import {ProtocolAdapter} from "../../src/ProtocolAdapter.sol";
import {Transaction} from "../../src/Types.sol";
import {ERC20Example} from "../../test/examples/ERC20.e.sol";
import {Parsing} from "../libs/Parsing.sol";
import {DeployRiscZeroContracts} from "../script/DeployRiscZeroContracts.s.sol";

contract ERC20ForwarderTest is Test {
    using Parsing for Vm;

    uint128 internal constant _TRANSFER_AMOUNT = 1000;
    bytes internal constant _EXPECTED_OUTPUT = "";
    bytes32 internal constant _ACTION_TREE_ROOT = bytes32(uint256(0));

    bytes32 internal constant _CALLDATA_CARRIER_LOGIC_REF =
        0x6fd807d5589b13808fede076d2b756d721cd07b9e12a761b43cb80af5cd6f1f0;

    address internal _pa;

    address internal _alice;
    uint256 internal _alicePrivateKey;
    address internal _fwd;
    IPermit2 internal _permit2;
    ERC20Example internal _erc20;

    ISignatureTransfer.PermitTransferFrom internal _defaultPermit;

    // Copied since we can't `import {SignatureExpired, InvalidNonce} from "@permit2/src/PermitErrors.sol";`
    // because of the incompatible solc pragma.
    error SignatureExpired(uint256 signatureDeadline);
    error InvalidNonce();

    function setUp() public {
        _alicePrivateKey = 0xc522337787f3037e9d0dcba4dc4c0e3d4eb7b1c65598d51c425574e8ce64d140;
        _alice = vm.addr(_alicePrivateKey);

        vm.selectFork(vm.createFork("sepolia"));

        // Deploy token and mint for alice
        _erc20 = new ERC20Example();

        // Deploy Permit2 to the canonical address.
        _permit2 = IPermit2(address(0x000000000022D473030F116dDEE9F6B43aC78BA3)); //new DeployPermit2().run();

        // Deploy RISC Zero contracts
        (RiscZeroVerifierRouter router,, RiscZeroGroth16Verifier verifier) = new DeployRiscZeroContracts().run();

        // Deploy the protocol adapter
        _pa = address(new ProtocolAdapter(router, verifier.SELECTOR()));

        // Deploy the ERC20 forwarder
        _fwd = address(
            new ERC20Forwarder({
                protocolAdapter: _pa,
                emergencyCommittee: address(uint160(1)),
                calldataCarrierLogicRef: _CALLDATA_CARRIER_LOGIC_REF
            })
        );

        _defaultPermit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: address(_erc20), amount: _TRANSFER_AMOUNT}),
            nonce: 0,
            deadline: Time.timestamp() + 5 minutes
        });
    }

    function test_execute_mint_transfer_burn() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        uint256 aliceBalanceBefore = _erc20.balanceOf(_alice);
        uint256 fwdBalanceBefore = _erc20.balanceOf(_fwd);

        // Mint
        {
            Transaction memory mintTx = vm.parseTransaction("/test/examples/transactions/mint.bin");
            ProtocolAdapter(_pa).execute(mintTx);

            assertEq(_erc20.balanceOf(_alice), aliceBalanceBefore - _TRANSFER_AMOUNT);
            assertEq(_erc20.balanceOf(_fwd), fwdBalanceBefore + _TRANSFER_AMOUNT);
        }

        // Transfer
        {
            Transaction memory transferTx = vm.parseTransaction("/test/examples/transactions/transfer.bin");
            ProtocolAdapter(_pa).execute(transferTx);

            assertEq(_erc20.balanceOf(_alice), aliceBalanceBefore - _TRANSFER_AMOUNT);
            assertEq(_erc20.balanceOf(_fwd), fwdBalanceBefore + _TRANSFER_AMOUNT);
        }

        // Burn
        {
            Transaction memory burnTx = vm.parseTransaction("/test/examples/transactions/burn.bin");
            ProtocolAdapter(_pa).execute(burnTx);

            assertEq(_erc20.balanceOf(_alice), aliceBalanceBefore);
            assertEq(_erc20.balanceOf(_fwd), fwdBalanceBefore);
        }
    }

    function testFuzz_enum_panics(uint8 v) public {
        uint8 callTypeEnumLength = uint8(type(ERC20Forwarder.CallType).max) + 1;

        if (v < callTypeEnumLength) {
            ERC20Forwarder.CallType(v);
        } else {
            vm.expectRevert(stdError.enumConversionError);
            ERC20Forwarder.CallType(v);
        }
    }

    function test_forwardCall_Unwrap_call_sends_funds_to_the_user() public {
        _erc20.mint({to: _fwd, value: _TRANSFER_AMOUNT});
        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(_fwd);

        bytes memory input;
        {
            address token = address(_erc20);
            address to = _alice;
            uint256 amount = _TRANSFER_AMOUNT;

            input = abi.encode(ERC20Forwarder.CallType.Unwrap, token, to, amount);
        }

        vm.prank(_pa);
        bytes memory output = ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});

        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT));
        assertEq(_erc20.balanceOf(_alice), startBalanceAlice + _TRANSFER_AMOUNT);
        assertEq(_erc20.balanceOf(_fwd), startBalanceForwarder - _TRANSFER_AMOUNT);
    }

    function test_forwardCall_Unwrap_call_emits_the_Unwrapped_event() public {
        _erc20.mint({to: _fwd, value: _TRANSFER_AMOUNT});
        bytes memory input = abi.encode(ERC20Forwarder.CallType.Unwrap, address(_erc20), _alice, _TRANSFER_AMOUNT);

        vm.prank(_pa);
        vm.expectEmit(address(_fwd));
        emit ERC20Forwarder.Unwrapped({token: address(_erc20), to: _alice, value: _TRANSFER_AMOUNT});
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_forwardCall_Wrap_call_reverts_if_user_did_not_approve_permit2() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});

        bytes memory input;
        {
            address from = _alice;
            ISignatureTransfer.PermitTransferFrom memory permit = _defaultPermit;
            bytes32 witness = _ACTION_TREE_ROOT;
            bytes memory signature = _createPermitWitnessTransferFromSignature({
                permit: _defaultPermit,
                privateKey: _alicePrivateKey,
                spender: _fwd,
                witness: witness
            });

            input = abi.encode(ERC20Forwarder.CallType.Wrap, from, permit, witness, signature);
        }

        vm.prank(_pa);
        vm.expectRevert("TRANSFER_FROM_FAILED", address(_erc20));
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_forwardCall_Wrap_call_reverts_if_the_signature_expired() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        bytes memory input;
        {
            address from = _alice;
            ISignatureTransfer.PermitTransferFrom memory permit = _defaultPermit;
            bytes32 witness = _ACTION_TREE_ROOT;
            bytes memory signature = _createPermitWitnessTransferFromSignature({
                permit: _defaultPermit,
                privateKey: _alicePrivateKey,
                spender: _fwd,
                witness: witness
            });

            input = abi.encode(ERC20Forwarder.CallType.Wrap, from, permit, witness, signature);
        }

        // Advance time after the deadline
        vm.warp(_defaultPermit.deadline + 1);

        vm.prank(_pa);
        vm.expectRevert(abi.encodeWithSelector(SignatureExpired.selector, _defaultPermit.deadline), address(_permit2));
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_forwardCall_Wrap_call_reverts_if_the_signature_was_already_used() public {
        _erc20.mint({to: _alice, value: 2 * _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        bytes memory input;
        {
            address from = _alice;
            ISignatureTransfer.PermitTransferFrom memory permit = _defaultPermit;
            bytes32 witness = _ACTION_TREE_ROOT;
            bytes memory signature = _createPermitWitnessTransferFromSignature({
                permit: _defaultPermit,
                privateKey: _alicePrivateKey,
                spender: _fwd,
                witness: witness
            });

            input = abi.encode(ERC20Forwarder.CallType.Wrap, from, permit, witness, signature);
        }

        // Use the signature.
        vm.startPrank(_pa);
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});

        // Reuse the signature.
        vm.expectRevert(abi.encodeWithSelector(InvalidNonce.selector), address(_permit2));
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_forwardCall_Wrap_call_reverts_if_the_amount_to_be_wrapped_overflows() public {
        uint256 maxAmount = type(uint128).max;

        _erc20.mint({to: _alice, value: maxAmount + 1});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        ISignatureTransfer.PermitTransferFrom memory permit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: address(_erc20), amount: maxAmount + 1}),
            nonce: 0,
            deadline: Time.timestamp() + 5 minutes
        });

        bytes memory input;
        {
            address from = _alice;
            bytes32 witness = _ACTION_TREE_ROOT;
            bytes memory signature = _createPermitWitnessTransferFromSignature({
                permit: permit,
                privateKey: _alicePrivateKey,
                spender: _fwd,
                witness: witness
            });

            input = abi.encode(ERC20Forwarder.CallType.Wrap, from, permit, witness, signature);
        }

        vm.prank(_pa);
        vm.expectRevert(
            abi.encodeWithSelector(ERC20Forwarder.TypeOverflow.selector, maxAmount, maxAmount + 1), address(_fwd)
        );
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_forwardCall_PermitTransferFrom_call_pulls_funds_from_user() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(_fwd);

        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        bytes memory input;
        {
            address from = _alice;
            ISignatureTransfer.PermitTransferFrom memory permit = _defaultPermit;
            bytes32 witness = _ACTION_TREE_ROOT;
            bytes memory signature = _createPermitWitnessTransferFromSignature({
                permit: _defaultPermit,
                privateKey: _alicePrivateKey,
                spender: _fwd,
                witness: witness
            });

            input = abi.encode(ERC20Forwarder.CallType.Wrap, from, permit, witness, signature);
        }

        vm.prank(_pa);
        bytes memory output = ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});

        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT));
        assertEq(_erc20.balanceOf(_alice), startBalanceAlice - _TRANSFER_AMOUNT);
        assertEq(_erc20.balanceOf(_fwd), startBalanceForwarder + _TRANSFER_AMOUNT);
    }

    function test_forwardCall_PermitTransferFrom_emits_the_Wrapped_event() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});

        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        bytes memory input;
        {
            address from = _alice;
            ISignatureTransfer.PermitTransferFrom memory permit = _defaultPermit;
            bytes32 witness = _ACTION_TREE_ROOT;
            bytes memory signature = _createPermitWitnessTransferFromSignature({
                permit: _defaultPermit,
                privateKey: _alicePrivateKey,
                spender: _fwd,
                witness: witness
            });

            input = abi.encode(ERC20Forwarder.CallType.Wrap, from, permit, witness, signature);
        }

        vm.prank(_pa);
        vm.expectEmit(address(_fwd));
        emit ERC20Forwarder.Wrapped({token: address(_erc20), from: _alice, value: _TRANSFER_AMOUNT});
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function _createPermitWitnessTransferFromSignatureRsv(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        uint256 privateKey,
        bytes32 witness
    ) internal view returns (uint8 v, bytes32 r, bytes32 s) {
        bytes32 digest = _computePermitWitnessTransferFromDigest({permit: permit, spender: spender, witness: witness});

        (v, r, s) = vm.sign(privateKey, digest);
    }

    function _createPermitWitnessTransferFromSignature(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        uint256 privateKey,
        bytes32 witness
    ) internal view returns (bytes memory signature) {
        (uint8 v, bytes32 r, bytes32 s) = _createPermitWitnessTransferFromSignatureRsv({
            permit: permit,
            spender: spender,
            privateKey: privateKey,
            witness: witness
        });

        return abi.encodePacked(r, s, v);
    }

    /// @notice Computes the `permitWitnessTransferFrom` digest.
    /// @param permit The permit data constituted by the token address, token amount, nonce, and deadline.
    /// @param spender The address being allowed to execute the `permitWitnessTransferFrom` call.
    /// @param witness The witness information.
    /// @return digest The digest.
    function _computePermitWitnessTransferFromDigest(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        bytes32 witness
    ) internal view returns (bytes32 digest) {
        string memory witnessTypeString = "bytes32 witness";

        bytes32 structHash = keccak256(
            abi.encode(
                keccak256(abi.encodePacked(PermitHash._PERMIT_TRANSFER_FROM_WITNESS_TYPEHASH_STUB, witnessTypeString)),
                keccak256(
                    abi.encode(PermitHash._TOKEN_PERMISSIONS_TYPEHASH, permit.permitted.token, permit.permitted.amount)
                ),
                spender,
                permit.nonce,
                permit.deadline,
                witness
            )
        );

        digest = keccak256(abi.encodePacked("\x19\x01", _permit2.DOMAIN_SEPARATOR(), structHash));
    }
}
