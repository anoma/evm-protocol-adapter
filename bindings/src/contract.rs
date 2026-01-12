use crate::addresses::protocol_adapter_address;
use crate::error::{BindingsError, BindingsResult};
use crate::generated::protocol_adapter::ProtocolAdapter::ProtocolAdapterInstance;
use alloy::providers::{DynProvider, Provider};
use alloy_chains::NamedChain;

/// Returns a protocol adapter instance for the given provider.
pub async fn protocol_adapter(
    provider: &DynProvider,
) -> BindingsResult<ProtocolAdapterInstance<DynProvider>> {
    let named_chain = NamedChain::try_from(
        provider
            .get_chain_id()
            .await
            .map_err(BindingsError::RpcTransportError)?,
    )
    .map_err(|_| BindingsError::ChainIdUnkown)?;

    match protocol_adapter_address(&named_chain) {
        Some(address) => Ok(ProtocolAdapterInstance::new(address, provider.clone())),
        None => Err(BindingsError::UnsupportedChain(named_chain)),
    }
}
