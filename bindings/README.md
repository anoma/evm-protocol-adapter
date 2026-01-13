[![Crates.io](https://img.shields.io/crates/v/test-anoma-pa-evm-bindings)](https://crates.io/crates/test-anoma-pa-evm-bindings) [![License](https://img.shields.io/crates/l/test-anoma-pa-evm-bindings)](https://github.com/anoma/pa-evm/blob/main/LICENSE) [![Bindings Tests](https://github.com/anoma/pa-evm/actions/workflows/bindings.yml/badge.svg)](https://github.com/anoma/pa-evm/actions/workflows/bindings.yml)

# Anoma EVM Protocol Adapter Bindings

This package provides [Rust](https://www.rust-lang.org/) bindings for the conversion of Rust and [RISC Zero](https://risczero.com/) types into [EVM types](https://docs.soliditylang.org/en/latest/types.html) and exposes the deployment addresses on the different supported networks using the [alloy-rs](https://github.com/alloy-rs)
library.

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

Run

```sh
cargo build
```

### Test

To test the build, run

```sh
cargo test
```
