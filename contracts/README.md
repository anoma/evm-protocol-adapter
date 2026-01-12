[![CI](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml/badge.svg)](https://github.com/anoma/evm-protocol-adapter/actions/workflows/ci.yml)

# EVM Protocol Adapter

The protocol adapter contract written in Solidity enabling Anoma Resource Machine transaction settlement on EVM-compatible chains.

## Prerequisites

Get an up-to-date version of [Foundry](https://github.com/foundry-rs/foundry) with

```sh
curl -L https://foundry.paradigm.xyz | sh
foundryup
```

## Usage

#### Installation

Change the directory to the `contracts` folder with `cd contracts` and run

```sh
forge soldeer install
```

#### Build

To compile the contracts, run

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
forge coverage
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
