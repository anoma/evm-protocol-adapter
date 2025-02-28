// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Test } from "forge-std/Test.sol";

import { EllipticCurveK256 } from "../src/libs/EllipticCurveK256.sol";
import { Universal } from "../src/libs/Identities.sol";

contract UniversalIdentityTest is Test {
    bytes internal _publicKey;
    bytes32 internal _hashedKey;
    address internal _account;

    function setUp() public {
        (uint256 x, uint256 y) = EllipticCurveK256.derivePubKey({ privateKey: Universal.PRIVATE_KEY });
        _publicKey = abi.encode(bytes32(x), bytes32(y));

        _hashedKey = keccak256(_publicKey);

        _account = address(uint160(uint256(_hashedKey)));
    }

    function testPublicKey() public view {
        assertEq(Universal.PUBLIC_KEY, _publicKey);
    }

    function testExternalIdentity() public view {
        assertEq(Universal.EXTERNAL_IDENTITY, _hashedKey);
    }

    function testAccount() public view {
        assertEq(Universal.ACCOUNT, _account);
    }

    function testPrivateKey() public pure {
        assertEq(Universal.INTERNAL_IDENTITY, bytes32(Universal.PRIVATE_KEY));
    }

    function testPublicKeyComponents() public pure {
        assertEq(abi.encode(Universal.PUBLIC_KEY_X, Universal.PUBLIC_KEY_Y), Universal.PUBLIC_KEY);
    }
}
