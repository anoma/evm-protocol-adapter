# Release Checklist

Releases of the packages contained in this monorepo follow the [SemVer convention](https://semver.org/spec/v2.0.0.html).

> [!NOTE]
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

- [ ] Install dependencies and check bindings are up-to-date:

  ```sh
  just contracts-deps
  just bindings-check
  ```

- [ ] Checkout a new git branch branching off from `main`.

- [ ] Check that there are no staged or unstaged changes by running `git status`.

- [ ] Check that the deployer wallet is funded and add it to `cast`:

  ```sh
  cast wallet import deployer --private-key <PRIVATE_KEY>
  # or
  cast wallet import deployer --mnemonic <MNEMONIC>
  ```

- [ ] Set environment variables:

  ```sh
  export IS_TEST_DEPLOYMENT=false
  export EMERGENCY_STOP_CALLER=<ADDRESS>
  export ALCHEMY_API_KEY=<KEY>
  export ETHERSCAN_API_KEY=<KEY>
  ```

### 2. Bump the Version

- [ ] Bump the `_PROTOCOL_ADAPTER_VERSION` constant in `./contracts/src/libs/Versioning.sol`.

- [ ] Remove all chain name and address pairs in the `protocol_adapter_deployments_map()` function in `./bindings/src/addresses.rs`.

### 3. Build and Test

```sh
just contracts-build
just contracts-test
```

### 4. Deploy and Verify the Protocol Adapter

For each chain you want to deploy to:

- [ ] **Simulate** the deployment:

  ```sh
  just contracts-simulate <CHAIN_NAME>
  ```

- [ ] **Deploy** the contract:

  ```sh
  just contracts-deploy <CHAIN_NAME>
  ```

- [ ] **Verify** the contract:

  ```sh
  just contracts-verify <PA_ADDRESS> <CHAIN_NAME>
  ```

  Check verification on https://sourcify.dev/#/lookup.

### 5. Update the Deployments Map and Create GitHub Releases

- [ ] Add the **new** address and chain name pairs in the `protocol_adapter_deployments_map()` function in `./bindings/src/addresses.rs`.

- [ ] Change the `bindings` package version in `./bindings/Cargo.toml` to `A.0.0` (increment MAJOR).

- [ ] Build and test bindings:

  ```sh
  just bindings-build
  just bindings-test
  ```

- [ ] After merging, create tags for:
  - [ ] `contracts/X.Y.Z` (must match protocol adapter version)
  - [ ] `bindings/A.0.0`

- [ ] Create new [GH releases](https://github.com/anoma/pa-evm/releases) for both packages.

### 6. Publish Packages

```sh
# Contracts to soldeer (remove "" for actual publish)
just contracts-publish <X.Y.Z> ""

# Bindings to crates.io (remove "" for actual publish)
just bindings-publish ""
```

## Deploying an existing Protocol Adapter Version to new Chains

### 1. Prerequisites

Same as [new version prerequisites](#1-prerequisites).

### 2. Build and Test

```sh
just contracts-build
just contracts-test
```

### 3. Deploy and Verify the Protocol Adapter

For each **new** chain you want to deploy to:

> [!NOTE]
> For chains where the protocol adapter of this version has already been deployed, the simulation will fail since the deterministic address is already taken.

- [ ] **Simulate**: `just contracts-simulate <CHAIN_NAME>`
- [ ] **Deploy**: `just contracts-deploy <CHAIN_NAME>`
- [ ] **Verify**: `just contracts-verify <PA_ADDRESS> <CHAIN_NAME>`

### 4. Update the Deployments Map and Create GitHub Release

- [ ] Add the **new** address and chain name pairs in the `protocol_adapter_deployments_map()` function in `./bindings/src/addresses.rs`.

- [ ] Change the `bindings` package version in `./bindings/Cargo.toml` to `A.B.0` (increment MINOR).

- [ ] Build and test bindings:

  ```sh
  just bindings-build
  just bindings-test
  ```

- [ ] After merging, create a new `bindings/A.B.0` tag.

- [ ] Create a new [GH release](https://github.com/anoma/pa-evm/releases).

### 5. Publish Bindings

```sh
just bindings-publish ""
```

## Maintaining the Bindings

### 1. Create a new `bindings` GitHub Release

- [ ] Run tests: `just bindings-test`

- [ ] Commit the changes and open a PR to `main`.

- [ ] After merging, create a new `bindings/A.B.C` tag (increment PATCH).

- [ ] Create a new [GH release](https://github.com/anoma/pa-evm/releases).

### 2. Publish Bindings

```sh
just bindings-publish ""
```
