use crate::permit2::permit_witness_transfer_from_signature;
use alloy::hex;
use alloy::primitives::{address, Address, B256, U256};
use alloy::signers::local::PrivateKeySigner;
use arm_risc0::action_tree::MerkleTree;
use arm_risc0::authorization::{AuthorizationSigningKey, AuthorizationVerifyingKey};
use arm_risc0::compliance::INITIAL_ROOT;
use arm_risc0::encryption::{random_keypair, AffinePoint, SecretKey};
use arm_risc0::evm::CallType;
use arm_risc0::merkle_path::MerklePath;
use arm_risc0::nullifier_key::{NullifierKey, NullifierKeyCommitment};

use crate::conversion::ProtocolAdapter;
use arm_risc0::utils::bytes_to_words;
use sha2::{Digest, Sha256};
use simple_transfer_app::burn::construct_burn_tx;
use simple_transfer_app::mint::construct_mint_tx;
use simple_transfer_app::resource::{construct_ephemeral_resource, construct_persistent_resource};
use simple_transfer_app::transfer::construct_transfer_tx;
use simple_transfer_app::utils::authorize_the_action;

pub struct SetUp {
    pub signer: PrivateKeySigner,
    pub erc20: Address,
    pub amount: U256,
    pub nonce: U256,
    pub deadline: U256,
    pub spender: Address,
}

fn empty_leaf_hash() -> B256 {
    B256::from(hex!(
        "cc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06"
    ))
}

pub fn default_values() -> SetUp {
    SetUp {
        signer: "0x97ecae11e1bd9b504ff977ae3815599331c6b0757ee4af3140fe616adb19ae45"
            .parse()
            .expect("should parse private key"),
        erc20: address!("0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f"),
        amount: U256::from(1000),
        nonce: U256::from(0),
        deadline: U256::from(1789040701),
        spender: address!("0xA4AD4f68d0b91CFD19687c881e50f3A00242828c"),
    }
}

pub struct KeyChain {
    auth_signing_key: AuthorizationSigningKey,
    nf_key: NullifierKey,
    discovery_sk: SecretKey,
    discovery_pk: AffinePoint,
    encryption_sk: SecretKey,
    encryption_pk: AffinePoint,
}

impl KeyChain {
    fn auth_verifying_key(&self) -> AuthorizationVerifyingKey {
        AuthorizationVerifyingKey::from_signing_key(&self.auth_signing_key)
    }

    fn nullifier(&self, resource: arm_risc0::resource::Resource) -> arm_risc0::Digest {
        resource.nullifier(&self.nf_key).unwrap()
    }

    fn nullifier_key_commitment(&self) -> NullifierKeyCommitment {
        self.nf_key.commit()
    }
}

fn keychain_a() -> KeyChain {
    let (discovery_sk, discovery_pk) = random_keypair();
    let (encryption_sk, encryption_pk) = random_keypair();

    KeyChain {
        auth_signing_key: AuthorizationSigningKey::from_bytes(&vec![15u8; 32]),
        nf_key: NullifierKey::from_bytes(&vec![13u8; 32]),
        discovery_sk: discovery_sk,
        discovery_pk: discovery_pk,
        encryption_sk: encryption_sk,
        encryption_pk: encryption_pk,
    }
}

fn mint_tx(
    d: &SetUp,
    keychain: &KeyChain,
) -> (ProtocolAdapter::Transaction, arm_risc0::resource::Resource) {
    let latest_cm_tree_root = INITIAL_ROOT.as_words().to_vec();

    let (consumed_resource, created_resource) = mint_consumed_created_pair(d, keychain);

    let action_tree_root = sha256(
        consumed_resource
            .nullifier(&keychain.nf_key)
            .unwrap()
            .as_bytes(),
        created_resource.commitment().as_bytes(),
    );

    let rt = tokio::runtime::Runtime::new().unwrap();
    let permit_sig = rt.block_on(permit_witness_transfer_from_signature(
        &d.signer,
        d.erc20,
        d.amount,
        d.nonce,
        d.deadline,
        d.spender,
        action_tree_root, // Witness
    ));

    // Construct the mint transaction
    let tx = construct_mint_tx(
        consumed_resource,
        latest_cm_tree_root,
        keychain.nf_key.clone(),
        keychain.discovery_pk,
        d.spender.to_vec(),
        d.erc20.to_vec(),
        d.signer.address().to_vec(),
        d.nonce.to_be_bytes_vec(),
        d.deadline.to_be_bytes_vec(),
        permit_sig.as_bytes().to_vec(),
        created_resource.clone(),
        keychain.discovery_pk,
        keychain.encryption_pk,
    );

    // Verify the transaction
    assert!(tx.clone().verify(), "Transaction verification failed");

    (ProtocolAdapter::Transaction::from(tx), created_resource)
}

