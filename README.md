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

The `contracts` folder contains the contracts written in [Solidity](https://soliditylang.org/) contracts as well as [Foundry forge](https://book.getfoundry.sh/forge/) tests and deploy scripts.

The `bindings` folder contains bindings in [Rust](https://www.rust-lang.org/) to convert [Rust](https://www.rust-lang.org/) and [RISC Zero](https://risczero.com/) types into EVM types using the [`alloy-rs` library](https://github.com/alloy-rs).

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

#### Tests

Run

```sh
forge test
```

#### Deployment

To simulate deployment on sepolia, run

```sh
forge script script/Deploy.s.sol:Deploy \
   --rpc-url sepolia
```

Append the

- `--broadcast` flag to deploy on sepolia
- `--verify` flag for subsequent contract verification on Etherscan
- `--account <ACCOUNT_NAME>` flag to use a previously imported keystore (see
  `cast wallet --help` for more info)

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
