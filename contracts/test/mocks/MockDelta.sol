// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Universal} from "../../src/libs/Identities.sol";
import {Delta} from "../../src/proving/Delta.sol";

library MockDelta {
    using Delta for uint256[2];

    /// @notice A message containing  the empty `bytes32` array.
    /// @dev Obtained from `abi.encode(new bytes32[](0))`.
    bytes internal constant MESSAGE = hex"0000000000000000000000000000000000000000000000000000000000000020"
        hex"0000000000000000000000000000000000000000000000000000000000000000";

    /// @notice The message hash.
    bytes32 internal constant MESSAGE_HASH = keccak256(MESSAGE);

    /// @notice The account of the signer.
    address internal constant SIGNER_ACCOUNT = Universal.ACCOUNT;

    /// @notice The private key of the signer.
    uint256 internal constant SIGNER_PRIVATE_KEY = Universal.PRIVATE_KEY;

    /// @notice The x-component of the signature.
    /// @dev obtained from `(uint8 v, bytes32 r, bytes32 s) = vm.sign(SIGNER_PRIVATE_KEY, MESSAGE_HASH);`
    bytes32 internal constant R = 0x281904b46380592ae0d9c3de363c450ea37ba9b7fcfdac5f568d878b43464bb9;
    bytes32 internal constant S = 0x167d04ade99ca40b42df474db6e51b45495a8bfe48248dc5952948354a0f9017;
    uint8 internal constant V = 0x1c; // 28

    /// @notice The ECDSA signature constituting the proof.
    bytes internal constant PROOF = abi.encodePacked(R, S, V);

    error WrongUsage();

    /// @notice A mock transaction delta fitting the proof.
    /// @return txDelta The transaction delta.
    function transactionDelta() internal pure returns (uint256[2] memory txDelta) {
        txDelta[0] = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
        txDelta[1] = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8;
    }

    /// @notice Mocks the verify function reverting on verification failure.
    /// @param deltaProof The delta proof to check.
    /// @dev Expects the `MockDelta.PROOF` to be the argument.
    function verify(bytes memory deltaProof) internal pure {
        // NOTE: On transaction object creation, we currently must put the `MockDelta.PROOF`
        // for the mock verification to work
        if (keccak256(deltaProof) != keccak256(PROOF)) revert WrongUsage();

        Delta.verify({proof: deltaProof, instance: transactionDelta(), verifyingKey: MESSAGE_HASH});
    }
}
