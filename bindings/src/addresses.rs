use alloy::primitives::{Address, address};
use alloy_chains::NamedChain;
use std::collections::HashMap;

/// Returns a map of protocol adapter deployments for all supported chains.
pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address> {
    HashMap::from([
        (
            NamedChain::TempoModerato,
            address!("0x5573d493120736322794D870cCEDF74073588b24"), // 0xA951282CEd703DEd6E4327DEfFcA446246D3D6f8 // 0x15174BDBfEE53a845F1dB0bbB6cDC335C678C331
        ),
        (
            NamedChain::Tempo,
            address!("0x5573d493120736322794D870cCEDF74073588b24"), // 0xA951282CEd703DEd6E4327DEfFcA446246D3D6f8
        ),
    ])
}

/// Returns the address of the protocol adapter deployed on the provided chain, if any.
pub fn protocol_adapter_address(chain: &NamedChain) -> Option<Address> {
    protocol_adapter_deployments_map().get(chain).cloned()
}
