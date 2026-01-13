[![Crates.io](https://img.shields.io/crates/v/anoma-pa-evm-bindings)](https://crates.io/crates/anoma-pa-evm-bindings) [![License](https://img.shields.io/crates/l/anoma-pa-evm-bindings)](https://github.com/anoma/evm-protocol-adapter/blob/main/LICENSE) [![CI](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml/badge.svg)](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml)

# Example Transaction Generation

This package provides a [Rust](https://www.rust-lang.org/) executable to generate example transactions with aggregated and non-aggregated proofs that can be submitted to the Anoma EVM Protocol Adapter.

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
cargo build --release --package example-tx-generation
```

### Generate an Example Transaction

The executable expects three input arguments:

1. Whether to generate aggregate proofs or not.
2. The number of actions to generate.
3. The number of compliance units per action, each of which contains two resources.

Compliance units contain one ephemeral consumed resource and one created resource, both having a quantity of one and the trivial resource logic always returning true.

To generate an example transaction `.bin` file with, e.g., aggregated proofs and one action containg one compliance unit, run

```sh
./target/release/example-tx-generation true 1 1
```

from the project root.
