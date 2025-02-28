// SPDX-License-Identifier: MIT
pragma solidity >=0.8.27;

//import { GpsStatementVerifier } from
// "@starkware-libs/starkex-contracts/evm-verifier/solidity/contracts/gps/GpsStatementVerifier.sol";

interface IGpsStatementVerifier {
    // @inheritdoc @GpsStatementVerifier
    function verifyProofAndRegister(
        uint256[] calldata proofParams,
        uint256[] calldata proof,
        uint256[] calldata taskMetadata,
        uint256[] calldata cairoAuxInput,
        uint256 cairoVerifierId
    )
        external;
}
