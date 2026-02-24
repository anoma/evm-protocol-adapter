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
            NamedChain::BinanceSmartChainTestnet,
            address!("0x33d4F0c88ef555E105Ba5e5F1aFbF34d6f650964"),
        ),
    ])
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: &NamedChain) -> Option<Address> {
    protocol_adapter_deployments_map().get(chain).cloned()
}