fn mint_consumed_created_pair(
    d: &SetUp,
    keychain: &KeyChain,
) -> (arm_risc0::resource::Resource, arm_risc0::resource::Resource) {
    let consumed_resource = construct_ephemeral_resource(
        &d.spender.to_vec(),
        &d.erc20.to_vec(),
        d.amount.try_into().unwrap(),
        vec![4u8; 32], // nonce
        keychain.nf_key.commit(),
        vec![5u8; 32], // rand_seed
        CallType::Wrap,
        &d.signer.address().to_vec(),
    );

    // ZCash Nonce trick
    let consumed_nf = consumed_resource.nullifier(&keychain.nf_key).unwrap();

    // Note: We could use a different nullifier key here
    let created_resource = construct_persistent_resource(
        &d.spender.to_vec(),
        &d.erc20.to_vec(),
        d.amount.try_into().unwrap(),
        consumed_nf.as_bytes().to_vec(), // nonce
        keychain.nf_key.commit(),
        vec![6u8; 32], // rand_seed
        &keychain.auth_verifying_key(),
    );
    (consumed_resource, created_resource)
}

fn transfer_tx(
    d: &SetUp,
    keychain: &KeyChain,
    resource_to_transfer: &arm_risc0::resource::Resource,
) -> (ProtocolAdapter::Transaction, arm_risc0::resource::Resource) {
    let consumed_nf = resource_to_transfer.nullifier(&keychain.nf_key).unwrap();

    let created_resource = construct_persistent_resource(
        &d.spender.to_vec(), // forwarder_addr
        &d.erc20.to_vec(),   // token_addr
        d.amount.try_into().unwrap(),
        consumed_nf.as_bytes().to_vec(), // nonce
        keychain.nullifier_key_commitment(),
        vec![7u8; 32], // rand_seed
        &keychain.auth_verifying_key(),
    );
    let created_cm = created_resource.commitment();

    // Get the authorization signature, it can be from external signing(e.g. wallet)
    let action_tree = MerkleTree::new(vec![consumed_nf, created_cm]);

    let auth_sig = authorize_the_action(&keychain.auth_signing_key, &action_tree);

    // Construct the transfer transaction
    let is_left = false;
    let path: &[(Vec<u32>, bool)] = &[(bytes_to_words(empty_leaf_hash().as_slice()), is_left)];
    let merkle_path = MerklePath::from_path(path);

    let tx = construct_transfer_tx(
        resource_to_transfer.clone(),
        merkle_path.clone(),
        keychain.nf_key.clone(),
        keychain.auth_verifying_key(),
        auth_sig,
        keychain.discovery_pk,
        keychain.encryption_pk,
        created_resource.clone(),
        keychain.discovery_pk,
        keychain.encryption_pk,
    );

    // Verify the transaction
    assert!(tx.clone().verify(), "Transaction verification failed");

    (ProtocolAdapter::Transaction::from(tx), created_resource)
}

