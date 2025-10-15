use crate::keychain::KeyChain;
use crate::permit2::{Permit2Data, permit_witness_transfer_from_signature};
use alloy::hex;
use alloy::primitives::{Address, B256, U256, address};
use alloy::signers::local::PrivateKeySigner;
use arm_risc0::Digest as ArmDigest;
use arm_risc0::action_tree::MerkleTree;
use arm_risc0::compliance::INITIAL_ROOT;
use arm_risc0::evm::CallType;
use arm_risc0::merkle_path::MerklePath;
use evm_protocol_adapter_bindings::conversion::ProtocolAdapter;
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
        nonce: U256::random(),
        deadline: U256::from(1789040701),
        spender: address!("0xA4AD4f68d0b91CFD19687c881e50f3A00242828c"),
    }
}

pub fn mint_tx(
    data: &SetUp,
    keychain: &KeyChain,
) -> (ProtocolAdapter::Transaction, arm_risc0::resource::Resource) {
    let latest_cm_tree_root = &INITIAL_ROOT;

    let consumed_resource = construct_ephemeral_resource(
        &data.spender.to_vec(),
        &data.erc20.to_vec(),
        data.amount.try_into().unwrap(),
        [4u8; 32], // nonce
        keychain.nf_key.commit(),
        [5u8; 32], // rand_seed
        CallType::Wrap,
        &data.signer.address().as_slice(),
    );

    let consumed_nf = consumed_resource.nullifier(&keychain.nf_key).unwrap();

    // Note: We could use a different nullifier key here
    let created_resource = construct_persistent_resource(
        &data.spender.to_vec(),
        &data.erc20.to_vec(),
        data.amount.try_into().unwrap(),
        consumed_nf.into(), // nonce // ZCash Trick
        keychain.nf_key.commit(),
        [6u8; 32], // rand_seed
        &keychain.auth_verifying_key(),
    );

    let created_cm = created_resource.commitment();

    let action_tree = MerkleTree::new(vec![consumed_nf, created_cm]);

    let rt = tokio::runtime::Runtime::new().unwrap();
    let permit_sig = rt.block_on(permit_witness_transfer_from_signature(
        &data.signer,
        Permit2Data {
            chain_id: 11155111,
            token: data.erc20,
            amount: data.amount.try_into().unwrap(),
            nonce: data.nonce,
            deadline: data.deadline,
            spender: data.spender,
            action_tree_root: B256::from_slice(action_tree.root().as_bytes()),
        },
    ));

    // Construct the mint transaction
    let tx = construct_mint_tx(
        consumed_resource,
        latest_cm_tree_root.as_bytes().try_into().unwrap(),
        keychain.nf_key.clone(),
        data.spender.to_vec(),
        data.erc20.to_vec(),
        data.signer.address().to_vec(),
        data.nonce.to_be_bytes_vec(),
        data.deadline.to_be_bytes_vec(),
        permit_sig.as_bytes().to_vec(),
        created_resource.clone(),
        keychain.discovery_pk,
        keychain.encryption_pk,
    )
    .unwrap();

    // Verify the transaction
    tx.clone().verify().unwrap();

    (ProtocolAdapter::Transaction::from(tx), created_resource)
}

pub fn transfer_tx(
    data: &SetUp,
    keychain: &KeyChain,
    resource_to_transfer: &arm_risc0::resource::Resource,
) -> (ProtocolAdapter::Transaction, arm_risc0::resource::Resource) {
    let consumed_nf = resource_to_transfer.nullifier(&keychain.nf_key).unwrap();

    let created_resource = construct_persistent_resource(
        &data.spender.to_vec(), // forwarder_addr
        &data.erc20.to_vec(),   // token_addr
        data.amount.try_into().unwrap(),
        consumed_nf.into(), // nonce
        keychain.nullifier_key_commitment(),
        [7u8; 32], // rand_seed
        &keychain.auth_verifying_key(),
    );
    let created_cm = created_resource.commitment();

    // Get the authorization signature, it can be from external signing(e.g. wallet)
    let action_tree = MerkleTree::new(vec![consumed_nf, created_cm]);

    let auth_sig = authorize_the_action(&keychain.auth_signing_key, &action_tree);

    // Construct the transfer transaction
    let is_left = false;
    let node: [u8; 32] = empty_leaf_hash().into();
    let path: &[(ArmDigest, bool)] = &[(node.into(), is_left)];
    let merkle_path = MerklePath::from_path(path);

    let tx = construct_transfer_tx(
        resource_to_transfer.clone(),
        merkle_path.clone(),
        keychain.nf_key.clone(),
        keychain.auth_verifying_key(),
        auth_sig,
        created_resource.clone(),
        keychain.discovery_pk,
        keychain.encryption_pk,
    )
    .unwrap();

    // Verify the transaction
    tx.clone().verify().unwrap();

    (ProtocolAdapter::Transaction::from(tx), created_resource)
}

pub fn burn_tx(
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
        consumed_nf.into(), // nonce
        keychain.nullifier_key_commitment(),
        [6u8; 32], // rand_seed
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
        ArmDigest::from(minted_resource.commitment()),
        sibling0is_left,
    );

    let sibling1is_left = false;
    let sibling1 = (
        sha256(empty_leaf_hash().as_slice(), empty_leaf_hash().as_slice()).into(),
        sibling1is_left,
    );

    let path: &[(ArmDigest, bool)] = &[sibling0, sibling1];
    let merkle_path = MerklePath::from_path(path);

    let tx = construct_burn_tx(
        resource_to_burn.clone(),
        merkle_path,
        keychain.nf_key.clone(),
        keychain.auth_verifying_key(),
        auth_sig,
        created_resource,
        data.spender.to_vec(),
        data.erc20.to_vec(),
        data.signer.address().to_vec(),
    )
    .unwrap();

    tx.clone().verify().unwrap();

    ProtocolAdapter::Transaction::from(tx)
}

fn sha256(a: &[u8], b: &[u8]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(a);
    hasher.update(b);

    hasher.finalize().into()
}
