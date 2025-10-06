use alloy::primitives::{Address, U256};
use alloy::providers::Network;
use alloy::providers::ProviderBuilder;
use alloy::providers::ProviderLayer;
use alloy::providers::RootProvider;
use alloy::providers::fillers::TxFiller;
use arm_risc0::transaction::Transaction;
use async_trait::async_trait;
use reqwest::Url;
use url::ParseError;

/// Identifies a protocol adapter version
pub const PA_V1_0_0_BETA: &str = "1.0.0-beta";

/// The interface exposed by compliant protocol adapters
#[async_trait]
pub trait Client {
    type Provider;
    /// Construct new protocol adapter client
    fn new(address: Address, provider: Self::Provider) -> Self;
    /// Get the verions of this protocol adapter client
    fn get_client_version() -> &'static str;
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

/// An Ethereum network and RPC endpoint to connect to it with
pub enum NetworkRpc {
    /// A Sepolia RPC endpoint
    Sepolia(Url),
}

impl NetworkRpc {
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
}

impl From<NetworkRpc> for Url {
    fn from(rpc: NetworkRpc) -> Self {
        match rpc {
            NetworkRpc::Sepolia(url) => url,
        }
    }
}

pub trait ProtocolAdapterBuilder<L, F, N> {
    /// Build a protocol adapter client that connects to the given protocol
    /// adapter contract address using the given RPC.
    fn connect_pa<C: Client<Provider = F::Provider>>(self, rpc: Url, contract: Address) -> C
    where
        L: ProviderLayer<RootProvider<N>, N>,
        F: TxFiller<N> + ProviderLayer<L::Provider, N>,
        N: Network;

    /// Build a protocol adapter client using the given RPC. The network of
    /// the RPC and the client version determine the protocol adapter contract
    /// address that is connect to.
    fn connect_default_pa<C: Client<Provider = F::Provider>>(self, rpc: NetworkRpc) -> C
    where
        L: ProviderLayer<RootProvider<N>, N>,
        F: TxFiller<N> + ProviderLayer<L::Provider, N>,
        N: Network;
}

impl<L, F, N> ProtocolAdapterBuilder<L, F, N> for ProviderBuilder<L, F, N> {
    fn connect_pa<C: Client<Provider = F::Provider>>(self, rpc: Url, contract: Address) -> C
    where
        L: ProviderLayer<RootProvider<N>, N>,
        F: TxFiller<N> + ProviderLayer<L::Provider, N>,
        N: Network,
    {
        C::new(contract, self.connect_http(rpc))
    }

    fn connect_default_pa<C: Client<Provider = F::Provider>>(self, rpc: NetworkRpc) -> C
    where
        L: ProviderLayer<RootProvider<N>, N>,
        F: TxFiller<N> + ProviderLayer<L::Provider, N>,
        N: Network,
    {
        let contract = match (&rpc, C::get_client_version()) {
            (NetworkRpc::Sepolia(_), PA_V1_0_0_BETA) => {
                "0xaf21c8a4d489610f42aabc883e66be3d651e5d52"
            }
            _ => unreachable!("No default protocol adapter for the given network-version pair"),
        };
        let contract = contract
            .parse::<Address>()
            .expect("Sepolia deployment address should be correct");
        C::new(contract, self.connect_http(rpc.into()))
    }
}

#[cfg(test)]
mod tests {
    use super::ProtocolAdapterBuilder;
    use crate::call::{Client, NetworkRpc};
    use crate::protocol_adapter_v1_0_0_beta;
    use alloy::hex;
    use alloy::network::EthereumWallet;
    use alloy::providers::ProviderBuilder;
    use alloy::signers::local::PrivateKeySigner;
    use arm_risc0::delta_proof::{DeltaProof, DeltaWitness};
    use arm_risc0::transaction::{Delta, Transaction};
    use std::env;
    use tokio;

    fn initial_root() -> [u8; 32] {
        hex!("7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3")
    }

    fn sepolia_protocol_adapter() -> impl Client {
        let signer = env::var("PRIVATE_KEY")
            .expect("Couldn't read PRIVATE_KEY")
            .parse::<PrivateKeySigner>()
            .expect("Wrong private key format");
        let api_key = env::var("API_KEY_ALCHEMY").expect("Couldn't read API_KEY_ALCHEMY");
        let network = NetworkRpc::alchemy_sepolia_rpc(api_key).expect("invalid API key");
        let provider = ProviderBuilder::new().wallet(EthereumWallet::from(signer));
        provider.connect_default_pa::<protocol_adapter_v1_0_0_beta::Client<_>>(network)
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
        let result = sepolia_protocol_adapter().execute(empty_tx).await;
        assert!(result.is_ok());
    }
}
