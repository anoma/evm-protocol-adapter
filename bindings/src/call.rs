use alloy::primitives::{Address, address};
use alloy::sol;

/// Protocol adapter deployment address on Sepolia
pub const SEPOLIA_DEPLOYMENT_ADDR: Address = address!("0xaf21c8a4d489610f42aabc883e66be3d651e5d52");

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
    #[sol(rpc)]
    ERC20Forwarder,
    "../contracts/out/ERC20Forwarder.sol/ERC20Forwarder.json"
);

#[cfg(test)]
mod tests {
    use crate::call::SEPOLIA_DEPLOYMENT_ADDR;
    use crate::conversion::ProtocolAdapter;
    use alloy::hex;
    use alloy::network::EthereumWallet;
    use alloy::primitives::B256;
    use alloy::providers::{Provider, ProviderBuilder};
    use alloy::signers::local::PrivateKeySigner;
    use tokio;

    fn private_key_signer() -> PrivateKeySigner {
        std::env::var("PRIVATE_KEY")
            .expect("Couldn't read PRIVATE_KEY")
            .parse::<PrivateKeySigner>()
            .expect("Wrong private key format")
    }

    fn alchemy_sepolia_rpc() -> reqwest::Url {
        let rpc_url = format!(
            "https://eth-sepolia.g.alchemy.com/v2/{}",
            std::env::var("API_KEY_ALCHEMY").expect("Couldn't read API_KEY_ALCHEMY")
        );
        rpc_url.parse().expect("Failed to parse RPC URL")
    }

    pub fn sepolia_protocol_adapter() -> ProtocolAdapter::ProtocolAdapterInstance<impl Provider> {
        let provider = ProviderBuilder::new()
            .wallet(EthereumWallet::from(private_key_signer()))
            .connect_http(alchemy_sepolia_rpc());
        ProtocolAdapter::new(SEPOLIA_DEPLOYMENT_ADDR, provider)
    }

    fn initial_root() -> B256 {
        B256::from(hex!(
            "7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3"
        ))
    }

    #[tokio::test]
    #[ignore = "This test requires updatng the protocol adapter address in .env"]
    async fn contains_initial_root() {
        assert!(
            sepolia_protocol_adapter()
                .isCommitmentTreeRootContained(initial_root())
                .call()
                .await
                .unwrap()
        );
    }

    #[tokio::test]
    #[ignore = "This test requires updating the protocol adapter address in .env"]
    async fn call_latest_root() {
        let root = sepolia_protocol_adapter()
            .latestCommitmentTreeRoot()
            .call()
            .await
            .unwrap();
        assert_ne!(root, initial_root());
    }

    #[tokio::test]
    #[ignore = "This test requires updating the protocol adapter address in .env"]
    async fn call_execute() {
        let empty_tx = ProtocolAdapter::Transaction {
            actions: vec![],
            aggregationProof: vec![].into(),
            deltaProof: vec![].into(),
        };
        let result = sepolia_protocol_adapter().execute(empty_tx).call().await;
        assert!(result.is_ok());
    }
}
