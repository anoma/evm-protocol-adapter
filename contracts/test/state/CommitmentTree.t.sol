// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {ICommitmentTree} from "../../src/interfaces/ICommitmentTree.sol";
import {MerkleTree} from "../../src/libs/MerkleTree.sol";
import {SHA256} from "../../src/libs/SHA256.sol";
import {CommitmentTree} from "../../src/state/CommitmentTree.sol";
import {Resource} from "../../src/Types.sol";
import {MerkleTreeExample} from "../examples/MerkleTree.e.sol";
import {TxGen} from "../libs/TxGen.sol";
import {CommitmentTreeMock} from "../mocks/CommitmentTree.m.sol";

contract CommitmentTreeTest is Test, MerkleTreeExample {
    using MerkleTree for bytes32[];

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

    function test_should_produce_an_invalid_root_for_a_non_existent_leaf() public {
        bytes32 nonExistentCommitment = sha256("NON_EXISTENT");

        for (uint256 i = 0; i < _N_LEAVES; ++i) {
            bytes32 root = _cmAcc.addCommitment(_leaves[i + 1][i]);

            for (uint256 j = 0; j <= i; ++j) {
                bytes32 computedRoot = MerkleTree.processProof({
                    siblings: _siblings[i + 1][j],
                    directionBits: _directionBits[_cmAcc.commitmentTreeCapacity()][j],
                    leaf: nonExistentCommitment
                });

                assertNotEq(computedRoot, root);
            }
        }
    }

    function test_verifyMerkleProof_reverts_on_non_existent_root() public {
        bytes32 nonExistingRoot = sha256("NON_EXISTENT_ROOT");

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentTree.NonExistingRoot.selector, nonExistingRoot), address(_cmAcc)
        );

        Resource memory resource = TxGen.defaultResource();

        _cmAcc.verifyMerkleProof({
            commitmentTreeRoot: nonExistingRoot, resource: resource, path: new bytes32[](0), directionBits: 0
        });
    }

    function test_verifyMerkleProof_reverts_on_non_existent_resource_commitment() public {
        /*
          (1)
           R
         /  \
        1   []
        */

        Resource memory resource = TxGen.defaultResource();
        bytes32 commitment = TxGen.commitment(resource);
        bytes32 newRoot = _cmAcc.addCommitment(commitment);
        _cmAcc.addCommitmentTreeRoot(newRoot);

        // Change the nonce
        // forge-lint: disable-next-line(unsafe-typecast)
        resource.nonce = bytes32("new");
        bytes32 nonExistingCommitment = TxGen.commitment(resource);
        bytes32 nonExistingRoot = SHA256.hash(commitment, nonExistingCommitment);
        bytes32[] memory siblingsCorrespondingToNonExistingRoot = new bytes32[](1);
        siblingsCorrespondingToNonExistingRoot[0] = commitment;
        uint256 directionBitsCorrespondingToNonExistingRoot = 0;

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentTree.InvalidRoot.selector, newRoot, nonExistingRoot), address(_cmAcc)
        );
        _cmAcc.verifyMerkleProof({
            commitmentTreeRoot: newRoot,
            resource: resource,
            path: siblingsCorrespondingToNonExistingRoot,
            directionBits: directionBitsCorrespondingToNonExistingRoot
        });
    }

    function test_verifyMerkleProof_reverts_on_wrong_path_length() public {
        Resource memory resource = TxGen.defaultResource();
        bytes32 commitment = TxGen.commitment(resource);
        _cmAcc.addCommitmentTreeRoot(_cmAcc.addCommitment(commitment));
        bytes32[] memory wrongPath = new bytes32[](3);

        vm.expectRevert(
            abi.encodeWithSelector(
                CommitmentTree.PathLengthExceedsLatestDepth.selector, _cmAcc.commitmentTreeDepth(), wrongPath.length
            ),
            address(_cmAcc)
        );
        _cmAcc.verifyMerkleProof({commitmentTreeRoot: 0, resource: resource, path: wrongPath, directionBits: 0});
    }

    function test_verifyMerkleProof_reverts_on_wrong_path() public {
        Resource memory resource = TxGen.defaultResource();
        bytes32 commitment = TxGen.commitment(resource);
        bytes32 newRoot = _cmAcc.addCommitment(commitment);
        _cmAcc.addCommitmentTreeRoot(newRoot);

        bytes32[] memory wrongPath = new bytes32[](_cmAcc.commitmentTreeDepth());

        // Compute the expected, invalid root.
        bytes32 invalidRoot = wrongPath.processProof({directionBits: 0, leaf: commitment});

        vm.expectRevert(
            abi.encodeWithSelector(CommitmentTree.InvalidRoot.selector, newRoot, invalidRoot), address(_cmAcc)
        );
        _cmAcc.verifyMerkleProof({commitmentTreeRoot: newRoot, resource: resource, path: wrongPath, directionBits: 0});
    }

    function test_verifyMerkleProof_verifies_path_for_old_roots() public {
        // Fix initial root
        bytes32 initialRoot = _cmAcc.latestCommitmentTreeRoot();

        // Update the tree with some commitment
        Resource memory resource = TxGen.defaultResource();
        bytes32 commitment = TxGen.commitment(resource);
        bytes32 firstRoot = _cmAcc.addCommitment(commitment);
        _cmAcc.addCommitmentTreeRoot(firstRoot);

        // Assert that the new root is different
        assert(_cmAcc.latestCommitmentTreeRoot() != initialRoot);

        // Add another
        Resource memory resourceNew = TxGen.defaultResource();
        // forge-lint: disable-next-line(unsafe-typecast)
        resourceNew.nonce = bytes32("NEW");
        bytes32 commitmentNew = TxGen.commitment(resource);
        bytes32 secondRoot = _cmAcc.addCommitment(commitmentNew);
        _cmAcc.addCommitmentTreeRoot(secondRoot);

        // Assert that the new root is different
        assert(_cmAcc.latestCommitmentTreeRoot() != firstRoot);

        // Construct valid path at the first root
        bytes32[] memory path = new bytes32[](1);
        path[0] = sha256("EMPTY");

        // Check merkle path verification for first updated root works
        _cmAcc.verifyMerkleProof({commitmentTreeRoot: firstRoot, resource: resource, path: path, directionBits: 1});
    }

    function test_should_produce_an_invalid_root_for_a_non_existent_leaf_in_the_empty_tree() public view {
        bytes32 root = _cmAcc.initialRoot();

        bytes32 nonExistentCommitment = sha256("NON_EXISTENT");
        bytes32 invalidRoot = nonExistentCommitment;

        bytes32 computedRoot =
            MerkleTree.processProof({siblings: new bytes32[](0), directionBits: 0, leaf: nonExistentCommitment});
        assertNotEq(computedRoot, root);
        assertEq(computedRoot, invalidRoot);
    }
}
