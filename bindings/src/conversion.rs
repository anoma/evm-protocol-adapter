use alloy::primitives::{Bytes, B256};
use alloy::sol;
use arm_risc0::action::Action;
use arm_risc0::action_tree::MerkleTree;
use arm_risc0::authorization::{AuthorizationSigningKey, AuthorizationVerifyingKey};
use arm_risc0::compliance::ComplianceInstance;
use arm_risc0::compliance_unit::ComplianceUnit;
use arm_risc0::encryption::random_keypair;
use arm_risc0::evm::CallType;
use arm_risc0::logic_instance::{AppData, ExpirableBlob};
use arm_risc0::logic_proof::LogicVerifierInputs;
use arm_risc0::merkle_path::MerklePath;
use arm_risc0::nullifier_key::NullifierKey;
use arm_risc0::proving_system::encode_seal;

use arm_risc0::transaction::{Delta, Transaction};
use arm_risc0::utils::words_to_bytes;
use sha2::Digest;
use simple_transfer_app::resource::{construct_ephemeral_resource, construct_persistent_resource};
use simple_transfer_app::utils::authorize_the_action;

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

    #[test]
    #[ignore]
    fn print_tx() {
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

    use arm_risc0::{
        action_tree::MerkleTree,
        authorization::{AuthorizationSigningKey, AuthorizationVerifyingKey},
        encryption::{random_keypair, Ciphertext},
        evm::CallType,
        merkle_path::MerklePath,
        nullifier_key::NullifierKey,
    };
    use simple_transfer_app::{
        burn::construct_burn_tx,
        resource::{construct_ephemeral_resource, construct_persistent_resource},
        utils::authorize_the_action,
    };

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
}
