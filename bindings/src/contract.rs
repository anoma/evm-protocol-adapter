use alloy::primitives::address;
use alloy::sol;
use alloy_chains::NamedChain;

use crate::contract::ProtocolAdapter::ProtocolAdapterInstance;
use alloy::providers::{DynProvider, Provider};

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
    #[sol(rpc)]
    ProtocolAdapter,
    "../contracts/out/ProtocolAdapter.sol/ProtocolAdapter.json"
);

pub async fn protocol_adapter(
    provider: DynProvider,
) -> Result<ProtocolAdapterInstance<DynProvider>, &'static str> {
    match NamedChain::try_from(
        provider
            .get_chain_id()
            .await
            .expect("Couldn't get chain id"),
    ) {
        Ok(NamedChain::Sepolia) => Ok(ProtocolAdapterInstance::new(
            address!("0xfF91D5653b7121718DE6BE553ef7014EF131EF50"),
            provider,
        )),
        _ => Err("Unsupported chain"),
    }
}

#[cfg(test)]
mod tests {
    extern crate dotenv;

    use crate::contract::ProtocolAdapter::ProtocolAdapterInstance;
    use crate::contract::{protocol_adapter, ProtocolAdapter};
    use alloy::primitives::B256;
    use alloy::providers::{DynProvider, Provider, ProviderBuilder};
    use std::env;
    use tokio;

    #[tokio::test]
    async fn protocol_adapter_version_matches_the_cargo_pkg_version() {
        let pa_version = pa_instance()
            .await
            .getProtocolAdapterVersion()
            .call()
            .await
            .expect("Couldn't get protocol adapter version");

        assert_eq!(
            decode_bytes32_to_utf8(pa_version),
            env!("CARGO_PKG_VERSION").to_string()
        );
    }

    #[tokio::test]
    async fn call_executes_the_empty_tx() {
        let empty_tx = ProtocolAdapter::Transaction {
            actions: vec![],
            aggregationProof: vec![].into(),
            deltaProof: vec![].into(),
        };

        let receipt = pa_instance()
            .await
            .execute(empty_tx)
            .send()
            .await
            .expect("Couldn't send tx")
            .get_receipt()
            .await
            .expect("Couldn't get receipt");

        assert!(receipt.inner.is_success());
    }

    async fn pa_instance() -> ProtocolAdapterInstance<DynProvider> {
        dotenv::dotenv().ok();
        let url = format!(
            "https://eth-sepolia.g.alchemy.com/v2/{}",
            env::var("API_KEY_ALCHEMY").expect("Couldn't read API_KEY_ALCHEMY")
        );

        let provider = ProviderBuilder::new()
            .connect_anvil_with_wallet_and_config(|a| a.fork(url))
            .expect("Couldn't create anvil provider");
        protocol_adapter(provider.erased()).await.unwrap()
    }

    fn decode_bytes32_to_utf8(encoded_string: B256) -> String {
        let bytes = alloy::hex::decode(encoded_string.to_string()).unwrap();

        let trimmed = bytes.split(|b| *b == 0).next().unwrap();
        str::from_utf8(trimmed).unwrap().to_string()
    }
}
