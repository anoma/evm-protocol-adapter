use alloy::primitives::{Address, address};
use alloy_chains::NamedChain;
use std::collections::HashMap;

/// Returns a map of protocol adapter deployments for all supported chains.
pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address> {
    HashMap::from([
        (
            NamedChain::Sepolia,
            address!("0xf152BBA809d6cba122579cee997A54B8F3FBa417"),
        ),
        (
            NamedChain::Mainnet,
            address!("0x0eA3B55b68A3f307c8FE3fe66E443247c95F0CfF"),
        ),
        (
            NamedChain::BaseSepolia,
            address!("0x094FCC095323080e71a037b2B1e3519c07dd84F8"),
        ),
        (
            NamedChain::Base,
            address!("0x094FCC095323080e71a037b2B1e3519c07dd84F8"),
        ),
        (
            NamedChain::Optimism,
            address!("0x094FCC095323080e71a037b2B1e3519c07dd84F8"),
        ),
        (
            NamedChain::Arbitrum,
            address!("0x094FCC095323080e71a037b2B1e3519c07dd84F8"),
        ),
        (
            NamedChain::AuroraTestnet,
            address!("0x24CEc6A74A0E39eE33C8356DB8655308112f587F"),
        ),
    ])
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: &NamedChain) -> Option<Address> {
    protocol_adapter_deployments_map().get(chain).cloned()
}
