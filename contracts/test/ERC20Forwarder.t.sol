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
    constructor(address recipient) ERC20("MyToken", "MTK") {
        _mint(recipient, 10 * 10 ** decimals());
    }
}

contract ERC20ForwarderTest is Test {
    uint256 internal constant _ALICE_PRIVATE_KEY = 0xA11CE;

    address internal _pa;
    address internal _alice;
    IPermit2 internal _permit2;
    ERC20Forwarder internal _fwd;
    ERC20 internal _erc20;

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
        _fwd = new ERC20Forwarder({
            protocolAdapter: _pa,
            emergencyCommittee: address(uint160(1)),
            calldataCarrierLogicRef: bytes32(type(uint256).max),
            erc20: address(_erc20)
        });
    }

    function test_forwardCall_pulls_ERC20_tokens_via_transferFrom_and_permit2() public {
        // Approve Permit2
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        uint256 value = 1 * 10 ** _erc20.decimals();

        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(address(_fwd));

        bytes memory input = _defaultInput({value: value});
        vm.prank(_pa);
        bytes memory output = _fwd.forwardCall(input);

        assertEq(keccak256(output), keccak256(""));
        assertEq(_erc20.balanceOf(_alice), startBalanceAlice - value);
        assertEq(_erc20.balanceOf(address(_fwd)), startBalanceForwarder + value);
    }

    function test_forwardCall_reverts_if_permit2_was_not_approved() public {
        bytes memory input = _defaultInput({value: 1 * 10 ** _erc20.decimals()});
        vm.prank(_pa);

        vm.expectRevert("TRANSFER_FROM_FAILED", address(_erc20));
        _fwd.forwardCall(input);
    }

    function _defaultInput(uint256 value) internal view returns (bytes memory input) {
        address from = _alice;

        ISignatureTransfer.PermitTransferFrom memory permit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: address(_erc20), amount: value}),
            nonce: 0,
            deadline: Time.timestamp() + 5 minutes
        });

        bytes memory signature =
            _getPermitTransferSignature({permit: permit, privateKey: _ALICE_PRIVATE_KEY, spender: address(_fwd)});

        input = abi.encode(_erc20.transferFrom.selector, from, value, permit, signature);
    }

    function _getPermitTransferSignature(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        uint256 privateKey
    ) internal view returns (bytes memory signature) {
        bytes32 digest = _computePermitTransferFromDigest({permit: permit, spender: spender});

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        signature = bytes.concat(r, s, bytes1(v));
    }

    function _computePermitTransferFromDigest(ISignatureTransfer.PermitTransferFrom memory permit, address spender)
        internal
        view
        returns (bytes32 digest)
    {
        bytes32 tokenPermissionsHash = keccak256(
            abi.encode(PermitHash._TOKEN_PERMISSIONS_TYPEHASH, permit.permitted.token, permit.permitted.amount)
        );

        bytes32 structHash = keccak256(
            abi.encode(
                PermitHash._PERMIT_TRANSFER_FROM_TYPEHASH, tokenPermissionsHash, spender, permit.nonce, permit.deadline
            )
        );

        digest = keccak256(abi.encodePacked("\x19\x01", _permit2.DOMAIN_SEPARATOR(), structHash));
    }
}
