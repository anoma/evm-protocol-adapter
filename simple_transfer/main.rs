use alloy::sol_types::SolValue;
use evm_protocol_adapter_bindings::conversion::ProtocolAdapter;
use simple_transfer_lib::erc20_forwarder::{burn_tx, default_values, mint_tx, transfer_tx};
use simple_transfer_lib::keychain::example_keychain;
use std::env;

fn main() {
    env::var("PRIVATE_KEY").expect("Couldn't read PRIVATE_KEY");

    let data = default_values();
    let keychain = example_keychain();

    let (mint_tx, minted_resource) = mint_tx(&data, &keychain);
    write_to_file(mint_tx, "mint");

    let (transfer_tx, transferred_resource) = transfer_tx(&data, &keychain, &minted_resource);
    write_to_file(transfer_tx, "transfer");

    let burn_tx = burn_tx(&data, &keychain, &minted_resource, &transferred_resource);
    write_to_file(burn_tx, "burn");
}

fn write_to_file(tx: ProtocolAdapter::Transaction, file_name: &str) {
    let encoded_tx = tx.abi_encode();

    std::fs::write(
        format!("./contracts/test/examples/transactions/{file_name}.bin"),
        encoded_tx,
    )
    .expect("Failed to write file");
}
