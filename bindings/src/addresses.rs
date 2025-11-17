use alloy::primitives::{Address, address};
use alloy_chains::NamedChain;
use std::collections::HashMap;

/// Returns a map of protocol adapter deployments for all supported chains.
pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address> {
    use NamedChain::*;
    HashMap::from([(
        Sepolia,
        address!("0x0b74B3f295344Ae4e79b94Fb02c7d640dFF6176E"),
    )])
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: NamedChain) -> Option<Address> {
    protocol_adapter_deployments_map().get(&chain).cloned()
}
