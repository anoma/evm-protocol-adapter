use anoma_pa_evm_bindings::conversion::to_evm_bin_file;
use anoma_pa_evm_bindings::generated::protocol_adapter::ProtocolAdapter;
use anoma_rm_risc0::aggregation::AggregationStrategy;
use anoma_rm_risc0::proving_system::ProofType;
use anoma_rm_risc0_test_app::generate_test_transaction;
use std::{env, process};

extern crate dotenvy;

/// A program generating example transactions consuming and creating resources with the trivial resource logic as `.bin` files.
/// The program expects three input arguments:
/// 1. Whether to generate aggregate proofs or not.
/// 2. The number of actions to generate.
/// 3. The number of compliance units per action, each of which contains two resources.
fn main() {
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

    dotenvy::dotenv().ok();

    match env::var("BONSAI_API_URL") {
        Ok(url) => {
            println!("Remote proving on {url} cluster...");

            env::var("BONSAI_API_KEY")
                .expect("The environment variable `BONSAI_API_KEY` must be set.");
        }
        Err(_) => println!("Local proving..."),
    }

    println!(
        "Generating {tx_type}. transaction with {n_actions} actions and {n_cus} compliance units."
    );

    let path = format!("test_tx_{tx_type}_{n_actions:02}_{n_cus:02}.bin",);

    println!("Writing to file: {path:?}");

    let proof_type = if aggregate_proofs {
        ProofType::Succinct
    } else {
        ProofType::Groth16
    };

    let mut tx = generate_test_transaction(n_actions, n_cus, proof_type);

    if aggregate_proofs {
        tx.aggregate_with_strategy(AggregationStrategy::Batch, ProofType::Groth16)
            .expect("Aggregation proof failed.");
    }

    to_evm_bin_file(ProtocolAdapter::Transaction::from(tx), path.as_str())
        .expect("Failed to write transaction to file.");
}
