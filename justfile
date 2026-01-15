# Show commands before running (helps debug failures)
set shell := ["bash", "-euo", "pipefail", "-c"]

# Default recipe
default:
    @just --list

# --- Contracts ---

# Install contract dependencies
contracts-deps:
    cd contracts && forge soldeer install

# Clean contracts
contracts-clean:
    cd contracts && forge clean && forge soldeer clean

# Build contracts
contracts-build *args: contracts-clean contracts-deps
    cd contracts && forge build {{ args }}

# Run contract tests
contracts-test *args:
    cd contracts && forge test {{ args }}

# Regenerate Rust bindings from contracts
contracts-gen-bindings:
    cd contracts && forge bind \
        --select '^(IProtocolAdapter|ProtocolAdapter|VersioningLibExternal)$' \
        --bindings-path ../bindings/src/generated/ \
        --module \
        --overwrite

# Simulate deployment (dry-run)
contracts-simulate chain *args:
    cd contracts && forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter \
        --sig "run(bool,address)" $IS_TEST_DEPLOYMENT $EMERGENCY_STOP_CALLER \
        --rpc-url {{chain}} {{ args }}

# Deploy protocol adapter
contracts-deploy chain *args:
    cd contracts && forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter \
        --sig "run(bool,address)" $IS_TEST_DEPLOYMENT $EMERGENCY_STOP_CALLER \
        --broadcast --rpc-url {{chain}} --account deployer {{ args }}

# Verify on sourcify
contracts-verify-sourcify address chain *args:
    cd contracts && forge verify-contract {{address}} \
        src/ProtocolAdapter.sol:ProtocolAdapter \
        --chain {{chain}} --verifier sourcify {{ args }}

# Verify on etherscan
contracts-verify-etherscan address chain *args:
    cd contracts && forge verify-contract {{address}} \
        src/ProtocolAdapter.sol:ProtocolAdapter \
        --chain {{chain}} --verifier etherscan {{ args }}

# Verify on both sourcify and etherscan
contracts-verify address chain: (contracts-verify-sourcify address chain) (contracts-verify-etherscan address chain)

# Publish contracts (dry-run by default)
contracts-publish version dry-run="--dry-run":
    cd contracts && forge soldeer push anoma-pa-evm~{{version}} {{dry-run}}

# --- Bindings ---

# Build bindings
bindings-build *args:
    cd bindings && cargo build {{ args }}

# Test bindings
bindings-test *args:
    cd bindings && cargo test {{ args }}

# Check bindings are up-to-date
bindings-check: contracts-gen-bindings
    git diff --exit-code bindings/src/generated/

# Publish bindings (dry-run by default)
bindings-publish dry-run="--dry-run":
    cd bindings && cargo publish {{dry-run}}

# --- All ---

# Build all (contracts + bindings)
all-build:
    @echo "==> Building contracts..."
    @just contracts-build
    @echo "==> Building bindings..."
    @just bindings-build

# Test all (contracts + bindings)
all-test:
    @echo "==> Testing contracts..."
    @just contracts-test
    @echo "==> Testing bindings..."
    @just bindings-test

# Prerequisites check
all-check:
    git status
    @echo "==> Checking bindings are up-to-date..."
    @just bindings-check
