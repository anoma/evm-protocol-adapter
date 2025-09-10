use crate::permit2::{default_values, permit_witness_transfer_from_signature, SetUp};
use alloy::primitives::{Bytes, B256};
use alloy::{hex, sol};
use arm_risc0::action::Action;
use arm_risc0::action_tree::MerkleTree;
use arm_risc0::authorization::{AuthorizationSigningKey, AuthorizationVerifyingKey};
use arm_risc0::compliance::{ComplianceInstance, INITIAL_ROOT};
use arm_risc0::compliance_unit::ComplianceUnit;
use arm_risc0::encryption::{random_keypair, AffinePoint};
use arm_risc0::evm::CallType;
use arm_risc0::logic_instance::{AppData, ExpirableBlob};
use arm_risc0::logic_proof::LogicVerifierInputs;
use arm_risc0::merkle_path::MerklePath;
use arm_risc0::nullifier_key::NullifierKey;
use arm_risc0::proving_system::encode_seal;

use arm_risc0::transaction::{Delta, Transaction};
use arm_risc0::utils::{bytes_to_words, words_to_bytes};
use sha2::{Digest, Sha256};
use simple_transfer_app::mint::construct_mint_tx;
use simple_transfer_app::resource::{construct_ephemeral_resource, construct_persistent_resource};
use simple_transfer_app::transfer::construct_transfer_tx;
use simple_transfer_app::utils::authorize_the_action;

fn sha256(a: &[u8], b: &[u8]) -> B256 {
    let mut hasher = Sha256::new();
    hasher.update(a);
    hasher.update(b);

    B256::from_slice(&hasher.finalize())
}

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
    #[sol(rpc)]
    ProtocolAdapter,
    "../contracts/out/ProtocolAdapter.sol/ProtocolAdapter.json"
);

impl From<ExpirableBlob> for Logic::ExpirableBlob {
    fn from(expirable_blob: ExpirableBlob) -> Self {
        Self {
            blob: words_to_bytes(&expirable_blob.blob).to_vec().into(),
            deletionCriterion: expirable_blob.deletion_criterion as u8,
        }
    }
}

impl From<AppData> for Logic::AppData {
    fn from(app_data: AppData) -> Self {
        Self {
            discoveryPayload: app_data
                .discovery_payload
                .into_iter()
                .map(Logic::ExpirableBlob::from)
                .collect(),
            resourcePayload: app_data
                .resource_payload
                .into_iter()
                .map(Logic::ExpirableBlob::from)
                .collect(),
            externalPayload: app_data
                .external_payload
                .into_iter()
                .map(Logic::ExpirableBlob::from)
                .collect(),
            applicationPayload: app_data
                .application_payload
                .into_iter()
                .map(Logic::ExpirableBlob::from)
                .collect(),
        }
    }
}

impl From<LogicVerifierInputs> for Logic::VerifierInput {
    fn from(logic_verifier_inputs: LogicVerifierInputs) -> Self {
        Self {
            tag: B256::from_slice(words_to_bytes(&logic_verifier_inputs.tag)),
            verifyingKey: B256::from_slice(words_to_bytes(&logic_verifier_inputs.verifying_key)),
            appData: logic_verifier_inputs.app_data.into(),
            proof: Bytes::from(encode_seal(&logic_verifier_inputs.proof)),
        }
    }
}

impl From<ComplianceInstance> for Compliance::Instance {
    fn from(instance: ComplianceInstance) -> Self {
        Self {
            consumed: Compliance::ConsumedRefs {
                nullifier: B256::from_slice(words_to_bytes(&instance.consumed_nullifier)),
                logicRef: B256::from_slice(words_to_bytes(&instance.consumed_logic_ref)),
                commitmentTreeRoot: B256::from_slice(words_to_bytes(
                    &instance.consumed_commitment_tree_root,
                )),
            },
            created: Compliance::CreatedRefs {
                commitment: B256::from_slice(words_to_bytes(&instance.created_commitment)),
                logicRef: B256::from_slice(words_to_bytes(&instance.created_logic_ref)),
            },
            unitDeltaX: B256::from_slice(words_to_bytes(&instance.delta_x)),
            unitDeltaY: B256::from_slice(words_to_bytes(&instance.delta_y)),
        }
    }
}

