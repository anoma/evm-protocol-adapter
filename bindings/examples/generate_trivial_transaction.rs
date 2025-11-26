use arm_risc0::aggregation::AggregationStrategy;
use evm_protocol_adapter_bindings::contract::ProtocolAdapter;
use evm_protocol_adapter_bindings::conversion::to_evm_bin_file;
use std::path::Path;
use std::{env, process};

extern crate dotenv;

fn main() {
    dotenv::dotenv().ok();

    println!(
        "GPU Prover URL: {}",
        env::var("BONSAI_API_URL").expect("Failed to get BONSAI_API_URL")
    );
    env::var("BONSAI_API_KEY").expect("Failed to get BONSAI_API_KEY");

    // Collect command line arguments into a vector
    let args: Vec<String> = env::args().collect();

    // args[0] is the program name, so we need at least 4 elements total
    if args.len() < 4 {
        eprintln!("Usage: {} <aggregate_proofs> <n_actions> <n_cus>", args[0]);
        process::exit(1);
    }

    // Parse the arguments
    let aggregate_proofs: bool = args[1].parse().expect(
        "Argument 1 must be a boolean (true/false) indicating whether to aggregate proofs or not.",
    );

    let tx_type = if aggregate_proofs { "agg" } else { "reg" };

    let n_actions: usize = args[2].parse().expect(
        "Argument 2 must be a positive number indicating the number of actions in the transaction.",
    );

    let n_cus: usize = args[3].parse().expect(
        "Argument 3 must be a positive number indicating the number of compliance units in the transaction.",
    );

    println!(
        "Generating {tx_type}. transaction with {n_actions} actions and {n_cus} compliance units."
    );

    let bindings_path = Path::new(env!("CARGO_MANIFEST_DIR"));
    let project_root = bindings_path.parent().expect("Failed to get project root");

    let path = format!(
        "{project_root}/contracts/test/examples/transactions/test_tx_{tx_type}_{n_actions:02}_{n_cus:02}.bin",
        project_root = project_root
            .to_str()
            .expect("Failed to convert project root")
    );

    println!("Writing to file: {path:?}");

    let mut tx = arm_risc0::tests::generate_test_transaction(n_actions, n_cus);

    if aggregate_proofs {
        tx.aggregate_with_strategy(AggregationStrategy::Batch)
            .expect("Aggregation proof failed.");
    }

    to_evm_bin_file(ProtocolAdapter::Transaction::from(tx), path.as_str())
        .expect("Failed to write transaction to file.");
}
