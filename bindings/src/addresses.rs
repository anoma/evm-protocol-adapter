use alloy::primitives::{Address, address};
use alloy_chains::NamedChain;
use std::collections::HashMap;

/// Returns a map of protocol adapter deployments for all supported chains.
pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address> {
    HashMap::from([
        (
            NamedChain::Sepolia,
            address!("0xc63336a48D0f60faD70ed027dFB256908bBD5e37"),
        ),
        (
            NamedChain::Mainnet,
            address!("0xdd4f4F0875Da48EF6d8F32ACB890EC81F435Ff3a"),
        ),
        (
            NamedChain::BaseSepolia,
            address!("0x212f275c6dD4829cd84ABDF767b0Df4A9CB9ef60"),
        ),
        (
            NamedChain::Base,
            address!("0x212f275c6dD4829cd84ABDF767b0Df4A9CB9ef60"),
        ),
        (
            NamedChain::Optimism,
            address!("0x212f275c6dD4829cd84ABDF767b0Df4A9CB9ef60"),
        ),
        (
            NamedChain::Arbitrum,
            address!("0x212f275c6dD4829cd84ABDF767b0Df4A9CB9ef60"),
        ),
    ])
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: &NamedChain) -> Option<Address> {
    protocol_adapter_deployments_map().get(chain).cloned()
}
