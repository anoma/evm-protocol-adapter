use tokio;

use crate::conversion::ProtocolAdapter;

use alloy::network::EthereumWallet;
use alloy::primitives::{Address, B256, U256};
use alloy::providers::fillers::{
    BlobGasFiller, ChainIdFiller, FillProvider, GasFiller, JoinFill, NonceFiller, WalletFiller,
};
use alloy::providers::{Identity, ProviderBuilder, RootProvider};
use alloy::signers::local::PrivateKeySigner;
use dotenv::dotenv;
use std::env;
pub fn get_pa() -> ProtocolAdapter::ProtocolAdapterInstance<
    (),
    FillProvider<
        JoinFill<
            JoinFill<
                Identity,
                JoinFill<GasFiller, JoinFill<BlobGasFiller, JoinFill<NonceFiller, ChainIdFiller>>>,
            >,
            WalletFiller<EthereumWallet>,
        >,
        RootProvider,
    >,
> {
    dotenv().ok();

    let signer = env::var("PRIVATE_KEY")
        .expect("Couldn't read PRIVATE_KEY")
        .parse::<PrivateKeySigner>()
        .expect("Wrong private key format");

    let rpc_url = format!(
        "https://sepolia.infura.io/v3/{}",
        env::var("API_KEY_INFURA").expect("Couldn't read API_KEY_INFURA")
    );

    let provider = ProviderBuilder::new()
        .wallet(signer)
        .on_http(rpc_url.parse().expect("Failed to parse RPC URL"));

    let protocol_adapter = env::var("PROTOCOL_ADAPTER_ADDRESS_SEPOLIA")
        .expect("Couldn't read PROTOCOL_ADAPTER_ADDRESS_SEPOLIA")
        .parse::<Address>()
        .expect("Wrong address format");

    ProtocolAdapter::new(protocol_adapter, provider)
}

pub async fn get_latest_root() -> B256 {
    get_pa().latestRoot().call().await.unwrap().root
}

pub async fn get_merkle_proof(commitment: B256) -> (Vec<B256>, U256) {
    let res = get_pa().merkleProof(commitment).call().await.unwrap();
    (res.siblings, res.directionBits)
}

pub async fn verify(tx: ProtocolAdapter::Transaction) {
    let res = get_pa().verify(tx).call().await.unwrap();
    println!("{:?}", res);
}

pub fn example_tx() -> ProtocolAdapter::Transaction {
    ProtocolAdapter::Transaction {
        actions: vec![],
        deltaProof: vec![].into(),
    }
}

#[tokio::test]
async fn rpc_call() {
    let latest_root = get_latest_root().await;

    println!("latest root: {:?}", latest_root);
}
