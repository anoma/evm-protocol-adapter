# Release Checklist

## 1. Prepare the Release

- [ ] Check that the contract dependencies are up-to-date and that there are no known vulnerabilities.

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
  export API_KEY_ALCHEMY=<KEY>
  ```

- [ ] Set the Etherscan key
  ```sh
  export API_KEY_ETHERSCAN=<KEY>
  ```

## 2. Bump the Version

- [ ] Bump the `_PROTOCOL_ADAPTER_VERSION` constant in `./contracts/src/libs/Versioning.sol` to the new version number following [SemVer](https://semver.org/spec/v2.0.0.html).

- [ ] Change the crate version in `.bindings/Cargo.toml` to the same version number.

- [ ] Change the directory with `cd contracts` and run `forge clean && forge build`

- [ ] Run the test suite with `forge test`

## 3. Deploy and Verify the Protocol Adapter

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

- [ ] Update the address and chain name in the `protocol_adapter` function in `./bindings/src/contract.rs`.

- [ ] Run the tests with `cargo test`

- [ ] Commit the change and artifacts generated in the `./broadcast/` directory to git and open a PR to `main`.

- [ ] After merging, create a tag matching the version number and create a [GH release](https://github.com/anoma/evm-protocol-adapter/releases).
