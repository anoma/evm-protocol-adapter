// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Time} from "@openzeppelin-contracts/utils/types/Time.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {PermitHash} from "@permit2/src/libraries/PermitHash.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, console, stdError} from "forge-std/Test.sol";

import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {ERC20Example} from "../test/examples/ERC20.e.sol";

import {DeployPermit2} from "./script/DeployPermit2.s.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

import {BenchmarkData} from "./benchmark/Benchmark.t.sol";
import {Transaction} from "../src/Types.sol";

contract ERC20ForwarderTest is BenchmarkData {
    uint256 internal constant _ALICE_PRIVATE_KEY =
        uint256(bytes32(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)); //0xA11CE;
    uint128 internal constant _TRANSFER_AMOUNT = 1000;
    bytes internal constant _EXPECTED_OUTPUT = "";
    bytes32 internal constant _ACTION_TREE_ROOT = bytes32(uint256(0));

    bytes32 internal constant _CALLDATA_CARRIER_LOGIC_REF = bytes32(type(uint256).max);

    address internal _pa;
    address internal _alice;
    address internal _fwd;
    IPermit2 internal _permit2;
    ERC20Example internal _erc20;

    ISignatureTransfer.PermitTransferFrom internal _defaultPermit;

    // Copied since we can't `import {SignatureExpired, InvalidNonce} from "@permit2/src/PermitErrors.sol";`
    // because of the incompatible solc pragma.
    error SignatureExpired(uint256 signatureDeadline);
    error InvalidNonce();

    function setUp() public {
        vm.selectFork(vm.createFork("sepolia"));
        _alice = vm.addr(_ALICE_PRIVATE_KEY);

        // Deploy token and mint for alice
        _erc20 = new ERC20Example();

        // Deploy Permit2 to the canonical address.
        _permit2 = IPermit2(address(0x000000000022D473030F116dDEE9F6B43aC78BA3)); //new DeployPermit2().run();

        // Deploy RISC Zero contracts
        (RiscZeroVerifierRouter _router,,) = new DeployRiscZeroContracts().run();

        // Deploy the protocol adapter
        _pa = address(new ProtocolAdapter({riscZeroVerifierRouter: _router}));

        // Deploy the ERC20 forwarder
        _fwd = address(
            new ERC20Forwarder({
                protocolAdapter: _pa,
                emergencyCommittee: address(uint160(1)),
                calldataCarrierLogicRef: bytes32(type(uint256).max)
            })
        );

        _defaultPermit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: address(_erc20), amount: _TRANSFER_AMOUNT}),
            nonce: 0,
            deadline: Time.timestamp() + 5 minutes
        });
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
                privateKey: _ALICE_PRIVATE_KEY,
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
                privateKey: _ALICE_PRIVATE_KEY,
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
                privateKey: _ALICE_PRIVATE_KEY,
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
                privateKey: _ALICE_PRIVATE_KEY,
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
                privateKey: _ALICE_PRIVATE_KEY,
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
                privateKey: _ALICE_PRIVATE_KEY,
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

    function test_example_digest() public {
        address token = address(_erc20);
        uint256 amount = 1000;
        uint256 nonce = 0;
        uint256 deadline = 2000;
        address spender = address(_fwd);
        bytes32 witness = bytes32(0);

        console.log("token", token);
        console.log("amount", amount);
        console.log("nonce", nonce);
        console.log("deadline", deadline);
        console.log("spender", spender);

        bytes32 digest = _computePermitWitnessTransferFromDigest({
            permit: ISignatureTransfer.PermitTransferFrom({
                permitted: ISignatureTransfer.TokenPermissions({token: token, amount: amount}),
                nonce: nonce,
                deadline: deadline
            }),
            spender: spender,
            witness: witness
        });

        console.log("\nDigest");

        console.logBytes32(digest);
    }

    function test_execute_simple_transfer_mint() public {
        Transaction memory txn = _parse("/test/simple_transfer_mint.bin");

        ProtocolAdapter(_pa).execute(txn);
    }

    function test_example_action_tree_root() public {
        bytes32 actionTreeRoot = sha256(
            abi.encode(
                bytes32(0x15a0677d564d21e3789ce6e5e574c6f611d9af4b31aeebb0f527bd23c5d0ac09),
                bytes32(0xa01386b0688a3100460fcf370cf509172c62f3b4ef1522a31dbca4640e47f63a)
            )
        );
        console.logBytes32(actionTreeRoot);
        assertEq(actionTreeRoot, bytes32(0x9524e8c0c71f5a53aa07d514cd508ac68a310c86809cd22f9c8a62cecd848e57));
    }

    function test_example_sig() public {
        uint256 privateKey = _ALICE_PRIVATE_KEY;
        address signer = vm.addr(_ALICE_PRIVATE_KEY);
        assertEq(signer, address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));

        address token = address(_erc20);
        uint256 amount = _TRANSFER_AMOUNT;
        uint256 deadline = 2000;
        address spender = address(_fwd);
        bytes32 witness = bytes32(0);

        ISignatureTransfer.PermitTransferFrom memory permit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: token, amount: amount}),
            nonce: 0,
            deadline: deadline
        });

        bytes32 digest =
            _computePermitWitnessTransferFromDigest({permit: permit, spender: address(_fwd), witness: witness});

        console.log("\nDigest:");
        console.logBytes32(digest);

        bytes memory sig = _createPermitWitnessTransferFromSignature({
            permit: permit,
            spender: address(_fwd),
            privateKey: _ALICE_PRIVATE_KEY,
            witness: witness
        });

        console.log("computed sig:");
        console.logBytes(sig);

        bool parity = false;
        bytes32 r = bytes32(0xba6735bb49280a954e3161d7162cae336e809ae8e5d0a37a5efd3fd42208833b);
        bytes32 s = bytes32(0x24b8dd3e25c27bf765aadf8feb63cff75f5c17c37fa0b29e670b9a90ba1b8b20);
        uint8 v = parity ? 27 : 28;

        console.log("expected sig:");
        console.logBytes(abi.encodePacked(r, s, v));
    }

    function _createPermitWitnessTransferFromSignature(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        uint256 privateKey,
        bytes32 witness
    ) internal view returns (bytes memory signature) {
        bytes32 digest = _computePermitWitnessTransferFromDigest({permit: permit, spender: spender, witness: witness});
        console.logBytes32(digest);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        console.log("r,s,v:");
        console.logBytes32(r);
        console.logBytes32(s);
        console.log(v);
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

        bytes32 hash1 =
            keccak256(abi.encodePacked(PermitHash._PERMIT_TRANSFER_FROM_WITNESS_TYPEHASH_STUB, witnessTypeString));
        console.log("hash1:");
        console.logBytes32(hash1);

        bytes32 hash2 = keccak256(
            abi.encode(PermitHash._TOKEN_PERMISSIONS_TYPEHASH, permit.permitted.token, permit.permitted.amount)
        );
        console.log("hash2:");
        console.logBytes32(hash2);

        bytes32 structHash = keccak256(abi.encode(hash1, hash2, spender, permit.nonce, permit.deadline, witness));
        console.log("structHash:");
        console.logBytes32(structHash);

        console.log("DOMAIN_SEPARATOR:");
        console.logBytes32(_permit2.DOMAIN_SEPARATOR());

        bytes memory msgdata = abi.encodePacked("\x19\x01", _permit2.DOMAIN_SEPARATOR(), structHash);

        console.log("msg before digest:");
        console.logBytes(msgdata);

        digest = keccak256(msgdata);
    }
}
