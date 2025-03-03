# EVM Protocol Adapter

## Produce DeepTest

```sh
forge build --ast
```

```sh
bunx --bun forge-deep
```

make sure that all the types are used

## Deployment

```shell
forge create \
   --broadcast \
   --rpc-url https://sepolia.infura.io/v3/d64bc77ca96a4a3ea1a70e64e17660a2 \
   src/HelloWorld.sol:HelloWorld \
   --private-key 0xfb8d2aabbba7855ced487dbc6dba4352c637471698690d904f733278ba3d336d \
   --constructor-args 0xbeC907C237c5d27c7D4cB37b2c17CBB227B5f335 "Hello Jan" \
   --etherscan-api-key VHFVV93PAHZPGVQWWICJRA4MFAHFPXVSV4 \
   --verify
```
