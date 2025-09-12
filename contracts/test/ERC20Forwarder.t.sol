// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Time} from "@openzeppelin-contracts/utils/types/Time.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {PermitHash} from "@permit2/src/libraries/PermitHash.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test, stdError} from "forge-std/Test.sol";

import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";
import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";
import {ERC20Example} from "../test/examples/ERC20.e.sol";
import {DeployPermit2} from "./script/DeployPermit2.s.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract ERC20ForwarderTest is Test {
    uint256 internal constant _ALICE_PRIVATE_KEY = 0xA11CE;
    uint128 internal constant _TRANSFER_AMOUNT = 1 * 10 ** 18;
    bytes internal constant _EXPECTED_OUTPUT = "";
    bytes32 internal constant _ACTION_TREE_ROOT = bytes32(type(uint256).max);

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
        _alice = vm.addr(_ALICE_PRIVATE_KEY);

        // Deploy token and mint for alice
        _erc20 = new ERC20Example();

        // Deploy Permit2 to the canonical address.
        _permit2 = new DeployPermit2().run();

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

    function test_forwardCall_Unwrap_sends_funds_to_user() public {
        // Arrange: Prepare the initial state for the test.
        _erc20.mint({to: _fwd, value: _TRANSFER_AMOUNT});
        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(_fwd);
        bytes memory input = abi.encode(ERC20Forwarder.CallType.Unwrap, address(_erc20), _alice, _TRANSFER_AMOUNT);

        // Act: Call the function being tested.
        vm.prank(_pa);
        bytes memory output = ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});

        // Assert: Verify the outcome is as expected.
        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT), "Output should be empty");
        assertEq(
            _erc20.balanceOf(_alice), startBalanceAlice + _TRANSFER_AMOUNT, "Alice's balance should have increased"
        );
        assertEq(
            _erc20.balanceOf(_fwd), startBalanceForwarder - _TRANSFER_AMOUNT, "Forwarder's balance should have decreased"
        );
    }

    function test_forwardCall_Unwrap_emits_Unwrapped_event() public {
        // Arrange
        _erc20.mint({to: _fwd, value: _TRANSFER_AMOUNT});
        bytes memory input = abi.encode(ERC20Forwarder.CallType.Unwrap, address(_erc20), _alice, _TRANSFER_AMOUNT);

        // Act & Assert
        vm.prank(_pa);
        vm.expectEmit(address(_fwd));
        emit ERC20Forwarder.Unwrapped({token: address(_erc20), to: _alice, value: _TRANSFER_AMOUNT});
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_forwardCall_Wrap_reverts_if_user_did_not_approve_permit2() public {
        // Arrange
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        bytes memory input = _createDefaultWrapInput();

        // Act & Assert
        vm.prank(_pa);
        vm.expectRevert("TRANSFER_FROM_FAILED", address(_erc20));
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_forwardCall_Wrap_reverts_if_signature_expired() public {
        // Arrange
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);
        bytes memory input = _createDefaultWrapInput();

        // Act
        vm.warp(_defaultPermit.deadline + 1); // Advance time past the deadline

        // Assert
        vm.prank(_pa);
        vm.expectRevert(abi.encodeWithSelector(SignatureExpired.selector, _defaultPermit.deadline), address(_permit2));
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_forwardCall_Wrap_reverts_if_signature_was_already_used() public {
        // Arrange
        _erc20.mint({to: _alice, value: 2 * _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);
        bytes memory input = _createDefaultWrapInput();

        // Act: Use the signature for the first time.
        vm.startPrank(_pa);
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});

        // Assert: Reusing the signature should fail.
        vm.expectRevert(abi.encodeWithSelector(InvalidNonce.selector), address(_permit2));
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
        vm.stopPrank();
    }

    function test_forwardCall_Wrap_reverts_if_amount_to_wrap_overflows() public {
        // Arrange
        uint256 maxAmount = type(uint128).max;
        uint256 overflowAmount = maxAmount + 1;
        _erc20.mint({to: _alice, value: overflowAmount});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        ISignatureTransfer.PermitTransferFrom memory permit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: address(_erc20), amount: overflowAmount}),
            nonce: 0,
            deadline: Time.timestamp() + 5 minutes
        });

        bytes32 witness = _ACTION_TREE_ROOT;
        bytes memory signature =
            _createPermitWitnessTransferFromSignature({permit: permit, privateKey: _ALICE_PRIVATE_KEY, spender: _fwd, witness: witness});

        bytes memory input = abi.encode(ERC20Forwarder.CallType.Wrap, _alice, permit, witness, signature);

        // Act & Assert
        vm.prank(_pa);
        vm.expectRevert(
            abi.encodeWithSelector(ERC20Forwarder.TypeOverflow.selector, maxAmount, overflowAmount), address(_fwd)
        );
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    function test_forwardCall_Wrap_pulls_funds_from_user() public {
        // Arrange
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(_fwd);
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);
        bytes memory input = _createDefaultWrapInput();

        // Act
        vm.prank(_pa);
        bytes memory output = ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});

        // Assert
        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT), "Output should be empty");
        assertEq(
            _erc20.balanceOf(_alice), startBalanceAlice - _TRANSFER_AMOUNT, "Alice's balance should have decreased"
        );
        assertEq(
            _erc20.balanceOf(_fwd), startBalanceForwarder + _TRANSFER_AMOUNT, "Forwarder's balance should have increased"
        );
    }

    function test_forwardCall_Wrap_emits_Wrapped_event() public {
        // Arrange
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);
        bytes memory input = _createDefaultWrapInput();

        // Act & Assert
        vm.prank(_pa);
        vm.expectEmit(address(_fwd));
        emit ERC20Forwarder.Wrapped({token: address(_erc20), from: _alice, value: _TRANSFER_AMOUNT});
        ERC20Forwarder(_fwd).forwardCall({logicRef: _CALLDATA_CARRIER_LOGIC_REF, input: input});
    }

    // --- Helper Functions ---

    /// @notice Creates the `input` data for a standard `Wrap` call with default parameters.
    function _createDefaultWrapInput() internal view returns (bytes memory) {
        address from = _alice;
        ISignatureTransfer.PermitTransferFrom memory permit = _defaultPermit;
        bytes32 witness = _ACTION_TREE_ROOT;
        bytes memory signature = _createPermitWitnessTransferFromSignature({
            permit: permit,
            privateKey: _ALICE_PRIVATE_KEY,
            spender: _fwd,
            witness: witness
        });

        return abi.encode(ERC20Forwarder.CallType.Wrap, from, permit, witness, signature);
    }

    function _createPermitWitnessTransferFromSignature(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        uint256 privateKey,
        bytes32 witness
    ) internal view returns (bytes memory signature) {
        bytes32 digest = _computePermitWitnessTransferFromDigest({permit: permit, spender: spender, witness: witness});

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
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
