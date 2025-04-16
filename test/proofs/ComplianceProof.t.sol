// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Receipt as RiscZeroReceipt } from "@risc0-ethereum/IRiscZeroVerifier.sol";
import { RiscZeroVerifierRouter } from "@risc0-ethereum/RiscZeroVerifierRouter.sol";
import { RiscZeroMockVerifier } from "@risc0-ethereum/test/RiscZeroMockVerifier.sol";

import { Test } from "forge-std/Test.sol";

contract ComplianceProofTest is Test {
    RiscZeroVerifierRouter internal _sepoliaVerifierRouter;
    RiscZeroMockVerifier internal _mockVerifier;

    bytes internal constant _SEAL =
        hex"c101b42b1d7a433884c550f0d572b755857d6efb0bc536b2eee3cb15eb01ef302bb504fe063465d84c678fb0b49ae915541a8dc829ddf6b1c26c4d17043d00d3cc60cd36051795b51d10cc100f7be904994568a238633d51a344da4b694616e896c9e9e90d3cd4b0f422a61a9b848f24f96c3548eb4ba657fff6bef91752121227909cd21a255d46ad7d4b1c15736526c94757fefc17141f8ca8a3fca58f20316779f228183175b10b3550fd8ec4e2feeea036b85785bc193c7968a9eb93d0a52ca72ef90144fef05cc250ae3912b3362c65980223df54755f4f4e8bd4c3df87729481ae0a54f0bdb6734369fbfb46925c4c18cf3c6103dbfb450cbcd4b2f2b1cb74b844";

    bytes32 internal constant _COMPLIANCE_CIRCUIT_ID =
        hex"2d66afddd55cd62aefb80ebf9358b5642ede5fdfaa8279a57b9a2b5b4f2e4e2b";

    bytes32 internal constant _JOURNAL_DIGEST = sha256(
        hex"a8178c622ae23d879faef1e39df8ff03d907186e21b8406aaaccc1607cbb47575a802f8f3042ef0f1665c9b28c5be1da8f802621d489215f868302cf0076f75b1ad3f1918d23fa18315a979950e35bc860dd0a1fb8ece3706727b35ec68dea834100000004000000f000000022000000d60000000a000000a50000001100000081000000c80000001b00000079000000c3000000c90000008600000093000000eb0000001b000000e7000000cf000000cf00000082000000fa0000006800000047000000e2000000f6000000fd000000230000001200000048000000d600000085000000ea000000a5000000b600000083000000d70000003d000000820000001f000000c90000004c0000006f0000002a000000da00000095000000c200000025000000e7000000d90000005b000000c1000000510000009a00000057000000650000009f0000000c00000013000000760000002200000038000000cb0000000300000024000000e3e3d9b5166cf4e98913948fda27fe8c7e2b730c124aa79b377ff838269ba8dee3e3d9b5166cf4e98913948fda27fe8c7e2b730c124aa79b377ff838269ba8de"
    );

    RiscZeroReceipt internal _mockReceipt;
    bytes internal _mockSeal;

    function setUp() public {
        _sepoliaVerifierRouter = RiscZeroVerifierRouter(0x925d8331ddc0a1F0d96E68CF073DFE1d92b69187);
        _mockVerifier = new RiscZeroMockVerifier({ selector: bytes4(_SEAL) });

        _mockReceipt = _mockVerifier.mockProve({ imageId: _COMPLIANCE_CIRCUIT_ID, journalDigest: _JOURNAL_DIGEST });
        _mockSeal = _mockReceipt.seal;
    }

    function test_mock_complianceProof() public view {
        _mockVerifier.verify({ seal: _mockSeal, imageId: _COMPLIANCE_CIRCUIT_ID, journalDigest: _JOURNAL_DIGEST });
    }

    function test_real_complianceProof() public view {
        _sepoliaVerifierRouter.verify({ seal: _SEAL, imageId: _COMPLIANCE_CIRCUIT_ID, journalDigest: _JOURNAL_DIGEST });
    }
}
