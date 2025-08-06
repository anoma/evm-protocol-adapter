/*
use crate::conversion::ProtocolAdapter;

use alloy::network::EthereumWallet;
use alloy::primitives::Address;
use alloy::providers::fillers::{
    BlobGasFiller, ChainIdFiller, FillProvider, GasFiller, JoinFill, NonceFiller, WalletFiller,
};
use alloy::providers::{Identity, ProviderBuilder, RootProvider};
use alloy::signers::local::PrivateKeySigner;
use dotenv::dotenv;
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

pub fn protocol_adapter() -> ProtocolAdapter::ProtocolAdapterInstance<(), DefaultProvider> {
    dotenv().ok();

    let protocol_adapter = env::var("PROTOCOL_ADAPTER_ADDRESS_SEPOLIA")
        .expect("Couldn't read PROTOCOL_ADAPTER_ADDRESS_SEPOLIA")
        .parse::<Address>()
        .expect("Wrong address format");

    ProtocolAdapter::new(protocol_adapter, crate::call::provider())
}

pub fn provider() -> DefaultProvider {
    dotenv().ok();

    let signer = env::var("PRIVATE_KEY")
        .expect("Couldn't read PRIVATE_KEY")
        .parse::<PrivateKeySigner>()
        .expect("Wrong private key format");

    let rpc_url = format!(
        "https://eth-sepolia.g.alchemy.com/v2/{}",
        env::var("API_KEY_ALCHEMY").expect("Couldn't read API_KEY_ALCHEMY")
    );

    ProviderBuilder::new()
        .wallet(signer)
        .on_http(rpc_url.parse().expect("Failed to parse RPC URL"))
}

#[cfg(test)]
mod tests {
    use crate::call::protocol_adapter;
    use crate::conversion::ProtocolAdapter;
    use alloy::hex;
    use alloy::primitives::{B256, U256};
    use tokio;

    fn initial_root() -> B256 {
        B256::from(hex!(
            "7e70786b1d52fc0412d75203ef2ac22de13d9596ace8a5a1ed5324c3ed7f31c3"
        ))
    }

    #[tokio::test]
    async fn call_merkle_proof() {
        let commitment = B256::from(hex!(
            "9c590db144abb0434267475ac46554bc71377b1e678a6ce7dd86c8559b97cf1c"
        ));

        let res = protocol_adapter()
            .merkleProof(commitment)
            .call()
            .await
            .unwrap();

        assert_eq!(res.directionBits, U256::from(0xFFFFFFFFu64));

        assert_eq!(res.siblings.len(), 32);
    }

    #[tokio::test]
    async fn call_merkle_proof_revert() {
        let non_existent_commitment = B256::from(hex!(
            "0000000000000000000000000000000000000000000000000000000000000001"
        ));

        let err = protocol_adapter()
            .merkleProof(non_existent_commitment)
            .call()
            .await
            .unwrap_err();

        // Expect error
        assert_eq!(
            err.as_decoded_error::<ProtocolAdapter::NonExistingCommitment>()
                .unwrap()
                .commitment,
            non_existent_commitment
        );
    }

    #[tokio::test]
    async fn contains_initial_root() {
        assert!(
            protocol_adapter()
                .containsRoot(initial_root())
                .call()
                .await
                .unwrap()
                .isContained
        );
    }

    #[tokio::test]
    async fn call_latest_root() {
        let root = protocol_adapter().latestRoot().call().await.unwrap().root;
        assert_ne!(root, initial_root());
    }

    #[tokio::test]
    async fn call_verify() {
        let empty_tx = ProtocolAdapter::Transaction {
            actions: vec![],
            deltaProof: vec![].into(),
        };
        let result = protocol_adapter().verify(empty_tx).call().await;
        assert!(result.is_ok());
    }

    #[tokio::test]
    async fn call_execute() {
        let empty_tx = ProtocolAdapter::Transaction {
            actions: vec![],
            deltaProof: vec![].into(),
        };
        let result = protocol_adapter().execute(empty_tx).call().await;
        assert!(result.is_ok());
    }
}
*/
