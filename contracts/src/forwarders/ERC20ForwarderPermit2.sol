// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title ERC20ForwarderPermit2
/// @author Anoma Foundation, 2025
/// @notice A library containing definitions related to the Permit2 witness type.
/// @custom:security-contact security@anoma.foundation
library ERC20ForwarderPermit2 {
    /// @notice The Permit2 witness struct being used in `Wrap` (`permitWitnessTransferFrom`) calls of the forwarder.
    /// @param actionTreeRoot The action tree root of the action the external call is triggered from.
    struct Witness {
        bytes32 actionTreeRoot;
    }

    // solhint-disable-next-line gas-small-strings
    /// @notice The witness type string respecting the alphabetical ordering of structs
    /// (see https://docs.uniswap.org/contracts/permit2/reference/signature-transfer).
    string internal constant _WITNESS_TYPE_STRING =
        "Witness witness)TokenPermissions(address token,uint256 amount)Witness(bytes32 actionTreeRoot)";

    /// @notice The witness type definition.
    string internal constant _WITNESS_TYPE_DEF = "Witness(bytes32 actionTreeRoot)";

    /// @notice The witness type hash (see https://docs.uniswap.org/contracts/permit2/reference/signature-transfer).
    bytes32 internal constant _WITNESS_TYPEHASH = keccak256(bytes(_WITNESS_TYPE_DEF));

    /// @notice Computes the EIP-712 struct hash of the ERC20 forwarder witness.
    /// @param witness The ERC20 forwarder witness.
    /// @return structHash The resulting EIP-712 struct hash.
    function hash(ERC20ForwarderPermit2.Witness memory witness) internal pure returns (bytes32 structHash) {
        structHash = keccak256(abi.encode(ERC20ForwarderPermit2._WITNESS_TYPEHASH, witness.actionTreeRoot));
    }
}
