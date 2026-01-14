# Release Checklist

Releases of the packages contained in this monorepo follow the [SemVer convention](https://semver.org/spec/v2.0.0.html).

> ![NOTE]
> The `contracts` and `bindings` are independently versioned with `X.Y.Z` and `A.B.C`, respectively.
> Both versions can include release candidates (suffixed with `-rc.?`).

We distinguish between three release cases:

- Deploying a **new** protocol adapter version to multiple new chains resulting in a new

  - `contracts/X.Y.Z` version
  - `bindings/A.0.0` version

- Deploying an **existing** protocol adapter version to multiple new chains resulting in a new

  - `bindings/A.B.0` version

- Maintaining the bindings resulting in a new

  - `bindings/A.B.C` version

## Deploying a new Protocol Adapter Version

### 1. Prerequisites

- [ ] Visit https://www.soliditylang.org/ and check that Solidity compiler version used in `contracts/foundry.toml` has no known vulnerabilities.

- [ ] Change the directory to `contracts` and install the dependencies with

  ```sh
  forge soldeer install
  ```

- [ ] Check that the dependencies are up-to-date, have no known vulnerabilities in the dependencies

- [ ] Check that the Rust bindings are up-to-date by regenerating them with

  ```sh
  forge bind \
    --select '^(IProtocolAdapter|ProtocolAdapter|VersioningLibExternal)$' \
    --bindings-path ../bindings/src/generated/ \
    --module \
    --overwrite
  ```

  and running `git status`, which should shown no changes.

- [ ] Checkout a new git branch branching off from `main`.

- [ ] Check that there are no staged or unstaged changes by running `git status`.

- [ ] Check that the deployer wallet is funded and add it to `cast` with

  ```sh
  cast wallet import deployer --private-key <PRIVATE_KEY>
  ```

  or

  ```sh
  cast wallet import deployer --mnemonic <MNEMONICC>
  ```

- [ ] Set `IS_TEST_DEPLOYMENT` to `false` to deterministically deploy the protocol adapter.

  ```sh
  export IS_TEST_DEPLOYMENT=false
  ```

- [ ] Check that the emergency caller address is set up correctly and export it with

  ```sh
  export EMERGENCY_STOP_CALLER=<ADDRESS>
  ```

- [ ] Set the Alchemy RPC provider by exporting

  ```sh
  export ALCHEMY_API_KEY=<KEY>
  ```

- [ ] Set the Etherscan key
  ```sh
  export ETHERSCAN_API_KEY=<KEY>
  ```

### 2. Bump the Version

- [ ] Bump the `_PROTOCOL_ADAPTER_VERSION` constant in `./contracts/src/libs/Versioning.sol` to the new version number following [SemVer](https://semver.org/spec/v2.0.0.html).

- [ ] Remove all chain name and address pairs in the

  ```rust
  pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address>
  ```

  function in `./bindings/src/addresses.rs`.

### 3. Build the Contracts

- [ ] Change the directory with `cd contracts`.

- [ ] Run `forge clean && forge build`.

- [ ] Run the test suite with `forge test`.

### 4. Deploy and Verify the Protocol Adapter

For each chain, you want to deploy to, do the following:

- [ ] **Simulate** the deployment by running

  ```sh
  forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter \
  --sig "run(bool,address)" $IS_TEST_DEPLOYMENT $EMERGENCY_STOP_CALLER \
  --rpc-url <CHAIN_NAME>
  ```

- [ ] After successful simulation, **deploy** the contract by running

  ```sh
  forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter \
   --sig "run(bool,address)" $IS_TEST_DEPLOYMENT $EMERGENCY_STOP_CALLER \
  --broadcast --rpc-url <CHAIN_NAME> --account deployer
  ```

- [ ] Export the address of the newly deployed protocol adapter contract with

  ```sh
  export PA_ADDRESS=<ADDRESS>
  ```

- [ ] Verify the contract on

  - [ ] sourcify

    ```sh
    forge verify-contract $PA_ADDRESS \
      src/ProtocolAdapter.sol:ProtocolAdapter \
      --chain <CHAIN> --verifier sourcify
    ```

  - [ ] Etherscan

    ```sh
    forge verify-contract $PA_ADDRESS \
      src/ProtocolAdapter.sol:ProtocolAdapter \
      --chain <CHAIN> --verifier etherscan
    ```

  and check that the verification worked (e.g., on https://sourcify.dev/#/lookup).

### 5. Update the Deployments Map and Create a new `contracts` and `bindings` GitHub Release

- [ ] Add the **new** address and chain name pairs in the

  ```rust
  pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address>
  ```

  function in `./bindings/src/addresses.rs`.

- [ ] Change the `bindings` package version number in the `./bindings/Cargo.toml` file to `A.0.0`, where `A` is the last `MAJOR` version number incremented by 1.

- [ ] Run `cargo build` and check that the `Cargo.lock` file reflects the version number change.

- [ ] Run the tests with `cargo test`.

- [ ] After merging, create new tags for:

  - [ ] `contracts/X.Y.Z` where `X.Y.Z` must match the protocol adapter version number and
  - [ ] `bindings/A.0.0` tag, where `A` is the last `MAJOR` version incremented by 1.

- [ ] Create new [GH releases](https://github.com/anoma/pa-evm/releases) for both packages.

### 6. Publish a new `contracts` package

- [ ] Go to the `contracts` directory

- [ ] Publish the `contracts` package on https://soldeer.xyz/ with

  ```sh
  forge soldeer push anoma-pa-evm~<X.Y.Z> --dry-run
  ```

  where `<X.Y.Z>` is the `_PROTOCOL_ADAPTER_VERSION` number and check the result. If everything is correct, remove the `--dry-run` flag and publish the package.

### 7. Publish a new `bindings` package

- [ ] Go to the `bindings` directory

- [ ] Publish the `anoma-pa-evm-bindings` package on https://crates.io/ with

  ```sh
  cargo publish --dry-run
  ```

  and check the result. If everything is correct, remove the `--dry-run` flag and publish the package.

## Deploying an existing Protocol Adapter Version to new Chains

### 1. Prerequisites

- [ ] Visit https://www.soliditylang.org/ and check that Solidity compiler version used in `contracts/foundry.toml` has no known vulnerabilities.

- [ ] Change the directory to `contracts` and install the dependencies with

  ```sh
  forge soldeer install
  ```

- [ ] Check that the dependencies are up-to-date, have no known vulnerabilities in the dependencies

- [ ] Check that the Rust bindings are up-to-date by regenerating them with

  ```sh
  forge bind \
    --select '^(IProtocolAdapter|ProtocolAdapter|VersioningLibExternal)$' \
    --bindings-path ../bindings/src/generated/ \
    --module \
    --overwrite
  ```

  and running `git status`, which should shown no changes.

- [ ] Checkout a new git branch branching off from `main`.

- [ ] Check that there are no staged or unstaged changes by running `git status`.

- [ ] Check that the deployer wallet is funded and add it to `cast` with

  ```sh
  cast wallet import deployer --private-key <PRIVATE_KEY>
  ```

  or

  ```sh
  cast wallet import deployer --mnemonic <MNEMONICC>
  ```

- [ ] Set `IS_TEST_DEPLOYMENT` to `false` to deterministically deploy the protocol adapter.

  ```sh
  export IS_TEST_DEPLOYMENT=false
  ```

- [ ] Check that the emergency caller address is set up correctly and export it with

  ```sh
  export EMERGENCY_STOP_CALLER=<ADDRESS>
  ```

- [ ] Set the Alchemy RPC provider by exporting

  ```sh
  export ALCHEMY_API_KEY=<KEY>
  ```

- [ ] Set the Etherscan key
  ```sh
  export ETHERSCAN_API_KEY=<KEY>
  ```

### 2. Build the contracts

- [ ] Change the directory with `cd contracts`

- [ ] Run `forge clean && forge build`

- [ ] Run the test suite with `forge test`

### 3. Deploy and Verify the Protocol Adapter

For each **new** chain, you want to deploy to, do the following:

- [ ] **Simulate** the deployment by running

  ```sh
  forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter \
  --sig "run(bool,address)" $IS_TEST_DEPLOYMENT $EMERGENCY_STOP_CALLER \
  --rpc-url <CHAIN_NAME>
  ```

  > ![NOTE]
  > For chains that the protocol adapter of this version has already been deployed to, the simulation will fail since the deterministic address is already taken.

- [ ] After successful simulation, **deploy** the contract by running

  ```sh
  forge script script/DeployProtocolAdapter.s.sol:DeployProtocolAdapter \
   --sig "run(bool,address)" $IS_TEST_DEPLOYMENT $EMERGENCY_STOP_CALLER \
  --broadcast --rpc-url <CHAIN_NAME> --account deployer
  ```

- [ ] Export the address of the newly deployed protocol adapter contract with

  ```sh
  export PA_ADDRESS=<ADDRESS>
  ```

- [ ] Verify the contract on

  - [ ] sourcify

    ```sh
    forge verify-contract $PA_ADDRESS \
      src/ProtocolAdapter.sol:ProtocolAdapter \
      --chain <CHAIN> --verifier sourcify
    ```

  - [ ] Etherscan

    ```sh
    forge verify-contract $PA_ADDRESS \
      src/ProtocolAdapter.sol:ProtocolAdapter \
      --chain <CHAIN> --verifier etherscan
    ```

  and check that the verification worked (e.g., on https://sourcify.dev/#/lookup).

### 4. Update the Deployments Map and Create a new `bindings` GitHub Release

- [ ] Add the **new** address and chain name pairs in the

  ```rust
  pub fn protocol_adapter_deployments_map() -> HashMap<NamedChain, Address>
  ```

  function in `./bindings/src/addresses.rs`.

- [ ] Change the `bindings` package version number in the `./bindings/Cargo.toml` file to `A.B.0`, where `A` is the last `MAJOR` version and `B` is the last `MINOR` version number incremented by 1.

- [ ] Run `cargo build` and check that the `Cargo.lock` file reflects the version number change.

- [ ] Run the tests with `cargo test`.

- [ ] After merging, create a new `bindings/A.B.0` tag, where `A` is the last `MAJOR` version and `B` is the last `MINOR` version number incremented by 1.

- [ ] Create a new [GH release](https://github.com/anoma/pa-evm/releases).

### 5. Publish a new `bindings` package

- [ ] Go to the `bindings` directory

- [ ] Publish the `anoma-pa-evm-bindings` package on https://crates.io/ with

  ```sh
  cargo publish --dry-run
  ```

  and check the result. If everything is correct, remove the `--dry-run` flag and publish the package.

## Maintaining the Bindings

### 1. Create a new `bindings` GitHub Release

- [ ] Run the tests with `cargo test`.

- [ ] Commit the changes and open a PR to `main`.

- [ ] After merging, create a new `bindings/A.B.C` tag, where `A` and `B` are the last `MAJOR` and `MINOR` version numbers, respectively and `C` is the last `PATCH` version number incremented by 1.

- [ ] Create a new [GH release](https://github.com/anoma/pa-evm/releases).

### 2. Publish a new `bindings` package

- [ ] Go to the `bindings` directory

- [ ] Publish the `anoma-pa-evm-bindings` package on https://crates.io/ with

  ```sh
  cargo publish --dry-run
  ```

  and check the result. If everything is correct, remove the `--dry-run` flag and publish the package.
