use crate::conversion::ProtocolAdapter;

use alloy::network::EthereumWallet;
use alloy::primitives::Address;
use alloy::providers::fillers::{
    BlobGasFiller, ChainIdFiller, FillProvider, GasFiller, JoinFill, NonceFiller, WalletFiller,
};
use alloy::providers::{Identity, ProviderBuilder, RootProvider};
use alloy::sol;
use reqwest::Url;
use url::ParseError;

type DefaultProvider = FillProvider<
    JoinFill<
        JoinFill<
            Identity,
            JoinFill<GasFiller, JoinFill<BlobGasFiller, JoinFill<NonceFiller, ChainIdFiller>>>,
        >,
        WalletFiller<EthereumWallet>,
    >,
    RootProvider,
    >;

pub enum EthereumRpc {
    Sepolia(Url),
    Other(Url),
}

impl EthereumRpc {
    pub fn sepolia_rpc(rpc_url: String) -> Result<Self, ParseError> {
        Ok(Self::Sepolia(rpc_url.parse()?))
    }
    
    pub fn alchemy_sepolia_rpc(api_key: String) -> Result<Self, ParseError> {
        Ok(Self::Sepolia(format!(
            "https://eth-sepolia.g.alchemy.com/v2/{}",
            api_key
        ).parse()?))
    }
}

impl From<EthereumRpc> for Url {
    fn from(rpc: EthereumRpc) -> Self {
        match rpc {
            EthereumRpc::Sepolia(url) => url,
            EthereumRpc::Other(url) => url,
        }
    }
}

pub enum ProtocolAdapterId {
    SepoliaPa,
    Other { protocol_adapter: Address, erc20_forwarder: Address },
}

pub fn protocol_adapter(
    id: ProtocolAdapterId,
    rpc: EthereumRpc,
    wallet: EthereumWallet,
) -> ProtocolAdapter::ProtocolAdapterInstance<DefaultProvider> {
    let provider = ProviderBuilder::new().wallet(wallet);
    match (id, rpc) {
        (ProtocolAdapterId::SepoliaPa, EthereumRpc::Sepolia(rpc_url)) => {
            let protocol_adapter_address = "0xaf21c8a4d489610f42aabc883e66be3d651e5d52"
                .parse::<Address>()
                .expect("Sepolia deployment address should be correct");
            let provider = provider.connect_http(rpc_url);
            ProtocolAdapter::new(protocol_adapter_address, provider)
        },
        (ProtocolAdapterId::Other { protocol_adapter, .. }, rpc) => {
            let provider = provider.connect_http(rpc.into());
            ProtocolAdapter::new(protocol_adapter, provider)
        },
        _ => unreachable!("Incompatable RPC chosen for protocol adapter"),
    }
}

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
    #[sol(rpc)]
    ERC20Forwarder,
    "../contracts/out/ERC20Forwarder.sol/ERC20Forwarder.json"
);

pub fn erc20_forwarder(
    id: ProtocolAdapterId,
    rpc: EthereumRpc,
    wallet: EthereumWallet,
) -> ERC20Forwarder::ERC20ForwarderInstance<DefaultProvider> {
    let provider = ProviderBuilder::new().wallet(wallet);
    match (id, rpc) {
        (ProtocolAdapterId::SepoliaPa, EthereumRpc::Sepolia(rpc_url)) => {
            let erc20_forwarder_address = "0xaf21c8a4d489610f42aabc883e66be3d651e5d52"
                .parse::<Address>()
                .expect("Wrong address format");
            let provider = provider.connect_http(rpc_url);
            ERC20Forwarder::new(erc20_forwarder_address, provider)
        },
        (ProtocolAdapterId::Other { erc20_forwarder, .. }, rpc) => {
            let provider = provider.connect_http(rpc.into());
            ERC20Forwarder::new(erc20_forwarder, provider)
        },
        _ => unreachable!("Incompatable RPC chosen for ERC-20 forwarder"),
    }
}

#[cfg(test)]
mod tests {
    use crate::call::{protocol_adapter, DefaultProvider, EthereumRpc, ProtocolAdapterId};
    use crate::conversion::ProtocolAdapter;
    use alloy::hex;
    use alloy::primitives::B256;
    use tokio;
    use std::env;
    use alloy::signers::local::PrivateKeySigner;

    fn initial_root() -> B256 {
        B256::from(hex!(
            "7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3"
        ))
    }

    fn sepolia_protocol_adapter() -> ProtocolAdapter::ProtocolAdapterInstance<DefaultProvider> {
        let api_key = env::var("API_KEY_ALCHEMY").expect("Couldn't read API_KEY_ALCHEMY");
        let signer = env::var("PRIVATE_KEY")
            .expect("Couldn't read PRIVATE_KEY")
            .parse::<PrivateKeySigner>()
            .expect("Wrong private key format");
        let rpc = EthereumRpc::alchemy_sepolia_rpc(api_key).expect("invalid API key");
        protocol_adapter(ProtocolAdapterId::SepoliaPa, rpc, signer.into())
    }

    #[tokio::test]
    #[ignore = "This test requires updatng the protocol adapter address in .env"]
    async fn contains_initial_root() {
        assert!(
            sepolia_protocol_adapter()
                .containsRoot(initial_root())
                .call()
                .await
                .unwrap()
        );
    }

    #[tokio::test]
    #[ignore = "This test requires updatng the protocol adapter address in .env"]
    async fn call_latest_root() {
        let root = sepolia_protocol_adapter().latestRoot().call().await.unwrap();
        assert_ne!(root, initial_root());
    }

    #[tokio::test]
    #[ignore = "This test requires updatng the protocol adapter address in .env"]
    async fn call_execute() {
        let empty_tx = ProtocolAdapter::Transaction {
            actions: vec![],
            deltaProof: vec![].into(),
        };
        let result = sepolia_protocol_adapter().execute(empty_tx).call().await;
        assert!(result.is_ok());
    }
}
