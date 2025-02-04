# EVM Protocol Adapter


## Protocol Adapter Deployment

```mermaid
sequenceDiagram
  box ARM
    participant rm as RM Interface
    participant app as Juvix App
    participant wr as Wrapper Resource
    participant er as ERC20 Resource
  end
  actor dep as Deployer
  box EVM
    participant pa as Protocol Adapter Contract
    participant wc as Wrapper Contract
    participant ec as  ERC20 Contract
    participant r0 as  RISZ Zero Verifier Contract
  end
  # Preparation
  wr -->> pa : logic reference  
  rm -->> pa : logic circuit ID
  rm -->> pa : compliance circuit ID
  r0 -->> pa : address
  
  # Steps
  dep ->> pa : deploy
```


## Wrapper Contract Deployment

```mermaid
sequenceDiagram
  box ARM
    participant rm as RM Interface
    participant app as Juvix App
    participant wr as Wrapper Resource
    participant er as ERC20 Resource
  end
  actor dep as Deployer
  box EVM
    participant pa as Protocol Adapter Contract
    participant wc as Wrapper Contract
    participant ec as  ERC20 Contract
    participant r0 as  RISZ Zero Verifier Contract
  end

  dep ->> wc : 1. deploy

  par Wrapper Resource Creation
    dep ->> pa : 2. createWrapperContractResource(address wrapperContract)
    pa ->> wr : create resource
    pa ->> pa : store resource commitment
  end
```


## Transaction with EVM call


```mermaid
sequenceDiagram
  box ARM
    participant rm as RM Interface
    participant app as Juvix App
    participant wr as Wrapper Resource
    participant er as ERC20 Resource
  end
  #participant ip as Intent Pool
  #participant mp as Mem Pool
  actor a as Alice
  #actor b as Bob
  box EVM
    participant pa as Protocol Adapter Contract
    participant wc as Wrapper Contract
    participant ec as  ERC20 Contract
    participant r0 as  RISZ Zero Verifier Contract
  end

  par Step 1
    a ->> app : call transaction function <br> wrap (erc20 : Address) (quantity : Nat) <br> or unwrap (erc20 : resource)
    app -->> wr : consume & create wrapper resource NFT
    app -->> er : initialize or finalize ERC20 resource
    app -->> rm : computeProofs()
    rm -->> app : proofs
    app ->> a : transaction object
  end

  par Step 2
    a ->> pa : execute transaction object
    pa ->> pa : do out-of-circuit checks
    pa ->> r0 : verify in-circuit proofs
    pa ->> wc : evmCall(bytes input) : bytes output
    wc ->> ec : call external function <br>transferFrom(address from, address to, uint256 value) : bool success <br> or transfer(address to, uint256 value) : bool success
    pa ->> pa : store blobs
    pa ->> pa : add nullifiers & commitments to the <br> commitment and nullifier accumulators

  end
```

### Limitations
- A wrapper contract must be deployed by a 3rd party
- 1 EVM call per wrapper contract per block
- EVM call return values must be known at proving time