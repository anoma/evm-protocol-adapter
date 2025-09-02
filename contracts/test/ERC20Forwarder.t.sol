// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin-contracts/token/ERC20/ERC20.sol";
import {Time} from "@openzeppelin-contracts/utils/types/Time.sol";

import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {PermitHash} from "@permit2/src/libraries/PermitHash.sol";
import {RiscZeroVerifierRouter} from "@risc0-ethereum/RiscZeroVerifierRouter.sol";

import {Test} from "forge-std/Test.sol";

import {ERC20Forwarder} from "../src/forwarders/ERC20Forwarder.sol";
import {Parameters} from "../src/libs/Parameters.sol";

import {ProtocolAdapter} from "../src/ProtocolAdapter.sol";

import {DeployPermit2} from "./script/DeployPermit2.s.sol";
import {DeployRiscZeroContracts} from "./script/DeployRiscZeroContracts.s.sol";

contract MyToken is ERC20 {
    constructor(address recipient) ERC20("MyToken", "MTK") {}

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

    function setUp() public {
        _alice = vm.addr(_ALICE_PRIVATE_KEY);

        // Deploy token and mint for alice
        _erc20 = new MyToken({recipient: _alice});

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
    }

    function test_forwardCall_pulls_ERC20_tokens_from_user_via_permitWitnessTransferFrom() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(_fwd);

        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        bytes memory input = _permit2ExampleInput({value: _TRANSFER_AMOUNT});
        vm.prank(_pa);
        bytes memory output = ERC20Forwarder(_fwd).forwardCall(input);

        assertEq(keccak256(output), keccak256(_EXPECTED_OUTPUT));
        assertEq(_erc20.balanceOf(_alice), startBalanceAlice - _TRANSFER_AMOUNT);
        assertEq(_erc20.balanceOf(_fwd), startBalanceForwarder + _TRANSFER_AMOUNT);
    }

    function test_forwardCall_reverts_if_permit2_was_not_approved() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        bytes memory input = _permit2ExampleInput({value: _TRANSFER_AMOUNT});
        vm.prank(_pa);

        vm.expectRevert("TRANSFER_FROM_FAILED", address(_erc20));
        ERC20Forwarder(_fwd).forwardCall(input);
    }

    function _permit2ExampleInput(uint256 value) internal view returns (bytes memory input) {
        address from = _alice;

        ISignatureTransfer.PermitTransferFrom memory permit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: address(_erc20), amount: value}),
            nonce: 0,
            deadline: Time.timestamp() + 5 minutes
        });

        bytes memory signature = _getPermitWitnessTransferSignature({
            permit: permit,
            privateKey: _ALICE_PRIVATE_KEY,
            spender: _fwd,
            witness: _ACTION_TREE_ROOT
        });

        input = abi.encode(_erc20.transferFrom.selector, from, value, permit, _ACTION_TREE_ROOT, signature);
    }

    function _getPermitWitnessTransferSignature(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        uint256 privateKey,
        bytes32 witness
    ) internal view returns (bytes memory signature) {
        bytes32 digest = _computePermitWitnessTransferFromDigest({permit: permit, spender: spender, witness: witness});

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        return abi.encodePacked(r, s, v);
    }

    function _computePermitWitnessTransferFromDigest(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        bytes32 witness
    ) internal view returns (bytes32 digest) {
        // The type string for the witness (bytes32)
        string memory witnessTypeString = "bytes32 witness";

        // Compute the PermitHash struct hash with witness
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

        // Compute the EIP-712 digest
        bytes32 domainSeparator = _permit2.DOMAIN_SEPARATOR();
        digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }
}
