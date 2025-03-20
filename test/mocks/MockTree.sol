// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { SHA256 } from "../../src/libs/SHA256.sol";

import { MerkleTree } from "../../src/state/MerkleTree.sol";

contract MockTree {
    uint8 internal constant _TREE_DEPTH = 2;
    uint256 internal constant _N_LEAFS = 2 ** _TREE_DEPTH;
    uint256 internal constant _N_NODES = 2 ** (_TREE_DEPTH - 1);
    uint256 internal constant _N_ROOTS = _N_LEAFS + 1;

    bytes32[4][5] internal _leaves;
    bytes32[][4][5] internal _siblings; // 2
    bytes32[2][5] internal _nodes;
    bytes32[5] internal _roots;

    function _setupMockTree() internal {
        /*
                R
              /  \
            N0   N1
           / \   / \
          0  1  2  3
        */

        for (uint256 i = 0; i < _N_ROOTS; ++i) {
            for (uint256 j = 0; j < i; ++j) {
                _leaves[i][j] = SHA256.hash(bytes32(j));
            }

            for (uint256 j = i; j < _N_ROOTS - 1; ++j) {
                _leaves[i][j] = MerkleTree._EMPTY_LEAF_HASH;
            }

            _nodes[i][0] = SHA256.commutativeHash(_leaves[i][0], _leaves[i][1]);
            _nodes[i][1] = SHA256.commutativeHash(_leaves[i][2], _leaves[i][3]);
            _roots[i] = SHA256.commutativeHash(_nodes[i][0], _nodes[i][1]);

            _siblings[i][0] = new bytes32[](2);
            _siblings[i][0][0] = _leaves[i][1];
            _siblings[i][0][1] = _nodes[i][1];

            _siblings[i][1] = new bytes32[](2);
            _siblings[i][1][0] = _leaves[i][0];
            _siblings[i][1][1] = _nodes[i][1];

            _siblings[i][2] = new bytes32[](2);
            _siblings[i][2][0] = _leaves[i][3];
            _siblings[i][2][1] = _nodes[i][0];

            _siblings[i][3] = new bytes32[](2);
            _siblings[i][3][0] = _leaves[i][2];
            _siblings[i][3][1] = _nodes[i][0];
        }
    }
}
