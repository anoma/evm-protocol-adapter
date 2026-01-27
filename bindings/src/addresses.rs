use alloy::primitives::{Address, address};
use alloy_chains::NamedChain;
use std::collections::HashMap;

/// Returns a map of protocol adapter deployments for all supported chains.
pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address> {
    HashMap::from([
        (
            NamedChain::Sepolia,
            address!("0x0000000000000000000000000000000000000000"),
        ),
        (
            NamedChain::Mainnet,
            address!("0x0000000000000000000000000000000000000000"),
        ),
        (
            NamedChain::BaseSepolia,
            address!("0x0000000000000000000000000000000000000000"),
        ),
        (
            NamedChain::Base,
            address!("0x0000000000000000000000000000000000000000"),
        ),
        (
            NamedChain::Optimism,
            address!("0x0000000000000000000000000000000000000000"),
        ),
        (
            NamedChain::Arbitrum,
            address!("0x0000000000000000000000000000000000000000"),
        ),
    ])
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: &NamedChain) -> Option<Address> {
    protocol_adapter_deployments_map().get(chain).cloned()
}