fn burn_tx(
    d: &SetUp,
    keychain: &KeyChain,
    minted_resource: &arm_risc0::resource::Resource,
    resource_to_burn: &arm_risc0::resource::Resource,
) -> ProtocolAdapter::Transaction {
    let consumed_nf = resource_to_burn.nullifier(&keychain.nf_key).unwrap();

    // Create the ephemeral resource
    let created_resource = construct_ephemeral_resource(
        &d.spender.to_vec(), // forwarder_addr
        &d.erc20.to_vec(),   // token_addr
        d.amount.try_into().unwrap(),
        consumed_nf.as_bytes().to_vec(), // nonce
        keychain.nullifier_key_commitment(),
        vec![6u8; 32], // rand_seed
        CallType::Unwrap,
        &d.signer.address().to_vec(), // user_addr // TODO rename
    );
    let created_cm = created_resource.commitment();

    // Get the authorization signature, it can be from external signing(e.g. wallet)
    let action_tree = MerkleTree::new(vec![consumed_nf, created_cm]);
    let auth_sig = authorize_the_action(&keychain.auth_signing_key, &action_tree);

    // Construct the burn transaction

    let sibling0is_left = true;
    let sibling0 = (
        bytes_to_words(minted_resource.commitment().as_bytes()),
        sibling0is_left,
    );

    let sibling1is_left = false;
    let sibling1 = (
        bytes_to_words(
            sha256(empty_leaf_hash().as_slice(), empty_leaf_hash().as_slice()).as_slice(),
        ),
        sibling1is_left,
    );

    let path: &[(Vec<u32>, bool)] = &[sibling0, sibling1];
    let merkle_path = MerklePath::from_path(path);

    let tx = construct_burn_tx(
        resource_to_burn.clone(),
        merkle_path,
        keychain.nf_key.clone(),
        keychain.auth_verifying_key(),
        auth_sig,
        keychain.discovery_pk,
        keychain.encryption_pk,
        created_resource,
        keychain.discovery_pk,
        d.spender.to_vec(),
        d.erc20.to_vec(),
        d.signer.address().to_vec(),
    );

    ProtocolAdapter::Transaction::from(tx)
}

fn sha256(a: &[u8], b: &[u8]) -> B256 {
    let mut hasher = Sha256::new();
    hasher.update(a);
    hasher.update(b);

    B256::from_slice(&hasher.finalize())
}

fn write_to_file(tx: ProtocolAdapter::Transaction, file_name: &str) {
    use alloy::sol_types::SolValue; // Import the trait for abi_encode

    let encoded_tx = tx.abi_encode();

    std::fs::write(
        format!("{file_name}.json"),
        serde_json::to_string_pretty(&tx).unwrap(),
    )
    .expect("Failed to write file");

    std::fs::write(format!("{file_name}.bin"), encoded_tx).expect("Failed to write file");
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::conversion::ProtocolAdapter;
    use std::env;

    #[test]
    #[ignore]
    fn print_tx() {
        env::var("BONSAI_API_KEY").expect("Couldn't read BONSAI_API_KEY");
        env::var("BONSAI_API_URL").expect("Couldn't read BONSAI_API_URL");

        println!(
            "{:?}",
            B256::from_slice(arm_risc0::constants::COMPLIANCE_VK.as_bytes())
        );

        let n_actions = 1;

        let raw_tx = arm_risc0::transaction::generate_test_transaction(n_actions);
        println!("{:?}", raw_tx);
        let evm_tx = ProtocolAdapter::Transaction::from(raw_tx);

        use alloy::sol_types::SolValue;
        let encoded_tx = evm_tx.abi_encode();
        let decoded_tx: ProtocolAdapter::Transaction =
            ProtocolAdapter::Transaction::abi_decode(&encoded_tx).unwrap();
        assert_eq!(evm_tx, decoded_tx);

        write_to_file(evm_tx, &format!("test_tx{n_actions:02}"));
    }

    #[test]
    fn generates_simple_transfer_txns() {
        env::var("BONSAI_API_KEY").expect("Couldn't read BONSAI_API_KEY");
        env::var("BONSAI_API_URL").expect("Couldn't read BONSAI_API_URL");

        let d = default_values();
        let keychain = keychain_a();

        let (mint_tx, minted_resource) = mint_tx(&d, &keychain);
        write_to_file(mint_tx, "mint");

        let (transfer_tx, transferred_resource) = transfer_tx(&d, &keychain, &minted_resource);
        write_to_file(transfer_tx, "transfer");

        let burn_tx = burn_tx(&d, &keychain, &minted_resource, &transferred_resource);
        write_to_file(burn_tx, "burn");
    }
}
