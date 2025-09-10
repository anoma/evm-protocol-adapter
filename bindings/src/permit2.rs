//! Example of how to transfer ERC20 tokens from one account to another using a signed permit.

use alloy::primitives::{bytes, keccak256, Address, Bytes, FixedBytes, Signature, B256, U256};
use alloy::signers::{local::PrivateKeySigner, Signer};
use alloy::sol;
use alloy::sol_types::SolValue;
use alloy_sol_types::private::primitives::address;

const CANONICAL_PERMIT2_ADDRESS: Address = address!("0x000000000022D473030F116dDEE9F6B43aC78BA3");

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

    println!("digest: {:?}", digest);

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

    let hash1 = keccak256(
        (
            PERMIT_TRANSFER_FROM_WITNESS_TYPEHASH_STUB,
            witness_type_string,
        )
            .abi_encode_packed(),
    );
    println!("hash1: {:?}", hash1);

    let hash2 = keccak256(
        (
            token_permissions_typehash(),
            permit.permitted.token,
            permit.permitted.amount,
        )
            .abi_encode_params(),
    );
    println!("hash2: {:?}", hash2);

    let struct_hash: B256 = keccak256(
        (
            hash1,
            hash2,
            spender,
            permit.nonce,
            permit.deadline,
            witness,
        )
            .abi_encode_params(),
    );

    println!("struct_hash: {:?}", struct_hash);

    let prefix = FixedBytes::<2>::from(&[0x19, 0x01]);
    println!("prefix: {}", &prefix);
    let data = (&prefix, PERMIT2_DOMAIN_SEPARATOR_SEPOLIA, struct_hash).abi_encode_packed();

    println!("msg before digest: {:?}", hex::encode(&data));

    keccak256(data)
}

pub struct SetUp {
    pub signer: PrivateKeySigner,
    pub erc20: Address,
    pub amount: U256,
    pub nonce: U256,
    pub deadline: U256,
    pub spender: Address,
    pub witness: B256,
}

pub fn default_values() -> SetUp {
    SetUp {
        signer: "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
            .parse()
            .expect("should parse private key"),
        erc20: address!("0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f"),
        amount: U256::from(1000),
        nonce: U256::from(0),
        deadline: U256::from(2000),
        spender: address!("0xA4AD4f68d0b91CFD19687c881e50f3A00242828c"),
        witness: B256::from(U256::from(0)),
    }
}

#[cfg(test)]
mod tests {
    use crate::permit2::{
        default_values, permit_witness_transfer_from_digest, permit_witness_transfer_from_signature,
        PERMIT2_DOMAIN_SEPARATOR_SEPOLIA,
    };
    use alloy::primitives::B256;

    use tokio;

    #[test]
    fn digest_is_as_expected() {
        let setup = default_values();

        let digest = permit_witness_transfer_from_digest(
            setup.erc20,
            setup.amount,
            setup.nonce,
            setup.deadline,
            setup.spender,
            setup.witness,
        );

        println!("PERMIT2_DOMAIN_SEPARATOR_SEPOLIA {PERMIT2_DOMAIN_SEPARATOR_SEPOLIA}");
        println!("Digest {digest:?}");
    }

    #[tokio::test]
    async fn sig_is_as_expected() {
        let setup = default_values();

        let sig = permit_witness_transfer_from_signature(
            &setup.signer,
            setup.erc20,
            setup.amount,
            setup.nonce,
            setup.deadline,
            setup.spender,
            setup.witness,
        )
        .await;

        println!("{:?},{:?}", B256::from(sig.r()), B256::from(sig.s()));

        println!("{sig:?}");
    }
}
