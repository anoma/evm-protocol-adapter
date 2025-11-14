use alloy::primitives::{B256, Bytes};

use arm_risc0::action::Action;
use arm_risc0::compliance::ComplianceInstance;
use arm_risc0::compliance_unit::ComplianceUnit;
use arm_risc0::logic_instance::{AppData, ExpirableBlob};
use arm_risc0::logic_proof::LogicVerifierInputs;
use arm_risc0::proving_system::encode_seal;
use arm_risc0::transaction::{Delta as ArmDelta, Transaction};
use arm_risc0::utils::words_to_bytes;

pub use crate::contract::{Compliance, Logic, ProtocolAdapter};

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
            tag: B256::from_slice(logic_verifier_inputs.tag.as_bytes()),
            verifyingKey: B256::from_slice(logic_verifier_inputs.verifying_key.as_bytes()),
            appData: logic_verifier_inputs.app_data.into(),
            proof: match &logic_verifier_inputs.proof {
                Some(proof) => Bytes::from(encode_seal(proof).unwrap()),
                None => Bytes::from(""),
            },
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
            unitDeltaX: B256::from_slice(words_to_bytes(&instance.delta_x)),
            unitDeltaY: B256::from_slice(words_to_bytes(&instance.delta_y)),
        }
    }
}

impl From<ComplianceUnit> for Compliance::VerifierInput {
    fn from(compliance_unit: ComplianceUnit) -> Self {
        Self {
            proof: match &compliance_unit.clone().proof {
                Some(proof) => Bytes::from(encode_seal(proof).unwrap()),
                None => Bytes::from(""),
            },
            instance: compliance_unit.get_instance().unwrap().into(),
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
            ArmDelta::Witness(_) => panic!("Unbalanced Transactions cannot be converted"),
            ArmDelta::Proof(proof) => proof.to_bytes().to_vec(),
        };

        Self {
            actions: tx
                .clone()
                .actions
                .into_iter()
                .map(ProtocolAdapter::Action::from)
                .collect(),
            deltaProof: Bytes::from(delta_proof),
            aggregationProof: match tx.get_raw_aggregation_proof() {
                Some(proof) => Bytes::from(encode_seal(&proof).unwrap()),
                None => Bytes::from(""),
            },
        }
    }
}
