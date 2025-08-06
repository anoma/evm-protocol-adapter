use alloy::primitives::{B256, Bytes, U256};
use alloy::sol;

use arm_risc0::action::Action;
use arm_risc0::compliance::ComplianceInstance;
use arm_risc0::logic_instance::{ExpirableBlob, LogicInstance};
use arm_risc0::logic_proof::LogicProof;
use arm_risc0::resource::Resource as ArmResource;
use arm_risc0::transaction::{Delta, Transaction};

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
    #[sol(rpc)]
    ProtocolAdapter,
    "../contracts/out/ProtocolAdapter.sol/ProtocolAdapter.json"
);

fn insert_zeros(vec: Vec<u8>) -> Vec<u8> {
    vec.into_iter()
        .flat_map(|byte| {
            // Create an iterator that contains the original byte followed by three zero bytes
            std::iter::once(byte).chain(std::iter::repeat_n(0, 3))
        })
        .collect()
}

impl From<ArmResource> for ProtocolAdapter::Resource {
    fn from(r: ArmResource) -> Self {
        Self {
            logicRef: B256::from_slice(&r.logic_ref),
            labelRef: B256::from_slice(&r.label_ref),
            quantity: U256::from(r.quantity),
            valueRef: B256::from_slice(&r.value_ref),
            ephemeral: r.is_ephemeral,
            nonce: U256::from_le_slice(r.nonce.as_slice()),
            nullifierKeyCommitment: B256::from_slice(&r.nk_commitment.inner()),
            randSeed: U256::from_le_slice(r.rand_seed.as_slice()),
        }
    }
}

impl From<ExpirableBlob> for Logic::ExpirableBlob {
    fn from(expirable_blob: ExpirableBlob) -> Self {
        Self {
            blob: insert_zeros(expirable_blob.blob).into(),
            deletionCriterion: expirable_blob.deletion_criterion,
        }
    }
}

impl From<LogicInstance> for Logic::Instance {
    fn from(instance: LogicInstance) -> Self {
        Self {
            tag: B256::from_slice(&instance.tag),
            isConsumed: instance.is_consumed,
            actionTreeRoot: B256::from_slice(&instance.root),
            ciphertext: Bytes::from(insert_zeros(instance.cipher)),
            appData: instance
                .app_data
                .into_iter()
                .map(Logic::ExpirableBlob::from)
                .collect(),
        }
    }
}

impl From<LogicProof> for Logic::VerifierInput {
    fn from(logic_proof: LogicProof) -> Self {
        Self {
            proof: Bytes::from(logic_proof.proof.clone()),
            instance: logic_proof.get_instance().into(),
            verifyingKey: B256::from_slice(&logic_proof.verifying_key),
        }
    }
}

impl From<ComplianceInstance> for Compliance::Instance {
    fn from(instance: ComplianceInstance) -> Self {
        Self {
            consumed: Compliance::ConsumedRefs {
                nullifier: B256::from_slice(&instance.consumed_nullifier),
                logicRef: B256::from_slice(&instance.consumed_logic_ref),
                commitmentTreeRoot: B256::from_slice(&instance.consumed_commitment_tree_root),
            },
            created: Compliance::CreatedRefs {
                commitment: B256::from_slice(&instance.created_commitment),
                logicRef: B256::from_slice(&instance.created_logic_ref),
            },
            unitDeltaX: B256::from_slice(&instance.delta_x),
            unitDeltaY: B256::from_slice(&instance.delta_y),
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
                .map(|cu| Compliance::VerifierInput {
                    proof: Bytes::from(cu.proof.clone()),
                    instance: cu.get_instance().into(),
                })
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
        let nonce = U256::from(66);
        let rand_seed = U256::from(77);
        let ephemeral = true;

        assert_eq!(
            ProtocolAdapter::Resource::from(ArmResource {
                logic_ref: (*logic_ref).into(),
                label_ref: (*label_ref).into(),
                value_ref: (*value_ref).into(),
                nk_commitment: NullifierKeyCommitment::from_bytes(nkc),
                quantity,
                nonce: nonce.to_le_bytes_trimmed_vec(),
                rand_seed: rand_seed.to_le_bytes_trimmed_vec(),
                is_ephemeral: ephemeral,
            }),
            ProtocolAdapter::Resource {
                logicRef: B256::from_slice(logic_ref),
                labelRef: B256::from_slice(label_ref),
                valueRef: B256::from_slice(value_ref),
                nullifierKeyCommitment: B256::from_slice(nkc),
                quantity: U256::from(quantity),
                nonce,
                randSeed: rand_seed,
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

        let n_actions = 1;

        let raw_tx = arm_risc0::transaction::generate_test_transaction(n_actions);
        let evm_tx = ProtocolAdapter::Transaction::from(raw_tx);
        std::fs::write(
            format!("test_tx{:02}.json", n_actions),
            serde_json::to_string_pretty(&evm_tx).unwrap(),
        )
        .unwrap();
        println!("{:#?}", evm_tx);
    }
}
