[![CI](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml/badge.svg)](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml)

# EVM Protocol Adapter

A protocol adapter contract written in Solidity enabling Anoma Resource Machine transaction settlement on EVM-compatible chains.

## Project Structure

```sh
.
├── bindings
├── contracts
├── LICENSE
└── README.md
```

The `contracts` folder contains the contracts written in [Solidity](https://soliditylang.org/) as well
as [Foundry forge](https://book.getfoundry.sh/forge/) tests and deploy scripts.

The `bindings` folder contains bindings in [Rust](https://www.rust-lang.org/) to
convert [Rust](https://www.rust-lang.org/) and [RISC Zero](https://risczero.com/) types into EVM types using the [
`alloy-rs` library](https://github.com/alloy-rs).

## Security

If you believe you've found a security issue, we encourage you to notify us via Email at [security@anoma.foundation](mailto:security@anoma.foundation).

Please do not use the issue tracker for security issues. We welcome working with you to resolve the issue promptly.

## Solidity Contracts

### Prerequisites

Get an up-to-date version of [Foundry](https://github.com/foundry-rs/foundry) with

```sh
curl -L https://foundry.paradigm.xyz | sh
foundryup
```

### Usage

#### Build

Change the directory to the `contracts` folder with `cd contracts` and run

```sh
forge build
```

#### Tests & Coverage

To run the tests, run

```sh
forge test
```

To show the coverage report, run

```sh
forge coverage --ir-minimum
```

Append the

- `--no-match-coverage "(script|test|draft)"` to exclude scripts, tests, and drafts,
- `--report lcov` to generate the `lcov.info` file that can be used by code review tooling.

#### Linting & Static Analysis

As a prerequisite, install the

- `solhint` linter (see https://github.com/protofire/solhint)
- `slither` static analyzer (see https://github.com/crytic/slither)

To run the linter and static analyzer, run

```sh
npx solhint --config .solhint.json 'src/**/*.sol' && \
npx solhint --config .solhint.other.json 'script/**/*.sol' 'test/**/*.sol' && \
slither .
```

#### Documentation

Run

```sh
forge doc
```

#### Deployment

To simulate deployment on sepolia, run

```sh
forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter \
  --sig "run(bool,address)" <IS_TEST_DEPLOYMENT> <EMERGENCY_STOP_CALLER> \
  --rpc-url sepolia
```

Append the

- `--broadcast` flag to deploy on sepolia
- `--verify --slow` flags for subsequent contract verification on Etherscan (`--slow` adds 15 seconds of waiting time between verification attempts)
- `--account <ACCOUNT_NAME>` flag to use a previously imported keystore (see
  `cast wallet --help` for more info)

#### Block Explorer Verification

For post-deployment verification on Etherscan run

```sh
forge verify-contract \
   <ADDRESS> \
   src/ProtocolAdapter.sol:ProtocolAdapter \
   --chain sepolia
```

after replacing `<ADDRESS>` with the respective contract address.

### Benchmarks

The following benchmark shows the transaction execution costs without and with proof aggregation for the current protocol adapter implementation:

<img src=".assets/Benchmark.png" width=67% alt="Protocol adapter benchmark.">

The current protocol adapter implementation utilizes a Merkle tree of dynamic depth starting at depth 0.

## Rust Bindings

## Prerequisites

1. Get an up-to-date version of [Rust](https://www.rust-lang.org/) with

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

2. Install [RISC Zero `rzup`](https://github.com/risc0/risc0) with

   ```sh
   curl -L https://risczero.com/install | sh
   ```

3. Install the latest RISC Zero version with

   ```sh
   rzup install
   ```

   or a specific version (e.g., `3.0.3`) with

   ```sh
   rzup install cargo-risczero <version>
   ```

### Usage

#### Build

Change the directory to the `bindings` folder with `cd bindings` and run

```sh
cargo build
```

#### Test

To test the build, run

```sh
cargo test
```

To print a test transaction with aggregated proofs run

```sh
cargo test -- conversion::tests::generate_tx_agg --exact --show-output --ignored
```
