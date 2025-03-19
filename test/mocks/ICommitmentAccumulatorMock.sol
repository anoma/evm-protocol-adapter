// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ICommitmentAccumulator } from "../../src/interfaces/ICommitmentAccumulator.sol";

interface ICommitmentAccumulatorMock is ICommitmentAccumulator {
    function addCommitment(bytes32 commitment) external returns (bytes32 newRoot);

    function addCommitmentUnchecked(bytes32 commitment) external returns (bytes32 newRoot);

    function checkMerklePath(bytes32 root, bytes32 commitment, bytes32[] calldata path) external view;

    function computeMerklePath(bytes32 commitment) external view returns (bytes32[] memory path);

    function findCommitmentIndex(bytes32 commitment) external view returns (uint256 index);

    function commitmentAtIndex(uint256 index) external view returns (bytes32 commitment);

    function merkleTreeZero(uint8 level) external view returns (bytes32 zeroHash);

    function emptyLeafHash() external view returns (bytes32 hash);

    function initialRoot() external view returns (bytes32 hash);

    function commitmentCount() external view returns (uint256 count);
}
