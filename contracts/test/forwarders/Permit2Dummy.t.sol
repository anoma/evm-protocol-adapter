// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Time} from "@openzeppelin-contracts/utils/types/Time.sol";
import {IPermit2, ISignatureTransfer} from "@permit2/src/interfaces/IPermit2.sol";
import {PermitHash} from "@permit2/src/libraries/PermitHash.sol";

import {Test, Vm, console} from "forge-std/Test.sol";

import {Permit2Dummy} from "../../src/forwarders/Permit2Dummy.sol";
import {ERC20ForwarderPermit2} from "../../src/forwarders/ERC20ForwarderPermit2.sol";

import {ERC20Example} from "../../test/examples/ERC20.e.sol";

import {DeployPermit2} from "../script/DeployPermit2.s.sol";

contract Permit2DummyTest is Test {
    using ERC20ForwarderPermit2 for ERC20ForwarderPermit2.Witness;

    uint128 internal constant _TRANSFER_AMOUNT = 1000;
    bytes32 internal constant _ACTION_TREE_ROOT = bytes32(uint256(0));

    address internal _alice;
    uint256 internal _alicePrivateKey;

    Permit2Dummy internal _permit2Dummy;
    IPermit2 internal _permit2;
    ERC20Example internal _erc20;

    function setUp() public virtual {
        vm.selectFork(vm.createFork("sepolia"));

        _alicePrivateKey = 0xc522337787f3037e9d0dcba4dc4c0e3d4eb7b1c65598d51c425574e8ce64d140;
        _alice = vm.addr(_alicePrivateKey);

        // Deploy token and mint for alice
        _erc20 = new ERC20Example();

        // Get the Permit2 contract
        _permit2 = IPermit2(0x000000000022D473030F116dDEE9F6B43aC78BA3);
        //_permit2 = _permit2Contract();

        // Deploy the ERC20 forwarder
        _permit2Dummy = new Permit2Dummy();
    }

    function test_witness_typeHash() public pure {
        assertEq(ERC20ForwarderPermit2._WITNESS_TYPEHASH, vm.eip712HashType(ERC20ForwarderPermit2._WITNESS_TYPE_DEF));
    }

    function test_witness_structHash() public pure {
        ERC20ForwarderPermit2.Witness memory witness = ERC20ForwarderPermit2.Witness({actionTreeRoot: bytes32(0)});
        assertEq(witness.hash(), vm.eip712HashStruct(ERC20ForwarderPermit2._WITNESS_TYPE_DEF, abi.encode(witness)));
    }

    function test_pullFunds() public {
        _erc20.mint({to: _alice, value: _TRANSFER_AMOUNT});
        uint256 startBalanceAlice = _erc20.balanceOf(_alice);
        uint256 startBalanceForwarder = _erc20.balanceOf(address(_permit2Dummy));
        vm.prank(_alice);
        _erc20.approve(address(_permit2), type(uint256).max);

        address from = _alice;
        address spender = address(_permit2Dummy);

        ISignatureTransfer.PermitTransferFrom memory permit = ISignatureTransfer.PermitTransferFrom({
            permitted: ISignatureTransfer.TokenPermissions({token: address(_erc20), amount: _TRANSFER_AMOUNT}),
            nonce: 0,
            deadline: 1767222000
        });

        bytes32 witness = ERC20ForwarderPermit2.Witness({actionTreeRoot: _ACTION_TREE_ROOT}).hash();
        bytes memory signature = _createPermitWitnessTransferFromSignature({
            permit: permit,
            privateKey: _alicePrivateKey,
            spender: spender,
            witness: witness
        });

        console.log("chain ID:", block.chainid);

        console.log("from:", from);
        console.log("spender:", spender);
        console.log();

        console.log("permit.permitted.token:", permit.permitted.token);
        console.log("permit.permitted.amount:", permit.permitted.amount);
        console.log("permit.nonce:", permit.nonce);
        console.log("permit.deadline:", permit.deadline);
        console.log();

        console.log("actionTreeRoot:", vm.toString(_ACTION_TREE_ROOT));
        console.log("witness:", vm.toString(witness));
        console.log();

        console.log("signature:", vm.toString(signature));
        console.log("signature length:", signature.length);
        console.log();

        console.log("signer_address:", vm.toString(_alice));
        console.log("signer_privateKey:", vm.toString(bytes32(_alicePrivateKey)));

        _permit2Dummy.pullFunds({from: from, permit: permit, actionTreeRoot: _ACTION_TREE_ROOT, signature: signature});

        assertEq(_erc20.balanceOf(_alice), startBalanceAlice - _TRANSFER_AMOUNT);
        assertEq(_erc20.balanceOf(address(_permit2Dummy)), startBalanceForwarder + _TRANSFER_AMOUNT);
    }

    function _permit2Contract() internal virtual returns (IPermit2 permit2) {
        permit2 = new DeployPermit2().run();
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

    function _createPermitWitnessTransferFromSignatureRsv(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        uint256 privateKey,
        bytes32 witness
    ) internal view returns (uint8 v, bytes32 r, bytes32 s) {
        bytes32 digest = _computePermitWitnessTransferFromDigest({permit: permit, spender: spender, witness: witness});

        (v, r, s) = vm.sign(privateKey, digest);
    }

    /// @notice Computes the `permitWitnessTransferFrom` digest.
    /// @param permit The permit data constituted by the token address, token amount, nonce, and deadline.
    /// @param spender The address being allowed to execute the `permitWitnessTransferFrom` call.
    /// @param witness The witness obtained from the hashed `ERC20ForwarderPermit2.Witness` struct.
    /// @return digest The digest.
    function _computePermitWitnessTransferFromDigest(
        ISignatureTransfer.PermitTransferFrom memory permit,
        address spender,
        bytes32 witness
    ) internal view returns (bytes32 digest) {
        bytes32 dataHash = _hashWithWitness({
            permit: permit,
            witness: witness,
            witnessTypeString: ERC20ForwarderPermit2._WITNESS_TYPE_STRING,
            spender: spender
        });

        digest = _hashTypedData(dataHash);
    }

    function _hashTypedData(bytes32 dataHash) internal view returns (bytes32 hash) {
        bytes memory message = abi.encodePacked("\x19\x01", _permit2.DOMAIN_SEPARATOR(), dataHash);

        hash = keccak256(message);
    }

    function _hashWithWitness(
        ISignatureTransfer.PermitTransferFrom memory permit,
        bytes32 witness,
        string memory witnessTypeString,
        address spender
    ) internal pure returns (bytes32 hash) {
        bytes32 typeHash =
            keccak256(abi.encodePacked(PermitHash._PERMIT_TRANSFER_FROM_WITNESS_TYPEHASH_STUB, witnessTypeString));

        bytes32 tokenPermissionsHash = _hashTokenPermissions(permit.permitted);
        hash = keccak256(abi.encode(typeHash, tokenPermissionsHash, spender, permit.nonce, permit.deadline, witness));
    }

    function _hashTokenPermissions(ISignatureTransfer.TokenPermissions memory permitted)
        private
        pure
        returns (bytes32 hash)
    {
        hash = keccak256(abi.encode(PermitHash._TOKEN_PERMISSIONS_TYPEHASH, permitted));
    }
}
