#[cfg(test)]
use alloy::primitives::B256;
use alloy::sol_types::SolValue;
use arm_risc0::aggregation::AggregationStrategy;
use evm_protocol_adapter_bindings::conversion::ProtocolAdapter;

#[test]
fn print_verifying_keys() {
    println!(
        "COMPLIANCE_VK: {:?}",
        B256::from_slice(arm_risc0::constants::COMPLIANCE_VK.as_bytes())
    );

    println!(
        "BATCH_AGGREGATION_VK: {:?}",
        B256::from_slice(arm_risc0::aggregation::constants::BATCH_AGGREGATION_VK.as_bytes())
    );
}

#[test]
#[ignore]
fn generate_tx_reg() {
    let n_actions = 2;
    let n_cus = 2;

    let tx = arm_risc0::tests::generate_test_transaction(n_actions, n_cus);

    to_evm_bin_file(
        ProtocolAdapter::Transaction::from(tx),
        "tx_reg",
        &n_actions,
        &n_cus,
    );
}

#[test]
#[ignore]
fn generate_tx_agg() {
    let n_actions = 1;
    let n_cus = 1;

    let mut tx = arm_risc0::tests::generate_test_transaction(n_actions, n_cus);

    tx.aggregate_with_strategy(AggregationStrategy::Batch)
        .unwrap();

    to_evm_bin_file(
        ProtocolAdapter::Transaction::from(tx),
        "tx_agg",
        &n_actions,
        &n_cus,
    );
}

fn to_evm_bin_file(tx: ProtocolAdapter::Transaction, name: &str, n_actions: &usize, n_cus: &usize) {
    let encoded_tx = tx.abi_encode();
    let decoded_tx: ProtocolAdapter::Transaction =
        ProtocolAdapter::Transaction::abi_decode(&encoded_tx).unwrap();
    assert_eq!(tx, decoded_tx);

    println!("Transaction: {tx:#?}");
    std::fs::write(
        format!(
            "../contracts/test/examples/transactions/test_{name}_{n_actions:02}_{n_cus:02}.bin"
        ),
        &encoded_tx,
    )
    .expect("Failed to write encoded transaction to file");
}
