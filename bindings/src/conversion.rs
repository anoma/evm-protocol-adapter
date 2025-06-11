use alloy::primitives::{Address, B256, Bytes, U256};
use alloy::sol;

use risc0_ethereum_contracts::encode_seal;

use aarm::action::{Action, ForwarderCalldata};
use aarm::logic_proof::LogicProof;
use aarm::transaction::{Delta, Transaction};
use aarm_core::compliance::ComplianceInstance;
use aarm_core::logic_instance::{ExpirableBlob, LogicInstance};
use aarm_core::resource::Resource;

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

impl From<Resource> for ProtocolAdapter::Resource {
    fn from(r: Resource) -> Self {
        Self {
            logicRef: B256::from_slice(r.logic_ref.as_bytes()),
            labelRef: B256::from_slice(r.label_ref.as_bytes()),
            quantity: U256::from(r.quantity),
            valueRef: B256::from_slice(r.value_ref.as_bytes()),
            ephemeral: r.is_ephemeral,
            nonce: U256::from_le_slice(r.nonce.as_slice()),
            nullifierKeyCommitment: B256::from_slice(r.nk_commitment.inner().as_bytes()),
            randSeed: U256::from_le_slice(r.rand_seed.as_slice()),
        }
    }
}

impl From<ExpirableBlob> for BlobStorage::ExpirableBlob {
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
            tag: B256::from_slice(instance.tag.as_bytes()),
            isConsumed: instance.is_consumed,
            actionTreeRoot: B256::from_slice(instance.root.as_bytes()),
            ciphertext: Bytes::from(insert_zeros(instance.cipher)),
            appData: instance
                .app_data
                .into_iter()
                .map(BlobStorage::ExpirableBlob::from)
                .collect(),
        }
    }
}

impl From<LogicProof> for Logic::VerifierInput {
    fn from(logic_proof: LogicProof) -> Self {
        Self {
            proof: Bytes::from(encode_seal(&logic_proof.receipt).unwrap()),
            instance: logic_proof
                .receipt
                .journal
                .decode::<LogicInstance>()
                .unwrap()
                .into(),
            verifyingKey: B256::from_slice(logic_proof.verifying_key.as_bytes()),
        }
    }
}

impl From<ComplianceInstance> for Compliance::Instance {
    fn from(instance: ComplianceInstance) -> Self {
        Self {
            consumed: Compliance::ConsumedRefs {
                nullifier: B256::from_slice(instance.consumed_nullifier.as_bytes()),
                logicRef: B256::from_slice(instance.consumed_logic_ref.as_bytes()),
                commitmentTreeRoot: B256::from_slice(
                    instance.consumed_commitment_tree_root.as_bytes(),
                ),
            },
            created: Compliance::CreatedRefs {
                commitment: B256::from_slice(instance.created_commitment.as_bytes()),
                logicRef: B256::from_slice(instance.created_logic_ref.as_bytes()),
            },
            unitDeltaX: B256::from_slice(instance.delta_x.as_bytes()),
            unitDeltaY: B256::from_slice(instance.delta_y.as_bytes()),
        }
    }
}

impl From<ForwarderCalldata> for ProtocolAdapter::ForwarderCalldata {
    fn from(calldata: ForwarderCalldata) -> Self {
        Self {
            untrustedForwarder: Address::from(calldata.untrusted_forwarder),
            input: Bytes::from(calldata.input),
            output: Bytes::from(calldata.output),
        }
    }
}

impl From<(Resource, ForwarderCalldata)> for ProtocolAdapter::ResourceForwarderCalldataPair {
    fn from(pair: (Resource, ForwarderCalldata)) -> Self {
        Self {
            carrier: pair.0.into(),
            call: pair.1.into(),
        }
    }
}

impl From<Action> for ProtocolAdapter::Action {
    fn from(action: Action) -> Self {
        Self {
            logicVerifierInputs: action
                .logic_proofs
                .into_iter()
                .map(|lp| lp.into())
                .collect(),
            complianceVerifierInputs: action
                .compliance_units
                .into_iter()
                .map(|receipt| Compliance::VerifierInput {
                    proof: Bytes::from(encode_seal(&receipt).unwrap()),
                    instance: receipt
                        .journal
                        .decode::<ComplianceInstance>()
                        .unwrap()
                        .into(),
                })
                .collect(),
            resourceCalldataPairs: action
                .resource_forwarder_calldata_pairs
                .into_iter()
                .map(|p| p.into())
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
    use aarm_core::nullifier_key::NullifierKeyCommitment;
    use aarm_core::resource::Resource;
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
            ProtocolAdapter::Resource::from(Resource {
                logic_ref: (*logic_ref).into(),
                label_ref: (*label_ref).into(),
                value_ref: (*value_ref).into(),
                nk_commitment: NullifierKeyCommitment::from_bytes(*nkc),
                quantity,
                nonce: nonce.to_le_bytes(),
                rand_seed: rand_seed.to_le_bytes(),
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

        println!("{:?}", aarm::constants::get_compliance_id());

        let n_actions = 1;

        let raw_tx = aarm::transaction::generate_test_transaction(n_actions);
        let evm_tx = ProtocolAdapter::Transaction::from(raw_tx);
        std::fs::write(
            format!("test_tx{:02}.json", n_actions),
            serde_json::to_string_pretty(&evm_tx).unwrap(),
        )
        .unwrap();
        println!("{:#?}", evm_tx);
    }
}
