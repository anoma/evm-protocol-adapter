//! Example of how to transfer ERC20 tokens from one account to another using a signed permit.

use alloy::primitives::{bytes, keccak256, Address, Bytes, FixedBytes, Signature, B256, U256};
use alloy::signers::{local::PrivateKeySigner, Signer};
use alloy::sol;
use alloy::sol_types::SolValue;

sol!(
    #[allow(missing_docs)]
    #[sol(rpc)]
    Permit2,
    "./src/Permit2.json"
);

const TOKEN_PERMISSIONS_TYPESTRING: &str = "TokenPermissions(address token,uint256 amount)";

const PERMIT_TRANSFER_FROM_WITNESS_TYPEHASH_STUB: &str = "PermitWitnessTransferFrom(TokenPermissions permitted,address spender,uint256 nonce,uint256 deadline,";

fn token_permissions_typehash() -> B256 {
    keccak256(TOKEN_PERMISSIONS_TYPESTRING)
}

pub const PERMIT2_DOMAIN_SEPARATOR_LOCAL: Bytes =
    bytes!("0x4d553c58ae79a6c4ba64f0e690a5d1cd2deff8c6b91cf38300e0f2b76f9ee346");
pub const PERMIT2_DOMAIN_SEPARATOR_SEPOLIA: Bytes =
    bytes!("0x94c1dec87927751697bfc9ebf6fc4ca506bed30308b518f0e9d6c5f74bbafdb8");

pub async fn permit_witness_transfer_from_signature(
    signer: &PrivateKeySigner,
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
                    PERMIT_TRANSFER_FROM_WITNESS_TYPEHASH_STUB,
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

    let prefix = FixedBytes::<2>::from(&[0x19, 0x01]);
    let data = (&prefix, PERMIT2_DOMAIN_SEPARATOR_SEPOLIA, struct_hash).abi_encode_packed();

    keccak256(data)
}
