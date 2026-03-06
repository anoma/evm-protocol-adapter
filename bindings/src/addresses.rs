use alloy::primitives::Address;
use alloy_chains::NamedChain;
use serde::Deserialize;
use std::collections::HashMap;
use std::sync::LazyLock;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct DeploymentEntry {
    chain_id: u64,
    contract_address: String,
}

static DEPLOYMENTS: LazyLock<HashMap<NamedChain, Address>> = LazyLock::new(|| {
    let entries: Vec<DeploymentEntry> =
        serde_json::from_str(include_str!("../../deployments.json"))
            .expect("deployments.json: invalid JSON");

    entries
        .into_iter()
        .filter_map(|e| {
            let chain = NamedChain::try_from(e.chain_id).ok()?;
            let addr: Address = e.contract_address.parse().ok()?;
            Some((chain, addr))
        })
        .collect()
});

/// Returns a map of protocol adapter deployments for all supported chains.
pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address> {
    DEPLOYMENTS.clone()
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: &NamedChain) -> Option<Address> {
    DEPLOYMENTS.get(chain).cloned()
}
