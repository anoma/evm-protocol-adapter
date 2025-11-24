use crate::addresses::protocol_adapter_address;
use crate::contract::ProtocolAdapter::ProtocolAdapterInstance;
use crate::error::{BindingsError, BindingsResult};
use alloy::providers::{DynProvider, Provider};
use alloy::sol;
use alloy_chains::NamedChain;

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize, Default)]
    #[sol(rpc)]
    ProtocolAdapter,
    "../contracts/out/ProtocolAdapter.sol/ProtocolAdapter.json"
);

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
