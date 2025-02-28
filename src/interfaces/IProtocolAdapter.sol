// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IWrapper as UntrustedWrapper } from "../interfaces/IWrapper.sol";
import { Transaction } from "../Types.sol";

interface IProtocolAdapter {
    /// @notice Executes a transaction by adding the commitments and nullifiers to the commitment tree and nullifier
    /// set, respectively.
    /// @param transaction The transaction to execute.
    function execute(Transaction calldata transaction) external;

    /// @notice Creates a wrapper contract resource object and adds the commitment to the commitment accumulator
    /// @param wrapperContract The wrapper contract.
    function createWrapperContractResource(UntrustedWrapper wrapperContract) external;

    /// @notice Verifies a transaction by checking the delta, resource logic, and compliance proofs.
    /// @param transaction The transaction to verify.
    function verify(Transaction calldata transaction) external view;
}
