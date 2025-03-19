// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Test } from "forge-std/Test.sol";

import { SHA256 } from "../../src/libs/SHA256.sol";

import { CommitmentAccumulatorMock } from "../mocks/CommitmentAccumulatorMock.sol";

import { ICommitmentAccumulatorMock } from "../mocks/ICommitmentAccumulatorMock.sol";

import { ImprovedCommitmentAccumulatorMock } from "../mocks/ImprovedCommitmentAccumulatorMock.sol";

contract Base is Test {
    uint8 internal constant _TREE_DEPTH = 10; // Use 20

    bytes32[] internal _leaves;
    bytes32 internal _latestRoot;

    ICommitmentAccumulatorMock internal _cmAcc;

    constructor(ICommitmentAccumulatorMock cmAcc) {
        _cmAcc = cmAcc;
    }

    function setUp() public {
        _leaves = new bytes32[](2 ** _TREE_DEPTH);

        for (uint256 i = 0; i < 2 ** _TREE_DEPTH; ++i) {
            _leaves[i] = SHA256.hash(bytes32(i));
            _latestRoot = _cmAcc.addCommitment(_leaves[i]);
        }
    }

    function test_checkPath() public view {
        bytes32 cm = SHA256.hash(bytes32(0));
        _cmAcc.checkMerklePath({ root: _latestRoot, commitment: cm, path: _cmAcc.computeMerklePath(cm) });
    }
}

contract ImprovedCommitmentAccumulatorBenchmark is Base {
    constructor() Base(new ImprovedCommitmentAccumulatorMock(_TREE_DEPTH)) { }
}

contract CommitmentAccumulatorBenchmark is Base {
    constructor() Base(new CommitmentAccumulatorMock(_TREE_DEPTH)) { }
}
