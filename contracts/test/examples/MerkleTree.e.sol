// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {SHA256} from "../../src/libs/SHA256.sol";

contract MerkleTreeExample {
    using MerkleTree for bytes32[];

    uint256 internal constant _N_LEAFS = 7;
    uint256 internal constant _N_ROOTS = 8;

    // We will push 4 leafs - hence the tree will have 5 states

    bytes32[][_N_ROOTS] internal _a;
    bytes32[][_N_ROOTS] internal _b;
    bytes32[][_N_ROOTS] internal _c;

    bytes32[][][_N_ROOTS] internal _siblings;
    mapping(uint256 capacity => uint256[] directionBits) internal _directionBits; // One for every leaf

    bytes32[_N_ROOTS] internal _roots;

    function _setupMockTree() internal {
        /*
        (0)       (1)            (2)            (3)                   (4)                        (5)        
        []        B0             C0             C0'                   D0                         D0'        
                 /  \           /  \           /  \                  /  \                       /  \        
            -> A0    [] ->    B0'  []   ->   B0'  B1  ->           /     \        ->          /     \        
                             / \   / \      / \   / \            /        \                 /        \     
                            A0 A1 [] []    A0 A1 A2 []         C0'         []             C0'         C1    
                                                              /  \        /  \           /  \        /  \   
                                                            B0'  B1'    []   []        B0'  B1'    B2   []  
                                                           / \   / \   / \   / \      / \   / \   / \   / \ 
                                                          A0 A1 A2 A3 [] [] [] []    A0 A1 A2 A3 A4 [] [] []
        */

        // State 0
        {
            _a[0] = new bytes32[](1);
            _a[0][0] = SHA256.EMPTY_HASH;

            _b[0] = _calculateNextLevel(_a[0]);

            _c[0] = _calculateNextLevel(_b[0]);

            _siblings[0] = new bytes32[][](0);

            _roots[0] = _a[0].computeRoot();
        }

        // State 1
        {
            _a[1] = new bytes32[](2);
            _a[1][0] = bytes32(uint256(1));
            _a[1][1] = SHA256.EMPTY_HASH;

            _b[1] = _calculateNextLevel(_a[1]);

            _c[1] = _calculateNextLevel(_b[1]);

            _roots[1] = _a[1].computeRoot();

            _siblings[1] = new bytes32[][](1);

            _siblings[1][0] = new bytes32[](1);
            _siblings[1][0][0] = _a[1][1];
        }

        // State 2
        {
            _a[2] = new bytes32[](4);
            _a[2][0] = _a[1][0];
            _a[2][1] = bytes32(uint256(2));
            _a[2][2] = SHA256.EMPTY_HASH;
            _a[2][3] = SHA256.EMPTY_HASH;

            _b[2] = _calculateNextLevel(_a[2]);

            _c[2] = _calculateNextLevel(_b[2]);

            _roots[2] = _a[2].computeRoot();

            _siblings[2] = new bytes32[][](2);

            _siblings[2][0] = new bytes32[](2);
            _siblings[2][0][0] = _a[2][1];
            _siblings[2][0][1] = _b[2][1];

            _siblings[2][1] = new bytes32[](2);
            _siblings[2][1][0] = _a[2][0];
            _siblings[2][1][1] = _b[2][1];
        }

        // State 3
        {
            _a[3] = new bytes32[](4);
            _a[3][0] = _a[2][0];
            _a[3][1] = _a[2][1];
            _a[3][2] = bytes32(uint256(3));
            _a[3][3] = SHA256.EMPTY_HASH;

            _b[3] = _calculateNextLevel(_a[3]);

            _c[3] = _calculateNextLevel(_b[3]);

            _roots[3] = MerkleTree.computeRoot(_a[3]);

            _siblings[3] = new bytes32[][](3);

            _siblings[3][0] = new bytes32[](3);
            _siblings[3][0][0] = _a[3][1];
            _siblings[3][0][1] = _b[3][1];

            _siblings[3][1] = new bytes32[](2);
            _siblings[3][1][0] = _a[3][0];
            _siblings[3][1][1] = _b[3][1];

            _siblings[3][2] = new bytes32[](2);
            _siblings[3][2][0] = _a[3][3];
            _siblings[3][2][1] = _b[3][0];
        }

        // State 4
        {
            _a[4] = new bytes32[](8);
            _a[4][0] = _a[3][0];
            _a[4][1] = _a[3][1];
            _a[4][2] = _a[3][2];
            _a[4][3] = bytes32(uint256(4));
            _a[4][4] = SHA256.EMPTY_HASH;

            _a[4][5] = SHA256.EMPTY_HASH;

            _a[4][6] = SHA256.EMPTY_HASH;

            _a[4][7] = SHA256.EMPTY_HASH;

            _b[4] = _calculateNextLevel(_a[4]);

            _c[4] = _calculateNextLevel(_b[4]);

            _roots[4] = _a[4].computeRoot();

            _siblings[4] = new bytes32[][](4);

            _siblings[4][0] = new bytes32[](3);
            _siblings[4][0][0] = _a[4][1];
            _siblings[4][0][1] = _b[4][1];
            _siblings[4][0][2] = _c[4][1];

            _siblings[4][1] = new bytes32[](3);
            _siblings[4][1][0] = _a[4][0];
            _siblings[4][1][1] = _b[4][1];
            _siblings[4][1][2] = _c[4][1];

            _siblings[4][2] = new bytes32[](3);
            _siblings[4][2][0] = _a[4][3];
            _siblings[4][2][1] = _b[4][0];
            _siblings[4][2][2] = _c[4][1];

            _siblings[4][3] = new bytes32[](3);
            _siblings[4][3][0] = _a[4][2];
            _siblings[4][3][1] = _b[4][0];
            _siblings[4][3][2] = _c[4][1];
        }

        // State 5
        {
            _a[5] = new bytes32[](8);
            _a[5][0] = _a[4][0];
            _a[5][1] = _a[4][1];
            _a[5][2] = _a[4][2];
            _a[5][3] = _a[4][3];
            _a[5][4] = bytes32(uint256(5));
            _a[5][5] = SHA256.EMPTY_HASH;

            _a[5][6] = SHA256.EMPTY_HASH;

            _a[5][7] = SHA256.EMPTY_HASH;

            _b[5] = _calculateNextLevel(_a[5]);

            _c[5] = _calculateNextLevel(_b[5]);

            _roots[5] = _a[5].computeRoot();

            _siblings[5] = new bytes32[][](5);

            _siblings[5][0] = new bytes32[](3);
            _siblings[5][0][0] = _a[5][1];
            _siblings[5][0][1] = _b[5][1];
            _siblings[5][0][2] = _c[5][1];

            _siblings[5][1] = new bytes32[](3);
            _siblings[5][1][0] = _a[5][0];
            _siblings[5][1][1] = _b[5][1];
            _siblings[5][1][2] = _c[5][1];

            _siblings[5][2] = new bytes32[](3);
            _siblings[5][2][0] = _a[5][3];
            _siblings[5][2][1] = _b[5][0];
            _siblings[5][2][2] = _c[5][1];

            _siblings[5][3] = new bytes32[](3);
            _siblings[5][3][0] = _a[5][2];
            _siblings[5][3][1] = _b[5][0];
            _siblings[5][3][2] = _c[5][1];

            _siblings[5][4] = new bytes32[](3);
            _siblings[5][4][0] = _a[5][5];
            _siblings[5][4][1] = _b[5][3];
            _siblings[5][4][2] = _c[5][0];
        }

        // State 6
        {
            _a[6] = new bytes32[](8);
            _a[6][0] = _a[5][0];
            _a[6][1] = _a[5][1];
            _a[6][2] = _a[5][2];
            _a[6][3] = _a[5][3];
            _a[6][4] = _a[5][4];
            _a[6][5] = bytes32(uint256(6));
            _a[6][6] = SHA256.EMPTY_HASH;

            _a[6][7] = SHA256.EMPTY_HASH;

            _b[6] = _calculateNextLevel(_a[6]);

            _c[6] = _calculateNextLevel(_b[6]);

            _roots[6] = _a[6].computeRoot();

            _siblings[6] = new bytes32[][](6);

            _siblings[6][0] = new bytes32[](3);
            _siblings[6][0][0] = _a[6][1];
            _siblings[6][0][1] = _b[6][1];
            _siblings[6][0][2] = _c[6][1];

            _siblings[6][1] = new bytes32[](3);
            _siblings[6][1][0] = _a[6][0];
            _siblings[6][1][1] = _b[6][1];
            _siblings[6][1][2] = _c[6][1];

            _siblings[6][2] = new bytes32[](3);
            _siblings[6][2][0] = _a[6][3];
            _siblings[6][2][1] = _b[6][0];
            _siblings[6][2][2] = _c[6][1];

            _siblings[6][3] = new bytes32[](3);
            _siblings[6][3][0] = _a[6][2];
            _siblings[6][3][1] = _b[6][0];
            _siblings[6][3][2] = _c[6][1];

            _siblings[6][4] = new bytes32[](3);
            _siblings[6][4][0] = _a[6][5];
            _siblings[6][4][1] = _b[6][3];
            _siblings[6][4][2] = _c[6][0];

            _siblings[6][5] = new bytes32[](3);
            _siblings[6][5][0] = _a[6][4];
            _siblings[6][5][1] = _b[6][3];
            _siblings[6][5][2] = _c[6][0];
        }

        // State 7
        {
            _a[7] = new bytes32[](8);
            _a[7][0] = _a[6][0];
            _a[7][1] = _a[6][1];
            _a[7][2] = _a[6][2];
            _a[7][3] = _a[6][3];
            _a[7][4] = _a[6][4];
            _a[7][5] = _a[6][5];
            _a[7][6] = bytes32(uint256(7));
            _a[7][7] = SHA256.EMPTY_HASH;

            _b[7] = _calculateNextLevel(_a[7]);

            _c[7] = _calculateNextLevel(_b[7]);

            _roots[7] = _a[7].computeRoot();

            _siblings[7] = new bytes32[][](7);

            _siblings[7][0] = new bytes32[](3);
            _siblings[7][0][0] = _a[7][1];
            _siblings[7][0][1] = _b[7][1];
            _siblings[7][0][2] = _c[7][1];

            _siblings[7][1] = new bytes32[](3);
            _siblings[7][1][0] = _a[7][0];
            _siblings[7][1][1] = _b[7][1];
            _siblings[7][1][2] = _c[7][1];

            _siblings[7][2] = new bytes32[](3);
            _siblings[7][2][0] = _a[7][3];
            _siblings[7][2][1] = _b[7][0];
            _siblings[7][2][2] = _c[7][1];

            _siblings[7][3] = new bytes32[](3);
            _siblings[7][3][0] = _a[7][2];
            _siblings[7][3][1] = _b[7][0];
            _siblings[7][3][2] = _c[7][1];

            _siblings[7][4] = new bytes32[](3);
            _siblings[7][4][0] = _a[7][4];
            _siblings[7][4][1] = _b[7][3];
            _siblings[7][4][2] = _c[7][0];

            _siblings[7][5] = new bytes32[](3);
            _siblings[7][5][0] = _a[7][4];
            _siblings[7][5][1] = _b[7][3];
            _siblings[7][5][2] = _c[7][0];

            _siblings[7][6] = new bytes32[](3);
            _siblings[7][6][0] = _a[7][7];
            _siblings[7][6][1] = _b[7][2];
            _siblings[7][6][2] = _c[7][0];
        }

        {
            _directionBits[1] = new uint256[](1);
            _directionBits[1][0] = 0; // 0

            _directionBits[2] = new uint256[](2);
            _directionBits[2][0] = 1; // 1
            _directionBits[2][1] = 0; // 0

            _directionBits[4] = new uint256[](4);
            _directionBits[4][0] = 3; // 11
            _directionBits[4][1] = 2; // 10
            _directionBits[4][2] = 1; // 01
            _directionBits[4][3] = 0; // 00

            _directionBits[8] = new uint256[](8);
            _directionBits[8][0] = 7; // 111
            _directionBits[8][1] = 6; // 110
            _directionBits[8][2] = 5; // 101
            _directionBits[8][3] = 4; // 100
            _directionBits[8][4] = 3; // 011
            _directionBits[8][5] = 2; // 010
            _directionBits[8][6] = 1; // 001
            _directionBits[8][7] = 0; // 000
        }
    }

    function _calculateNextLevel(bytes32[] memory x) internal pure returns (bytes32[] memory y) {
        uint256 len = x.length / 2;
        y = new bytes32[](len);
        for (uint256 i = 0; i < len; ++i) {
            y[i] = SHA256.hash(x[i * 2], x[(i * 2) + 1]);
        }
    }
}
