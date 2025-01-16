// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

//import { CpuVerifier } from "@starkware-libs/starkex-contracts/evm-verifier/solidity/contracts/cpu/CpuVerifier.sol";
//import { StarkVerifier } from "@starkware-libs/starkex-contracts/evm-verifier/solidity/contracts/StarkVerifier.sol";
//import { IStarkVerifier } from "@starkware-libs/starkex-contracts/evm-verifier/solidity/contracts/interfaces/IStarkVerifier.sol";

interface IStarkVerifier {
    // @inheritdoc @CpuVerifier
    function verifyProofExternal(
        uint256[] memory proofParams,
        uint256[] memory proof,
        uint256[] memory publicInput
    )
        external;
}
