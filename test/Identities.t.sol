// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import {Test} from "forge-std/Test.sol";

import {Universal} from "../src/libs/Identities.sol";

import {EllipticCurveK256} from "../src/libs/EllipticCurveK256.sol";

contract UniversalIdentityTest is Test {
    bytes32 constant privateKey = bytes32(uint256(1));
    bytes internal publicKey;
    bytes32 internal hashedKey;
    address internal account;

    function setUp() public {
        (uint256 x, uint256 y) = EllipticCurveK256.derivePubKey({privKey: uint256(privateKey)});
        publicKey = abi.encode(bytes32(x), bytes32(y));

        hashedKey = keccak256(publicKey);

        account = address(uint160(uint256(hashedKey)));
    }

    function testPrivateKey() public pure {
        assertEq(Universal.INTERNAL_IDENTITY, privateKey);
    }

    function testPublicKey() public view {
        assertEq(Universal.PUBLIC_KEY, publicKey);
    }

    function testPublicKeyComponents() public pure {
        assertEq(abi.encode(Universal.PUBLIC_KEY_X, Universal.PUBLIC_KEY_Y), Universal.PUBLIC_KEY);
    }

    function testExternalIdentity() public view {
        assertEq(Universal.EXTERNAL_IDENTITY, hashedKey);
    }

    function testAccount() public view {
        assertEq(Universal.ACCOUNT, account);
    }
}
