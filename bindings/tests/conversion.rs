#[cfg(test)]
use alloy::primitives::B256;

#[test]
fn print_verifying_keys() {
    println!(
        "COMPLIANCE_VK: {:?}",
        B256::from_slice(arm_risc0::constants::COMPLIANCE_VK.as_bytes())
    );

    println!(
        "BATCH_AGGREGATION_VK: {:?}",
        B256::from_slice(arm_risc0::aggregation::constants::BATCH_AGGREGATION_VK.as_bytes())
    );
}
