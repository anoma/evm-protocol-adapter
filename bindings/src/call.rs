use crate::conversion::ProtocolAdapter;

use alloy::network::EthereumWallet;
use alloy::primitives::Address;
use alloy::providers::fillers::{
    BlobGasFiller, ChainIdFiller, FillProvider, GasFiller, JoinFill, NonceFiller, WalletFiller,
};
use alloy::providers::{Identity, ProviderBuilder, RootProvider};
use alloy::signers::local::PrivateKeySigner;
use alloy::sol;
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

pub fn protocol_adapter() -> ProtocolAdapter::ProtocolAdapterInstance<DefaultProvider> {
    let protocol_adapter = env::var("PROTOCOL_ADAPTER_ADDRESS_SEPOLIA")
        .expect("Couldn't read PROTOCOL_ADAPTER_ADDRESS_SEPOLIA")
        .parse::<Address>()
        .expect("Wrong address format");

    ProtocolAdapter::new(protocol_adapter, provider())
}

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
    #[sol(rpc)]
    ERC20Forwarder,
    "../contracts/out/ERC20Forwarder.sol/ERC20Forwarder.json"
);

pub fn erc20_forwarder(
    forwarder: Address,
) -> ERC20Forwarder::ERC20ForwarderInstance<DefaultProvider> {
    ERC20Forwarder::new(forwarder, provider())
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
    use crate::call::protocol_adapter;
    use crate::conversion::ProtocolAdapter;
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
                .isCommitmentRootContained(initial_root())
                .call()
                .await
                .unwrap()
        );
    }

    #[tokio::test]
    #[ignore = "This test requires updatng the protocol adapter address in .env"]
    async fn call_latest_root() {
        let root = protocol_adapter()
            .latestCommitmentRoot()
            .call()
            .await
            .unwrap();
        assert_ne!(root, initial_root());
    }

    #[tokio::test]
    #[ignore = "This test requires updatng the protocol adapter address in .env"]
    async fn call_execute() {
        let empty_tx = ProtocolAdapter::Transaction {
            actions: vec![],
            deltaProof: vec![].into(),
        };
        let result = protocol_adapter().execute(empty_tx).call().await;
        assert!(result.is_ok());
    }
}
