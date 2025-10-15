use alloy::primitives::{Address, U256, address};
use alloy::sol;
use arm_risc0::transaction::Transaction;
use async_trait::async_trait;

/// Protocol adapter deployment address on Sepolia
pub const SEPOLIA_DEPLOYMENT_ADDR: Address = address!("0xaf21c8a4d489610f42aabc883e66be3d651e5d52");

sol!(
    #[allow(missing_docs)]
    #[derive(Debug, PartialEq, serde::Serialize, serde::Deserialize)]
    #[sol(rpc)]
    ERC20Forwarder,
    "../contracts/out/ERC20Forwarder.sol/ERC20Forwarder.json"
);

/// The interface exposed by compliant protocol adapters
#[async_trait]
pub trait Client {
    type Provider;
    /// Construct new protocol adapter client
    fn new(address: Address, provider: Self::Provider) -> Self;
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
    /// Get the number of commitments in the tree
    async fn commitment_count(&self) -> Result<U256, alloy::contract::Error>;
    /// Get the commitment tree depth.
    async fn commitment_tree_depth(&self) -> Result<u8, alloy::contract::Error>;
    /// Get the capacity of the tree based on the current tree depth.
    async fn commitment_tree_capacity(&self) -> Result<U256, alloy::contract::Error>;
    /// Get the latest commitment tree state root
    async fn latest_commitment_tree_root(&self) -> Result<[u8; 32], alloy::contract::Error>;
    /// Check if the commitment tree state root exists
    async fn is_commitment_tree_root_contained(
        &self,
        root: &[u8; 32],
    ) -> Result<bool, alloy::contract::Error>;
    /// Get the length of the commitment tree root set
    async fn commitment_tree_root_count(&self) -> Result<U256, alloy::contract::Error>;
    /// Get the commitment tree root at the given index in the set
    async fn commitment_tree_root_at_index(
        &self,
        index: U256,
    ) -> Result<[u8; 32], alloy::contract::Error>;
    ///Verifies that a Merkle path and a commitment leaf reproduce a given root
    async fn verify_merkle_proof(
        &self,
        root: &[u8; 32],
        commitment: &[u8; 32],
        path: &[[u8; 32]],
        direction_bits: U256,
    ) -> Result<(), alloy::contract::Error>;
    /// Check if the nullifier set contains the given nullifier
    async fn is_nullifier_contained(
        &self,
        nullifier: &[u8; 32],
    ) -> Result<bool, alloy::contract::Error>;
    /// Get the length of the nullifier set
    async fn nullifier_count(&self) -> Result<U256, alloy::contract::Error>;
    /// Get the nullifier at the given index in the set
    async fn nullifier_at_index(&self, index: U256) -> Result<[u8; 32], alloy::contract::Error>;
}

#[cfg(test)]
mod tests {
    use crate::call::{Client, SEPOLIA_DEPLOYMENT_ADDR};
    use crate::conversion::ProtocolAdapter;
    use alloy::hex;
    use alloy::network::EthereumWallet;
    use alloy::primitives::B256;
    use alloy::providers::ProviderBuilder;
    use alloy::signers::local::PrivateKeySigner;
    use arm_risc0::delta_proof::{DeltaProof, DeltaWitness};
    use arm_risc0::transaction::{Delta, Transaction};
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

    pub fn sepolia_protocol_adapter() -> impl Client {
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
                .is_commitment_tree_root_contained(&initial_root())
                .await
                .unwrap()
        );
    }

    #[tokio::test]
    #[ignore = "This test requires updating the protocol adapter address in .env"]
    async fn call_latest_root() {
        let root = sepolia_protocol_adapter()
            .latest_commitment_tree_root()
            .await
            .unwrap();
        assert_ne!(root, initial_root());
    }

    #[tokio::test]
    #[ignore = "This test requires updating the protocol adapter address in .env"]
    async fn call_execute() {
        let empty_tx = Transaction {
            actions: vec![],
            delta_proof: Delta::Proof(
                DeltaProof::prove(&vec![], &DeltaWitness::from_scalars(&[])).unwrap(),
            ),
            expected_balance: None,
            aggregation_proof: None,
        };
        let result = Client::execute(&sepolia_protocol_adapter(), empty_tx).await;
        assert!(result.is_ok());
    }
}
