use alloy::hex;
use alloy::primitives::{Address, B256, U256, address};
use alloy::signers::local::PrivateKeySigner;
use alloy::sol_types::SolValue;
use arm_risc0::action_tree::MerkleTree;
use arm_risc0::authorization::{AuthorizationSigningKey, AuthorizationVerifyingKey};
use arm_risc0::compliance::INITIAL_ROOT;
use arm_risc0::encryption::{AffinePoint, SecretKey, random_keypair};
use arm_risc0::evm::CallType;
use arm_risc0::merkle_path::MerklePath;
use arm_risc0::nullifier_key::{NullifierKey, NullifierKeyCommitment};
use arm_risc0::utils::{bytes_to_words, words_to_bytes};
use evm_protocol_adapter_bindings::conversion::ProtocolAdapter;
use evm_protocol_adapter_bindings::permit2::permit_witness_transfer_from_signature;
use sha2::{Digest, Sha256};
use simple_transfer_app::burn::construct_burn_tx;
use simple_transfer_app::mint::construct_mint_tx;
use simple_transfer_app::resource::{construct_ephemeral_resource, construct_persistent_resource};
use simple_transfer_app::transfer::construct_transfer_tx;
use simple_transfer_app::utils::authorize_the_action;
use std::env;

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
        signer: env::var("PRIVATE_KEY")
            .expect("Couldn't read PRIVATE_KEY")
            .parse()
            .expect("should parse private key"),
        erc20: address!("0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f"),
        amount: U256::from(1000),
        nonce: U256::from(0),
        deadline: U256::from(1789040701),
        spender: address!("0xA4AD4f68d0b91CFD19687c881e50f3A00242828c"),
    }
}

#[allow(dead_code)]
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

    fn nullifier_key_commitment(&self) -> NullifierKeyCommitment {
        self.nf_key.commit()
    }
}

fn example_keychain() -> KeyChain {
    let (discovery_sk, discovery_pk) = random_keypair();
    let (encryption_sk, encryption_pk) = random_keypair();

    KeyChain {
        auth_signing_key: AuthorizationSigningKey::from_bytes(&vec![15u8; 32]),
        nf_key: NullifierKey::from_bytes(&vec![13u8; 32]),
        discovery_sk,
        discovery_pk,
        encryption_sk,
        encryption_pk,
    }
}

fn mint_tx(
    data: &SetUp,
    keychain: &KeyChain,
) -> (ProtocolAdapter::Transaction, arm_risc0::resource::Resource) {
    let latest_cm_tree_root = INITIAL_ROOT.as_words().to_vec();

    let consumed_resource = construct_ephemeral_resource(
        &data.spender.to_vec(),
        &data.erc20.to_vec(),
        data.amount.try_into().unwrap(),
        vec![4u8; 32], // nonce
        keychain.nf_key.commit(),
        vec![5u8; 32], // rand_seed
        CallType::Wrap,
        &data.signer.address().to_vec(),
    );

    let consumed_nf = consumed_resource.nullifier(&keychain.nf_key).unwrap();

    // Note: We could use a different nullifier key here
    let created_resource = construct_persistent_resource(
        &data.spender.to_vec(),
        &data.erc20.to_vec(),
        data.amount.try_into().unwrap(),
        consumed_nf.as_bytes().to_vec(), // nonce // ZCash Trick
        keychain.nf_key.commit(),
        vec![6u8; 32], // rand_seed
        &keychain.auth_verifying_key(),
    );

    let created_cm = created_resource.commitment();

    let action_tree = MerkleTree::new(vec![consumed_nf, created_cm]);

    let rt = tokio::runtime::Runtime::new().unwrap();
    let permit_sig = rt.block_on(permit_witness_transfer_from_signature(
        &data.signer,
        data.erc20,
        data.amount,
        data.nonce,
        data.deadline,
        data.spender,
        B256::from_slice(words_to_bytes(action_tree.root().as_slice())), // Witness
    ));

    // Construct the mint transaction
    let tx = construct_mint_tx(
        consumed_resource,
        latest_cm_tree_root,
        keychain.nf_key.clone(),
        keychain.discovery_pk,
        data.spender.to_vec(),
        data.erc20.to_vec(),
        data.signer.address().to_vec(),
        data.nonce.to_be_bytes_vec(),
        data.deadline.to_be_bytes_vec(),
        permit_sig.as_bytes().to_vec(),
        created_resource.clone(),
        keychain.discovery_pk,
        keychain.encryption_pk,
    );

    // Verify the transaction
    assert!(tx.clone().verify(), "Transaction verification failed");

    (ProtocolAdapter::Transaction::from(tx), created_resource)
}

fn transfer_tx(
    data: &SetUp,
    keychain: &KeyChain,
    resource_to_transfer: &arm_risc0::resource::Resource,
) -> (ProtocolAdapter::Transaction, arm_risc0::resource::Resource) {
    let consumed_nf = resource_to_transfer.nullifier(&keychain.nf_key).unwrap();

    let created_resource = construct_persistent_resource(
        &data.spender.to_vec(), // forwarder_addr
        &data.erc20.to_vec(),   // token_addr
        data.amount.try_into().unwrap(),
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
    data: &SetUp,
    keychain: &KeyChain,
    minted_resource: &arm_risc0::resource::Resource,
    resource_to_burn: &arm_risc0::resource::Resource,
) -> ProtocolAdapter::Transaction {
    let consumed_nf = resource_to_burn.nullifier(&keychain.nf_key).unwrap();

    // Create the ephemeral resource
    let created_resource = construct_ephemeral_resource(
        &data.spender.to_vec(), // forwarder_addr
        &data.erc20.to_vec(),   // token_addr
        data.amount.try_into().unwrap(),
        consumed_nf.as_bytes().to_vec(), // nonce
        keychain.nullifier_key_commitment(),
        vec![6u8; 32], // rand_seed
        CallType::Unwrap,
        &data.signer.address().to_vec(), // user_addr // TODO rename
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
        data.spender.to_vec(),
        data.erc20.to_vec(),
        data.signer.address().to_vec(),
    );

    ProtocolAdapter::Transaction::from(tx)
}

fn sha256(a: &[u8], b: &[u8]) -> B256 {
    let mut hasher = Sha256::new();
    hasher.update(a);
    hasher.update(b);

    B256::from_slice(&hasher.finalize())
}

fn main() {
    env::var("PRIVATE_KEY").expect("Couldn't read PRIVATE_KEY");

    let data = default_values();
    let keychain = example_keychain();

    let (mint_tx, minted_resource) = mint_tx(&data, &keychain);
    write_to_file(mint_tx, "mint");

    let (transfer_tx, transferred_resource) = transfer_tx(&data, &keychain, &minted_resource);
    write_to_file(transfer_tx, "transfer");

    let burn_tx = burn_tx(&data, &keychain, &minted_resource, &transferred_resource);
    write_to_file(burn_tx, "burn");
}

fn write_to_file(tx: ProtocolAdapter::Transaction, file_name: &str) {
    let encoded_tx = tx.abi_encode();

    std::fs::write(
        format!("./contracts/test/transactions/{file_name}.bin"),
        encoded_tx,
    )
    .expect("Failed to write file");
}
