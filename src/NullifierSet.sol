// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.25;

import { EnumerableSet } from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract NullifierSet {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    EnumerableSet.Bytes32Set internal nullifierSet;

    event NullifierAdded(bytes32 indexed nullifier, uint256 indexed index);

    error DuplicatedNullifier(bytes32 nullifier);

    function contains(bytes32 nullifier) public view returns (bool) {
        return nullifierSet.contains(nullifier);
    }

    function _addNullifier(bytes32 nullifier) internal {
        (bool success) = nullifierSet.add(nullifier);
        if (!success) {
            revert DuplicatedNullifier(nullifier);
        }
        emit NullifierAdded({ nullifier: nullifier, index: nullifierSet.length() - 1 });
    }
}
