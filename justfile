# Show commands before running (helps debug failures)
set shell := ["bash", "-euo", "pipefail", "-c"]

# Default recipe
default:
    @just --list

# --- Contracts ---

# Install contract dependencies
contracts-deps:
    cd contracts && forge soldeer install

# Clean contract dependencies
contracts-deps-clean:
    cd contracts && forge soldeer clean

# Clean contracts
contracts-clean:
    cd contracts && forge clean

# Build contracts
contracts-build *args:
    cd contracts && forge build {{ args }}

# Lint contracts (forge lint + solhint)
contracts-lint:
    cd contracts && forge lint --deny warnings
    cd contracts && bunx --bun solhint --config .solhint.json 'src/**/*.sol'
    cd contracts && bunx --bun solhint --config .solhint.other.json 'test/**/*.sol'
    cd contracts && bunx --bun solhint --config .solhint.other.json 'script/**/*.sol'

# Run slither on contracts
contracts-static-analysis:
    cd contracts && slither .
    @echo "Removing slither compilation artifacts..."
    forge clean

# Format contracts
contracts-fmt *args:
    cd contracts && forge fmt {{ args }}

# Check contract formatting
contracts-fmt-check:
    cd contracts && forge fmt --check

# Run contract tests
contracts-test *args:
    cd contracts && forge test {{ args }}

# Regenerate Rust bindings from contracts
contracts-gen-bindings:
    cd contracts && forge clean && forge bind \
        --skip test --skip script \
        --select '^(IProtocolAdapter|ProtocolAdapter|IVersion|VersioningLibExternal|ICommitmentTree|INullifierSet|IForwarder)$' \
        --bindings-path ../bindings/src/generated/ \
        --module \
        --overwrite

# Simulate deployment (dry-run)
contracts-simulate chain *args:
    @echo "IS_TEST_DEPLOYMENT: $IS_TEST_DEPLOYMENT"
    @echo "EMERGENCY_STOP_CALLER: $EMERGENCY_STOP_CALLER"
    cd contracts && forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter \
        --sig "run(bool,address)" $IS_TEST_DEPLOYMENT $EMERGENCY_STOP_CALLER \
        --rpc-url {{chain}} {{ args }}

# Deploy protocol adapter
contracts-deploy deployer chain *args:
    cd contracts && forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter \
        --sig "run(bool,address)" $IS_TEST_DEPLOYMENT $EMERGENCY_STOP_CALLER \
        --broadcast --rpc-url {{chain}} --account {{deployer}} {{ args }}

# Execute a transaction binary on a deployed protocol adapter
contracts-execute-tx deployer pa-address filepath chain *args:
    cd contracts && forge script script/ExecuteTransaction.s.sol:ExecuteTransaction \
        --sig "run(address,string)" {{pa-address}} {{filepath}} \
        --broadcast --rpc-url {{chain}} --account {{deployer}} {{ args }}

# Verify on sourcify
contracts-verify-sourcify address chain *args:
    cd contracts && env -u ETHERSCAN_API_KEY forge verify-contract {{address}} \
        src/ProtocolAdapter.sol:ProtocolAdapter \
        --chain {{chain}} --verifier sourcify --watch {{ args }}

# Verify on etherscan
contracts-verify-etherscan address chain *args:
    cd contracts && forge verify-contract {{address}} \
        src/ProtocolAdapter.sol:ProtocolAdapter \
        --chain {{chain}} --verifier etherscan --watch {{ args }}

# Verify on both sourcify and etherscan
contracts-verify address chain: (contracts-verify-sourcify address chain) (contracts-verify-etherscan address chain)

# Publish contracts
contracts-publish version *args:
    cd contracts && forge soldeer push anoma-pa-evm~{{version}} {{ args }}

# --- Bindings ---

# Clean bindings
bindings-clean:
    cd bindings && cargo clean

# Build bindings
bindings-build *args:
    cd bindings && cargo build {{ args }}

# Test bindings
bindings-test *args:
    cd bindings && cargo test {{ args }}

# Check bindings are up-to-date
bindings-check: contracts-gen-bindings
    git diff --exit-code bindings/src/generated/

# Publish bindings
bindings-publish *args:
    cd bindings && cargo publish {{ args }}

# Lint bindings (clippy)
bindings-lint:
    cd bindings && cargo clippy --no-deps -- -Dwarnings
    cd bindings && cargo clippy --no-deps --tests -- -Dwarnings

# Format bindings
bindings-fmt:
    cargo fmt

# Check bindings formatting
bindings-fmt-check:
    cargo fmt -- --check

# --- All ---

# Lint all (contracts + bindings)
all-lint:
    @echo "==> Linting contracts..."
    @just contracts-lint
    @echo "==> Linting bindings..."
    @just bindings-lint

# Format all (contracts + bindings)
all-fmt:
    @echo "==> Formatting contracts..."
    @just contracts-fmt
    @echo "==> Formatting bindings..."
    @just bindings-fmt

# Check formatting for all (contracts + bindings)
all-fmt-check:
    @echo "==> Checking contract formatting..."
    @just contracts-fmt-check
    @echo "==> Checking bindings formatting..."
    @just bindings-fmt-check

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

# Prerequisites check (mirrors CI)
all-check:
    git status
    @echo "==> Static analysis with slither..."
    @just contracts-static-analysis
    @echo "==> Checking formatting..."
    @just all-fmt-check
    @echo "==> Linting..."
    @just all-lint
    @echo "==> Checking bindings are up-to-date..."
    @just bindings-check
