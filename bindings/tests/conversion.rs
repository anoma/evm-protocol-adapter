#[cfg(test)]
use alloy::primitives::B256;

#[test]
fn print_verifying_keys() {
    println!(
        "COMPLIANCE_VK: {:?}",
        B256::from_slice(anoma_rm_risc0_test_0112::constants::COMPLIANCE_VK.as_bytes())
    );

    println!(
        "BATCH_AGGREGATION_VK: {:?}",
        B256::from_slice(
            anoma_rm_risc0_test_0112::aggregation::constants::BATCH_AGGREGATION_VK.as_bytes()
        )
    );
}
