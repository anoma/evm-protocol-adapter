use alloy::primitives::{Address, address};
use alloy_chains::NamedChain;
use std::collections::HashMap;
use std::sync::OnceLock;

static PROTOCOL_ADAPTER_DEPLOYMENTS: OnceLock<HashMap<NamedChain, Address>> = OnceLock::new();

fn init_protocol_adapter_deployments_map() -> HashMap<NamedChain, Address> {
    use NamedChain::*;
    let mut m = HashMap::new();

    m.insert(
        Sepolia,
        address!("0x6aCDEdB64eb38f6a2911b52E8633D418E28fa9aB"),
    );

    m
}

/// Returns a map of protocol adapter deployments for all supported chains.
pub fn protocol_adapter_deployments_map() -> &'static HashMap<NamedChain, Address> {
    PROTOCOL_ADAPTER_DEPLOYMENTS.get_or_init(init_protocol_adapter_deployments_map)
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: NamedChain) -> Option<Address> {
    protocol_adapter_deployments_map().get(&chain).cloned()
}
