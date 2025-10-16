use crate::abi::ProtocolAdapter;

use alloy::network::EthereumWallet;
use alloy::primitives::{address, Address};
use alloy::providers::fillers::{
    BlobGasFiller, ChainIdFiller, FillProvider, GasFiller, JoinFill, NonceFiller, WalletFiller,
};
use alloy::providers::{Identity, ProviderBuilder, RootProvider};
use alloy::signers::local::PrivateKeySigner;
use std::env;

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

pub const PROTOCOL_ADAPTER_ADDRESS_SEPOLIA: Address =
    address!("0x375920798465eb6b845AC5BF8580d69ce0Bda34a");

pub fn protocol_adapter() -> ProtocolAdapter::ProtocolAdapterInstance<DefaultProvider> {
    ProtocolAdapter::new(PROTOCOL_ADAPTER_ADDRESS_SEPOLIA, provider())
}

pub fn provider() -> DefaultProvider {
    let signer = env::var("PRIVATE_KEY")
        .expect("Couldn't read PRIVATE_KEY")
        .parse::<PrivateKeySigner>()
        .expect("Wrong private key format");

    let rpc_url = format!(
        "https://eth-sepolia.g.alchemy.com/v2/{}",
        env::var("API_KEY_ALCHEMY").expect("Couldn't read API_KEY_ALCHEMY")
    );

    let wallet: EthereumWallet = signer.into();

    ProviderBuilder::new()
        .wallet(wallet)
        .connect_http(rpc_url.parse().expect("Failed to parse RPC URL"))
}

#[cfg(test)]
mod tests {
    use crate::abi::ProtocolAdapter;
    use crate::call::protocol_adapter;
    use alloy::hex;
    use alloy::primitives::B256;
    use tokio;

    fn initial_root() -> B256 {
        B256::from(hex!(
            "7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3"
        ))
    }

    #[tokio::test]
    #[ignore = "This test requires updatng the protocol adapter address in .env"]
    async fn contains_initial_root() {
        assert!(
            protocol_adapter()
                .isCommitmentTreeRootContained(initial_root())
                .call()
                .await
                .unwrap()
        );
    }

    #[tokio::test]
    #[ignore = "This test requires updating the protocol adapter address in .env"]
    async fn call_latest_root() {
        let root = protocol_adapter()
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
        let result = protocol_adapter().execute(empty_tx).call().await;
        assert!(result.is_ok());
    }
}
