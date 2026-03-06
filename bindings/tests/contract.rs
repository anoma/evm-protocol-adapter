#[cfg(test)]
extern crate dotenvy;

use alloy::primitives::B256;
use alloy::providers::{DynProvider, Provider, ProviderBuilder};
use alloy_chains::NamedChain;
use anoma_pa_evm_bindings::addresses::protocol_adapter_deployments_map;
use anoma_pa_evm_bindings::contract::protocol_adapter;
use anoma_pa_evm_bindings::generated::protocol_adapter;
use anoma_pa_evm_bindings::generated::versioning_lib_external;
use anoma_pa_evm_bindings::helpers::rpc_url;
use std::thread::sleep;
use std::time::Duration;

#[tokio::test]
async fn versions_of_deployed_protocol_adapters_match_the_expected_version() {
    // Get the expected protocol adapter version.
    let expected_version = {
        let provider = ProviderBuilder::new().connect_anvil_with_wallet();
        let contract = versioning_lib_external::VersioningLibExternal::deploy(&provider)
            .await
            .expect("Couldn't deploy `VersioningLibExternal` contract");
        contract
            .version()
            .call()
            .await
            .expect("Couldn't get version")
    };

    // Iterate over all supported chains
    for chain in protocol_adapter_deployments_map().keys() {
        let actual_version: alloy::primitives::FixedBytes<32> = pa_instance(chain)
            .await
            .getVersion()
            .call()
            .await
            .expect("Couldn't get protocol adapter version");

        //  Check that the deployed protocol adapter version matches the expected version.
        assert_eq!(
            decode_bytes32_to_utf8(actual_version),
            decode_bytes32_to_utf8(expected_version),
            "Protocol adapter version mismatch on network '{chain}'."
        );

        sleep(Duration::from_secs(3));
    }
}

#[tokio::test]
async fn call_executes_the_empty_tx_on_all_supported_chains() {
    for chain in protocol_adapter_deployments_map().keys() {
        let empty_tx = protocol_adapter::ProtocolAdapter::Transaction {
            actions: vec![],
            deltaProof: Default::default(),
            aggregationProof: Default::default(),
        };

        let receipt = pa_instance(chain)
            .await
            .execute(empty_tx)
            .send()
            .await
            .expect("Couldn't send tx")
            .get_receipt()
            .await
            .expect("Couldn't get receipt");

        assert!(
            receipt.inner.is_success(),
            "Empty transaction failed on network '{chain}'."
        );

        sleep(Duration::from_secs(3));
    }
}

async fn pa_instance(
    chain: &NamedChain,
) -> protocol_adapter::ProtocolAdapter::ProtocolAdapterInstance<DynProvider> {
    let rpc_url = rpc_url(chain).expect("Couldn't get RPC URL for chain");

    let provider = ProviderBuilder::new()
        .connect_anvil_with_wallet_and_config(|a| a.fork(rpc_url))
        .expect("Couldn't create anvil provider");
    protocol_adapter(&provider.erased())
        .await
        .expect("Couldn't get protocol adapter instance")
}

fn decode_bytes32_to_utf8(encoded_string: B256) -> String {
    let bytes = alloy::hex::decode(encoded_string.to_string()).expect("Couldn't decode hex string");

    let trimmed = bytes
        .split(|b| *b == 0)
        .next()
        .expect("No null byte found in bytes");
    str::from_utf8(trimmed)
        .expect("Conversion to UTF-8 failed.")
        .to_string()
}
