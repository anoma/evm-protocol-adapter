use alloy::primitives::{Address, address};
use alloy_chains::NamedChain;
use std::collections::HashMap;
use std::sync::OnceLock;

static CHAIN_ADDRESS_MAP: OnceLock<HashMap<NamedChain, Address>> = OnceLock::new();
fn init_chain_address_map() -> HashMap<NamedChain, Address> {
    use NamedChain::*;
    let mut m = HashMap::new();

    m.insert(
        Sepolia,
        address!("0x6aCDEdB64eb38f6a2911b52E8633D418E28fa9aB"),
    );

    m
}

pub fn chain_address_map() -> &'static HashMap<NamedChain, Address> {
    CHAIN_ADDRESS_MAP.get_or_init(init_chain_address_map)
}

pub fn protocol_adapter_address(chain: NamedChain) -> Option<Address> {
    chain_address_map().get(&chain).cloned()
}
