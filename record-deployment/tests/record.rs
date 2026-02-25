use std::fs;
use std::path::Path;
use std::process::Command;

/// Build the binary once and return its path.
fn binary_path() -> &'static Path {
    // The binary is built by `cargo test -p record-deployment` automatically
    // via the implicit dev-dependency on the package itself.
    // We locate it relative to the test binary's directory.
    static PATH: std::sync::LazyLock<std::path::PathBuf> = std::sync::LazyLock::new(|| {
        let output = Command::new(env!("CARGO"))
            .args(["build", "-p", "record-deployment", "--message-format=short"])
            .output()
            .expect("Failed to build record-deployment");
        assert!(
            output.status.success(),
            "cargo build failed: {}",
            String::from_utf8_lossy(&output.stderr)
        );

        // Locate the binary in the target directory.
        let target_dir = std::env::var("CARGO_TARGET_DIR")
            .map(std::path::PathBuf::from)
            .unwrap_or_else(|_| {
                // Walk up from the manifest dir to find the workspace target dir.
                let manifest_dir = Path::new(env!("CARGO_MANIFEST_DIR"));
                manifest_dir.parent().unwrap().join("target")
            });
        target_dir.join("debug").join("record-deployment")
    });
    PATH.as_path()
}

/// Minimal valid broadcast artifact for ProtocolAdapter.
fn mock_broadcast(address: &str, tx_hash: &str) -> String {
    format!(
        r#"{{
  "transactions": [
    {{
      "transactionType": "CREATE2",
      "contractName": "ProtocolAdapter",
      "contractAddress": "{address}",
      "hash": "{tx_hash}"
    }}
  ]
}}"#
    )
}

/// Set up a temp directory mimicking the repo layout and return its path.
fn setup_temp_dir(
    chain_id: u64,
    broadcast_json: Option<&str>,
    deployments_json: Option<&str>,
) -> tempfile::TempDir {
    let tmp = tempfile::tempdir().expect("Failed to create temp dir");

    // Write deployments.json.
    let deployments = deployments_json.unwrap_or("[]");
    fs::write(tmp.path().join("deployments.json"), deployments)
        .expect("Failed to write deployments.json");

    // Write broadcast artifact if provided.
    if let Some(json) = broadcast_json {
        let artifact_dir = tmp
            .path()
            .join("contracts/broadcast/DeployProtocolAdapter.s.sol")
            .join(chain_id.to_string());
        fs::create_dir_all(&artifact_dir).expect("Failed to create broadcast dir");
        fs::write(artifact_dir.join("run-latest.json"), json)
            .expect("Failed to write broadcast artifact");
    }

    tmp
}

fn run_record(tmp: &Path, args: &[&str]) -> std::process::Output {
    Command::new(binary_path())
        .args(args)
        .current_dir(tmp)
        .output()
        .expect("Failed to run record-deployment")
}

#[derive(serde::Deserialize)]
#[serde(rename_all = "camelCase")]
#[allow(dead_code)]
struct Entry {
    network: String,
    chain_id: u64,
    contract_address: String,
    version: String,
    tx_hash: Option<String>,
}

fn read_deployments(tmp: &Path) -> Vec<Entry> {
    let json =
        fs::read_to_string(tmp.join("deployments.json")).expect("Failed to read deployments.json");
    serde_json::from_str(&json).expect("Failed to parse deployments.json")
}

#[test]
fn writes_new_entry_to_empty_deployments() {
    let address = "0x094FCC095323080e71a037b2B1e3519c07dd84F8";
    let tx_hash = "0xabc123def456";
    let broadcast = mock_broadcast(address, tx_hash);
    let tmp = setup_temp_dir(1, Some(&broadcast), None);

    let output = run_record(tmp.path(), &["mainnet", "1.1.0"]);
    assert!(
        output.status.success(),
        "stderr: {}",
        String::from_utf8_lossy(&output.stderr)
    );

    let entries = read_deployments(tmp.path());
    assert_eq!(entries.len(), 1);
    assert_eq!(entries[0].network, "mainnet");
    assert_eq!(entries[0].chain_id, 1);
    assert_eq!(entries[0].contract_address, address);
    assert_eq!(entries[0].version, "1.1.0");
    assert_eq!(entries[0].tx_hash.as_deref(), Some(tx_hash));
}

