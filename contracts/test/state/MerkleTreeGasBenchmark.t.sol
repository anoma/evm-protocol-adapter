// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std-1.15.0/src/Test.sol";
import {MerkleTree} from "../../src/libs/MerkleTree.sol";

contract MerkleTreeGasBenchmark is Test {
    using MerkleTree for MerkleTree.Tree;

    struct PushGasTestCase {
        string name;
        uint256 prePushCount;
    }

    struct CumulativeGasTestCase {
        string name;
        uint256 pushCount;
    }

    MerkleTree.Tree internal _tree;

    /// @notice Measures one-time cost of initializing 256 zero hashes.
    function test_gas_setup() public {
        uint256 gasBefore = gasleft();
        _tree.setup();
        uint256 gasUsed = gasBefore - gasleft();
        console.log("setup() gas:", gasUsed);
    }

    /// @notice Gas for a single push at each depth (the push that triggers tree expansion).
    function tablePushDepthTest(PushGasTestCase memory pushDepth) public {
        _tree.setup();
        for (uint256 i = 1; i <= pushDepth.prePushCount; ++i) {
            _tree.push(bytes32(i));
        }

        uint256 gasBefore = gasleft();
        _tree.push(bytes32(uint256(pushDepth.prePushCount + 1)));
        uint256 gasUsed = gasBefore - gasleft();
        console.log(string.concat("push() ", pushDepth.name, " gas:"), gasUsed);
    }

    /// @notice Total gas for filling the tree from empty to 2^d leaves (covers all positions within each depth).
    function tableTreeCapacityTest(CumulativeGasTestCase memory treeCapacity) public {
        _tree.setup();

        uint256 gasBefore = gasleft();
        for (uint256 i = 1; i <= treeCapacity.pushCount; ++i) {
            _tree.push(bytes32(i));
        }
        uint256 gasUsed = gasBefore - gasleft();
        console.log(string.concat("cumulative pushes to ", treeCapacity.name, " gas:"), gasUsed);
    }

    function fixturePushDepth() public pure returns (PushGasTestCase[] memory pushDepth) {
        uint256 maxDepth = 5;
        pushDepth = new PushGasTestCase[](maxDepth + 1);
        for (uint256 d = 0; d <= maxDepth; ++d) {
            pushDepth[d] = PushGasTestCase({
                name: string.concat("depth ", vm.toString(d)), prePushCount: d == 0 ? 0 : uint256(1) << (d - 1)
            });
        }
    }

    function fixtureTreeCapacity() public pure returns (CumulativeGasTestCase[] memory treeCapacity) {
        uint256 minDepth = 3;
        uint256 maxDepth = 6;
        treeCapacity = new CumulativeGasTestCase[](maxDepth - minDepth + 1);
        for (uint256 d = minDepth; d <= maxDepth; ++d) {
            uint256 leaves = uint256(1) << d;
            string memory name = string.concat("depth ", vm.toString(d));
            name = string.concat(name, " (", vm.toString(leaves), " leaves)");
            treeCapacity[d - minDepth] = CumulativeGasTestCase({name: name, pushCount: leaves});
        }
    }
}
