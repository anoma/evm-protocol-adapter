use alloy::primitives::Address;
use alloy_chains::NamedChain;
use anoma_pa_evm_bindings::addresses::{
    protocol_adapter_address, protocol_adapter_deployments_map,
};
use std::collections::HashSet;

#[derive(serde::Deserialize)]
#[serde(rename_all = "camelCase")]
struct RawEntry {
    chain_id: u64,
    contract_address: String,
    network: String,
}

fn raw_entries() -> Vec<RawEntry> {
    serde_json::from_str(include_str!("../../deployments.json"))
        .expect("deployments.json: invalid JSON")
}

#[test]
fn all_entries_have_valid_chain_ids() {
    for entry in raw_entries() {
        NamedChain::try_from(entry.chain_id).unwrap_or_else(|_| {
            panic!(
                "chain ID {} (network '{}') does not map to a known NamedChain variant",
                entry.chain_id, entry.network
            )
        });
    }
}

#[test]
fn all_entries_have_valid_addresses() {
    for entry in raw_entries() {
        entry
            .contract_address
            .parse::<Address>()
            .unwrap_or_else(|_| {
                panic!(
                    "invalid contract address '{}' for network '{}'",
                    entry.contract_address, entry.network
                )
            });
    }
}

#[test]
fn no_duplicate_chain_ids() {
    let entries = raw_entries();
    let mut seen = HashSet::new();
    for entry in &entries {
        assert!(
            seen.insert(entry.chain_id),
            "duplicate chain ID {} (network '{}')",
            entry.chain_id,
            entry.network
        );
    }
}

#[test]
fn deployments_map_has_expected_count() {
    let map = protocol_adapter_deployments_map();
    let entries = raw_entries();
    assert_eq!(
        map.len(),
        entries.len(),
        "deployments map size ({}) does not match JSON entries ({})",
        map.len(),
        entries.len()
    );
}

#[test]
fn each_chain_is_individually_addressable() {
    let map = protocol_adapter_deployments_map();
    for chain in map.keys() {
        assert!(
            protocol_adapter_address(chain).is_some(),
            "protocol_adapter_address returned None for chain '{chain}'"
        );
    }
}
