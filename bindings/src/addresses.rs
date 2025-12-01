use alloy::primitives::{Address, address};
use alloy_chains::NamedChain;
use std::collections::HashMap;

/// Returns a map of protocol adapter deployments for all supported chains.
pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address> {
    use NamedChain::*;
    HashMap::from([
        (
            Sepolia,
            address!("0x71b36D618e8B086EBbE0896c5214C8464B1dFDD4"),
        ),
        (
            Mainnet,
            address!("0xf031F3c63400417ADA22B4D43b7bAa5E699548B1"),
        ),
        (
            ArbitrumSepolia,
            address!("0x6d0A05E3535bd4D2C32AaD37FFB28fd0E1e528c3"),
        ),
    ])
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: &NamedChain) -> Option<Address> {
    protocol_adapter_deployments_map().get(chain).cloned()
}
