use std::process::Command;

// Example custom build script.
fn main() {
    // Ensure forge is available.
    if Command::new("forge").arg("--version").output().is_err() {
        panic!("Forge not found. Visit https://getfoundry.sh/ to install it.");
    }

    // Run `forge soldeer install` in the `../contracts` directory.
    let status = Command::new("forge")
        .current_dir("../contracts")
        .args(["soldeer", "install"])
        .status()
        .expect("failed to fetch dependencies with forge soldeer");

    if !status.success() {
        panic!("forge soldeer install command failed");
    }

    // Run `forge build --ast` in the `../contracts` directory.
    let status = Command::new("forge")
        .current_dir("../contracts")
        .args(["build", "--ast"])
        .status()
        .expect("failed to run forge command");

    if !status.success() {
        panic!("forge build --ast command failed");
    }

    // Rebuild the contracts if any file changes in the contracts dir
    println!("cargo:rerun-if-changed=../contracts/");
}
