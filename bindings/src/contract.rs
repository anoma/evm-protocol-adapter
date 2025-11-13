use alloy::sol;
use alloy_chains::NamedChain;

use crate::addresses::protocol_adapter_address;
use crate::contract::ProtocolAdapter::ProtocolAdapterInstance;
use alloy::providers::{DynProvider, Provider};
use alloy::transports::{RpcError, TransportErrorKind};
use thiserror::Error;

pub type BindingsResult<T> = Result<T, BindingsError>;

#[derive(Error, Debug)]
pub enum BindingsError {
    #[error(
        "Thrown when the chain ID returned by the RPC transport is not in the list of named chains."
    )]
    ChainIdUnkown,
    #[error("Thrown when the RPC transport returns an error.")]
    RpcTransportError(RpcError<TransportErrorKind>),
    #[error(
        "Thrown when the current protocol adapter version has not been deployed on the provided chain."
    )]
    UnsupportedChain(NamedChain),
}

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
    #[sol(rpc)]
    ProtocolAdapter,
    "../contracts/out/ProtocolAdapter.sol/ProtocolAdapter.json"
);

pub async fn protocol_adapter(
    provider: DynProvider,
) -> BindingsResult<ProtocolAdapterInstance<DynProvider>> {
    let named_chain = NamedChain::try_from(
        provider
            .get_chain_id()
            .await
            .map_err(BindingsError::RpcTransportError)?,
    )
    .map_err(|_| BindingsError::ChainIdUnkown)?;

    match protocol_adapter_address(named_chain) {
        Some(address) => Ok(ProtocolAdapterInstance::new(address, provider)),
        None => Err(BindingsError::UnsupportedChain(named_chain)),
    }
}

#[cfg(test)]
mod tests {
    extern crate dotenv;

    use crate::addresses::chain_address_map;
    use crate::contract::ProtocolAdapter::ProtocolAdapterInstance;
    use crate::contract::{ProtocolAdapter, protocol_adapter};
    use crate::helpers::alchemy_url;
    use alloy::primitives::B256;
    use alloy::providers::{DynProvider, Provider, ProviderBuilder};
    use alloy::sol;
    use alloy_chains::NamedChain;
    use tokio;

    sol!(
        #[allow(missing_docs)]
        #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
        #[sol(rpc)]
        VersioningLibExternal,
        "../contracts/out/VersioningLibExternal.sol/VersioningLibExternal.json"
    );

    #[tokio::test]
    async fn versions_of_deployed_protocol_adapters_match_the_expected_version() {
        // Get the expected protocol adapter version.
        let expected_version = {
            let provider = ProviderBuilder::new().connect_anvil_with_wallet();
            let contract = VersioningLibExternal::deploy(&provider).await.unwrap();
            contract.version().call().await.unwrap()
        };

        // Iterate over all supported chains
        for chain in chain_address_map().keys() {
            let actual_version: alloy::primitives::FixedBytes<32> = pa_instance(chain)
                .await
                .getProtocolAdapterVersion()
                .call()
                .await
                .expect("Couldn't get protocol adapter version");

            //  Check that the deployed protocol adapter version matches the expected version.
            assert_eq!(
                decode_bytes32_to_utf8(actual_version),
                decode_bytes32_to_utf8(expected_version),
                "Protocol adapter version mismatch on network '{chain}'."
            );
        }
    }

    #[tokio::test]
    async fn call_executes_the_empty_tx_on_all_supported_chains() {
        for chain in chain_address_map().keys() {
            let empty_tx = ProtocolAdapter::Transaction {
                actions: vec![],
                aggregationProof: vec![].into(),
                deltaProof: vec![].into(),
            };

            let receipt = pa_instance(chain)
                .await
                .execute(empty_tx)
                .send()
                .await
                .expect("Couldn't send tx")
                .get_receipt()
                .await
                .expect("Couldn't get receipt");

            assert!(
                receipt.inner.is_success(),
                "Empty transaction failed on network '{chain}'."
            );
        }
    }

    async fn pa_instance(chain: &NamedChain) -> ProtocolAdapterInstance<DynProvider> {
        let rpc_url = alchemy_url(chain).unwrap();

        let provider = ProviderBuilder::new()
            .connect_anvil_with_wallet_and_config(|a| a.fork(rpc_url))
            .expect("Couldn't create anvil provider");
        protocol_adapter(provider.erased()).await.unwrap()
    }

    fn decode_bytes32_to_utf8(encoded_string: B256) -> String {
        let bytes = alloy::hex::decode(encoded_string.to_string()).unwrap();

        let trimmed = bytes.split(|b| *b == 0).next().unwrap();
        str::from_utf8(trimmed).unwrap().to_string()
    }
}
