use crate::conversion;

use alloy::network::EthereumWallet;
use alloy::primitives::{Address, U256};
use alloy::providers::fillers::{
    BlobGasFiller, ChainIdFiller, FillProvider, GasFiller, JoinFill, NonceFiller, WalletFiller,
};
use alloy::providers::{Identity, ProviderBuilder, RootProvider};
use alloy::sol;
use reqwest::Url;
use url::ParseError;
use arm_risc0::transaction::Transaction;
use async_trait::async_trait;

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

#[async_trait]
pub trait ProtocolAdapter {
    async fn execute(&self, tx: Transaction) -> Result<(), alloy::contract::Error>;
    async fn emergency_stop(&self) -> Result<(), alloy::contract::Error>;
    async fn is_emergency_stopped(&self) -> Result<bool, alloy::contract::Error>;
    async fn get_risc_zero_verifier_selector(&self) -> Result<[u8; 4], alloy::contract::Error>;
    async fn get_protocol_adapter_version(&self) -> Result<[u8; 32], alloy::contract::Error>;
    async fn latest_root(&self) -> Result<[u8; 32], alloy::contract::Error>;
    async fn contains_root(&self, root: &[u8; 32]) -> Result<bool, alloy::contract::Error>;
    async fn verify_merkle_proof(
        &self,
        root: &[u8; 32],
        commitment: &[u8; 32],
        path: &[[u8; 32]],
        direction_bits: U256,
    ) -> Result<(), alloy::contract::Error>;
    async fn contains(&self, nullifier: &[u8; 32]) -> Result<bool, alloy::contract::Error>;
    async fn length(&self) -> Result<U256, alloy::contract::Error>;
    async fn at_index(&self, index: U256) -> Result<[u8; 32], alloy::contract::Error>;
}


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
) -> Box<dyn ProtocolAdapter> {
    let provider = ProviderBuilder::new().wallet(wallet);
    match (id, rpc) {
        (ProtocolAdapterId::SepoliaPa, EthereumRpc::Sepolia(rpc_url)) => {
            let protocol_adapter_address = "0xaf21c8a4d489610f42aabc883e66be3d651e5d52"
                .parse::<Address>()
                .expect("Sepolia deployment address should be correct");
            let provider = provider.connect_http(rpc_url);
            Box::new(conversion::ProtocolAdapter::new(protocol_adapter_address, provider))
        },
        (ProtocolAdapterId::Other { protocol_adapter, .. }, rpc) => {
            let provider = provider.connect_http(rpc.into());
            Box::new(conversion::ProtocolAdapter::new(protocol_adapter, provider))
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
    use crate::call::{protocol_adapter, ProtocolAdapter, EthereumRpc, ProtocolAdapterId};
    use alloy::hex;
    use tokio;
    use std::env;
    use alloy::signers::local::PrivateKeySigner;
    use arm_risc0::transaction::{Delta, Transaction};
    use arm_risc0::delta_proof::{DeltaProof, DeltaWitness};

    fn initial_root() -> [u8; 32] {
        hex!(
            "7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3"
        )
    }

    fn sepolia_protocol_adapter() -> Box<dyn ProtocolAdapter> {
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
                .contains_root(&initial_root())
                .await
                .unwrap()
        );
    }

    #[tokio::test]
    #[ignore = "This test requires updatng the protocol adapter address in .env"]
    async fn call_latest_root() {
        let root = sepolia_protocol_adapter().latest_root().await.unwrap();
        assert_ne!(root, initial_root());
    }

    #[tokio::test]
    #[ignore = "This test requires updatng the protocol adapter address in .env"]
    async fn call_execute() {
        let empty_tx = Transaction {
            actions: vec![],
            delta_proof: Delta::Proof(DeltaProof::prove(&vec![], &DeltaWitness::from_scalars(&[]))),
            expected_balance: None,
        };
        let result = sepolia_protocol_adapter().execute(empty_tx).await;
        assert!(result.is_ok());
    }
}
