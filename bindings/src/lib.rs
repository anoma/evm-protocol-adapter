pub mod call;
pub mod conversion;

#[cfg(test)]
mod tests {
    use super::*;
    use alloy::primitives::{B256, Bytes, U256};
    use conversion::ProtocolAdapter;

    use alloy::sol_types::SolType;

    #[test]
    fn test_encode_resource() {
        let res = ProtocolAdapter::Resource {
            logicRef: B256::from_slice(&[0x11; 32]),
            labelRef: B256::from_slice(&[0x22; 32]),
            quantity: 12,
            valueRef: B256::from(U256::from(1)),
            ephemeral: true,
            nonce: B256::from(U256::from(0)),
            nullifierKeyCommitment: B256::from(U256::from(0)),
            randSeed: B256::from(U256::from(0)),
        };

        let encoded: Vec<u8> = ProtocolAdapter::Resource::abi_encode(&res);
        println!("{}", Bytes::from(encoded));
    }
}
