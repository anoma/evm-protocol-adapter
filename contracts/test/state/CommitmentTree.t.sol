// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {ICommitmentTree} from "../../src/interfaces/ICommitmentTree.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {CommitmentTree} from "../../src/state/CommitmentTree.sol";
import {MerkleTreeExample} from "../examples/MerkleTree.e.sol";
import {CommitmentTreeMock} from "../mocks/CommitmentTree.m.sol";

contract CommitmentTreeTest is Test, MerkleTreeExample {
    CommitmentTreeMock internal _cmAcc;

    constructor() {
        _setupMockTree();
        _cmAcc = new CommitmentTreeMock();
    }

    function test_constructor_stores_the_initial_root_being_the_empty_leaf_hash() public {
        CommitmentTree newCmAcc = new CommitmentTree();
        assertEq(newCmAcc.latestCommitmentTreeRoot(), SHA256.EMPTY_HASH, "The inital root should be the empty hash.");
        assertEq(newCmAcc.commitmentTreeRootCount(), 1, "The initial root count should be 1.");
    }

    function test_constructor_initializes_the_tree_with_depth_0() public {
        assertEq(new CommitmentTree().commitmentTreeDepth(), 0, "The initial tree depth should be 0.");
    }

    function test_constructor_initializes_the_tree_with_capacity_1() public {
        assertEq(new CommitmentTree().commitmentTreeCapacity(), 1, "The initial tree capacity should be 1.");
    }

    function test_constructor_initializes_the_tree_with_0_leaves() public {
        assertEq(new CommitmentTree().commitmentCount(), 0, "The initial commitment count should be 0.");
    }

    function test_constructor_emits_the_CommitmentTreeRootAdded_event() public {
        vm.expectEmit();
        emit ICommitmentTree.CommitmentTreeRootAdded({root: SHA256.EMPTY_HASH});
        new CommitmentTree();
    }

    function test_addCommitment_returns_correct_roots() public {
        bytes32 initialRoot = _cmAcc.latestCommitmentTreeRoot();

        assertEq(initialRoot, _roots[0]);
        assertEq(initialRoot, _cmAcc.initialRoot());

        for (uint256 i = 0; i < _N_LEAVES; ++i) {
            assertEq(_cmAcc.addCommitment(_leaves[i + 1][i]), _roots[i + 1]);
        }
    }

    function test_addCommitment_should_add_commitments() public {
        uint256 prevCount = 0;
        uint256 newCount = 0;

        for (uint256 i = 0; i < _N_LEAVES; ++i) {
            _cmAcc.addCommitment(_leaves[i + 1][i]);
            newCount = _cmAcc.commitmentCount();

            assertEq(newCount, ++prevCount);
            prevCount = newCount;
        }
    }

    function test_addCommitmentTreeRoot_reverts_on_pre_existing_root() public {
        bytes32 preExistingRoot = bytes32(type(uint256).max);
        _cmAcc.addCommitmentTreeRoot(preExistingRoot);

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentTree.PreExistingRoot.selector, preExistingRoot), address(_cmAcc)
        );
        _cmAcc.addCommitmentTreeRoot(preExistingRoot);
    }

    function test_addCommitmentTreeRoot_stores_the_root() public {
        bytes32 rootToStore = bytes32(type(uint256).max);

        assertEq(_cmAcc.latestCommitmentTreeRoot(), _cmAcc.initialRoot());
        assertEq(_cmAcc.isCommitmentTreeRootContained(rootToStore), false);

        _cmAcc.addCommitmentTreeRoot(rootToStore);

        assertEq(_cmAcc.latestCommitmentTreeRoot(), rootToStore);
        assertEq(_cmAcc.isCommitmentTreeRootContained(rootToStore), true);
    }

    function test_addCommitmentTreeRoot_emits_the_CommitmentTreeRootAdded_event_on_store_() public {
        bytes32 rootToStore = bytes32(type(uint256).max);

        vm.expectEmit(address(_cmAcc));
        emit ICommitmentTree.CommitmentTreeRootAdded({root: rootToStore});

        _cmAcc.addCommitmentTreeRoot(rootToStore);
    }

    function test_commitmentTreeRootAtIndex_returns_the_right_index() public {
        for (uint256 i = 0; i < _N_LEAVES; ++i) {
            _cmAcc.addCommitmentTreeRoot(_cmAcc.addCommitment(_leaves[i + 1][i]));
        }

        for (uint256 i = 0; i < _N_LEAVES; ++i) {
            assertEq(_cmAcc.commitmentTreeRootAtIndex(i), _roots[i], "The returned root should have the expected index");
        }
    }

    function test_addCommitment_allows_adding_the_same_commitment_multiple_times() public {
        // Note: The compliance circuit will prevent the same commitment being added a second time.
        bytes32 cm = sha256("SOMETHING");

        _cmAcc.addCommitment(cm);
        _cmAcc.addCommitment(cm);
    }
}
