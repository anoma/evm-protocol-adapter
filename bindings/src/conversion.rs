use alloy::primitives::{B256, Bytes};
use alloy::sol;

use arm_risc0::action::Action;
use arm_risc0::compliance::ComplianceInstance;
use arm_risc0::compliance_unit::ComplianceUnit;
use arm_risc0::logic_instance::{AppData, ExpirableBlob};
use arm_risc0::logic_proof::LogicVerifierInputs;
use arm_risc0::proving_system::encode_seal;
use arm_risc0::resource::Resource as ArmResource;
use arm_risc0::transaction::{Delta, Transaction};
use arm_risc0::utils::words_to_bytes;

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
    #[sol(rpc)]
    ProtocolAdapter,
    "../contracts/out/ProtocolAdapter.sol/ProtocolAdapter.json"
);

impl From<ArmResource> for ProtocolAdapter::Resource {
    fn from(r: ArmResource) -> Self {
        Self {
            logicRef: B256::from_slice(&r.logic_ref),
            labelRef: B256::from_slice(&r.label_ref),
            quantity: r.quantity,
            valueRef: B256::from_slice(&r.value_ref),
            ephemeral: r.is_ephemeral,
            nonce: B256::from_slice(&r.nonce),
            nullifierKeyCommitment: B256::from_slice(r.nk_commitment.inner()),
            randSeed: B256::from_slice(&r.rand_seed),
        }
    }
}

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
    use arm_risc0::nullifier_key::NullifierKeyCommitment;
    use dotenv::dotenv;
    use std::env;

    #[test]
    fn convert_resource() {
        let logic_ref = &[0x11; 32];
        let label_ref = &[0x22; 32];
        let value_ref = &[0x33; 32];
        let nkc = &[0x44; 32];
        let quantity = 55;
        let nonce = &[0x66; 32];
        let rand_seed = &[0x77; 32];
        let ephemeral = true;

        assert_eq!(
            ProtocolAdapter::Resource::from(ArmResource {
                logic_ref: (*logic_ref).into(),
                label_ref: (*label_ref).into(),
                value_ref: (*value_ref).into(),
                nk_commitment: NullifierKeyCommitment::from_bytes(nkc),
                nonce: (*nonce).into(),
                rand_seed: (*rand_seed).into(),
                quantity,
                is_ephemeral: ephemeral,
            }),
            ProtocolAdapter::Resource {
                logicRef: B256::from_slice(logic_ref),
                labelRef: B256::from_slice(label_ref),
                valueRef: B256::from_slice(value_ref),
                nullifierKeyCommitment: B256::from_slice(nkc),
                nonce: B256::from_slice(nonce),
                randSeed: B256::from_slice(rand_seed),
                quantity: quantity,
                ephemeral,
            }
        );
    }

    #[test]
    #[ignore]
    fn print_tx() {
        dotenv().ok();
        env::var("BONSAI_API_KEY").expect("Couldn't read BONSAI_API_KEY");
        env::var("BONSAI_API_URL").expect("Couldn't read BONSAI_API_URL");

        println!(
            "{:?}",
            B256::from_slice(arm_risc0::constants::COMPLIANCE_VK.as_bytes())
        );

        let n_actions = 20;

        let raw_tx = arm_risc0::transaction::generate_test_transaction(n_actions);
        println!("{:?}", raw_tx);
        let evm_tx = ProtocolAdapter::Transaction::from(raw_tx);
        std::fs::write(
            format!("test_tx{n_actions:02}.json"),
            serde_json::to_string_pretty(&evm_tx).unwrap(),
        )
        .unwrap();
        println!("{evm_tx:#?}");

        use alloy_sol_types::SolValue; // Import the trait for abi_encode
        let encoded_tx = evm_tx.abi_encode();
        let decoded_tx: ProtocolAdapter::Transaction =
            ProtocolAdapter::Transaction::abi_decode(&encoded_tx).unwrap();
        assert_eq!(evm_tx, decoded_tx);
        println!("Encoded transaction: {:?}", encoded_tx);
        std::fs::write(format!("test_tx{n_actions:02}.bin"), &encoded_tx)
            .expect("Failed to write encoded transaction to file");
    }
}