#[test]
fn replaces_existing_entry_for_same_chain() {
    let old_json = r#"[{
        "network": "mainnet",
        "chainId": 1,
        "contractAddress": "0xOLD",
        "version": "1.0.0"
    }]"#;
    let new_address = "0x094FCC095323080e71a037b2B1e3519c07dd84F8";
    let broadcast = mock_broadcast(new_address, "0xnewhash");
    let tmp = setup_temp_dir(1, Some(&broadcast), Some(old_json));

    let output = run_record(tmp.path(), &["mainnet", "1.1.0"]);
    assert!(
        output.status.success(),
        "stderr: {}",
        String::from_utf8_lossy(&output.stderr)
    );

    let entries = read_deployments(tmp.path());
    assert_eq!(entries.len(), 1, "Should have exactly one entry, not two");
    assert_eq!(entries[0].contract_address, new_address);
    assert_eq!(entries[0].version, "1.1.0");
}

#[test]
fn appends_without_clobbering_other_chains() {
    let existing_json = r#"[{
        "network": "mainnet",
        "chainId": 1,
        "contractAddress": "0x0eA3B55b68A3f307c8FE3fe66E443247c95F0CfF",
        "version": "1.1.0"
    }]"#;
    let new_address = "0x094FCC095323080e71a037b2B1e3519c07dd84F8";
    // Chain 10 = optimism.
    let broadcast = mock_broadcast(new_address, "0xopthash");
    let tmp = setup_temp_dir(10, Some(&broadcast), Some(existing_json));

    let output = run_record(tmp.path(), &["optimism", "1.1.0"]);
    assert!(
        output.status.success(),
        "stderr: {}",
        String::from_utf8_lossy(&output.stderr)
    );

    let entries = read_deployments(tmp.path());
    assert_eq!(entries.len(), 2);
    // Mainnet (chain 1) should still be there.
    assert_eq!(entries[0].chain_id, 1);
    assert_eq!(
        entries[0].contract_address,
        "0x0eA3B55b68A3f307c8FE3fe66E443247c95F0CfF"
    );
    // Optimism (chain 10) should be appended.
    assert_eq!(entries[1].chain_id, 10);
    assert_eq!(entries[1].contract_address, new_address);
}

#[test]
fn entries_are_sorted_by_chain_id() {
    // Add chains in reverse order: arbitrum (42161), then mainnet (1).
    let broadcast_arb = mock_broadcast("0xARB", "0xarbhash");
    let tmp = setup_temp_dir(42161, Some(&broadcast_arb), None);

    let output = run_record(tmp.path(), &["arbitrum", "1.1.0"]);
    assert!(
        output.status.success(),
        "stderr: {}",
        String::from_utf8_lossy(&output.stderr)
    );

    // Now add mainnet (chain 1).
    let broadcast_dir = tmp
        .path()
        .join("contracts/broadcast/DeployProtocolAdapter.s.sol/1");
    fs::create_dir_all(&broadcast_dir).unwrap();
    fs::write(
        broadcast_dir.join("run-latest.json"),
        mock_broadcast("0xMAIN", "0xmainhash"),
    )
    .unwrap();

    let output = run_record(tmp.path(), &["mainnet", "1.1.0"]);
    assert!(
        output.status.success(),
        "stderr: {}",
        String::from_utf8_lossy(&output.stderr)
    );

    let entries = read_deployments(tmp.path());
    assert_eq!(entries.len(), 2);
    assert_eq!(entries[0].chain_id, 1, "Mainnet should be first (sorted)");
    assert_eq!(
        entries[1].chain_id, 42161,
        "Arbitrum should be second (sorted)"
    );
}

#[test]
fn fails_gracefully_on_missing_artifact() {
    // No broadcast artifact provided.
    let tmp = setup_temp_dir(1, None, None);

    let output = run_record(tmp.path(), &["mainnet", "1.1.0"]);
    assert!(
        !output.status.success(),
        "Should fail when artifact is missing"
    );

    let stderr = String::from_utf8_lossy(&output.stderr);
    assert!(
        stderr.contains("Broadcast artifact not found"),
        "Expected 'Broadcast artifact not found' in stderr, got: {stderr}"
    );
}