impl From<ComplianceUnit> for Compliance::VerifierInput {
    fn from(compliance_unit: ComplianceUnit) -> Self {
        Self {
            proof: Bytes::from(encode_seal(&compliance_unit.proof)),
            instance: compliance_unit.get_instance().into(),
        }
    }
}

impl From<Action> for ProtocolAdapter::Action {
    fn from(action: Action) -> Self {
        Self {
            logicVerifierInputs: action
                .logic_verifier_inputs
                .into_iter()
                .map(|lp| lp.into())
                .collect(),
            complianceVerifierInputs: action
                .compliance_units
                .into_iter()
                .map(|cu| cu.into())
                .collect(),
        }
    }
}

impl From<Transaction> for ProtocolAdapter::Transaction {
    fn from(tx: Transaction) -> Self {
        let delta_proof = match &tx.delta_proof {
            Delta::Witness(_) => panic!("Unbalanced Transactions cannot be converted"),
            Delta::Proof(proof) => proof.to_bytes().to_vec(),
        };

        Self {
            actions: tx
                .actions
                .into_iter()
                .map(ProtocolAdapter::Action::from)
                .collect(),
            deltaProof: Bytes::from(delta_proof),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::conversion::ProtocolAdapter;
    use alloy::primitives::address;
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
        println!("Transaction: {:#?}", evm_tx);
        std::fs::write(format!("test_tx{n_actions:02}.bin"), &encoded_tx)
            .expect("Failed to write encoded transaction to file");
    }

    use crate::permit2::{default_values, permit_witness_transfer_from_signature};
    use arm_risc0::{
        action_tree::MerkleTree,
        authorization::{AuthorizationSigningKey, AuthorizationVerifyingKey},
        compliance::INITIAL_ROOT,
        encryption::{random_keypair, Ciphertext},
        evm::CallType,
        merkle_path::MerklePath,
        nullifier_key::NullifierKey,
    };
    use simple_transfer_app::{
        burn::construct_burn_tx,
        mint::construct_mint_tx,
        resource::{construct_ephemeral_resource, construct_persistent_resource},
        transfer::construct_transfer_tx,
        utils::authorize_the_action,
    };

    #[test]
    #[ignore = "reason: takes too long"]
    fn print_simple_transfer_tx() {
        let forwarder_addr = vec![1u8; 20];
        let token_addr = vec![2u8; 20];
        let quantity = 100;
        // Obtain the consumed resource data
        let consumed_auth_sk = AuthorizationSigningKey::new();
        let consumed_auth_pk = AuthorizationVerifyingKey::from_signing_key(&consumed_auth_sk);
        let (consumed_nf_key, consumed_nf_cm) = NullifierKey::random_pair();
        let (consumed_discovery_sk, consumed_discovery_pk) = random_keypair();
        let (consumed_encryption_sk, consumed_encryption_pk) = random_keypair();
        let consumed_resource = construct_persistent_resource(
            &forwarder_addr, // forwarder_addr
            &token_addr,     // token_addr
            quantity,
            vec![4u8; 32], // nonce
            consumed_nf_cm,
            vec![5u8; 32], // rand_seed
            &consumed_auth_pk,
        );
        let consumed_nf = consumed_resource.nullifier(&consumed_nf_key).unwrap();

        // Create the created resource data
        let created_auth_sk = AuthorizationSigningKey::new();
        let created_auth_pk = AuthorizationVerifyingKey::from_signing_key(&created_auth_sk);
        let (_created_nf_key, created_nf_cm) = NullifierKey::random_pair();
        let (_created_discovery_sk, created_discovery_pk) = random_keypair();
        let (_created_encryption_sk, created_encryption_pk) = random_keypair();
        let created_resource = construct_persistent_resource(
            &forwarder_addr, // forwarder_addr
            &token_addr,     // token_addr
            quantity,
            consumed_nf.as_bytes().to_vec(), // nonce
            created_nf_cm,
            vec![7u8; 32], // rand_seed
            &created_auth_pk,
        );
        let created_cm = created_resource.commitment();

        // Get the authorization signature, it can be from external signing(e.g. wallet)
        let action_tree = MerkleTree::new(vec![consumed_nf, created_cm]);
        let auth_sig = authorize_the_action(&consumed_auth_sk, &action_tree);

        // Construct the transfer transaction
        let merkle_path = MerklePath::default(); // mock a path

        let tx_start_timer = std::time::Instant::now();
        let tx = construct_transfer_tx(
            consumed_resource.clone(),
            merkle_path.clone(),
            consumed_nf_key.clone(),
            consumed_auth_pk,
            auth_sig,
            consumed_discovery_pk,
            consumed_encryption_pk,
            created_resource.clone(),
            created_discovery_pk,
            created_encryption_pk,
        );
        println!("Tx build duration time: {:?}", tx_start_timer.elapsed());

        // check the discovery ciphertexts
        let discovery_ciphertext = Ciphertext::from_words(
            &tx.actions[0].logic_verifier_inputs[0]
                .app_data
                .discovery_payload[0]
                .blob,
        );
        discovery_ciphertext
            .decrypt(&consumed_discovery_sk)
            .unwrap();

        // check the encryption ciphertexts
        let encryption_ciphertext = Ciphertext::from_words(
            &tx.actions[0].logic_verifier_inputs[0]
                .app_data
                .resource_payload[0]
                .blob,
        );
        let decrypted_resource = encryption_ciphertext
            .decrypt(&consumed_encryption_sk)
            .unwrap();
        assert_eq!(decrypted_resource, consumed_resource.to_bytes());

        // Verify the transaction
        assert!(tx.clone().verify(), "Transaction verification failed");

        println!("{:?}", tx);
        let evm_tx = ProtocolAdapter::Transaction::from(tx);

        use alloy::sol_types::SolValue;
        let encoded_tx = evm_tx.abi_encode();
        let decoded_tx: ProtocolAdapter::Transaction =
            ProtocolAdapter::Transaction::abi_decode(&encoded_tx).unwrap();
        assert_eq!(evm_tx, decoded_tx);
        println!("Transaction: {:#?}", evm_tx);

        std::fs::write(
            format!("simple_transfer.json"),
            serde_json::to_string_pretty(&evm_tx).unwrap(),
        )
        .unwrap();

        std::fs::write(format!("simple_transfer.bin"), &encoded_tx)
            .expect("Failed to write encoded transaction to file");
    }

    #[test]
    #[ignore = "reason: takes too long"]
    fn print_simple_burn_tx() {
        let forwarder_addr = address!("0xD6BbDE9174b1CdAa358d2Cf4D57D1a9F7178FBfF").to_vec();
        let token_addr = address!("0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f").to_vec();
        let user_addr = address!("0xe05fcC23807536bEe418f142D19fa0d21BB0cfF7").to_vec();
        let quantity = 100;

        // Obtain the consumed resource data
        let consumed_auth_sk = AuthorizationSigningKey::new();
        let consumed_auth_pk = AuthorizationVerifyingKey::from_signing_key(&consumed_auth_sk);
        let (consumed_nf_key, consumed_nf_cm) = NullifierKey::random_pair();
        let (consumed_discovery_sk, consumed_discovery_pk) = random_keypair();
        let (consumed_encryption_sk, consumed_encryption_pk) = random_keypair();
        let consumed_resource = construct_persistent_resource(
            &forwarder_addr, // forwarder_addr
            &token_addr,     // token_addr
            quantity,
            vec![4u8; 32], // nonce
            consumed_nf_cm,
            vec![5u8; 32], // rand_seed
            &consumed_auth_pk,
        );
        let consumed_nf = consumed_resource.nullifier(&consumed_nf_key).unwrap();

        // Create the ephemeral resource
        let (_created_nf_key, created_nf_cm) = NullifierKey::random_pair();
        let (_created_discovery_sk, created_discovery_pk) = random_keypair();
        let created_resource = construct_ephemeral_resource(
            &forwarder_addr, // forwarder_addr
            &token_addr,     // token_addr
            quantity,
            consumed_nf.as_bytes().to_vec(), // nonce
            created_nf_cm,
            vec![6u8; 32], // rand_seed
            CallType::Unwrap,
            &user_addr, // user_addr
        );
        let created_cm = created_resource.commitment();

        // Get the authorization signature, it can be from external signing(e.g. wallet)
        let action_tree = MerkleTree::new(vec![consumed_nf, created_cm]);
        let auth_sig = authorize_the_action(&consumed_auth_sk, &action_tree);

        // Construct the burn transaction
        let merkle_path = MerklePath::default(); // mock a path
        let tx_start_timer = std::time::Instant::now();
        let tx = construct_burn_tx(
            consumed_resource.clone(),
            merkle_path,
            consumed_nf_key,
            consumed_auth_pk,
            auth_sig,
            consumed_discovery_pk,
            consumed_encryption_pk,
            created_resource,
            created_discovery_pk,
            forwarder_addr,
            token_addr,
            user_addr,
        );
        println!("Tx build duration time: {:?}", tx_start_timer.elapsed());

        // check the discovery ciphertexts
        let discovery_ciphertext = Ciphertext::from_words(
            &tx.actions[0].logic_verifier_inputs[0]
                .app_data
                .discovery_payload[0]
                .blob,
        );
        discovery_ciphertext
            .decrypt(&consumed_discovery_sk)
            .unwrap();

        // check the encryption ciphertexts
        let encryption_ciphertext = Ciphertext::from_words(
            &tx.actions[0].logic_verifier_inputs[0]
                .app_data
                .resource_payload[0]
                .blob,
        );
        let decrypted_resource = encryption_ciphertext
            .decrypt(&consumed_encryption_sk)
            .unwrap();
        assert_eq!(decrypted_resource, consumed_resource.to_bytes());

        // Verify the transaction
        assert!(tx.clone().verify(), "Transaction verification failed");

        println!("{:?}", tx);
        let evm_tx = ProtocolAdapter::Transaction::from(tx);

        use alloy::sol_types::SolValue;
        let encoded_tx = evm_tx.abi_encode();
        let decoded_tx: ProtocolAdapter::Transaction =
            ProtocolAdapter::Transaction::abi_decode(&encoded_tx).unwrap();
        assert_eq!(evm_tx, decoded_tx);
        println!("Transaction: {:#?}", evm_tx);

        std::fs::write(
            format!("simple_transfer_burn.json"),
            serde_json::to_string_pretty(&evm_tx).unwrap(),
        )
        .unwrap();

        std::fs::write(format!("simple_transfer_burn.bin"), &encoded_tx)
            .expect("Failed to write encoded transaction to file");
    }

    #[test]
    fn print_simple_mint_tx() {
        let d = default_values();

        use arm_risc0::encryption::AffinePoint;

        // Construct the consumed resource
        let consumed_nf_key = NullifierKey::from_bytes(&vec![13u8; 32]);
        let consumed_nf_cm = consumed_nf_key.commit();
        let consumed_resource = construct_ephemeral_resource(
            &d.spender.to_vec(),
            &d.erc20.to_vec(),
            d.amount.try_into().unwrap(),
            vec![4u8; 32], // nonce
            consumed_nf_cm,
            vec![5u8; 32], // rand_seed
            CallType::Wrap,
            &d.signer.address().to_vec(),
        );
        let consumed_nf = consumed_resource.nullifier(&consumed_nf_key).unwrap();
        // Fetch the latest cm tree root from the chain
        let latest_cm_tree_root = INITIAL_ROOT.as_words().to_vec();

        // Generate the created resource
        let created_nf_key = NullifierKey::from_bytes(&vec![14u8; 32]);
        let created_nf_cm = created_nf_key.commit();
        let created_auth_sk = AuthorizationSigningKey::from_bytes(&vec![15u8; 32]);
        let created_auth_pk = AuthorizationVerifyingKey::from_signing_key(&created_auth_sk);
        let created_discovery_pk = AffinePoint::GENERATOR;
        let created_encryption_pk = AffinePoint::GENERATOR;
        let created_resource = construct_persistent_resource(
            &d.spender.to_vec(),
            &d.signer.address().to_vec(),
            d.amount.try_into().unwrap(),
            consumed_nf.as_bytes().to_vec(), // nonce
            created_nf_cm,
            vec![6u8; 32], // rand_seed
            &created_auth_pk,
        );

        let cm = created_resource.commitment();
        let nf = consumed_resource.nullifier(&consumed_nf_key).unwrap();
        println!("nf: {:?}, cm: {:?}", nf, cm);

        let action_tree_root = sha256(nf.as_bytes(), cm.as_bytes());

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

        println!("permit_sig: {:?}", permit_sig);

        println!("action_tree_root: {:#x}", action_tree_root);
        println!("{:?}", permit_sig.as_bytes());

        // Construct the mint transaction
        let tx_start_timer = std::time::Instant::now();
        let tx = construct_mint_tx(
            consumed_resource,
            latest_cm_tree_root,
            consumed_nf_key,
            created_discovery_pk,
            d.spender.to_vec(),
            d.erc20.to_vec(),
            d.signer.address().to_vec(),
            d.nonce.to_be_bytes_vec(),
            d.deadline.to_be_bytes_vec(),
            permit_sig.as_bytes().to_vec(),
            created_resource,
            created_discovery_pk,
            created_encryption_pk,
        );

        println!("Tx build duration time: {:?}", tx_start_timer.elapsed());

        // Verify the transaction
        assert!(tx.clone().verify(), "Transaction verification failed");

        println!("{:?}", tx);

        let cu_instance = tx.actions[0].compliance_units[0].get_instance();
        println!(
            "x:{:?}, y:{:?}",
            hex::encode(words_to_bytes(&cu_instance.delta_x)),
            hex::encode(words_to_bytes(&cu_instance.delta_y))
        );

        let evm_tx = ProtocolAdapter::Transaction::from(tx);

        use alloy::sol_types::SolValue;
        let encoded_tx = evm_tx.abi_encode();
        let decoded_tx: ProtocolAdapter::Transaction =
            ProtocolAdapter::Transaction::abi_decode(&encoded_tx).unwrap();
        assert_eq!(evm_tx, decoded_tx);
        println!("Transaction: {:#?}", evm_tx);

        std::fs::write(
            format!("simple_transfer_mint.json"),
            serde_json::to_string_pretty(&evm_tx).unwrap(),
        )
        .unwrap();

        std::fs::write(format!("simple_transfer_mint.bin"), &encoded_tx)
            .expect("Failed to write encoded transaction to file");
    }

    #[test]
    fn generates_simple_transfer_txns() {
        let d = default_values();

        let mint_tx = mint_tx(&d);
        write_to_file(mint_tx, "mint");

        let transfer_tx = transfer_tx(&d);
        write_to_file(transfer_tx, "transfer");
    }
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

fn mint_consumed_created_pair(
    d: &SetUp,
) -> (
    (arm_risc0::resource::Resource, NullifierKey),
    (arm_risc0::resource::Resource, NullifierKey),
) {
    let consumed_nf_key = NullifierKey::from_bytes(&vec![13u8; 32]);
    let consumed_nf_cm = consumed_nf_key.commit();
    let consumed_resource = construct_ephemeral_resource(
        &d.spender.to_vec(),
        &d.erc20.to_vec(),
        d.amount.try_into().unwrap(),
        vec![4u8; 32], // nonce
        consumed_nf_cm,
        vec![5u8; 32], // rand_seed
        CallType::Wrap,
        &d.signer.address().to_vec(),
    );
    let consumed_nf = consumed_resource.nullifier(&consumed_nf_key).unwrap();

    let created_nf_key = NullifierKey::from_bytes(&vec![14u8; 32]);
    let created_nf_cm = created_nf_key.commit();
    let created_auth_sk = AuthorizationSigningKey::from_bytes(&vec![15u8; 32]);
    let created_auth_pk = AuthorizationVerifyingKey::from_signing_key(&created_auth_sk);

    let created_resource = construct_persistent_resource(
        &d.spender.to_vec(),
        &d.erc20.to_vec(),
        d.amount.try_into().unwrap(),
        consumed_nf.as_bytes().to_vec(), // nonce
        created_nf_cm,
        vec![6u8; 32], // rand_seed
        &created_auth_pk,
    );
    (
        (consumed_resource, consumed_nf_key),
        (created_resource, created_nf_key),
    )
}

fn mint_tx(d: &SetUp) -> ProtocolAdapter::Transaction {
    let latest_cm_tree_root = INITIAL_ROOT.as_words().to_vec();

    let ((consumed_resource, consumed_nf_key), (created_resource, _)) =
        mint_consumed_created_pair(d);

    let cm = created_resource.commitment();
    let nf = consumed_resource.nullifier(&consumed_nf_key).unwrap();
    println!("nf: {:?}, cm: {:?}", nf, cm);

    let action_tree_root = sha256(nf.as_bytes(), cm.as_bytes());

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

    let created_discovery_pk = AffinePoint::GENERATOR;
    let created_encryption_pk = AffinePoint::GENERATOR;

    // Construct the mint transaction
    let tx = construct_mint_tx(
        consumed_resource,
        latest_cm_tree_root,
        consumed_nf_key,
        created_discovery_pk,
        d.spender.to_vec(),
        d.erc20.to_vec(),
        d.signer.address().to_vec(),
        d.nonce.to_be_bytes_vec(),
        d.deadline.to_be_bytes_vec(),
        permit_sig.as_bytes().to_vec(),
        created_resource,
        created_discovery_pk,
        created_encryption_pk,
    );

    // Verify the transaction
    assert!(tx.clone().verify(), "Transaction verification failed");

    ProtocolAdapter::Transaction::from(tx)
}

fn transfer_tx(d: &SetUp) -> ProtocolAdapter::Transaction {
    let (_, (minted_resource, minted_resource_nf_key)) = mint_consumed_created_pair(d);

    // Obtain the consumed resource data
    let consumed_auth_sk = AuthorizationSigningKey::from_bytes(&vec![15u8; 32]);
    let consumed_auth_pk = AuthorizationVerifyingKey::from_signing_key(&consumed_auth_sk);

    let (_, consumed_discovery_pk) = random_keypair();
    let (_, consumed_encryption_pk) = random_keypair();

    let consumed_nf = minted_resource.nullifier(&minted_resource_nf_key).unwrap();

    // Create the created resource data
    let created_auth_sk = AuthorizationSigningKey::new();
    let created_auth_pk = AuthorizationVerifyingKey::from_signing_key(&created_auth_sk);
    let created_nf_cm = minted_resource_nf_key.commit();

    let (_, created_discovery_pk) = random_keypair();
    let (_, created_encryption_pk) = random_keypair();

    let created_resource = construct_persistent_resource(
        &d.spender.to_vec(), // forwarder_addr
        &d.erc20.to_vec(),   // token_addr
        d.amount.try_into().unwrap(),
        consumed_nf.as_bytes().to_vec(), // nonce
        created_nf_cm,
        vec![7u8; 32], // rand_seed
        &created_auth_pk,
    );
    let created_cm = created_resource.commitment();

    // Get the authorization signature, it can be from external signing(e.g. wallet)
    let action_tree = MerkleTree::new(vec![consumed_nf, created_cm]);
    let auth_sig = authorize_the_action(&consumed_auth_sk, &action_tree);

    let empty_hash = B256::from(hex!(
        "cc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06"
    ));

    // Construct the transfer transaction
    let is_left = false;
    let path: &[(Vec<u32>, bool)] = &[(bytes_to_words(empty_hash.as_slice()), is_left)];
    let merkle_path = MerklePath::from_path(path);

    let tx = construct_transfer_tx(
        minted_resource.clone(),
        merkle_path.clone(),
        minted_resource_nf_key.clone(),
        consumed_auth_pk,
        auth_sig,
        consumed_discovery_pk,
        consumed_encryption_pk,
        created_resource.clone(),
        created_discovery_pk,
        created_encryption_pk,
    );

    // Verify the transaction
    assert!(tx.clone().verify(), "Transaction verification failed");

    ProtocolAdapter::Transaction::from(tx)
}
