// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @notice A library containing the cryptographic keys of the universally known identity,
/// an identity with which everyone can compose their own identity.
/// @dev This identity can own resources that everyone should be allowed to consume.
library Universal {
    // https://www.rfctools.com/ethereum-address-test-tool/

    /// @notice The private key.
    uint256 internal constant PRIVATE_KEY = 1;

    /// @notice The bytes32 encoded private key.
    bytes32 internal constant INTERNAL_IDENTITY = bytes32(PRIVATE_KEY);

    /// @notice The ECDSA public key derived from the private key.
    /// @dev Obtained from `EllipticCurveK256.derivePubKey(PRIVATE_KEY)`.
    bytes internal constant PUBLIC_KEY = hex"79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"
        hex"483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8";

    /// @notice The x-component of the ECDSA public key.
    bytes32 internal constant PUBLIC_KEY_X = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;

    /// @notice The y-component of the ECDSA public key.
    bytes32 internal constant PUBLIC_KEY_Y = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;

    /// @notice The external identity derived from the public key.
    /// @dev Obtained from `keccak256(PUBLIC_KEY)`.
    bytes32 internal constant EXTERNAL_IDENTITY = 0xc0a6c424ac7157ae408398df7e5f4552091a69125d5dfcb7b8c2659029395bdf;

    /// @notice The last 20 bytes of the external identity.
    /// @dev Obtained from `address(uint160(uint256(EXTERNAL_IDENTITY)))`.
    address internal constant ACCOUNT = 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf;
}
