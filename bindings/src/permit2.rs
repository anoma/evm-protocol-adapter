//! Example of how to transfer ERC20 tokens from one account to another using a signed permit.

use alloy::primitives::{Address, B256, Signature, U256, keccak256};
use alloy::signers::{Signer, local::PrivateKeySigner};
use alloy::sol;
use alloy::sol_types::SolValue;

const CANONICAL_PERMIT2_ADDRESS: &str = "0x000000000022D473030F116dDEE9F6B43aC78BA3";

sol!(
    #[allow(missing_docs)]
    #[sol(rpc)]
    Permit2,
    "./src/Permit2.json"
);

const TOKEN_PERMISSIONS_TYPESTRING: &str = "TokenPermissions(address token,uint256 amount)";

const PERMIT_TRANSFER_FROM_WITNESS_TYPESTRING_STUB: &str = "PermitWitnessTransferFrom(TokenPermissions permitted,address spender,uint256 nonce,uint256 deadline,";

fn permit_transfer_from_witness_typehash_stub() -> B256 {
    keccak256(PERMIT_TRANSFER_FROM_WITNESS_TYPESTRING_STUB)
}

fn token_permissions_typehash() -> B256 {
    keccak256(TOKEN_PERMISSIONS_TYPESTRING)
}

const PERMIT2_DOMAIN_SEPARATOR_LOCAL: &str =
    "0x4d553c58ae79a6c4ba64f0e690a5d1cd2deff8c6b91cf38300e0f2b76f9ee346";
const PERMIT2_DOMAIN_SEPARATOR_SEPOLIA: &str =
    "0x94c1dec87927751697bfc9ebf6fc4ca506bed30308b518f0e9d6c5f74bbafdb8";

pub async fn permit_witness_transfer_from_signature(
    signer: PrivateKeySigner,
    erc20: Address,
    amount: U256,
    nonce: U256,
    deadline: U256,
    spender: Address,
    witness: B256,
) -> Signature {
    let digest =
        permit_witness_transfer_from_digest(erc20, amount, nonce, deadline, spender, witness);
    signer.sign_hash(&digest).await.unwrap()
}

pub fn permit_witness_transfer_from_digest(
    erc20: Address,
    amount: U256,
    nonce: U256,
    deadline: U256,
    spender: Address,
    witness: B256,
) -> B256 {
    let permit = ISignatureTransfer::PermitTransferFrom {
        permitted: ISignatureTransfer::TokenPermissions {
            token: erc20,
            amount,
        },
        nonce,
        deadline,
    };
    let witness_type_string = "bytes32 witness";
    let struct_hash: B256 = keccak256(
        (
            keccak256(
                (
                    permit_transfer_from_witness_typehash_stub(),
                    witness_type_string,
                )
                    .abi_encode_packed(),
            ),
            keccak256(
                (
                    token_permissions_typehash(),
                    permit.permitted.token,
                    permit.permitted.amount,
                )
                    .abi_encode_params(),
            ),
            spender,
            permit.nonce,
            permit.deadline,
            witness,
        )
            .abi_encode_params(),
    );

    keccak256(("\x19\x01", PERMIT2_DOMAIN_SEPARATOR_LOCAL, struct_hash).abi_encode_packed())
}

/*
    function _computePermitWitnessTransferFromDigest(
       ISignatureTransfer.PermitTransferFrom memory permit,
       address spender,
       bytes32 witness
   ) internal view returns (bytes32 digest) {
       string memory witnessTypeString = "bytes32 witness";

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

       digest = keccak256(abi.encodePacked("\x19\x01", _permit2.DOMAIN_SEPARATOR(), structHash));
   }

   function _createPermitWitnessTransferFromSignature(
       ISignatureTransfer.PermitTransferFrom memory permit,
       address spender,
       uint256 privateKey,
       bytes32 witness
   ) internal view returns (bytes memory signature) {
       bytes32 digest = _computePermitWitnessTransferFromDigest({permit: permit, spender: spender, witness: witness});

       (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
       return abi.encodePacked(r, s, v);
   }

   /// @notice Computes the `permitWitnessTransferFrom` digest.
   /// @param permit The permit data constituted by the token address, token amount, nonce, and deadline.
   /// @param spender The address being allowed to execute the `permitWitnessTransferFrom` call.
   /// @param witness The witness information.
   /// @return digest The digest.
   function _computePermitWitnessTransferFromDigest(
       ISignatureTransfer.PermitTransferFrom memory permit,
       address spender,
       bytes32 witness
   ) internal view returns (bytes32 digest) {
       string memory witnessTypeString = "bytes32 witness";

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

       digest = keccak256(abi.encodePacked("\x19\x01", _permit2.DOMAIN_SEPARATOR(), structHash));
   }
*/
