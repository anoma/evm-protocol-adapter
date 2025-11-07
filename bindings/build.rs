use std::process::Command;

// Example custom build script.
fn main() {
    // make sure forge is available
    if Command::new("forge").arg("--version").output().is_err() {
        println!("cargo:warning=forge not found, skipping contract compilation");
        return;
    }

    // run forge build --ast in the ../contracts directory
    let status = Command::new("forge")
        .current_dir("../contracts")
        .args(["build", "--ast"])
        .status()
        .expect("failed to run forge command");

    if !status.success() {
        panic!("forge build --ast command failed");
    }

    // rebuild the contracts if any file changes in the contracts dir
    println!("cargo:rerun-if-changed=../contracts/");
}
