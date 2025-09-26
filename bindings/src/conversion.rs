use alloy::primitives::{Bytes, B256, U256};
use alloy::providers::Provider;
use alloy::sol;
use arm_risc0::action::Action;
use arm_risc0::compliance::ComplianceInstance;
use arm_risc0::compliance_unit::ComplianceUnit;
use arm_risc0::logic_instance::{AppData, ExpirableBlob};
use arm_risc0::logic_proof::LogicVerifierInputs;
use arm_risc0::proving_system::encode_seal;

use arm_risc0::transaction::{Delta, Transaction};
use arm_risc0::utils::words_to_bytes;
use async_trait::async_trait;

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

#[async_trait]
impl<X: Provider> crate::call::ProtocolAdapter for ProtocolAdapter::ProtocolAdapterInstance<X> {
    async fn execute(&self, tx: Transaction) -> Result<(), alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::execute(self, tx.into()).call().await.map(|_| ())
    }

    async fn emergency_stop(&self) -> Result<(), alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::emergencyStop(self).call().await.map(|_| ())
    }

    async fn is_emergency_stopped(&self) -> Result<bool, alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::isEmergencyStopped(self).call().await
    }

    async fn get_risc_zero_verifier_selector(&self) -> Result<[u8; 4], alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::getRiscZeroVerifierSelector(self).call().await.map(|x| x.0)
    }

    async fn get_protocol_adapter_version(&self) -> Result<[u8; 32], alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::getProtocolAdapterVersion(self).call().await.map(|x| x.0)
    }

    async fn latest_root(&self) -> Result<[u8; 32], alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::latestRoot(self).call().await.map(|x| x.0)
    }

    async fn contains_root(&self, root: &[u8; 32]) -> Result<bool, alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::containsRoot(self, root.into()).call().await
    }

    async fn verify_merkle_proof(
        &self,
        root: &[u8; 32],
        commitment: &[u8; 32],
        path: &[[u8; 32]],
        direction_bits: U256,
    ) -> Result<(), alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::verifyMerkleProof(
            self,
            root.into(),
            commitment.into(),
            path.iter().map(Into::into).collect(),
            direction_bits,
        ).call().await.map(|_| ())
    }

    async fn contains(&self, nullifier: &[u8; 32]) -> Result<bool, alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::contains(self, nullifier.into()).call().await
    }

    async fn length(&self) -> Result<U256, alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::length(self).call().await
    }

    async fn at_index(&self, index: U256) -> Result<[u8; 32], alloy::contract::Error> {
        ProtocolAdapter::ProtocolAdapterInstance::<X>::atIndex(self, index).call().await.map(Into::into)
    }
}

#[cfg(test)]
mod tests {
    use crate::conversion::ProtocolAdapter;
    use alloy::primitives::B256;

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
}
