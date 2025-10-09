use alloy::primitives::{address, Address, Signature, B256, U256};
use alloy::signers::{local::PrivateKeySigner, Signer};
use alloy::sol;
use alloy::sol_types::eip712_domain;

pub const PERMIT2_CONTRACT_ADDRESS: Address =
    address!("0x000000000022D473030F116dDEE9F6B43aC78BA3");

pub struct Permit2Data {
    pub chain_id: u64,
    pub token: Address,
    pub amount: U256,
    pub nonce: U256,
    pub deadline: U256,
    pub spender: Address,
    pub action_tree_root: B256,
}

sol! {
    struct TokenPermissions {
        address token;
        uint256 amount;
    }

    struct Witness{
        bytes32 actionTreeRoot;
    }

    struct PermitWitnessTransferFrom{
        TokenPermissions permitted;
        address spender;
        uint256 nonce;
        uint256 deadline;
        Witness witness;
     }
}

pub async fn permit_witness_transfer_from_signature(
    signer: &PrivateKeySigner,
    permit2_data: Permit2Data,
) -> Signature {
    let domain = eip712_domain! {
        name: "Permit2",
        chain_id: permit2_data.chain_id,
        verifying_contract: PERMIT2_CONTRACT_ADDRESS,
    };

    let typed_data = PermitWitnessTransferFrom {
        permitted: TokenPermissions {
            token: permit2_data.token,
            amount: permit2_data.amount,
        },
        spender: permit2_data.spender,
        nonce: permit2_data.nonce,
        deadline: permit2_data.deadline,
        witness: Witness {
            actionTreeRoot: permit2_data.action_tree_root,
        },
    };

    signer.sign_typed_data(&typed_data, &domain).await.unwrap()
}
