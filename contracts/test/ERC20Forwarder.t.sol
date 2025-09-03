// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20Errors} from "@openzeppelin-contracts/interfaces/draft-IERC6093.sol";
import {ERC20} from "@openzeppelin-contracts/token/ERC20/ERC20.sol";
import {Time} from "@openzeppelin-contracts/utils/types/Time.sol";

import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";
import {Parameters} from "../src/libs/Parameters.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {DeployPermit2} from "./script/DeployPermit2.s.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {}

    function mint(address to, uint256 value) external {
        _mint(to, value);
    }
}

contract ERC20ForwarderTest is Test {
    uint256 internal constant _ALICE_PRIVATE_KEY = 0xA11CE;
    uint256 internal constant _TRANSFER_AMOUNT = 1 * 10 ** 18;
    bytes internal constant _EXPECTED_OUTPUT = abi.encode(true);
    bytes32 internal constant _ACTION_TREE_ROOT = bytes32(type(uint256).max);

    address internal _pa;
    address internal _alice;
    address internal _fwd;
    IPermit2 internal _permit2;
    MyToken internal _erc20;

    ISignatureTransfer.PermitTransferFrom internal _defaultPermit;

    // Copied since we can't `import {SignatureExpired, InvalidNonce} from "@permit2/src/PermitErrors.sol";`
    // because of the incompatible solc pragma.
    error SignatureExpired(uint256 signatureDeadline);
    error InvalidNonce();

    function setUp() public {
        _alice = vm.addr(_ALICE_PRIVATE_KEY);

        // Deploy token and mint for alice
        _erc20 = new MyToken();

        // Deploy Permit2 to the canonical address.
        _permit2 = new DeployPermit2().run();

        // Deploy RISC Zero contracts
        (RiscZeroVerifierRouter _router,,) = new DeployRiscZeroContracts().run();

        // Deploy the protocol adapter
        _pa = address(
            new ProtocolAdapter({
                riscZeroVerifierRouter: _router,
                commitmentTreeDepth: Parameters.COMMITMENT_TREE_DEPTH,
                actionTagTreeDepth: Parameters.ACTION_TAG_TREE_DEPTH
            })
        );

        // Deploy the ERC20 forwarder
        _fwd = address(
            new ERC20Forwarder({
                protocolAdapter: _pa,
                emergencyCommittee: address(uint160(1)),
                calldataCarrierLogicRef: bytes32(type(uint256).max),
                erc20: address(_erc20)
            })
        );

        _defaultPermit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: address(_erc20), amount: _TRANSFER_AMOUNT}),
            nonce: 0,
            deadline: Time.timestamp() + 5 minutes
        });
    }

    function test_forwardCall_Transfer_call_sends_funds_to_the_user() public {
        _erc20.mint({to: _fwd, value: _TRANSFER_AMOUNT});
        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(_fwd);

        bytes memory input = ERC20Forwarder(_fwd).encodeTransfer({to: _alice, value: _TRANSFER_AMOUNT});

        vm.prank(_pa);
        bytes memory output = ERC20Forwarder(_fwd).forwardCall(input);

        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT));
        assertEq(_erc20.balanceOf(_alice), startBalanceAlice + _TRANSFER_AMOUNT);
        assertEq(_erc20.balanceOf(_fwd), startBalanceForwarder - _TRANSFER_AMOUNT);
    }

    function test_forwardCall_TransferFrom_call_reverts_if_user_did_not_approve_the_forwarder() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});

        bytes memory input = ERC20Forwarder(_fwd).encodeTransferFrom({from: _alice, value: _TRANSFER_AMOUNT});

        uint256 allowance = _erc20.allowance({owner: _alice, spender: _fwd});

        vm.prank(_pa);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector, address(_fwd), allowance, _TRANSFER_AMOUNT
            ),
            address(_erc20)
        );
        ERC20Forwarder(_fwd).forwardCall(input);
    }

    function test_forwardCall_TransferFrom_call_pulls_funds_from_user() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(_fwd);

        vm.prank(_alice);
        _erc20.approve(_fwd, type(uint256).max);

        bytes memory input = ERC20Forwarder(_fwd).encodeTransferFrom({from: _alice, value: _TRANSFER_AMOUNT});

        vm.prank(_pa);
        bytes memory output = ERC20Forwarder(_fwd).forwardCall(input);

        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT));
        assertEq(_erc20.balanceOf(_alice), startBalanceAlice - _TRANSFER_AMOUNT);
        assertEq(_erc20.balanceOf(_fwd), startBalanceForwarder + _TRANSFER_AMOUNT);
    }

    function test_forwardCall_PermitTransferFrom_call_reverts_if_user_did_not_approve_permit2() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});

        bytes memory input;
        {
            ISignatureTransfer.PermitTransferFrom memory permit = _defaultPermit;

            input = ERC20Forwarder(_fwd).encodePermitWitnessTransferFrom({
                from: _alice,
                value: _TRANSFER_AMOUNT,
                permit: permit,
                witness: _ACTION_TREE_ROOT,
                signature: _createPermitWitnessTransferFromSignature({
                    permit: permit,
                    privateKey: _ALICE_PRIVATE_KEY,
                    spender: _fwd,
                    witness: _ACTION_TREE_ROOT
                })
            });
        }

        vm.prank(_pa);
        vm.expectRevert("TRANSFER_FROM_FAILED", address(_erc20));
        ERC20Forwarder(_fwd).forwardCall(input);
    }

    function test_forwardCall_PermitTransferFrom_call_reverts_if_the_signature_expired() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        bytes memory input = ERC20Forwarder(_fwd).encodePermitWitnessTransferFrom({
            from: _alice,
            value: _TRANSFER_AMOUNT,
            permit: _defaultPermit,
            witness: _ACTION_TREE_ROOT,
            signature: _createPermitWitnessTransferFromSignature({
                permit: _defaultPermit,
                privateKey: _ALICE_PRIVATE_KEY,
                spender: _fwd,
                witness: _ACTION_TREE_ROOT
            })
        });

        // Advance time after the deadline
        vm.warp(_defaultPermit.deadline + 1);

        vm.prank(_pa);
        vm.expectRevert(abi.encodeWithSelector(SignatureExpired.selector, _defaultPermit.deadline), address(_permit2));
        ERC20Forwarder(_fwd).forwardCall(input);
    }

    function test_forwardCall_PermitTransferFrom_call_reverts_if_the_signature_was_already_used() public {
        _erc20.mint({to: _alice, value: 2 * _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        bytes memory input = ERC20Forwarder(_fwd).encodePermitWitnessTransferFrom({
            from: _alice,
            value: _TRANSFER_AMOUNT,
            permit: _defaultPermit,
            witness: _ACTION_TREE_ROOT,
            signature: _createPermitWitnessTransferFromSignature({
                permit: _defaultPermit,
                privateKey: _ALICE_PRIVATE_KEY,
                spender: _fwd,
                witness: _ACTION_TREE_ROOT
            })
        });

        // Use the signature.
        vm.startPrank(_pa);
        ERC20Forwarder(_fwd).forwardCall(input);

        // Reuse the signature.
        vm.expectRevert(abi.encodeWithSelector(InvalidNonce.selector), address(_permit2));
        ERC20Forwarder(_fwd).forwardCall(input);
    }

    function test_forwardCall_PermitWitnessTransferFrom_call_reverts_if_the_permitted_token_is_incorrect() public {
        MyToken wrongERC20 = new MyToken();

        wrongERC20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        vm.prank(_alice);
        wrongERC20.approve(address(_permit2), type(uint256).max);

        ISignatureTransfer.PermitTransferFrom memory permit = _defaultPermit;
        permit.permitted.token = address(wrongERC20);

        bytes memory input = ERC20Forwarder(_fwd).encodePermitWitnessTransferFrom({
            from: _alice,
            value: _TRANSFER_AMOUNT,
            permit: permit,
            witness: _ACTION_TREE_ROOT,
            signature: _createPermitWitnessTransferFromSignature({
                permit: permit,
                privateKey: _ALICE_PRIVATE_KEY,
                spender: _fwd,
                witness: _ACTION_TREE_ROOT
            })
        });

        vm.prank(_pa);
        vm.expectRevert(abi.encodeWithSelector(ERC20Forwarder.TokenMismatch.selector, _erc20, wrongERC20), _fwd);
        ERC20Forwarder(_fwd).forwardCall(input);
    }

    function test_forwardCall_PermitWitnessTransferFrom_call_reverts_if_the_permitted_and_transfer_amount_mismatch()
        public
    {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        ISignatureTransfer.PermitTransferFrom memory permit = _defaultPermit;
        permit.permitted.amount = _TRANSFER_AMOUNT - 1;

        bytes memory input = ERC20Forwarder(_fwd).encodePermitWitnessTransferFrom({
            from: _alice,
            value: _TRANSFER_AMOUNT,
            permit: permit,
            witness: _ACTION_TREE_ROOT,
            signature: _createPermitWitnessTransferFromSignature({
                permit: permit,
                privateKey: _ALICE_PRIVATE_KEY,
                spender: _fwd,
                witness: _ACTION_TREE_ROOT
            })
        });

        vm.prank(_pa);
        vm.expectRevert(
            abi.encodeWithSelector(ERC20Forwarder.ValueMismatch.selector, _TRANSFER_AMOUNT, permit.permitted.amount),
            address(_fwd)
        );
        ERC20Forwarder(_fwd).forwardCall(input);
    }

    function test_forwardCall_PermitTransferFrom_call_pulls_funds_from_user() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(_fwd);

        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        bytes memory input = ERC20Forwarder(_fwd).encodePermitWitnessTransferFrom({
            from: _alice,
            value: _TRANSFER_AMOUNT,
            permit: _defaultPermit,
            witness: _ACTION_TREE_ROOT,
            signature: _createPermitWitnessTransferFromSignature({
                permit: _defaultPermit,
                privateKey: _ALICE_PRIVATE_KEY,
                spender: _fwd,
                witness: _ACTION_TREE_ROOT
            })
        });

        vm.prank(_pa);
        bytes memory output = ERC20Forwarder(_fwd).forwardCall(input);

        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT));
        assertEq(_erc20.balanceOf(_alice), startBalanceAlice - _TRANSFER_AMOUNT);
        assertEq(_erc20.balanceOf(_fwd), startBalanceForwarder + _TRANSFER_AMOUNT);
    }

    function _createPermitWitnessTransferFromSignature(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        uint256 privateKey,
        bytes32 witness
    ) internal view returns (bytes memory signature) {
        bytes32 digest = ERC20Forwarder(_fwd).computePermitWitnessTransferFromDigest({
            permit: permit,
            spender: spender,
            witness: witness
        });

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        return abi.encodePacked(r, s, v);
    }
}
