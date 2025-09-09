//! Example of how to transfer ERC20 tokens from one account to another using a signed permit.

use std::str::FromStr;

use crate::call::ERC20Forwarder;

use alloy::{
    network::EthereumWallet,
    node_bindings::Anvil,
    primitives::U256,
    providers::{Provider, ProviderBuilder},
    signers::{local::PrivateKeySigner, Signer},
    sol,
    sol_types::eip712_domain,
};

const CANONICAL_PERMIT2_ADDRESS: &str = "0x000000000022D473030F116dDEE9F6B43aC78BA3";

sol!(
    #[allow(missing_docs)]
    #[sol(rpc)]
    ERC20Example,
    "../contracts/out/ERC20.e.sol/ERC20Example.json"
);

sol!(
    #[allow(missing_docs)]
    #[sol(rpc)]
    IPermit2,
    "../contracts/out/IPermit2.sol/IPermit2.json"
);

// The permit stuct that has to be signed is different from the contract input struct
// even though they have the same name.
// Also note that the EIP712 hash of this struct is sensitive to the order of the fields.
sol! {
    struct TokenPermissions {
        address token;
        uint256 amount;
    }

    struct PermitTransferFrom {
        TokenPermissions permitted;
        address spender;
        uint256 nonce;
        uint256 deadline;
    }
}

impl From<PermitTransferFrom> for ISignatureTransfer::PermitTransferFrom {
    fn from(val: PermitTransferFrom) -> Self {
        Self {
            permitted: ISignatureTransfer::TokenPermissions {
                token: val.permitted.token,
                amount: val.permitted.amount,
            },
            nonce: val.nonce,
            deadline: val.deadline,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use alloy::primitives::B256;
    use alloy_sol_types::private::Address;
    use alloy_sol_types::SolValue;
    use arm_risc0::evm::CallType;

    #[tokio::test]
    async fn e2e_example() {
        //let fwd = erc20_forwarder(
        //    Address::from_str("0xd82AC3c51d393c34b6e4bD02506e9C8c0113A6Ec").unwrap(),
        //);

        // Spin up a local Anvil node.
        // Ensure `anvil` is available in $PATH.
        let rpc_url = "https://reth-ethereum.ithaca.xyz/rpc";
        let anvil = Anvil::new().fork(rpc_url).try_spawn().unwrap();

        // Set up signers from the first two default Anvil accounts (Alice, Bob).
        let alice: PrivateKeySigner = anvil.keys()[0].clone().into();
        let bob: PrivateKeySigner = anvil.keys()[1].clone().into();

        // We can manage multiple signers with the same wallet
        let mut wallet = EthereumWallet::new(alice.clone());
        wallet.register_signer(bob.clone());

        // Create a provider with both signers pointing to anvil
        let rpc_url = anvil.endpoint_url();
        let provider = ProviderBuilder::new().wallet(wallet).connect_http(rpc_url);

        // Deploy the `ERC20Example` contract.
        let token = ERC20Example::deploy(provider.clone()).await.unwrap();

        let logic_ref = B256::from(U256::from(1));

        let fwd = ERC20Forwarder::deploy(Address::from(0), logic_ref, provider.clone())
            .await
            .unwrap();

        // Register the balances of Alice and Bob before the transfer.
        let alice_before_balance = token.balanceOf(alice.address()).call().await.unwrap();
        let bob_before_balance = token.balanceOf(bob.address()).call().await.unwrap();

        // Permit2 mainnet address
        let permit2 = IPermit2::new(
            Address::from_str(CANONICAL_PERMIT2_ADDRESS).unwrap(),
            provider.clone(),
        );

        let amount = U256::from(100);

        let tx_hash1 = token
            .mint(alice.address(), amount)
            .from(alice.address())
            .send()
            .await
            .unwrap()
            .watch()
            .await
            .unwrap();
        println!("Sent mint: {}", tx_hash1);

        // Alice approves the Permit2 contract
        let tx_hash2 = token
            .approve(*permit2.address(), U256::MAX)
            .from(alice.address())
            .send()
            .await
            .unwrap()
            .watch()
            .await
            .unwrap();
        println!("Sent approval: {}", tx_hash2);

        // Create the EIP712 Domain and Permit

        let domain = eip712_domain! {
            name: "Permit2",
            chain_id: provider.get_chain_id().await.unwrap(),
            verifying_contract: *permit2.address(),
        };
        let permit = PermitTransferFrom {
            permitted: TokenPermissions {
                token: *token.address(),
                amount,
            },
            spender: bob.address(),
            nonce: U256::from(0),
            deadline: U256::MAX,
        };

        // Alice signs the Permit
        let signature = alice
            .sign_typed_data(&permit, &domain)
            .await
            .unwrap()
            .as_bytes()
            .into();

        let witness = B256::from(U256::from(2));

        let input =
            (CallType::Wrap, alice.address(), permit, witness, signature).abi_encode_params();

        // This specifies the actual transaction executed via Permit2
        // Note that `to` can be any address and does not have to match the spender
        let transfer_details = ISignatureTransfer::SignatureTransferDetails {
            to: bob.address(),
            requestedAmount: amount,
        };

        let tx_hash3 = fwd
            .forwardCall(logic_ref, input)
            .from(bob.address())
            .send()
            .await
            .unwrap()
            .watch()
            .await
            .unwrap();
        println!("Sent permit transfer: {}", tx_hash3);

        // Register the balances of Alice and Bob after the transfer.
        let alice_after_balance = token.balanceOf(alice.address()).call().await.unwrap();
        let bob_after_balance = token.balanceOf(bob.address()).call().await.unwrap();

        // Check the balances of Alice and Bob after the transfer.
        assert_eq!(alice_before_balance - alice_after_balance, amount);
        assert_eq!(bob_after_balance - bob_before_balance, amount);
    }
}
