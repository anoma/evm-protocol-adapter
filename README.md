# EVM Protocol Adapter

For more information, see the
[related Anoma Research Day talk](https://www.youtube.com/watch?v=rKFZsOw360U).

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

<img src=".assets/Benchmark.png" width=67% alt="Protocol adapter benchmark for a Merkle tree depth of 32.">
