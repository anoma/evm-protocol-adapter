[![CI](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml/badge.svg)](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml)

# EVM Protocol Adapter

## Project Structure

```sh
.
├── bindings
├── contracts
├── LICENSE
└── README.md
```

The `contracts` folder contains the contracts written in [Solidity](https://soliditylang.org/) contracts as well
as [Foundry forge](https://book.getfoundry.sh/forge/) tests and deploy scripts.

The `bindings` folder contains bindings in [Rust](https://www.rust-lang.org/) to
convert [Rust](https://www.rust-lang.org/) and [RISC Zero](https://risczero.com/) types into EVM types using the [
`alloy-rs` library](https://github.com/alloy-rs).

## Prerequisites

1. Get an up-to-date version of [Rust](https://www.rust-lang.org/)
   with

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

2. Clone this repo

## Solidity Contracts

### Installation

Change the directory to the `contracts` folder with `cd contracts` and run

```sh
forge install
```

### Usage

#### Build

To build the contracts run

```sh
forge build
```

#### Tests

To run the tests run

```sh
forge test
```

#### Linting & Static Analysis

As a prerequisite, install the

- `solhint` linter (see https://github.com/protofire/solhint)
- `slither` static analyzer (see https://github.com/crytic/slither)

Run the linter and analysis with

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

Benchmark of the protocol adapter execution costs without and with proof aggregation.

<img src=".assets/Benchmark.png" width=67% alt="Protocol adapter benchmark.">

The protocol adapter utilizes a Merkle tree of dynamic depth being empty in the beginning.

## Rust Bindings

### Installation

Change the directory to the `bindings` folder with `cd bindings` and run

1. Install `rzup` by running the following command:

   ```sh
   curl -L https://risczero.com/install | bash
   ```

2. Run `rzup` to install RISC Zero:

   ```sh
   rzup install
   ```

3. Go to the `bindings` directory with `cd bindings` and run

   ```sh
   cargo build
   ```

### Usage

To print a test transaction with aggregated proofs run

```sh
cargo test -- conversion::tests::generate_tx_agg --exact --show-output --ignored
```
