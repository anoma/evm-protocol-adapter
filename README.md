[![CI](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml/badge.svg)](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml)

# EVM Protocol Adapter

For more information on the EVM protocol adapter, find the related

- [Anoma Research Day talk](https://www.youtube.com/watch?v=rKFZsOw360U)
- [Anoma Specs Page](https://specs.anoma.net/latest/arch/integrations/adapters/evm.html)

<div align="left">
  <a href="https://www.youtube.com/watch?v=rKFZsOw360U">
     <img src=".assets/Youtube_preview.png"
       alt="The EVM Protocol Adapter: Bringing Intent-Centric Apps to Ethereum - Anoma Research Day"
       border=1,
       style="width:67%;">
  </a>
</div>

> [!WARNING]
> This repo features a prototype and is work in progress. Do NOT use in
> production.

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

Build the contracts with following flags: //TODO! confirm this is needed

```sh
forge build --ast
```

#### Tests

Run

```sh
forge test
```

#### Linting & Static Analysis

As a pre-requisite, install `solhint` with

```sh
bun install solhint
```

or

```sh
bun install solhint
```

and `slither`

via

```sh
python3 -m pip install slither-analyzer
```

Run the linter and analysis with

```sh
bunx --bun solhint --config .solhint.json 'src/**/*.sol' && \
bunx --bun solhint --config .solhint.other.json 'script/**/*.sol' 'test/**/*.sol' && \
slither .
```

or

```sh
npx solhint --config .solhint.json 'src/**/*.sol' && \
npx solhint --config .solhint.other.json 'script/**/*.sol' 'test/**/*.sol' && \
slither .
```

#### Deployment

To simulate deployment on sepolia, run

```sh
forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter --rpc-url sepolia
```

Append the

- `--broadcast` flag to deploy on sepolia
- `--verify --slow` flags for subsequent contract verification on Etherscan (`--slow` adds 15 seconds of waiting time between verification attempts)
- `--account <ACCOUNT_NAME>` flag to use a previously imported keystore (see
  `cast wallet --help` for more info)
  
#### Local Anvil Deployment

To run on a local anvil process use

```sh
forge script script/Emitter.s.sol:EmitterDeployAndEmit --rpc-url <anvil-url> --broadcast --private-key <anvil-private-keykey>>
```

##### Block Explorer Verification

For post-deployment verification on Etherscan run

```sh
forge verify-contract \
   <ADDRESS> \
   src/ProtocolAdapter.sol:ProtocolAdapter \
   --chain sepolia \
   --constructor-args-path script/constructor-args.txt
```

after replacing `<ADDRESS>` with the respective contract address.

### Benchmarks

Parameters:

- Commitment accumulator `treeDepth = 32`

<img src=".assets/Benchmark.png" width=67% alt="Protocol adapter benchmark for a Merkle tree depth of 32.">

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

Print a test transaction with

```sh
cargo test -- conversion::tests::print_tx --exact --show-output --ignored
```
