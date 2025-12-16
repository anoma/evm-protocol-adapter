use alloy::primitives::{Address, address};
use alloy_chains::NamedChain;
use std::collections::HashMap;

/// Returns a map of protocol adapter deployments for all supported chains.
pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address> {
    use NamedChain::*;
    HashMap::from([
        (
            Sepolia,
            address!("0x2E539c08414DCaBF06305d4095e11096F3d7e612"),
        ),
        (
            BaseSepolia,
            address!("0x9ED43C229480659bF6B6607C46d7B96c6D760cBB"),
        ),
    ])
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: &NamedChain) -> Option<Address> {
    protocol_adapter_deployments_map().get(chain).cloned()
}
