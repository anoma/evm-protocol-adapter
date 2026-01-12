[![Crates.io](https://img.shields.io/crates/v/anoma-pa-evm-bindings)](https://crates.io/crates/anoma-pa-evm-bindings) [![License](https://img.shields.io/crates/l/anoma-pa-evm-bindings)](https://github.com/anoma/evm-protocol-adapter/blob/main/LICENSE) [![CI](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml/badge.svg)](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml)

# EVM Protocol Adapter Bindings

This package provides [Rust](https://www.rust-lang.org/) bindings for the conversion of Rust
and [RISC Zero](https://risczero.com/) types into [EVM types](https://docs.soliditylang.org/en/latest/types.html) and
exposes the deployment addresses on the different supported networks using the [alloy-rs](https://github.com/alloy-rs)
library.

## Project Structure

This package is structured as follows:

```
.
├── Cargo.toml
├── examples
├── README.md
├── src
└── tests
```

The `build.rs` script builds the `../contracts` dependency and
requires [Foundry](https://github.com/foundry-rs/foundry).

The `src` folder contains methods and bindings for type conversion and instantiation of the deployed protocol adapter
contracts.

The `examples` folder contains a binary to generate test transactions.

## Prerequisites

1. Get an up-to-date version of [Rust](https://www.rust-lang.org/) with

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

2. Install [RISC Zero `rzup`](https://github.com/risc0/risc0) with

   ```sh
   curl -L https://risczero.com/install | sh
   ```

3. Install the RISC Zero version 3.0.3 with

   ```sh
   rzup install cargo-risczero 3.0.3
   ```

## Usage

### Build

From the project root run

```sh
cargo build
```

### Test

To test the build, run

```sh
cargo test
```

### Example Transactions

To generate test transactions with aggregated and non-aggregated proofs, build the executable with

```sh
cargo build --package anoma-pa-evm-bindings --example generate_trivial_transaction
```

and run it with, e.g.,

```sh
./target/debug/examples/generate_trivial_transaction true 1 1
```

from the project root, where

- the first argument is whether to generate aggregate proofs or not,
- the second argument is the number of actions to generate, and
- the last argument is the number of compliance units per actions, each of which contains two resources.

Compliance units contain one ephemeral consumed resource and one created resource, both having a quantity of one and the
trivial resource logic always returning true.
