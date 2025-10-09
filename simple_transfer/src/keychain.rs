use arm_risc0::authorization::{AuthorizationSigningKey, AuthorizationVerifyingKey};
use arm_risc0::encryption::{random_keypair, AffinePoint, SecretKey};
use arm_risc0::nullifier_key::{NullifierKey, NullifierKeyCommitment};

#[allow(dead_code)]
pub struct KeyChain {
    pub auth_signing_key: AuthorizationSigningKey,
    pub nf_key: NullifierKey,
    pub discovery_sk: SecretKey,
    pub discovery_pk: AffinePoint,
    pub encryption_sk: SecretKey,
    pub encryption_pk: AffinePoint,
}

impl KeyChain {
    pub fn auth_verifying_key(&self) -> AuthorizationVerifyingKey {
        AuthorizationVerifyingKey::from_signing_key(&self.auth_signing_key)
    }

    pub fn nullifier_key_commitment(&self) -> NullifierKeyCommitment {
        self.nf_key.commit()
    }
}

pub fn example_keychain() -> KeyChain {
    let (discovery_sk, discovery_pk) = random_keypair();
    let (encryption_sk, encryption_pk) = random_keypair();

    KeyChain {
        auth_signing_key: AuthorizationSigningKey::from_bytes(&vec![15u8; 32]).unwrap(),
        nf_key: NullifierKey::from_bytes(&[13u8; 32]),
        discovery_sk,
        discovery_pk,
        encryption_sk,
        encryption_pk,
    }
}
