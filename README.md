# EVM Protocol Adapter

> [!WARNING] This repo features a prototype and is work in progress. Do NOT use
> it in production.

For more information, see the related Anoma Research Day talk.

<div align="left">
  <a href="https://www.youtube.com/watch?v=rKFZsOw360U">
     <img src="https://img.youtube.com/vi/rKFZsOw360U/0.jpg" 
       alt="The EVM Protocol Adapter: Bringing Intent-Centric Apps to Ethereum - Anoma Research Day"
       style="width:50%;">
  </a>
</div>

## Installation

1. Get an up-to-date version of [Foundry](https://github.com/foundry-rs/foundry)
   with

   ```sh
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. Clone this repo and run
   ```sh
   forge install
   ```

## Usage

### Tests

Run

```sh
forge test
```

### Deployments

> [!NOTE]  
> Work in progress.

## Benchmarks

Parameters:

- Commitment accumulator `treeDepth = 32`

<img src=".assets/Benchmark.png" width=50% alt="Protocol adapter benchmark for a Merkle tree depth of 32.">
