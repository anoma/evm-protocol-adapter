use crate::protocol_adapter_v1_0_0_beta;

use alloy::network::EthereumWallet;
use alloy::primitives::{Address, U256};
use alloy::providers::ProviderBuilder;
use arm_risc0::transaction::Transaction;
use async_trait::async_trait;
use reqwest::Url;
use url::ParseError;

/// The interface exposed by compliant protocol adapters
#[async_trait]
pub trait ProtocolAdapterEndpoint {
    /// Execute the given transaction
    async fn execute(&self, tx: Transaction) -> Result<(), alloy::contract::Error>;
    /// Stop the protocol adapter permanently
    async fn emergency_stop(&self) -> Result<(), alloy::contract::Error>;
    /// Check if the protocol adapter has been stopped or not
    async fn is_emergency_stopped(&self) -> Result<bool, alloy::contract::Error>;
    /// Get the RISC Zero verifier selector
    async fn get_risc_zero_verifier_selector(&self) -> Result<[u8; 4], alloy::contract::Error>;
    /// Get the protocol adapter version
    async fn get_protocol_adapter_version(&self) -> Result<[u8; 32], alloy::contract::Error>;
    /// Get the latest commitment tree state root
    async fn latest_root(&self) -> Result<[u8; 32], alloy::contract::Error>;
    /// Check if the commitment tree state root exists
    async fn contains_root(&self, root: &[u8; 32]) -> Result<bool, alloy::contract::Error>;
    ///Verifies that a Merkle path and a commitment leaf reproduce a given root
    async fn verify_merkle_proof(
        &self,
        root: &[u8; 32],
        commitment: &[u8; 32],
        path: &[[u8; 32]],
        direction_bits: U256,
    ) -> Result<(), alloy::contract::Error>;
    /// Check if the nullifier set contains the given nullifier
    async fn contains(&self, nullifier: &[u8; 32]) -> Result<bool, alloy::contract::Error>;
    /// Get the length of the nullifier set
    async fn length(&self) -> Result<U256, alloy::contract::Error>;
    /// Get the nullifier at the given index in the set
    async fn at_index(&self, index: U256) -> Result<[u8; 32], alloy::contract::Error>;
}

/// An Ethereum RPC endpoint
pub enum EthereumRpc {
    /// A Sepolia RPC endpoint
    Sepolia(Url),
    /// A custom Ethereum RPC endpoint
    Custom(Url),
}

impl EthereumRpc {
    /// A general Sepolia RPC endpoint
    pub fn sepolia_rpc(rpc_url: String) -> Result<Self, ParseError> {
        Ok(Self::Sepolia(rpc_url.parse()?))
    }

    /// An Alchemy Sepolia RPC endpoint with the given API key
    pub fn alchemy_sepolia_rpc(api_key: String) -> Result<Self, ParseError> {
        Ok(Self::Sepolia(
            format!("https://eth-sepolia.g.alchemy.com/v2/{api_key}").parse()?,
        ))
    }

    /// A custom RPC endpoint
    pub fn custom_rpc(rpc_url: String) -> Result<Self, ParseError> {
        Ok(Self::Custom(rpc_url.parse()?))
    }
}

impl From<EthereumRpc> for Url {
    fn from(rpc: EthereumRpc) -> Self {
        match rpc {
            EthereumRpc::Sepolia(url) => url,
            EthereumRpc::Custom(url) => url,
        }
    }
}

/// Uniquely identifies a protocol adapter
pub enum ProtocolAdapterId {
    /// The adapter deployed on Sepolia
    SepoliaPa,
    /// Some other instance deployed at the given address
    Custom { protocol_adapter: Address },
}

/// Construct an endpoint for the identified protocol adapter over the given RPC
/// and wallet
pub fn protocol_adapter(
    id: ProtocolAdapterId,
    rpc: EthereumRpc,
    wallet: EthereumWallet,
) -> Box<dyn ProtocolAdapterEndpoint> {
    let provider = ProviderBuilder::new().wallet(wallet);
    match (id, rpc) {
        // Sepolia RPC must be used with the Sepolia protocol adapter instance
        (ProtocolAdapterId::SepoliaPa, EthereumRpc::Sepolia(rpc_url)) => {
            // The address of the Sepolia Protocol Adapter instance
            let protocol_adapter_address = "0xaf21c8a4d489610f42aabc883e66be3d651e5d52"
                .parse::<Address>()
                .expect("Sepolia deployment address should be correct");
            let provider = provider.connect_http(rpc_url);
            Box::new(protocol_adapter_v1_0_0_beta::ProtocolAdapter::new(
                protocol_adapter_address,
                provider,
            ))
        }
        // Custom protocol adapter instances can be used with any RPC
        (
            ProtocolAdapterId::Custom {
                protocol_adapter, ..
            },
            rpc,
        ) => {
            let provider = provider.connect_http(rpc.into());
            Box::new(protocol_adapter_v1_0_0_beta::ProtocolAdapter::new(
                protocol_adapter,
                provider,
            ))
        }
        _ => unreachable!("Incompatable RPC chosen for protocol adapter"),
    }
}

#[cfg(test)]
mod tests {
    use crate::call::{EthereumRpc, ProtocolAdapterEndpoint, ProtocolAdapterId, protocol_adapter};
    use alloy::hex;
    use alloy::signers::local::PrivateKeySigner;
    use arm_risc0::delta_proof::{DeltaProof, DeltaWitness};
    use arm_risc0::transaction::{Delta, Transaction};
    use std::env;
    use tokio;

    fn initial_root() -> [u8; 32] {
        hex!("7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3")
    }

    fn sepolia_protocol_adapter() -> Box<dyn ProtocolAdapterEndpoint> {
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
