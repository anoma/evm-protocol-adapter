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

pub fn protocol_adapter() -> ProtocolAdapter::ProtocolAdapterInstance<
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
        "https://eth-sepolia.g.alchemy.com/v2/{}",
        env::var("API_KEY_ALCHEMY").expect("Couldn't read API_KEY_ALCHEMY")
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
            "b9a737dcf88058e86d299cc2882d22f09f5741864aaa4eb493ec8569fe55b4d7"
        ));

        let siblings = vec![
            hex!("cc1d2f838445db7aec431df9ee8a871f40e7aa5e064fc056633ef8c60fab7b06"),
            hex!("9052a1e9c2367d7248294f9ebc9495a73e2ff0c1b5e1dd09531e0a08ac1edc13"),
            hex!("78da8fe62dc0b46ba21971b6ab1b873c071f16a5f3f102216b8660884c3712e9"),
            hex!("e86b1f2d8ec1204d36481a46d3afc0fca0cc77386505ce4060cfa2eae6ba9547"),
            hex!("45c2f1b8d817e7dbb818ce089b402f5eb2e981dbade474cadce703f356dc3d67"),
            hex!("1b8dffac32c2afa124fef2dcdc231dc0a601bbc14f2392672412d295908f5399"),
            hex!("f4987c63cdab12aafee277155a5d06f67bf721027acd9106b3af895128616899"),
            hex!("760486b25ee7b732959e88c7cb305a03f426052953ddff48f8ff3dbeba209f9f"),
            hex!("9fd2b7153c9aac55a4220e24a6734810cf3ddd38da3607f29ac4c42df5802b56"),
            hex!("18db5dfe794336af2963876d47dc97738b45276ecb326e53431bbf734cab79f0"),
            hex!("d337ccd9a386fe657d315b4561dd126731960ec391ea97730fea2b8bdad775ba"),
            hex!("1be19a4cd40ebc4f1eaacf0a746bebcc0ebd41cf4e6c5efac87c9366e36ec5d4"),
            hex!("febc00e0f250cd3a1c33e60dd4b620f5661d831f65ed4364a5eeb46753adf661"),
            hex!("aa1519e851f0c734a289c57f36f301f4ed10c46f3403c7360b5d896afe3c2eba"),
            hex!("53692a35b69e0384ae8c1a78fc7324e109ea45a98f8c463dd40563d3fe92b939"),
            hex!("b449a011fdee39a0fa67cd2041bead15b224b1ab7665811a8881d6d2aaadabd4"),
            hex!("af5bf3704beccfde7534a4d61dfc55262c60f542b30c11781165e0664422d0ab"),
            hex!("d6be3b998bc09d7fac4f4a3e0f1751349cd4ab0c0d798e66c50c42d5d31346f7"),
            hex!("071105ef6f4550af999d417a5ce3e1d4e7534e3fb4737437e17006dde0dcee02"),
            hex!("0901a3f66292e7c70d4970a2dfa58334b8e96f8044c3daf41ae4420acef258c3"),
            hex!("f6f60db4f294f6373397178312dbc00d837f0edaaa1eb9247664927121228029"),
            hex!("a5b6b9b7a4de7bb26a9faa11037b5989d016f88e3dd9555d0e59972a292e97cb"),
            hex!("c4096b4abf3e7ba7a29322611be1e6fcfecaba653222e634e15bd6822109a6f2"),
            hex!("ad941c01e5acd3963536227309af0e40a6e27e0c2d6d5ecfd76da708169d1ff3"),
            hex!("223f70c38dda1063f13b23fd5fca5085f58705d82d59566e4ce92256c36c4cd5"),
            hex!("1e717c1005b410c7db7d9de50f4161626db27769bcd2370f5e0e271d84cae27f"),
            hex!("7af85d77d28dffe5d1181f573d0fa40cfc87416eebbfe9a02c75ca3402ecfbfe"),
            hex!("765b92a62ae38f274085c9b3e098bcbeb83dcb3618099f1b968c6eeefb85738c"),
            hex!("9a16ba8601e0fcc863c4dd5766c1fa445452cb582f6091ec72b238863f888511"),
            hex!("21cdfe66a766b1faff0bcfec88776a7629629deccc40cb3aa3c5da147b93093a"),
            hex!("bea1e263505974f7bd1be386b6a6d677867830425ddc45a71b5a413b129dbae1"),
            hex!("254f102fd2a0b5db3926704ac4f559a767f60854fc157b2de5d5853da9b8976a"),
        ];

        let res = protocol_adapter()
            .merkleProof(commitment)
            .call()
            .await
            .unwrap();

        assert_eq!(res.directionBits, U256::from(0xFFFFFFFFu64));

        assert_eq!(res.siblings, siblings);
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
