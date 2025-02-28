// SPDX-License-Identifier: MIT
pragma solidity >=0.8.27;

// TODO In Juvix, Elixir, the nullifier key is 64 bytes and contains the public key.
bytes32 constant UNIVERSAL_NULLIFIER_KEY = bytes32(0);

// Derived from the seed `0x0000000000000000000000000000000000000000000000000000000000000000`
// (see, e.g., https://cyphr.me/ed25519_tool/ed.html) in little-endian byte order.
// slither-disable-next-line max-line-length
bytes32 constant UNIVERSAL_NULLIFIER_KEY_COMMITMENT = 0x3b6a27bcceb6a42d62a3a8d02a6f0d73653215771de243a63ac048a18b59da29;
